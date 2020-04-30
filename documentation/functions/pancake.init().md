# `pancake.init(settings)`

## Description

Initiates pancake and defines all pancake variables that are needed for the library to work properly. It also starts an animation that plays on start.

## Inputs:
* `settings` <- Table containing all settings of pancake such as window settings, background, physic values and such. You can read more about what to include here in [settings](https://github.com/pancake-library/pancake-wiki/wiki/settings) article on the wiki.

## Outputs:

**Nothing**

## Example

`function love.load()`

`	pancake.init({window = {pixelSize = love.graphics.getHeight()/64}})`

`end`

Initiates pancake library with the window.pixelSize so the pancake virtual screen/window will fit in height of the game's window
