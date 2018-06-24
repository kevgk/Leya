## Changelog
### Version 1.2
- Renamed `imp.getRow` to `imp.getAll`
- `imp.getAll` now returns an object, with all values of a row, with key value pairs like `player.name` and `player.level`
- Dryed up query code in improv3d.ahk
- Internal helper functions now start with an underscore, like `imp._parseObject`

### Version 1.1
- imp.getWhere now returns an array if your query returns more than one result, if not, you get a string
- Added imp.join to turn arrays into strings

### Version 1.0
This version brings breaking changes with it and is not backwards compatible.

- Refactored the autohotkey part into a class (commands are now called like this: `imp.get()`)
- Changed all commands to camelCase
- Removed imp_read, use imp.get
- Removed imp_write, use imp.set
- Removed imp_read_where
- Removed imp_read_where_not
- Removed imp_read_where_greater
- Removed imp_read_where_less
- Added imp.getWhere, wich accepts a list of operators, eg. `=, !=, >, <, <=, >=`

### Version 0.6
- You can now assign specific permissions to keys
- Added alias imp_get for imp_read
- Added alias imp_set for imp_write

[Learn more about Authentification-Keys here](https://github.com/kevgk/AutoHotkey-MySQL-PHP-API/wiki/Authentification-Keys)

### Version 0.5
- Added imp_key (authenticate users with one or multiple keys)
- Improved error reporting

### Version 0.4.2
- Optimized and reduced db calls in imp_write, imp_delete_row and imp_create_row.

### Version 0.4.1
- Switched from URLDownloadToFile to URLDownloadToVar, to fix useragent restrictions on some servers.
*Credits to maestrith for the function

### Version 0.4
- Switched from MySQL to MySQLi
- Removed pin function
- Optimized code
- Translated into english

### Version 0.3.1
- Added support for hosts that append code to the output

### Version 0.3
- Added support for multiple tables
- Added imp_count_rows()
- Added imp_count_columns()
- Added imp_get_row()
- Added imp_check_table()

### Version 0.2.1
- Fixed a bug with imp_read_where(), where not all rows where searched
- Added imp_read_where_not()
- Added imp_read_where_greater()
- Added imp_read_where_less()

### Version 0.2
- Added imp_compare()
- Added imp_read_where()
- Added imp_exec()
- Added imp_hash()
- Added imp_mail()
- Added imp_table_exist()
- Code optimizations
- Added config.php
- Added AHK_ONLY setting
- Added FIELD_LENGTH setting

### Version 0.1
-  Initial release
