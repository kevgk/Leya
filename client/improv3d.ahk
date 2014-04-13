#NoEnv
;Dokumentation: 	http://api.improv3d.de

;Der Pfad der improv3d.php auf ihrem Server
imp_server := "http://yourdomain.de/improv3d.php"

;Pin zur Verschlüsselung der Verbindung
imp_pin := 0

;-------------------------------------------------------------------------------------------

imp_read(table, a, b) {
	global imp_server
	query := imp_server "?action=read&table=" table "&a=" a "&b=" b imp_secure()
	return imp_query(query)
}

imp_read_where(table, a, b, c) {
	global imp_server
	query := imp_server "?action=read_where&table=" table "&where=" a "&is=" b "&column=" c imp_secure()
	return imp_query(query)
	
}

imp_read_where_not(table, a, b, c) {
	global imp_server
	query := imp_server "?action=read_where_not&table=" table "&where=" a "&is=" b "&column=" c imp_secure()
	return imp_query(query)
	
}

imp_read_where_greater(table, a, b, c) {
	global imp_server
	query := imp_server "?action=read_where_greater&table=" table "&where=" a "&is=" b "&column=" c imp_secure()
	return imp_query(query)
	
}

imp_read_where_less(table, a, b, c) {
	global imp_server
	query := imp_server "?action=read_where_less&table=" table "&where=" a "&is=" b "&column=" c imp_secure()
	return imp_query(query)
	
}

imp_write(table, a, b, c) {
	global imp_server
	query := imp_server "?action=write&table=" table "&a=" a "&b=" b "&c=" c imp_secure()
	return imp_query(query)
}

imp_compare(table, a, b, c) {
	global imp_server
	query := imp_server "?action=compare&table=" table "&a=" a "&b=" b "&c=" c imp_secure()
	return imp_query(query)
}

imp_create_row(table, a) {
	global imp_server
	query := imp_server "?action=create_row&table=" table "&a=" a imp_secure()
	return imp_query(query)
}

imp_delete_row(table, a) {
	global imp_server
	query := imp_server "?action=delete_row&table=" table "&row=" a imp_secure()
	return imp_query(query)
}

imp_create_table(table, a) {
	global imp_server
	query := imp_server "?action=create_table&name=" table "&columns=" a imp_secure()
	return imp_query(query)
}

imp_delete_table(table) {
	global imp_server
	query := imp_server "?action=delete_table&name=" table imp_secure()
	return imp_query(query)
}

imp_list_columns(table) {
	global imp_server
	query := imp_server "?action=list_columns&table=" table imp_secure()
	return imp_query(query)
}

imp_list_rows(table) {
	global imp_server
	query := imp_server "?action=list_rows&table=" table imp_secure()
	return imp_query(query)
}

imp_add_column(table, a) {
	global imp_server
	query := imp_server "?action=add_column&table=" table "&column=" a imp_secure()
	return imp_query(query)
}

imp_delete_column(table, a) {
	global imp_server
	query := imp_server "?action=delete_column&table=" table "&column=" a imp_secure()
	return imp_query(query)
}

imp_rename_column(table, a, b) {
	global imp_server
	query := imp_server "?action=rename_column&table=" table "&column=" a "&newname=" b imp_secure()
	return imp_query(query)
}

imp_row_exist(table, a) {
	global imp_server
	query := imp_server "?action=row_exist&table=" table "&row=" a imp_secure()
	return imp_query(query)
}

imp_exec(a) {
	global imp_server
	query := imp_server "?action=exec&query=" a imp_secure()
	return imp_query(query)
}

imp_hash(a, b = "md5") {
	global imp_server
	query := imp_server "?action=hash&str=" a "&algo=" b imp_secure()
	return imp_query(query)
}

imp_mail(a, c, b = "E-Mail") {
	global imp_server
	query := imp_server "?action=mail&to=" a "&subject=" b "&message=" c imp_secure()
	return imp_query(query)
}

imp_table_exist(table) {
	global imp_server
	query := imp_server "?action=table_exist&name=" table imp_secure()
	return imp_query(query)
	
}

imp_count_rows(table) {
	global imp_server
	query := imp_server "?action=count_rows&table=" table imp_secure()
	return imp_query(query)
	
}

imp_get_row(table, a) {
	global imp_server
	query := imp_server "?table=" table "&action=get_row&row=" a imp_secure()
	return imp_query(query)
}

imp_check_table(table) {
	global imp_server
	query := imp_server "?table=" table "&action=check_table" imp_secure()
	return imp_query(query)
}

imp_query(a) {
	urlDownloadToFile, %a%, %A_Temp%/response.tmp
	FileRead, response, %A_Temp%/response.tmp
	FileDelete, %A_Temp%/response.tmp
	if(response)
	{
		regex = <!--imp_return="(.*)"-->
		response := RegExMatch(response, regex, match)
		return match1
	}	
	else
		return false
}

imp_secure() {
	global imp_pin
	if(imp_pin > 0)
		return "&key=" round(A_Hour * imp_pin, 4)
}