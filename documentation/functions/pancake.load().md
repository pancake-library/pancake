# pancake.load()

## Description

Loads previously saved data.

?> **NOTE:** All saved files are in your game's save directory. You can read more on where it is and how to find it [here](https://love2d.org/wiki/love.filesystem.getSaveDirectory)!

## Inputs

- `filename` <- Path to the file that is supposed to be loaded (relative to [save directory](https://love2d.org/wiki/love.filesystem.getSaveDirectory))!
- `data_type` <- This should be set to "table", if the loaded file was a table. Otherwise, it can be left empty.

## Outputs

Nothing.

## Example

```lua
players_stats = pancake.load()
```

This example will load file variable called `player_statistics` to file named "players_stats" in [save directory](https://love2d.org/wiki/love.filesystem.getSaveDirectory).
