#Improv3d Api v0.3.1
##Vorraussetzungen
    - Webserver(PHP4+)
    - MySQL Datenbank
    - FTP Client

##Installation
    -Öffnen Sie die 'config.php' und tragen Sie ihre MySql Datenbank Zugangsdaten in die dazu vorgesehenen Variablen ein.
    -Überprüfen Sie die Rechte und passen Sie diese ggf. an ihre Bedürfnisse an.
    -Laden Sie nun die 'improv3d.php' und die "config.php" auf ihren php-fähigen Webserver.
    -Öffnen Sie anschliessend die 'improv3d.ahk' und tragen Sie ihren Server mit Pfad zur 'improv3d.php' in die dafür vor gesehene Variable ein.

##Changelog
###Version 0.3.1
    - Die Api ist nun kompatibel mit Hostern, die Code an die Ausgabe der Datenbank anfügen.

###Version 0.3
    - Unterstützung für mehrere Tabellen hinzugefügt
    - imp_count_rows() hinzugefügt
    - imp_count_columns() hinzugefügt
    - imp_get_row() hinzugefügt
    - imp_check_table() hinzugefügt

###Version 0.2.1
    - imp_read_where() Fehler behoben, bei dem nicht alle Zeilen aus gelesen wurden
    - imp_read_where_not() hinzugefügt
    - imp_read_where_greater() hinzugefügt
    - imp_read_where_less() hinzugefügt

###Version 0.2
    - imp_compare() hinzugefügt
    - imp_read_where() hinzugefügt
    - imp_exec() hinzugefügt
    - imp_hash() hinzugefügt
    - imp_mail() hinzugefügt
    - imp_table_exist() hinzugefügt
    - Skript Optimierung
    - config.php hinzugefügt
    - AHK_ONLY Einstellung hinzugefügt
    - FIELD_LENGTH Einstellung hinzugefügt

###Version 0.1
    - Release

##Author
  - Kevin _'Improv3d'_ G.
