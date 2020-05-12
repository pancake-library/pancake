# pancake.smartDelete()

## Description

This function finds an object in a table using [pancake.find()](http://mightypancake.games/#/documentation/functions/pancake.find()) and then deletes it **immediately**!

## Inputs

- `table` <- Which table should be inspected.
- `value` <- What is the value pancake should be searching for.
- `key`("name") <- Key where the given value should be.

## Outputs

Nothing.

## Example

```lua
my_table = {}
my_table[1] = {name = "Alex", age = 26, hair = "wavy"}
my_table[2] = {name = "Olaf", age = 32, hair = "no hair"}
my_table[3] = {name = "Alicia", age = 50, hair = "short"}
my_table[4] = {name = "Matt", age = 21, hair = "straight"}
--Now we have to seach for Alicia
fact = #table == 4
--Now, we trash the object
pancake.trash(my_table, "Alicia")
fact = #table == 4 --This becomes false, now #table == 3
```

The example above will delete table with "name" key set to "Alicia".
