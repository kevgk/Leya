<?php

	#version 0.3
	require 'config.php';

	if($pin > 0)
	{
		if($_GET["key"] != round(date("H") * $pin, 4))
		{
			die();
		}
	}

	if(!empty($_GET["action"]) && $rights[$_GET["action"]])
	{

		if($_SERVER['HTTP_USER_AGENT'] != 'AutoHotkey' && AHK_ONLY) die();

		$connection	= mysql_connect(SERVER, USER, PASSWORD);
		if(!$connection)
		{
			die("Fehler: Es konnte keine Verbindung zum Server hergestellt werden.");
		}

		mysql_select_db(DATABASE, $connection) or die("Fehler: Datenbank konnte nicht gefunden werden.");
		
		$table = mysql_real_escape_string($_GET["table"], $connection);

		switch($_GET["action"])
		{
			case "read":
				$row 	= mysql_real_escape_string($_GET["a"], $connection);
				$column = mysql_real_escape_string($_GET["b"], $connection);

				if(!empty($row) && !empty($column))
				{				
					$primaryKey = mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$rowExist	= mysql_fetch_array(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

					if($rowExist[0] == $row)
					{
						$query = mysql_query("SELECT $column FROM $table WHERE $primaryKey[4]='$row'");
						$result = mysql_fetch_array($query);

						if(!$query)
						{
							echo "0";
						}
						else
						{
							echo $result[0];
						}
					}
					else
					{
						echo "-1";
					}
				}
				break;

			case "write":
				$row 	= mysql_real_escape_string($_GET["a"], $connection);
				$column = mysql_real_escape_string($_GET["b"], $connection);
				$value 	= mysql_real_escape_string($_GET["c"], $connection);

				if(!empty($row) && !empty($column))
				{
					$primaryKey = mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$rowExist 	= mysql_fetch_array(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

					if($rowExist[0] == $row)
					{
						$write 		= mysql_query("UPDATE `$table` SET `$column`='$value' WHERE `$primaryKey[4]`='$row'");		
						$success 	= mysql_fetch_array(mysql_query("SELECT `$column` FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

						if($success[0] == $value)
						{
							echo "1";
						}
					}
					else
					{
						echo "-1";
					}
				}
				break;

			case "create_row":
				$row = mysql_real_escape_string($_GET["a"], $connection);
				
				if(!empty($row))
				{
					$primaryKey = mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$rowExist 	= mysql_num_rows(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

					if($rowExist != 0)
					{
						echo "-1";
					}
					else
					{
						$create		= mysql_query("INSERT INTO $table ($primaryKey[4]) VALUES ('$row')");
						$success 	= mysql_num_rows(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

						if($success != 0)
						{
							echo "1";
						}
						else
						{
							echo "0";
						}
					}
				}
				break;

			case "delete_row":
				$row 			= mysql_real_escape_string($_GET["row"], $connection);
				$primaryKey 	= mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
				$rowExist 		= mysql_num_rows(mysql_query("SELECT * FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

				if($rowExist != 0)
				{
					$delete		= mysql_query("DELETE FROM $table WHERE $primaryKey[4]='$row'");
					$success 	= mysql_num_rows(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

					if($success != 0)
					{
						echo 0;
					}
					else
					{
						echo 1;
					}
				}
				else
				{
					echo "-1";
				}
				break;

			case "create_table":
				$name	 	= mysql_real_escape_string($_GET["name"], $connection);
				$tableExist = mysql_num_rows(mysql_query("SHOW TABLES LIKE '$name'"));

				if($tableExist !== 1)
				{
					$columns 	= mysql_real_escape_string($_GET["columns"], $connection);
					$args 		= explode(",", $columns);
					$queryStr 	= "CREATE TABLE $name (";

					foreach($args as $val) {
						$val = str_ireplace("alter", '`alter`', $val);
						$queryStr .= "$val VARCHAR (".FIELD_LENGTH."),";
					}

					$queryStr  	.= "PRIMARY  KEY (`$args[0]`))";
					$create 	= mysql_query($queryStr);
					$success 	= mysql_num_rows(mysql_query("SHOW TABLES LIKE '$name'"));

					if($success)
					{
						echo 1;
					}
					else
					{
						echo "0";
					}
				}
				else
				{
					echo "-1";
				}
				break;

			case "delete_table":
				$name	 	= mysql_real_escape_string($_GET["name"], $connection);
				$tableExist	= mysql_num_rows(mysql_query("SHOW TABLES LIKE '$name'"));

				if($tableExist)
				{
					$delete 	= mysql_query("DROP TABLE $name");
					$success 	= mysql_num_rows(mysql_query("SHOW TABLES LIKE '$name'"));
					if($success !== 1)
					{
						echo 1;
					}
					else
					{
						echo "0";
					}
				}
				else
				{
					echo "-1";
				}
				break;

			case "list_columns":
					$list = mysql_query("SHOW COLUMNS FROM $table");
					while($column = mysql_fetch_array($list))
					{
						$columns .= $column[0] . ",";
					}
					$columns = substr($columns, 0, -1);
					echo $columns;
				break;

			case "list_rows":
				$primaryKey = mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
				$rows 		= mysql_query("SELECT $primaryKey[4] FROM $table");

				while($row = mysql_fetch_array($rows))
				{
					$output .=  $row[$primaryKey[4]] . ", ";
				}

				$output = substr($output, 0, -2);
				echo $output;
				break;

			case "table_exist":
				$name = mysql_real_escape_string($_GET["name"], $connection);
				if(mysql_num_rows(mysql_query("SHOW TABLES LIKE '".$name."'")))
				{
					echo 1;
				}
				break;

			case "delete_column":
				$column = mysql_real_escape_string($_GET["column"], $connection);

				if(!empty($column))
				{
					$columnExist	= mysql_num_rows(mysql_query("SELECT $column FROM $table LIMIT 1"));
					
					if($columnExist)
					{
						$delete 	= mysql_query("ALTER TABLE $table DROP $column");
						$success	= mysql_num_rows(mysql_query("SELECT $column FROM $table LIMIT 1"));
						if($success != 1)
						{
							echo 1;
						}
						else
						{
							echo "0";
						}
					}
					else
					{
						echo "-1";
					}

				}
				break;
		
			case "add_column":
				$column = mysql_real_escape_string($_GET["column"], $connection);
				
				if(!empty($column))
				{
					$columnExist = mysql_num_rows(mysql_query("SELECT $column FROM $table LIMIT 1"));
					
					if($columnExist == 1)
					{
						echo "-1";
					}
					else
					{
						$add 		= mysql_query("ALTER TABLE $table ADD $column VARCHAR(128)");
						$success 	= mysql_num_rows(mysql_query("SELECT $column FROM $table LIMIT 1"));
						
						if($success)
						{
							echo 1;
						}
						else
						{
							echo "0";
						}
					}
				}	
				break;

			case "rename_column":
				$column 		= mysql_real_escape_string($_GET["column"], $connection);
				$newname 		= mysql_real_escape_string($_GET["newname"], $connection);
			
				if(!empty($column) && !empty($newname))
				{
					$primaryKey 	= mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$columnExist	= mysql_num_rows(mysql_query("SELECT $column FROM $table LIMIT 1"));
					
					if($columnExist)
					{		
						$rename		= mysql_query("ALTER TABLE $table CHANGE $column $newname VARCHAR(128)");
						$success	= mysql_num_rows(mysql_query("SELECT $newname FROM $table LIMIT 1")); //yolo
						
						if($success == 1)
						{
							echo "1";
						}
						else
						{
							echo "0";
						}
					}
					else
					{
						echo "-1";
					}
				}
				break;

			case "row_exist":
				$row = mysql_real_escape_string($_GET["row"], $connection);
				
				if(!empty($row))
				{
					$primaryKey 	= mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$rowExist 		= mysql_num_rows(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));
					
					if($rowExist != 0)
					{
						echo 1;
					}
					else
					{
						echo "0";
					}
				}
				break;

			case "exec":
				$query	= $_GET['query'];
				$result = mysql_query($query);
				$result = mysql_fetch_assoc($result);
				
				if(is_array($result))
				{
					for ($i = 0, $x = sizeof($result); $i < $x; ++$i)
					{
						echo key($result)." = ".current($result).", \n";
						next($result);
					}
				}
				else
				{
					if(mysql_affected_rows($result) >= 0)
					{
						echo 1;
					}
				}
				break;

			case "mail":
				$to 		= $_GET["to"];
				$subject 	= $_GET["subject"];
				$message 	= $_GET["message"];
				
				if(!empty($to) && !empty($message))
				{
					$mail = mail($to, $subject, $message, "From: ".MAIL_SENDER);
					echo ($mail) ? 1 : 0;	
				}
				break;

			case "hash":			
				$str	= $_GET["str"];
				$algo	= $_GET["algo"];
				
				if(!empty($str) && !empty($algo))
				{
					if(in_array($algo, hash_algos()))
						echo hash($algo, $str);
				}
				break;
				
			case "read_where":
				$column_where 	= mysql_real_escape_string($_GET["where"], 	$connection);
				$row_where 		= mysql_real_escape_string($_GET["is"], 	$connection);
				$column 		= mysql_real_escape_string($_GET["column"], $connection);

				if(!empty($column_where) && !empty($row_where) && !empty($column))
				{
					$query = mysql_query("SELECT $column FROM $table WHERE $column_where='$row_where'");
					
					if(!$query)
					{
						echo "0";
					}
					else
					{
						while($res = mysql_fetch_array($query))
						{
							$str .= $res[0] . ", ";
						}
						echo substr($str, 0, -2);
					}
				}
				break;
			
			case "read_where_not":
				$column_where 	= mysql_real_escape_string($_GET["where"], 	$connection);
				$row_where 		= mysql_real_escape_string($_GET["is"], 	$connection);
				$column 		= mysql_real_escape_string($_GET["column"], $connection);

				if(!empty($column_where) && !empty($row_where) && !empty($column))
				{
					$query = mysql_query("SELECT $column FROM $table WHERE $column_where!='$row_where'");
					
					if(!$query)
					{
						echo "0";
					}
					else
					{
						while($res = mysql_fetch_array($query))
						{
							$str .= $res[0] . ", ";
						}
						echo substr($str, 0, -2);
					}
				}
				break;
				
			case "read_where_greater":
				$column_where 	= mysql_real_escape_string($_GET["where"], 	$connection);
				$row_where 		= mysql_real_escape_string($_GET["is"], 	$connection);
				$column 		= mysql_real_escape_string($_GET["column"], $connection);

				if(!empty($column_where) && !empty($row_where) && !empty($column))
				{
					$query = mysql_query("SELECT $column FROM $table WHERE $column_where > '$row_where'");
					
					if(!$query)
					{
						echo "0";
					}
					else
					{
						while($res = mysql_fetch_array($query))
						{
							$str .= $res[0] . ", ";
						}
						echo substr($str, 0, -2);
					}
				}
				break;
				
			case "read_where_less":
				$column_where 	= mysql_real_escape_string($_GET["where"], 	$connection);
				$row_where 		= mysql_real_escape_string($_GET["is"], 	$connection);
				$column 		= mysql_real_escape_string($_GET["column"], $connection);

				if(!empty($column_where) && !empty($row_where) && !empty($column))
				{
					$query = mysql_query("SELECT $column FROM $table WHERE $column_where < '$row_where'");
					
					if(!$query)
					{
						echo "0";
					}
					else
					{
						while($res = mysql_fetch_array($query))
						{
							$str .= $res[0] . ", ";
						}
						echo substr($str, 0, -2);
					}
				}
				break;
				
			case "compare":
				$row 		= mysql_real_escape_string($_GET["a"], $connection);
				$column 	= mysql_real_escape_string($_GET["b"], $connection);
				$compare 	= $_GET["c"];
				
				if(!empty($row) && !empty($column) && !empty($compare))
				{				
					$primaryKey = mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$rowExist	= mysql_fetch_array(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));
					
					if($rowExist[0] == $row)
					{
						$query = mysql_query("SELECT $column FROM $table WHERE $primaryKey[4]='$row'");
						$result = mysql_fetch_array($query);
						
						if($result[0] == $compare)
						{
							echo 1;
						}
						else
						{
							echo "0";
						}
					}
					else
					{
						echo "-1";
					}
				}
				break;
				
			case "count_rows":
				$result = mysql_query("SELECT count(1) FROM $table");
				$row 	= mysql_fetch_array($result);
				
				echo $row[0];
				break;

			case "get_row":
				$row = mysql_real_escape_string($_GET["row"], $connection);
				
				if(!empty($row))
				{				
					$primaryKey 	= mysql_fetch_array(mysql_query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'"));
					$rowExist		= mysql_fetch_array(mysql_query("SELECT $primaryKey[4] FROM $table WHERE $primaryKey[4]='$row' LIMIT 1"));

					if($rowExist[0] == $row)
					{
						$query = mysql_query("SELECT * FROM $table WHERE $primaryKey[4]='$row'");
						$result = mysql_fetch_assoc($query);
						
						foreach($result as $column => $value)
						{
							$str .= $column . ": " . $value . ", ";
						}
						
						echo substr($str, 0, -2);
					}
					else
					{
						echo "-1";
					}
				}
				break;
				
			case "check_table":
				$query 	= mysql_query("SELECT * FROM $table");
				
				while($content = mysql_fetch_assoc($query))
				{
					$str .= serialize($content);
				}
				
				$query = mysql_query("SELECT count(1) FROM $table");
				$rows 	= mysql_fetch_array($query);
				
				$str .= $rows[0];

				echo md5($str);
				break;
				
			default:
				die();	
		}
		mysql_close($connection);
	}
?>