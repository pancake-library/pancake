# Pancake Canvas

## What is pancake canvas?

Pancake canvas is, as the name suggests, canvas that is reserved for pancake library. It's updated whenever [pancake.draw()](http://mightypancake.games/#/documentation/functions/pancake.draw()) is called. It can be accessed by `pancake.canvas`.

## Attributes

All parameters for pancake canvas are inside `pancake.window`. They're part of [pancake settings](http://mightypancake.games/#/documentation/topics/settings) and they will be saved. These attributes are as follows:

* `pixelSize`(5) <- Witdh and height of one pixel of `pancake.canvas`.
* `width`(64) <- Width (in pancake pixels) of the window.
* `height`(width) <- Height (in pancake pixels) of the window.
* `x`(Witdh_of_the_screen/2 - pancake.window.width/2) <- `X` coordinate of the physical display on which the canvas should be drawn.
* `y`(Height_of_the_screen/2 - pancake.window.height/2) <- `Y` coordinate of the physical display on which the canvas should be drawn.
* `offsetX`(0) <- Offset on the `X` axis of the image. This acts as a camera!
* `offsetY`(0) <- Offset on the `Y` axis of the image. This acts as a camera!

!> **NOTE:** All these attributes should be in a table called `window`!

?> **TIP:** You can adjust your camera manually using `offsetX` and `offsetY`. For example, settings `offsetX` to `-1` will make the camera move one pancake pixel to the left. You can also use [pancake.cameraFollow](http://mightypancake.games/#/documentation/topics/camera_follow) for easier camera movement!

## Example

```lua
--Setting pancake canvas to display 128 pancake pixels!
pancake.window.width = 128
pancake.window.height = 128
```
