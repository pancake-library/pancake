# pancake.andCheck()

## Description

This function can check whether a table contains multiple keys (and all of them are present and not equal to `false`).

## Inputs

- `table` <- This the inspected table.
- `keys` <- This is the table that should contain all keys that you want to check for.

## Outputs

- `check` <- This is a boolean that is true if all of the given keys are in given table and none of them is equal to `false`!

## Example 

```lua
if pancake.andCheck(player_object, {"physics", "name", "ID", "stuff"})
  doSomething()
end
```

The example above will execute **ONLY** if player has attributes: "physics", "name", "ID" and "stuff" **and none of them is equal to `false`
