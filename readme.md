# :honeybee: Improv3d Api v0.4
## Requirements
    - Webserver(PHP4+)
    - MySQL database

## Installation
    - Open 'config.php', fill in your server data and adjust permissions.
    - Upload the 'improv3d.php' and 'config.php' files.
    - Open 'improv3d.ahk' and fill in you serveradress.

## Changelog
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
