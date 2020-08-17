# Settings

## What are pancake settings?

They are a set of parameters that define how pancake should behave. This article contains everything you need to know to configure your pancake library for your needs!

## General settings

* `background` ({r=1,g=1,b=1,a=1}) <- Defines how the background should look like. The `r`, `g`, `b` defines ratio of these colours and `a` defines how transparent background should be.

* `debugMode` (false) <- When set to `true`, pancake enters its debug mode! It has some cool features in it such as showing hitboxes, vectors and all different useful stuff.

* `smoothRender` (false) <- Defines if pancake should draw everything pixel perfect or not. You can turn it on and off to see the difference, but basically setting it to `false` makes your game work in true pixel mode and setting it to `true` will make the game look smoother.

* `autoDraw` (true) <- Defines whether pancake should draw display automatically or if the user wants to do it themselve. You can always draw pancake.canvas!

* `layerDepth` (0.75) <- Defines layer depth for the game. You can read more on that [here](http://mightypancake.games/#/documentation/topics/layers).

* `meter` (10) <- Defines how many pancake pixels is equal to a meter.

* `screenShake` (true) <- Defines if the display screen shake should work.

* `paused` (false) <- Defines whether the pancake should be in pause mode.

## Window settings

The window parameter is a table containing information on how to display things. You can read about them [here](http://mightypancake.games/#/documentation/topics/pancake_canvas?id=attributes)!
## Physics settings

Physics parameters determine how physic in your game will work.

* `gravityX` (0) <- Defines gravity's vector `x` parameter. It's probably going to be 0 most of the time, but hey, you can change it.

* `gravityY` (10×pancake.meter) <- Defines gravity's `y` parameter.

!> **NOTE:** Changing gravity affects only objects added *after* this action. If you want to globally change gravity for all [objects](http://mightypancake.games/#/documentation/topics/objects), you can do it through a loop, accessing `object.forces[1][axis]`!
