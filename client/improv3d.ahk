; ---------------------------------------------------------------------------
;
;		Improv3d MySQL/PHP API
;		Version: 1.1
;		https://github.com/kevgk/AutoHotkey-MySQL-PHP-API
;
; ---------------------------------------------------------------------------
#NoEnv

class imp {
	static server := ""
	static key := ""

	get(table, row, column) {
		query := imp.server "?action=get&table=" table "&row=" row "&column=" column
		return imp.query(query)
	}

	getWhere(table, column, conditionColumn, operator, conditionValue) {
		query := imp.server "?action=getWhere&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column "&operator=" operator
		return imp.query(query)
	}

	set(table, row, column, value) {
		query := imp.server "?action=set&table=" table "&row=" row "&column=" column "&value=" value
		return imp.query(query)
	}

	compare(table, row, column, value) {
		query := imp.server "?action=compare&table=" table "&row=" row "&column=" column "&value=" value
		return imp.query(query)
	}

	createRow(table, row) {
		query := imp.server "?action=create_row&table=" table "&row=" row
		return imp.query(query)
	}

	deleteRow(table, row) {
		query := imp.server "?action=delete_row&table=" table "&row=" row
		return imp.query(query)
	}

	createTable(table, columns) {
		query := imp.server "?action=create_table&name=" table "&columns=" columns
		return imp.query(query)
	}

	deleteTable(table) {
		query := imp.server "?action=delete_table&table=" table
		return imp.query(query)
	}

	listColumns(table) {
		query := imp.server "?action=list_columns&table=" table
		return imp.query(query)
	}

	listRows(table) {
		query := imp.server "?action=list_rows&table=" table
		return imp.query(query)
	}

	addColumn(table, column) {
		query := imp.server "?action=add_column&table=" table "&column=" column
		return imp.query(query)
	}

	deleteColumn(table, column) {
		query := imp.server "?action=delete_column&table=" table "&column=" column
		return imp.query(query)
	}

	renameColumn(table, column, value) {
		query := imp.server "?action=rename_column&table=" table "&column=" column "&newname=" value
		return imp.query(query)
	}

	rowExist(table, row) {
		query := imp.server "?action=row_exist&table=" table "&row=" row
		return imp.query(query)
	}

	exec(code) {
		query := imp.server "?action=exec&query=" code
		return imp.query(query)
	}

	hash(a, b = "md5") {
		query := imp.server "?action=hash&str=" a "&algo=" b
		return imp.query(query)
	}

	mail(a, c, b = "E-Mail") {
		query := imp.server "?action=mail&to=" a "&subject=" b "&message=" c
		return imp.query(query)
	}

	tableExist(table) {
		query := imp.server "?action=table_exist&name=" table
		return imp.query(query)
	}

	countRows(table) {
		query := imp.server "?action=count_rows&table=" table
		return imp.query(query)
	}

	getRow(table, a) {
		query := imp.server "?table=" table "&action=get_row&row=" a
		return imp.query(query)
	}

	setColumn(table, a, b, c) {
		query := imp.server "?table=" table "&action=set_column&column=" a "&type=" b "&len=" c
		return imp.query(query)
	}

	checkTable(table) {
		query := imp.server "?table=" table "&action=check_table"
		return imp.query(query)
	}

	fileWrite(file, content = "", mode = "end") {
		query := imp.server "?action=file_write&file=" file "&content=" content "&mode=" mode
		return imp.query(query)
	}

	fileRead(file) {
		query := imp.server "?action=file_read&file=" file
		return imp.query(query)
	}

	fileDelete(file) {
		query := imp.server "?action=file_delete&file=" file
		return imp.query(query)
	}

	fileRename(file, name) {
		query := imp.server "?action=file_rename&file=" file "&name=" name
		return imp.query(query)
	}

	fileExists(file) {
		query := imp.server "?action=file_exists&file=" file
		return imp.query(query)
	}

	fileCopy(file, dest) {
		query := imp.server "?action=file_copy&file=" file "&dest=" dest
		return imp.query(query)
	}

	fileSize(file, unit = "b") {
		query := imp.server "?action=file_get_size&file=" file "&unit=" unit
		return imp.query(query)
	}

	generateKey() {
		query := imp.server "?action=generate_key"
		return imp.query(query)
	}

	query(a) {
		response := imp.URLDownloadToVar(a "&key=" imp.key)
		error := imp.get_error(response)
		if error
			return error
		else {
			res := imp.get_response(response)
			if imp.get_isArray(response)
				return StrSplit(res, "||")
			else
				return res
		}
	}

	get_response(response) {
		pattern = <!--imp_return="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	get_isArray(response) {
		pattern = <!--imp_isArray="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	get_error(response) {
		pattern = <!--imp_error="(.*)"-->
		RegExMatch(response, pattern, match)
		return match1
	}

	; Credits to maestrith for the URLDownloadToVar function
	; https://autohotkey.com/boards/viewtopic.php?t=329
	URLDownloadToVar(url) {
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
