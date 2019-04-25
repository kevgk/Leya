# Leya 2.0.0
_Formerly "Improv3d API"_

[![Gitter chat](https://badges.gitter.im/Improv3d-API.png)](https://gitter.im/Improv3d-API/Lobby)
## About
Leya is an api that enables the work with MySQL databases in autohotkey, without exposing server credentials to the client. This is done by running the api on a php server, between the client and the database.

In addition to that, you get a powerful authentification & permission system.

You don´t need to write any SQL queries, leya gives you a collection of commands to access and alter the database, and builds the queries for you.

## Installation
- Open `config.php`, fill in your server data and adjust permissions.
- Upload the `leya.php` and `config.php` files.

## Api Response
### data
The api responds with an object containing your data and metadata at the root level of the object. When requesting an array of rows, with methods like getWhere, the results are put into an array with the name of the database.

### __error
When the __error value is empty or 0, no error occurred, while executing the function.

### __affectedRows
The amount of rows, that got affected by the function.

### example
Let's say you executed the get method and requested "username" and "role".
Your response is going to look like this:
```
{
  username
  role
  __error
  __affectedRows
}
```
```autohotkey
#include leya.ahk

leya.server := "http://my-server.com/leya.php"

player := leya.get("users", "playerA", "first_name, last_name")

if player.__error
  msgbox % player.__error
else
  msgbox The fullname of playerA is %player.first_name% %player.last_name%.
```

```autohotkey
#include leya.ahk

leya.server := "http://my-server.com/leya.php"

req := leya.getWhere("users", "*", "age", ">=", "18")

if req.__error
  msgbox % req.__error
else {
  msgbox Found %req.users.__affectedRows% users over 18.
  if req.users {
    ; loop over all users, over the age of 18
    for index, user in req.users {
        msgbox % user.first_name " " user.last_name
    }
  }
}
```


## Methods
### Database
#### Basic
- [get(table, row, column)](https://github.com/kevgk/Leya/wiki/leya.get)
- [getWhere(table, column, conditionColumn, operator, conditionValue)](https://github.com/kevgk/Leya/wiki/leya.getWhere)
- [set(table, row, column, value)](https://github.com/kevgk/Leya/wiki/leya.set)
- compare(table, row, column, value, caseInsensitive)

#### Rows
- createRow(table, row)
- deleteRow(table, row)
- listRows(table)
- countRows(table)
- rowExist(table, row)

#### Columns
- listColumns(table)
- addColumn(table, column)
- deleteColumn(table, column)
- renameColumn(table, column, value)
- setColumn(table, column, type, length)

#### Table
- createTable(table, columns)
- deleteTable(table)
- tableExist(table)
- checkTable(table)
- exec(query)

### File
- fileWrite(file, content, mode)
- fileRead(file)
- fileDelete(file)
- fileRename(file, name)
- fileExists(file)
- fileCopy(file, destination)
- fileSize(file, unit)

### Misc
- hash(content, algorithm)
- mail(reciever, message, subject)
- generateKey()
- join(array, seperator)

## Properties
- leya.server
- leya.key
- leya.debug

## Examples
```autohotkey
#include leya.ahk

leya.server := "http://my-server.com/leya.php"

player := leya.get("users", "playerA", "level")
msgbox PlayerA is on Level %player.level%
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

player := leya.get("users", "improv3d", "*")

msgbox % "Name: " player.name " Level: " player.level
```

## Security
If you share your application with others, they could figure out the url to your server and use the api against you. Depending on your configuration, they could read anything from the database, modify data or even delete all tables.

Don´t worry, the api has functions, to prevent this.

You should always use [Authentication-Keys](https://github.com/kevgk/leya/wiki/Authentication-Keys), so someone without a key, can´t access the api. When you´re working with multiple users, assign individual keys for every user, so you could easily block someone, or limit their permissions.

Only give users the permissions they need.

Don't hardcode keys in your application. Import them from a txt file or let users enter them.

```autohotkey
FileRead, userkey, %A_ScriptDir%/apikey

leya.key := userkey
```