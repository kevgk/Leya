<?php
	error_reporting(0);

	/*************************************************************
	* SERVER SETTINGS
	**************************************************************/
	DEFINE ("SERVER", "yourserver");
	DEFINE ("USER", "yourusername");
	DEFINE ("PASSWORD", "yourpassword");
	DEFINE ("DATABASE", "yourdatabase");
	DEFINE ("FIELD_LENGTH", 64);
	DEFINE ("MAIL_SENDER", "example@yourserver.de");
	DEFINE ("AHK_ONLY", false);

	/*************************************************************
	* PERMISSIONS
	**************************************************************/
	$rights = array(
		// MYSQL
		"read" => true,
		"write" => true,
		"create_row" => true,
		"delete_row" => true,
		"create_table" => true,
		"delete_table" => true,
		"list_columns" => true,
		"list_rows" => true,
		"table_exist" => true,
		"delete_column" => true,
		"add_column" => true,
		"rename_column" => true,
		"row_exist" => true,
		"exec" => true,
		"read_where" => true,
		"read_where_not" => true,
		"read_where_greater" => true,
		"read_where_less" => true,
		"compare" => true,
		"count_rows" => true,
		"get_row" => true,
		"check_table" => true,
		// FILE
		"file_write" => false,
		"file_read" => true,
		"file_delete" => false,
		"file_rename" => false,
		"file_copy" => false,
		"file_size" => true,
		"file_exists" => true,
		// MISC
		"mail" => true,
		"hash" => true
	);
?>
