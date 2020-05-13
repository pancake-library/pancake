# pancake.sumTables()

## Description

Sums two given table into one.

!> **NOTE:** This only includes number keys from 1 to #table (if 1 is even present).

## Inputs

- `table_1` <- This is the first table that will have the second one attached to it at the end.
- `table_2` <- This is th second table that will be added to the end of `table_1`.

## Outputs

- `final_table` <- This is the sum of two inputed tables.

## Example

```lua
one_table = {}
one_table[1] = {name = "Alex", age = 26, hair = "wavy"}
one_table[2] = {name = "Olaf", age = 32, hair = "no hair"}

--Now, there is also a second one.
another_table[1] = {name = "Alicia", age = 50, hair = "short"}
another_table[2 = {name = "Matt", age = 21, hair = "straight"}

--Now we can create one table contaning these two!

my_table = pancake.sumTables(one_table, another_table)

fact = my_table[1] == one_table[1]
fact = my_table[3] == another_table[1]
```

This example shows how to sum two tables.

?> **NOTE:** Both assigns of a value to `fact` will result in setting it to `true`!
