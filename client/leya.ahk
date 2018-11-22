; ---------------------------------------------------------------------------
;
;		Leya
;		MySQL / PHP API
;		Version: 1.3.1
;		https://github.com/kevgk/leya
;
; ---------------------------------------------------------------------------
#NoEnv

class leya {
	static server := ""
	static key := ""
	static error := ""
	static affectedRows = 0

	get(table, row, column) {
		query := "?action=get&table=" table "&row=" row "&column=" column
		return this._query(query)
	}

	getWhere(table, column, conditionColumn, operator, conditionValue) {
		query := "?action=getWhere&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column "&operator=" operator
		return this._queryJSON(query)
	}

	getAll(table, a) {
		query := "?table=" table "&action=getAll&row=" a
		return this._query(query)
	}

	set(table, row, column, value) {
		query := "?action=set&table=" table "&row=" row "&column=" column "&value=" value
		return this._query(query)
	}

	compare(table, row, column, value) {
		query := "?action=compare&table=" table "&row=" row "&column=" column "&value=" value
		return this._query(query)
	}

	createRow(table, row) {
		query := "?action=create_row&table=" table "&row=" row
		return this._query(query)
	}

	deleteRow(table, row) {
		query := "?action=delete_row&table=" table "&row=" row
		return this._query(query)
	}

	createTable(table, columns) {
		query := "?action=create_table&name=" table "&columns=" columns
		return this._query(query)
	}

	deleteTable(table) {
		query := "?action=delete_table&table=" table
		return this._query(query)
	}

	listColumns(table) {
		query := "?action=list_columns&table=" table
		return this._query(query)
	}

	listRows(table) {
		query := "?action=list_rows&table=" table
		return this._query(query)
	}

	addColumn(table, column) {
		query := "?action=add_column&table=" table "&column=" column
		return this._query(query)
	}

	deleteColumn(table, column) {
		query := "?action=delete_column&table=" table "&column=" column
		return this._query(query)
	}

	renameColumn(table, column, value) {
		query := "?action=rename_column&table=" table "&column=" column "&newname=" value
		return this._query(query)
	}

	rowExist(table, row) {
		query := "?action=row_exist&table=" table "&row=" row
		return this._query(query)
	}

	exec(code) {
		query := "?action=exec&query=" code
		return this._queryJSON(query)
	}

	hash(a, b = "md5") {
		query := "?action=hash&str=" a "&algo=" b
		return this._query(query)
	}

	mail(a, c, b = "E-Mail") {
		query := "?action=mail&to=" a "&subject=" b "&message=" c
		return this._query(query)
	}

	tableExist(table) {
		query := "?action=table_exist&name=" table
		return this._query(query)
	}

	countRows(table) {
		query := "?action=count_rows&table=" table
		return this._query(query)
	}

	setColumn(table, a, b, c) {
		query := "?table=" table "&action=set_column&column=" a "&type=" b "&len=" c
		return this._query(query)
	}

	checkTable(table) {
		query := "?table=" table "&action=check_table"
		return this._query(query)
	}

	fileWrite(file, content = "", mode = "end") {
		query := "?action=file_write&file=" file "&content=" content "&mode=" mode
		return this._query(query)
	}

	fileRead(file) {
		query := "?action=file_read&file=" file
		return this._query(query)
	}

	fileDelete(file) {
		query := "?action=file_delete&file=" file
		return this._query(query)
	}

	fileRename(file, name) {
		query := "?action=file_rename&file=" file "&name=" name
		return this._query(query)
	}

	fileExists(file) {
		query := "?action=file_exists&file=" file
		return this._query(query)
	}

	fileCopy(file, dest) {
		query := "?action=file_copy&file=" file "&dest=" dest
		return this._query(query)
	}

	fileSize(file, unit = "b") {
		query := "?action=file_get_size&file=" file "&unit=" unit
		return this._query(query)
	}

	generateKey() {
		query := "?action=generate_key"
		return this._query(query)
	}

	_query(a) {
		response := this._URLDownloadToVar(this.server a "&key=" this.key)
		error := this._getError(response)
		if error
			this.error := error
		else {
			res := this._getResponse(response)
			if this._getIsArray(response)
				return StrSplit(res, "||")
			else if this._getIsAssoc(response)
				return this._parseObject(res)
			else
				return res
		}
	}

	_queryJSON(a) {
		response := this._URLDownloadToVar(this.server a "&key=" this.key)
		FileAppend, %response%, debug.txt
		this.affectedRows := this._getAffectedRows(response)

		error := this._getError(response)
		if error
			this.error := error
		else {
			res := this._getResponse(response)
			return JSON.load(res)
		}
	}

