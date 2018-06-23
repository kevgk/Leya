; ---------------------------------------------------------------------------
;
;		Improv3d MySQL/PHP API
;		Version: 1.2
;		https://github.com/kevgk/AutoHotkey-MySQL-PHP-API
;
; ---------------------------------------------------------------------------
#NoEnv

class imp {
	static server := ""
	static key := ""

	get(table, row, column) {
		query := "?action=get&table=" table "&row=" row "&column=" column
		return imp._query(query)
	}

	getWhere(table, column, conditionColumn, operator, conditionValue) {
		query := "?action=getWhere&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column "&operator=" operator
		return imp._query(query)
	}

	getAll(table, a) {
		query := "?table=" table "&action=getAll&row=" a
		return imp._query(query)
	}

	set(table, row, column, value) {
		query := "?action=set&table=" table "&row=" row "&column=" column "&value=" value
		return imp._query(query)
	}

	compare(table, row, column, value) {
		query := "?action=compare&table=" table "&row=" row "&column=" column "&value=" value
		return imp._query(query)
	}

	createRow(table, row) {
		query := "?action=create_row&table=" table "&row=" row
		return imp._query(query)
	}

	deleteRow(table, row) {
		query := "?action=delete_row&table=" table "&row=" row
		return imp._query(query)
	}

	createTable(table, columns) {
		query := "?action=create_table&name=" table "&columns=" columns
		return imp._query(query)
	}

	deleteTable(table) {
		query := "?action=delete_table&table=" table
		return imp._query(query)
	}

	listColumns(table) {
		query := "?action=list_columns&table=" table
		return imp._query(query)
	}

	listRows(table) {
		query := "?action=list_rows&table=" table
		return imp._query(query)
	}

	addColumn(table, column) {
		query := "?action=add_column&table=" table "&column=" column
		return imp._query(query)
	}

	deleteColumn(table, column) {
		query := "?action=delete_column&table=" table "&column=" column
		return imp._query(query)
	}

	renameColumn(table, column, value) {
		query := "?action=rename_column&table=" table "&column=" column "&newname=" value
		return imp._query(query)
	}

	rowExist(table, row) {
		query := "?action=row_exist&table=" table "&row=" row
		return imp._query(query)
	}

	exec(code) {
		query := "?action=exec&query=" code
		return imp._query(query)
	}

	hash(a, b = "md5") {
		query := "?action=hash&str=" a "&algo=" b
		return imp._query(query)
	}

	mail(a, c, b = "E-Mail") {
		query := "?action=mail&to=" a "&subject=" b "&message=" c
		return imp._query(query)
	}

	tableExist(table) {
		query := "?action=table_exist&name=" table
		return imp._query(query)
	}

	countRows(table) {
		query := "?action=count_rows&table=" table
		return imp._query(query)
	}

	setColumn(table, a, b, c) {
		query := "?table=" table "&action=set_column&column=" a "&type=" b "&len=" c
		return imp._query(query)
	}

	checkTable(table) {
		query := "?table=" table "&action=check_table"
		return imp._query(query)
	}

	fileWrite(file, content = "", mode = "end") {
		query := "?action=file_write&file=" file "&content=" content "&mode=" mode
		return imp._query(query)
	}

	fileRead(file) {
		query := "?action=file_read&file=" file
		return imp._query(query)
	}

	fileDelete(file) {
		query := "?action=file_delete&file=" file
		return imp._query(query)
	}

	fileRename(file, name) {
		query := "?action=file_rename&file=" file "&name=" name
		return imp._query(query)
	}

	fileExists(file) {
		query := "?action=file_exists&file=" file
		return imp._query(query)
	}

	fileCopy(file, dest) {
		query := "?action=file_copy&file=" file "&dest=" dest
		return imp._query(query)
	}

	fileSize(file, unit = "b") {
		query := "?action=file_get_size&file=" file "&unit=" unit
		return imp._query(query)
	}

	generateKey() {
		query := "?action=generate_key"
		return imp._query(query)
	}

	_query(a) {
		response := imp._URLDownloadToVar(imp.server a "&key=" imp.key)
		error := imp._getError(response)
		if error
			return error
		else {
			res := imp._getResponse(response)
			if imp._getIsArray(response)
				return StrSplit(res, "||")
			else if imp._getIsAssoc(response)
				return imp._parseObject(res)
			else
				return res
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
		pattern = <!--imp_return="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getIsArray(response) {
		pattern = <!--imp_isArray="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getIsAssoc(response) {
		pattern = <!--imp_isAssoc="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	_getError(response) {
		pattern = <!--imp_error="(.*)"-->
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
