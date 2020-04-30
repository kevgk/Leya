#SingleInstance force

#include tests/Get.ahk
#include tests/Set.ahk
#include ../leya.ahk

; leya.debug := 1
leya.server := "http://localhost/Leya/server/leya.php"

global TABLE_NAME := "__leya_tests"

Gui, New, , Leya Test Runner
Gui, Add, ListView, r20 w700 Grid, Status|Function|Name
Get_Tests.run()
Set_Tests.run()
Gui, Show
return

GuiClose:
  ExitApp
