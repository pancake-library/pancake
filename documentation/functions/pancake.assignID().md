# pancake.assignID()

## Description

Assign parameter named "ID" to the given table.

?> **TIP:** Every pancake [object](http://mightypancake.games/#/documentation/topics/objects), [force](http://mightypancake.games/#/documentation/topics/forces) and [timer](http://mightypancake.games/#/documentation/topics/timer) will have it's own ID uppon creation!

!> **NOTE:** This parameteris unique. This means that no matter how many times you will create one, there are no two tables that have two same ID's.

?> **TIP:** Given ID is a number (first one being, shockingly, 1) that increases after each ID assignement. The last given ID is stored in `pancake.lastID`!

## Inputs

- `table` <- This table will have an ID assigned to it!

## Outputs

- `table_with_ID` <- Same table, but it has ID now!

## Example

```lua
fact = my_table.ID == nil

--Assigning unique ID...

pancake.assignID(my_table)

fact my_table.ID != nil
```

The example above will assing ID to a `my_table` table!
