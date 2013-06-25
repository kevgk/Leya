<?php

	/*************************************************************
	* Rechte:	true = erlauben | false = verbieten
	**************************************************************/
	
	$rights = array(
		"read" 					=>	true,
		"write" 				=>	true,
		"create_row" 			=>	true,
		"delete_row" 			=> 	true,
		"create_table" 			=>	true,
		"delete_table"			=>	false,
		"list_columns" 			=>	true,
		"list_rows" 			=>	true,
		"table_exist" 			=> 	true,
		"delete_column"			=> 	true,
		"add_column" 			=>	true,
		"rename_column" 		=> 	true,
		"row_exist" 			=> 	true,
		"exec" 					=> 	false,
		"mail" 					=> 	true,
		"hash" 					=> 	true,
		"read_where" 			=> 	true,
		"read_where_not" 		=> 	true,
		"read_where_greater"	=> 	true,
		"read_where_less"		=> 	true,
		"compare"				=> 	true,
		"count_rows"			=> 	true,
		"get_row"				=> 	true,
		"check_table"			=> 	true
	);
	
	/*************************************************************
	* Einstellungen
	**************************************************************/
	
	DEFINE ("SERVER", "localhost");
	DEFINE ("USER", "yourusername");
	DEFINE ("PASSWORD", "yourpassword");
	DEFINE ("DATABASE", "yourdatabase");
	DEFINE ("FIELD_LENGTH", 64);
	DEFINE ("MAIL_SENDER", "api@server.de");
	DEFINE ("AHK_ONLY", false);
	
	/*************************************************************
	* PIN Sicherung
	* 	Die PIN kann nur aus Zahlen bestehen
	* 	Ist PIN = 0 wird kein PIN benutzt
	*
	**************************************************************/
	$pin = 0;
	
?>