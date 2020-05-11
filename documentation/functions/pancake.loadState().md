# pancake.loadState()

## Description

Loads file and turns it into a single variable.

?> **NOTE:** All saved files are in your game's save directory. You can read more on where it is and how to find it [here](https://love2d.org/wiki/love.filesystem.getSaveDirectory)!

## Inputs

- `filename` <- Path to save state file that should be loaded from.

## Outputs

- `data` <- Save state data from file!

## Example

```lua
pancake.loadState("level_1")
```

This example shows how easy it is to load a potential level from pancake!
