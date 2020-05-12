# pancake.print()

## Description

Simple function that displays text when called in draw. The text is in pseudo font which is made with squares only!

?> You can change every single character in this pseudo font!

## Inputs

- `text`(" ") <- String you want to print.
- `x`(0) <- Position on `x` axis of where the left upper corner of the first character will be printed.
- `y`(0) <- Position on `y` axis of where the left upper corner of the first character will be printed.
- scale(1) <- scale for the pseudofont. This is how much pixels wide and tall should every pixel of the pseudofont be!

## Outputs

Nothing.

## Example

```lua
--This is your love.draw() callback!

love.draw()
  pancake.print(love.timer.getFPS(),0,0,pancake.window.pixelSize)
end
```

This example will display number of frames per second in the left upper corner of the display!

!> **NOTE:** This is the real display, not [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas)!
