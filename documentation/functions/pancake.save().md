# pancake.save()

## Description

Saves inputed data to memory of the computer. These files will stay on the machine even after the user exists your game!

?> **NOTE:** All saved files are in your game's save directory. You can read more on where it is and how to find it [here](https://love2d.org/wiki/love.filesystem.getSaveDirectory)!

## Inputs

- `data` <- Something that you want to save. It can be a string, number, boolean or even a table!
- `filename` <- Name of the file that will have given data. This can be also a path! So something like "saves/save_1" is a valid filename, since it only serves as the path for the file.

## Outputs

Nothing.

## Example

```lua
pancake.save(player_statistics, "players_stats")
```

This example will save variable called `player_statistics` to file named "players_stats" in [save directory](https://love2d.org/wiki/love.filesystem.getSaveDirectory).
