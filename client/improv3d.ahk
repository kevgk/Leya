#NoEnv

/*!
* Improv3d MySQL/PHP API
*/

; improv3d.php path on your server
global imp_server := "http://yourdomain.de/improv3d.php"

;-------------------------------------------------------------------------------------------

imp_read(table, row, column) {
	query := imp_server "?action=read&table=" table "&row=" row "&column=" column
	return imp_query(query)
}

imp_read_where(table, conditionColumn, conditionValue, column) {
	query := imp_server "?action=read_where&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column
	return imp_query(query)

}

imp_read_where_not(table, conditionColumn, conditionValue, column) {
	query := imp_server "?action=read_where_not&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column
	return imp_query(query)
}

imp_read_where_greater(table, conditionColumn, conditionValue, column) {
	query := imp_server "?action=read_where_greater&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column
	return imp_query(query)
}

imp_read_where_less(table, conditionColumn, conditionValue, column) {
	query := imp_server "?action=read_where_less&table=" table "&where=" conditionColumn "&is=" conditionValue "&column=" column
	return imp_query(query)
}

imp_write(table, row, column, value) {
	query := imp_server "?action=write&table=" table "&row=" row "&column=" column "&value=" value
	return imp_query(query)
}

imp_compare(table, row, column, value) {
	query := imp_server "?action=compare&table=" table "&row=" row "&column=" column "&value=" value
	return imp_query(query)
}

imp_create_row(table, row) {
	query := imp_server "?action=create_row&table=" table "&row=" row
	return imp_query(query)
}

imp_delete_row(table, row) {
	query := imp_server "?action=delete_row&table=" table "&row=" row
	return imp_query(query)
}

imp_create_table(table, columns) {
	query := imp_server "?action=create_table&name=" table "&columns=" columns
	return imp_query(query)
}

imp_delete_table(table) {
	query := imp_server "?action=delete_table&table=" table
	return imp_query(query)
}

imp_list_columns(table) {
	query := imp_server "?action=list_columns&table=" table
	return imp_query(query)
}

imp_list_rows(table) {
	query := imp_server "?action=list_rows&table=" table
	return imp_query(query)
}

imp_add_column(table, column) {
	query := imp_server "?action=add_column&table=" table "&column=" column
	return imp_query(query)
}

imp_delete_column(table, column) {
	query := imp_server "?action=delete_column&table=" table "&column=" column
	return imp_query(query)
}

imp_rename_column(table, column, value) {
	query := imp_server "?action=rename_column&table=" table "&column=" column "&newname=" value
	return imp_query(query)
}

imp_row_exist(table, row) {
	query := imp_server "?action=row_exist&table=" table "&row=" row
	return imp_query(query)
}

imp_exec(code) {
	query := imp_server "?action=exec&query=" code
	return imp_query(query)
}

imp_hash(a, b = "md5") {
	query := imp_server "?action=hash&str=" a "&algo=" b
	return imp_query(query)
}

imp_mail(a, c, b = "E-Mail") {
	query := imp_server "?action=mail&to=" a "&subject=" b "&message=" c
	return imp_query(query)
}

imp_table_exist(table) {
	query := imp_server "?action=table_exist&name=" table
	return imp_query(query)

}

imp_count_rows(table) {
	query := imp_server "?action=count_rows&table=" table
	return imp_query(query)

}

imp_get_row(table, a) {
	query := imp_server "?table=" table "&action=get_row&row=" a
	return imp_query(query)
}

imp_set_column(table, a, b, c) {
	query := imp_server "?table=" table "&action=set_column&column=" a "&type=" b "&len=" c
	return imp_query(query)
}


imp_check_table(table) {
	query := imp_server "?table=" table "&action=check_table"
	return imp_query(query)
}

imp_file_write(file, content = "", mode = "end") {
	query := imp_server "?action=file_write&file=" file "&content=" content "&mode=" mode
	return imp_query(query)
}

imp_file_read(file) {
	query := imp_server "?action=file_read&file=" file
	return imp_query(query)
}

imp_file_delete(file) {
	query := imp_server "?action=file_delete&file=" file
	return imp_query(query)
}

imp_file_rename(file, name) {
	query := imp_server "?action=file_rename&file=" file "&name=" name
	return imp_query(query)
}

imp_file_exists(file) {
	query := imp_server "?action=file_exists&file=" file
	return imp_query(query)
}

imp_file_copy(file, dest) {
	query := imp_server "?action=file_copy&file=" file "&dest=" dest
	return imp_query(query)
}

imp_file_size(file, unit = "b") {
	query := imp_server "?action=file_get_size&file=" file "&unit=" unit
	return imp_query(query)
}

imp_query(a) {
	urlDownloadToFile, %a%, %A_Temp%/response.tmp
	FileRead, response, %A_Temp%/response.tmp
	FileDelete, %A_Temp%/response.tmp
	if(response) {
		regex = <!--imp_return="(.*)"-->
		response := RegExMatch(response, regex, match)
		return match1
	}
	else
		return 0
}
