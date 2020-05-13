# pancake.getDirectionName()

## Descrition

This function gets string name of direction by combining axis (x or y) and binary direction (>0 or <0).

!> **NOTE:** If binary direction is set to 0, function will output empty string!

## Inputs

- `axis` <- This is the axis. It's either "y" or "x".
- `binary_direction` <- This decides what "side" of this axis will be our output.

## Outputs

- `direction_name` <- Our direction.

## Example

```lua
pancake.draw("Player is moving " .. pancake.getDirectionName("x", pancake.getStat(player, "directionX")) .. " and " .. pancake.getDirectionName("y", pancake.getStat(player, "directionY")))
```

The example above will show all directions that `player` [object](http://mightypancake.games/#/documentation/topics/objects) is moving towards.
