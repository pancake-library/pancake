# pancake.addAssets()

## Description

Function that adds searches for any asset in the game's main directory and adds it to pancake!

!> **NOTE:** Pancake will only take `.wav` files for [sounds](http://mightypancake.games/#/documentation/topics/sounds) and `.png` files for images!

!> **NOTE:** This function is not capable of adding animations! If there are any in desired folder, they'll be treated as just images not related to anything!

!> **NOTE:** This might not be a good approach when your game has lots of assets, because they will be stored in pancake, resolving in a big memory drop!

## Inputs

Nothing.

## Outputs

Nothing.

## Example

```lua
pancake.addAssets()
```

The example above adds assets from you game directory. It **IS** that simple!

?> **TIP:** Usually call this function in love.load().
