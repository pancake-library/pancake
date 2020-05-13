# pancake.find()

## Description

This is a small utility function that makes everything so much easier and save a lot of time! As the name suggests, it finds for something in the given table and returns the first table with that matches given value in given attribute!

!> **NOTE:** This function will only iterate through tables from 1 to #table. This means, only numeric keys are taken in!

## Inputs

- `table` <- Which table should be inspected.
- `value` <- What is the value pancake should be searching for.
- `key`("name") <- Key where the given value should be.

## Outputs

- `found_table` <- This is the first table that matches your research!
 * `i` <- This is the position of target table in the parent table

## Example and how it works

```lua
my_table = {}
my_table[1] = {name = "Alex", age = 26, hair = "wavy"}
my_table[2] = {name = "Olaf", age = 32, hair = "no hair"}
my_table[3] = {name = "Alicia", age = 50, hair = "short"}
my_table[4] = {name = "Matt", age = 21, hair = "straight"}
--Now we have to search for Alicia
alicia = pancake.find(my_table, 50, "age")
--or
alicia = pancake.find(my_table, "Alicia")
```

The example above will create a table and then search for Alicia in it!

?> **NOTE:** If the key is equal to "name", you can just ommit it!
