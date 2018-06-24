# :zap: Improv3d Api v1.1
## Installation
- Open `config.php`, fill in your server data and adjust permissions.
- Upload the `improv3d.php` and `config.php` files.

## Examples
```autohotkey
#include improv3d.ahk

imp.server := "http://my-server.com/improv3d.php"

level := imp.get("users", "playerA", "level")
msgbox PlayerA is on Level %level%.
```
```autohotkey
#include improv3d.ahk

imp.server := "http://my-server.com/improv3d.php"

; get an array with the names of users, where "level" is greater than 3
pros := imp.getWhere("users", "name", "level", ">", 3)

; turn the array into a comma seperated string
list := imp.join(pros, ", ")

msgbox %list% are over level 3.
```

```autohotkey
#include improv3d.ahk

imp.server := "http://my-server.com/improv3d.php"

player := imp.getAll("users", "improv3d")

msgbox % "Name: " player.name " Level: " player.level
```
