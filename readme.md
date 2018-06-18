# :zap: Improv3d Api v0.5
## Requirements
    - Webserver(PHP4+)
    - MySQL database

## Installation
    - Open 'config.php', fill in your server data and adjust permissions.
    - Upload the 'improv3d.php' and 'config.php' files.
    - Open 'improv3d.ahk' and fill in you serveradress.

## Changelog
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

## Author
  - Kevin _'Improv3d'_ G.
