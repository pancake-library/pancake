# pancake.addFolder()

## Description

Function that adds certain folder to pancake as assets.

!> **NOTE:** Pancake will only take `.wav` files for [sounds](http://mightypancake.games/#/documentation/topics/sounds) and `.png` files for images!

!> **NOTE:** This function is not capable of adding animations! If there are any in desired folder, they'll be treated as just images not related to anything!

## Inputs

- `path` <- Path to the folder (relative to game directory!)

## Outputs

Nothing.

## Example

```lua
pancake.addFolder("images")
```

The example above would add a folder name "image" from the base directory of your game as assets!
