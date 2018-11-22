<?php

	/** ---------------------------------------------------------------------------
	 *
	 *	Leya
	 *	MySQL / PHP API
	 *	Version: 2.0.0
	 *	https://github.com/kevgk/leya
	 *
	 *	You should not edit this file,
	 *	you can change your settings in the config.php file.
	 *
	 * ---------------------------------------------------------------------------*/

	error_reporting(0);
	header_remove('x-powered-by');
	require 'config.php';

	// Create global response object
	$ResponseObject = new ResponseObject();

	getRights();

	if (!empty($_GET['action']) && $rights[$_GET['action']] && isAuthorized()) {

		$mysqli	= dbConnect();
		$mysqli->set_charset('utf8');
		$mysqli->query("SET NAMES 'utf8'");
		$mysqli->query("SET CHARACTER SET 'utf8'");

		foreach($_GET as $key => $value) {
			if($key != 'query') {
				$_GET[$key] = $mysqli->escape_string($value);
			}
		}

		$table = $_GET['table'];

		switch($_GET['action']) {

			/** ---------------------------------------------------------------------------
			 *	imp.get()
			 * ---------------------------------------------------------------------------*/

			case 'get':
				if (!empty($_GET['row']) && !empty($_GET['column'])) {
					global $ResponseObject;
					$row = $_GET['row'];
					$column = $_GET['column'];
					$primaryKey = getPrimaryKey($table);

					if (!rowExist($row, $primaryKey)) {
						$ResponseObject->error = -1;
					} else {
						$query = $mysqli->query("SELECT $column FROM $table WHERE $primaryKey='$row' LIMIT 1");

						while($row = $query->fetch_assoc()) $result[] = $row;

						$ResponseObject->affectedRows = $mysqli->affected_rows;

						if ($mysqli->errno) {
							$ResponseObject->error = -2;
						}
						else {
							if ($result) {
								if (count($result) == 1) {
									$result = $result[0];
								}
								$ResponseObject->data = $result;
							}
						}
					}
					
				}
				break;


			/** ---------------------------------------------------------------------------
			 *	imp.getWhere()
			 * ---------------------------------------------------------------------------*/

			case "getWhere":
				global $ResponseObject;
				$column_where = $_GET["where"];
				$row_where = $_GET["is"];
				$column = $_GET["column"];
				$operator = $_GET['operator'];
				$operatorWhitelist = ['=', '!=', '<', '>', '>=', '<='];

				if (!empty($column_where) && !empty($row_where) && !empty($column) && in_array($operator, $operatorWhitelist)) {
					$query = $mysqli->query("SELECT $column FROM $table WHERE $column_where $operator $row_where");

					$ResponseObject->affectedRows = $mysqli->affected_rows;

					if ($mysqli->errno) {
						$ResponseObject->error = -2;
					}

					if ($mysqli->affected_rows >= 1) {
						while($row = $query->fetch_assoc()) $result[] = $row;

						if ($result) {
							if (count($result) == 1) {
								$result = $result[0];
							}
							$ResponseObject->data = $result;
						}
					}
					
				}
				break;

			case "set":
				global $ResponseObject;
				$row = $_GET["row"];
				$column = $_GET["column"];
				$value = $_GET["value"];

				if (!empty($row) && !empty($column)) {
					$primaryKey = getPrimaryKey($table);

					if (rowExist($row, $primaryKey)) {
						$mysqli->query("UPDATE `$table` SET `$column`='$value' WHERE `$primaryKey`='$row'");

						$ResponseObject->affectedRows = $mysqli->affected_rows;

						if ($mysqli->errno) {
							$ResponseObject->error = -2;
						}
					}
					else {
						$ResponseObject->error = -1;
					}
				}
				break;

			case "compare":
				global $ResponseObject;
				$row = $_GET["row"];
				$column = $_GET["column"];
				$compare = $_GET["value"];
				$caseInsensitive = $_GET["caseInsensitive"];


				if (!empty($row) && !empty($column) && !empty($compare)) {
					$primaryKey = getPrimaryKey($table);

					if (rowExist($row, $primaryKey)) {
						$query = $mysqli->query("SELECT $column FROM $table WHERE $primaryKey='$row'");
						$result = $query->fetch_array();

						if($caseInsensitive) {
							$result[0] = strtolower($result[0]);
							$compare = strtolower($compare);
						}

						if ($result[0] == $compare) {
							$ResponseObject->data = 1;
						}
						else {
							$ResponseObject->data = 0;
						}
					}
					else {
						$ResponseObject->error = -1;
					}
				}
				break;

			case "create_row":
				global $ResponseObject;
				$row = $_GET["row"];

				if (!empty($row)) {
					$primaryKey = getPrimaryKey($table);

					if (rowExist($row, $primaryKey)) {
						$ResponseObject->error = -1;
					}
					else {
						$mysqli->query("INSERT INTO $table ($primaryKey) VALUES ('$row')");
						
						$ResponseObject->affectedRows = $mysqli->affected_rows;

						if ($mysqli->errno) {
							$ResponseObject->error = -2;
						}
					}
				}
				break;

			case "delete_row":
				global $ResponseObject;
				$row = $_GET["row"];
				$primaryKey = getPrimaryKey($table);

				if (rowExist($row, $primaryKey)) {
					$mysqli->query("DELETE FROM $table WHERE $primaryKey='$row'");
					
					$ResponseObject->affectedRows = $mysqli->affected_rows;

					if ($mysqli->errno) {
						$ResponseObject->error = -2;
					}
				}
				else {
					$ResponseObject->error = -1;
				}
				break;

			case "create_table":
				global $ResponseObject;
				$name = $_GET["name"];
				$tableExist = $mysqli->query("SHOW TABLES LIKE '$name'")->num_rows;

				if ($tableExist !== 1) {
					$columns = $_GET["columns"];
					$args = explode(",", $columns);
					$queryStr = "CREATE TABLE $name (";

					foreach($args as $val) {
						$val = str_ireplace("alter", '`alter`', $val);
						$queryStr .= "$val VARCHAR (".FIELD_LENGTH."),";
					}

					$queryStr .= "PRIMARY  KEY (`$args[0]`))";
					$create = $mysqli->query($queryStr);
					$success = $mysqli->query("SHOW TABLES LIKE '$name'")->num_rows;

					if ($mysqli->errno) {
						$ResponseObject->error = -2;
					}
				}
				else {
					$ResponseObject->error = -1;
				}
				break;

			case "delete_table":
				global $ResponseObject;
				$name = $_GET["table"];
				$tableExist = $mysqli->query("SHOW TABLES LIKE '$name'")->num_rows;

				if ($tableExist) {
					$mysqli->query("DROP TABLE $name");

					$ResponseObject->affectedRows = $mysqli->affected_rows;

					if ($mysqli->errno) {
						$ResponseObject->error = -2;
					}

					$success = $mysqli->query("SHOW TABLES LIKE '$name'")->num_rows;
					if ($success !== 1) {
						$ResponseObject->data = 1;
					}
				}
				else {
					$ResponseObject->error = -1;
				}
				break;

			case "list_columns":
				global $ResponseObject;
					$query = $mysqli->query("SHOW COLUMNS FROM $table");

					$ResponseObject->affectedRows = $mysqli->affected_rows;

					if ($mysqli->errno) {
						$ResponseObject->error = -2;
					}

					while($row = $query->fetch_array()) $result[] = $row[0];

					$ResponseObject->data = $result;
				break;

			case "list_rows":
				global $ResponseObject;
				$primaryKey = getPrimaryKey($table);
				$query = $mysqli->query("SELECT $primaryKey FROM $table");

				while($row = $query->fetch_array()) $result[] = $row[0];

				$ResponseObject->data = $result;
				break;

			case "table_exist":
				global $ResponseObject;
				$name = $_GET["name"];
				if ($mysqli->query("SHOW TABLES LIKE '".$name."'")->num_rows) {
					$ResponseObject->data = 1;
				}

				$ResponseObject->affectedRows = $mysqli->affected_rows;

				if ($mysqli->errno) {
					$ResponseObject->error = -2;
				}

				break;

			case "delete_column":
				global $ResponseObject;
				$column = $_GET["column"];

				if (!empty($column)) {
					$columnExist	= $mysqli->query("SELECT $column FROM $table LIMIT 1")->num_rows;

					if ($columnExist) {
						if ($mysqli->query("ALTER TABLE $table DROP $column")) {
							$ResponseObject->data = 1;
						}

						$ResponseObject->affectedRows = $mysqli->affected_rows;

						if ($mysqli->errno) {
							$ResponseObject->error = -2;
						}

					}
					else {
						$ResponseObject->error = -1;
					}
				}
				break;

			case "add_column":
				global $ResponseObject;
				$column = $_GET["column"];

				if (!empty($column)) {
					$columnExist = $mysqli->query("SELECT $column FROM $table LIMIT 1")->num_rows;

					if ($columnExist == 1) {
						$ResponseObject->error = -1;
					}
					else {
						if ($mysqli->query("ALTER TABLE $table ADD $column VARCHAR(128)")) {
							$ResponseObject->data = 1;
						}

						$ResponseObject->affectedRows = $mysqli->affected_rows;

						if ($mysqli->errno) {
							$ResponseObject->error = -2;
						}
					}
				}
				break;

			case "rename_column":
				global $ResponseObject;
				$column = $_GET["column"];
				$newname = $_GET["newname"];

				if (!empty($column) && !empty($newname)) {
					$columnExist	= $mysqli->query("SELECT $column FROM $table LIMIT 1")->num_rows;

					if ($columnExist) {
						if ($mysqli->query("ALTER TABLE $table CHANGE $column $newname VARCHAR(128)")) {
							$ResponseObject->data = 1;
						}

						$ResponseObject->affectedRows = $mysqli->affected_rows;

						if ($mysqli->errno) {
							$ResponseObject->error = -2;
						}
					}
					else {
						$ResponseObject->error = -1;
					}
				}
				break;

			case "row_exist":
				global $ResponseObject;
				$row = $_GET["row"];

				if (!empty($row)) {
					$primaryKey = getPrimaryKey($table);

					if (rowExist($row, $primaryKey)) {
						$ResponseObject->data = 1;
					}

					$ResponseObject->affectedRows = $mysqli->affected_rows;

					if ($mysqli->errno) {
						$ResponseObject->error = -2;
					}
				}
				break;

			case "exec":
				global $ResponseObject;
				$query	= $_GET['query'];
				$result = $mysqli->query($query);

				$ResponseObject->affectedRows = $mysqli->affected_rows;

				if ($mysqli->errno) {
					$ResponseObject->error = $mysqli->errno;
				} else {
					if (preg_match('/^UPDATE/', $query)) 	{
						$ResponseObject->data = $result;
					}
					elseif (preg_match('/^SELECT/', $query)) {
						$out = [];
	
						while($row = $result->fetch_assoc()) {
							array_push($out, $row);
						}
	
						$ResponseObject->data = $out;
					}
				}
				break;

			case "mail":
			global $ResponseObject;
				$to = $_GET["to"];
				$subject = $_GET["subject"];
				$message = $_GET["message"];

				if (!empty($to) && !empty($message)) {
					if (mail($to, $subject, $message, "From: ".MAIL_SENDER)) {
						$ResponseObject->data = 1;
					}
				}
				break;

			case "hash":
				global $ResponseObject;
				$str	= $_GET["str"];
				$algo	= $_GET["algo"];

				if (!empty($str) && !empty($algo)) {
					if (in_array($algo, hash_algos()))
					$ResponseObject->data = hash($algo, $str);
				}
				break;

			case "count_rows":
				global $ResponseObject;
				$result = $mysqli->query("SELECT count(1) FROM $table");
				$row 	= $result->fetch_array();

				$ResponseObject->affectedRows = $mysqli->affected_rows;

				if ($mysqli->errno) {
					$ResponseObject->error = -2;
				}

				$ResponseObject->data = $row[0];
				break;

			case "check_table":
				global $ResponseObject;

				$query 	= $mysqli->query("SELECT * FROM $table");
				while($content = $query->fetch_assoc()) {
					$str .= serialize($content);
				}

				$ResponseObject->affectedRows = $mysqli->affected_rows;

				if ($mysqli->errno) {
					$ResponseObject->error = -2;
				}

				$ResponseObject->data = md5($str);
				break;

			case "generate_key":
				global $ResponseObject;
				$ResponseObject->data = md5(random_bytes(24));
				break;

			case "file_write":
				global $ResponseObject;
				$file = $_GET['file'];
				$content = $_GET['content'];
				$mode = $_GET['mode'];

				switch ($mode) {
					case 'overwrite':
						$handle = fopen($file, 'w');
						break;

					case 'end':
						$handle = fopen($file, 'a');
						break;
				}

				$s = fwrite($handle, $content);
				fclose($handle);

				if (empty($content) && file_exists($file)) {
					$ResponseObject->data = 1;
				}
				else {
					if ($s>0) {
						$ResponseObject->data = 1;
					}
				}
				break;

			case "file_read":
				global $ResponseObject;
				$file = $_GET['file'];
				$ResponseObject->data = file_get_contents($file);
				break;

			case 'file_delete':
				global $ResponseObject;
				$file = $_GET['file'];
				if (unlink($file)) {
					$ResponseObject->data = 1;
				}
				break;

			case 'file_rename':
				global $ResponseObject;
				$file = $_GET['file'];
				$name = $_GET['name'];

				if (rename($file, $name)){
					$ResponseObject->data = 1;
				}
				break;

			case 'file_copy':
				global $ResponseObject;
				$file = $_GET['file'];
				$dest = $_GET['dest'];

				if (copy($file, $dest)) {
					$ResponseObject->data = 1;
				}
				break;

			case 'file_exists':
				global $ResponseObject;
				$file = $_GET['file'];
				if (file_exists($file)) {
					$ResponseObject->data = 1;
				}
				break;

			case 'file_size':
				global $ResponseObject;
				$file = $_GET['file'];
				$unit = $_GET['unit'];

				switch ($unit) {
					case 'b':
						$divider = 1;
						break;

					case 'kb':
						$divider = 1024;
						break;

					case 'mb':
						$divider = 1048576;
						break;

					case 'gb':
						$divider = 1073741824;
						break;
				}

				$ResponseObject->data = filesize($file)/$divider;
				break;
		}
		
		$ResponseObject->affectedRows = $mysqli->affected_rows;

		if ($mysqli->errno) {
			$ResponseObject->error = -2;
		}

		

		$mysqli->close();
	}
	else {
		$ResponseObject->error = -4;
	}
	api_send($ResponseObject);

	function dbConnect() {
		$db = new mysqli(SERVER, USER, PASSWORD, DATABASE);
		if ($db->connect_errno) {
			imp_error('Can`t connect to database.');
			exit();
		}
		else {
			return $db;
		}
	}

	class ResponseObject {
		public $error;
		public $affectedRows;
		public $data;

		function __construct() {
			$this->error = 0;
			$this->affectedRows = 0;
			$this->data = null;
		}
	}

	function api_send($ResponseObject) {
		$json = json_encode($ResponseObject);
		echo '<!--response="'.$json.'"-->';
	}

	function getRights() {
		global $rights, $keys;
		if (!empty($_GET['key']) && is_array($keys[$_GET['key']])) {
			$nkey = $keys[$_GET['key']];

			foreach($nkey as $field => $value) {
				$rights[$field] = $value;
			}
		}
	}

	function isAuthorized() {
		global $keys, $ResponseObject;
		$key = $_GET['key'];

		if (in_array($key, $keys) || array_key_exists($key, $keys) || empty($keys) || ALLOW_UNAUTHENTICATED) {
			return true;
		}
		else {
			if (SHOW_AUTH_ERROR) {
				$ResponseObject->error = -3;
			}
			else {
				header("HTTP/1.0 404 Not Found");
				exit();
			}
		}
	}

	function getPrimaryKey($table) {
		global $mysqli;
		return $mysqli->query("SHOW KEYS FROM $table WHERE Key_name='PRIMARY'")->fetch_array()[4];
	}

	function rowExist($row, $primaryKey) {
		global $mysqli, $table;
		return $mysqli->query("SELECT * FROM $table WHERE $primaryKey='$row' LIMIT 1")->num_rows;
	}

?>