	_parseObject(data) {
		pairs := StrSplit(data, "||")
		output := {}
		for i, pair in pairs {
			p := StrSplit(pair, "::")
			output[p[1]] := p[2]
		}
		return output
	}

	_getResponse(response) {
		pattern = U)<!--imp_return="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getIsArray(response) {
		pattern = U)<!--imp_isArray="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getIsAssoc(response) {
		pattern = U)<!--imp_isAssoc="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getError(response) {
		pattern = U)<!--imp_error="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getAffectedRows(response) {
		pattern = U)<!--imp_affectedRows="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	; Credits to maestrith for the URLDownloadToVar function
	; https://autohotkey.com/boards/viewtopic.php?t=329
	_URLDownloadToVar(url) {
		obj:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),obj.Open("GET",url),obj.Send()
		return obj.status=200?obj.ResponseText:""
	}

	; https://autohotkey.com/boards/viewtopic.php?t=7124
	join(Array, Sep = "") {
		for k, v in Array
			out .= Sep . v
		return SubStr(Out, 1+StrLen(Sep))
	}
}

/**
 * Lib: JSON.ahk
 *     JSON lib for AutoHotkey.
 * Version:
 *     v2.1.3 [updated 04/18/2016 (MM/DD/YYYY)]
 * License:
 *     WTFPL [http://wtfpl.net/]
 * Requirements:
 *     Latest version of AutoHotkey (v1.1+ or v2.0-a+)
 * Installation:
 *     Use #Include JSON.ahk or copy into a function library folder and then
 *     use #Include <JSON>
 * Links:
 *     GitHub:     - https://github.com/cocobelgica/AutoHotkey-JSON
 *     Forum Topic - http://goo.gl/r0zI8t
 *     Email:      - cocobelgica <at> gmail <dot> com
 */


/**
 * Class: JSON
 *     The JSON object contains methods for parsing JSON and converting values
 *     to JSON. Callable - NO; Instantiable - YES; Subclassable - YES;
 *     Nestable(via #Include) - NO.
 * Methods:
 *     Load() - see relevant documentation before method definition header
 *     Dump() - see relevant documentation before method definition header
 */
class JSON
{
	/**
	 * Method: Load
	 *     Parses a JSON string into an AHK value
	 * Syntax:
	 *     value := JSON.Load( text [, reviver ] )
	 * Parameter(s):
	 *     value      [retval] - parsed value
	 *     text    [in, ByRef] - JSON formatted string
	 *     reviver   [in, opt] - function object, similar to JavaScript's
	 *                           JSON.parse() 'reviver' parameter
	 */
	class Load extends JSON.Functor
	{
		Call(self, ByRef text, reviver:="")
		{
			this.rev := IsObject(reviver) ? reviver : false
		; Object keys(and array indices) are temporarily stored in arrays so that
		; we can enumerate them in the order they appear in the document/text instead
		; of alphabetically. Skip if no reviver function is specified.
			this.keys := this.rev ? {} : false

			static quot := Chr(34), bashq := "\" . quot
			     , json_value := quot . "{[01234567890-tfn"
			     , json_value_or_array_closing := quot . "{[]01234567890-tfn"
			     , object_key_or_object_closing := quot . "}"

			key := ""
			is_key := false
			root := {}
			stack := [root]
			next := json_value
			pos := 0

			while ((ch := SubStr(text, ++pos, 1)) != "") {
				if InStr(" `t`r`n", ch)
					continue
				if !InStr(next, ch, 1)
					this.ParseError(next, text, pos)

				holder := stack[1]
				is_array := holder.IsArray

				if InStr(",:", ch) {
					next := (is_key := !is_array && ch == ",") ? quot : json_value

				} else if InStr("}]", ch) {
					ObjRemoveAt(stack, 1)
					next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"

				} else {
					if InStr("{[", ch) {
					; Check if Array() is overridden and if its return value has
					; the 'IsArray' property. If so, Array() will be called normally,
					; otherwise, use a custom base object for arrays
						static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0

					; sacrifice readability for minor(actually negligible) performance gain
						(ch == "{")
							? ( is_key := true
							  , value := {}
							  , next := object_key_or_object_closing )
						; ch == "["
							: ( value := json_array ? new json_array : []
							  , next := json_value_or_array_closing )

						ObjInsertAt(stack, 1, value)

						if (this.keys)
							this.keys[value] := []

					} else {
						if (ch == quot) {
							i := pos
							while (i := InStr(text, quot,, i+1)) {
								value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")

								static tail := A_AhkVersion<"2" ? 0 : -1
								if (SubStr(value, tail) != "\")
									break
							}

							if (!i)
								this.ParseError("'", text, pos)

							  value := StrReplace(value,  "\/",  "/")
							, value := StrReplace(value, bashq, quot)
							, value := StrReplace(value,  "\b", "`b")
							, value := StrReplace(value,  "\f", "`f")
							, value := StrReplace(value,  "\n", "`n")
							, value := StrReplace(value,  "\r", "`r")
							, value := StrReplace(value,  "\t", "`t")

							pos := i ; update pos

							i := 0
							while (i := InStr(value, "\",, i+1)) {
								if !(SubStr(value, i+1, 1) == "u")
									this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))

								uffff := Abs("0x" . SubStr(value, i+2, 4))
								if (A_IsUnicode || uffff < 0x100)
									value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
							}

							if (is_key) {
								key := value, next := ":"
								continue
							}

						} else {
							value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)

							static number := "number", integer :="integer"
							if value is %number%
							{
								if value is %integer%
									value += 0
							}
							else if (value == "true" || value == "false")
								value := %value% + 0
							else if (value == "null")
								value := ""
							else
							; we can do more here to pinpoint the actual culprit
							; but that's just too much extra work.
								this.ParseError(next, text, pos, i)

							pos += i-1
						}

						next := holder==root ? "" : is_array ? ",]" : ",}"
					} ; If InStr("{[", ch) { ... } else

					is_array? key := ObjPush(holder, value) : holder[key] := value

					if (this.keys && this.keys.HasKey(holder))
						this.keys[holder].Push(key)
				}

			} ; while ( ... )

