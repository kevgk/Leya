# Leya 1.3
_Formerly "Improv3d API"_
[![Gitter chat](https://badges.gitter.im/Improv3d-API.png)](https://gitter.im/Improv3d-API/Lobby)
## Installation
- Open `config.php`, fill in your server data and adjust permissions.
- Upload the `leya.php` and `config.php` files.

## Examples
```autohotkey
#include leya.ahk

leya.server := "http://my-server.com/leya.php"

level := leya.get("users", "playerA", "level")
msgbox PlayerA is on Level %level%.
```
```autohotkey
#include leya.ahk

leya.server := "http://my-server.com/leya.php"

; get an array with the names of users, where "level" is greater than 3
pros := leya.getWhere("users", "name", "level", ">", 3)

; turn the array into a comma seperated string
list := leya.join(pros, ", ")

msgbox %list% are over level 3.
```

```autohotkey
#include leya.ahk

leya.server := "http://my-server.com/leya.php"

player := leya.getAll("users", "improv3d")

msgbox % "Name: " player.name " Level: " player.level
```

## Security
If you share your application with others, they could figure out the url to your server and use the api against you. Depending on your configuration, they could read anything from the database, modify data or even delete all tables.

Don´t worry, the api has functions, to prevent this.

You should always use [Authentification-Keys](https://github.com/kevgk/leya/wiki/Authentification-Keys), so someone without a key, can´t access the api. When you´re working with multiple users, assign individual keys for every user, so you could easily block someone, or limit their permissions.

Only give users the permissions they need.

Don't hardcode keys in your application. Import them from a txt file or let users enter them.

```autohotkey
FileRead, userkey, %A_ScriptDir%/apikey

leya.key := userkey
```
