# pancake.trash()

## Description

This function finds an object in a table using [pancake.find()](http://mightypancake.games/#/documentation/functions/pancake.find()) and then deletes it **after updating data**!

?> **TIP:** This function is used to delete things after the update, when doing so manually would cause potential problems.

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
fact = #table == 4 --This is still true!
--After the update ends
fact = #table == 4 --This becomes false, now #table == 3
```

The example above will trash table with "name" key set to "Alicia".

## Where to use pancake.trash()?

Consider this scenario:

```lua
my_table = {}
my_table[1] = {name = "Alex", age = 26, hair = "wavy"}
my_table[2] = {name = "Olaf", age = 32, hair = "no hair"}
my_table[3] = {name = "Alicia", age = 50, hair = "short"}
my_table[4] = {name = "Matt", age = 21, hair = "straight"}

--Now, a loop like this

for i = 1, #my_table do
  if my_table[i].name == "Olaf" then
    pancake.smartDelete(my_table, "Olaf")
  end
end
```

This loop will cause an error, since after "Olaf" is deleted, "Alicia" will be 2nd and "Matt" will become 3rd, leaving the 4th space empty! But we still check if `my_table[i].name == "Olaf"` and i is from 1 to 4, this means that when it will be equal to 4 it will check for `my_table[4].name` and since `my_table[4] == nil` it will produce an error while attempting to index a `nil` value.

To prevent this, just change `pancake.smartDelete` to `pancake.trash`!