			return this.rev ? this.Walk(root, "") : root[""]
		}

		ParseError(expect, ByRef text, pos, len:=1)
		{
			static quot := Chr(34), qurly := quot . "}"

			line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
			col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
			msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}"
			,     (expect == "")     ? "Extra data"
			    : (expect == "'")    ? "Unterminated string starting at"
			    : (expect == "\")    ? "Invalid \escape"
			    : (expect == ":")    ? "Expecting ':' delimiter"
			    : (expect == quot)   ? "Expecting object key enclosed in double quotes"
			    : (expect == qurly)  ? "Expecting object key enclosed in double quotes or object closing '}'"
			    : (expect == ",}")   ? "Expecting ',' delimiter or object closing '}'"
			    : (expect == ",]")   ? "Expecting ',' delimiter or array closing ']'"
			    : InStr(expect, "]") ? "Expecting JSON value or array closing ']'"
			    :                      "Expecting JSON value(string, number, true, false, null, object or array)"
			, line, col, pos)

			static offset := A_AhkVersion<"2" ? -3 : -4
			throw Exception(msg, offset, SubStr(text, pos, len))
		}

		Walk(holder, key)
		{
			value := holder[key]
			if IsObject(value) {
				for i, k in this.keys[value] {
					; check if ObjHasKey(value, k) ??
					v := this.Walk(value, k)
					if (v != JSON.Undefined)
						value[k] := v
					else
						ObjDelete(value, k)
				}
			}

			return this.rev.Call(holder, key, value)
		}
	}



	/**
	 * Property: Undefined
	 *     Proxy for 'undefined' type
	 * Syntax:
	 *     undefined := JSON.Undefined
	 * Remarks:
	 *     For use with reviver and replacer functions since AutoHotkey does not
	 *     have an 'undefined' type. Returning blank("") or 0 won't work since these
	 *     can't be distnguished from actual JSON values. This leaves us with objects.
	 *     Replacer() - the caller may return a non-serializable AHK objects such as
	 *     ComObject, Func, BoundFunc, FileObject, RegExMatchObject, and Property to
	 *     mimic the behavior of returning 'undefined' in JavaScript but for the sake
	 *     of code readability and convenience, it's better to do 'return JSON.Undefined'.
	 *     Internally, the property returns a ComObject with the variant type of VT_EMPTY.
	 */
	Undefined[]
	{
		get {
			static empty := {}, vt_empty := ComObject(0, &empty, 1)
			return vt_empty
		}
	}

	class Functor
	{
		__Call(method, ByRef arg, args*)
		{
		; When casting to Call(), use a new instance of the "function object"
		; so as to avoid directly storing the properties(used across sub-methods)
		; into the "function object" itself.
			if IsObject(method)
				return (new this).Call(method, arg, args*)
			else if (method == "")
				return (new this).Call(arg, args*)
		}
	}
}
