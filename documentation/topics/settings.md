# What are pancake settings?

They are a set of parameters that define how pancake should behave. This article contains everything you need to know to configure your pancake library for your needs!

## General settings

* `background` ({r=1,g=1,b=1,a=1}) <- Defines how the background should look like. The `r`, `g`, `b` defines ratio of these colours and `a` defines how transparent background should be.

* `debugMode` (false) <- When set to `true`, pancake enters its debug mode! It has some cool features in it such as showing hitboxes, vectors and all different useful stuff.

* `smoothRender` (false) <- Defines if pancake should draw everything pixel perfect or not. You can turn it on and off to see the difference, but basically setting it to `false` makes your game work in true pixel mode and setting it to `true` will make the game look smoother.

* `autoDraw` (true) <- Defines whether pancake should draw display automatically or if the user wants to do it themselve. You can always draw pancake.canvas!

* `layerDepth` (0.75) <- Defines layer depth for the game. You can read more on that https://github.com/pancake-library/pancake-wiki/wiki/Layers#layer-depth[here].

* `meter` (10) <- Defines how many pancake pixels is equal to a meter.

* `screenShake` (true) <- Defines if the display screen shake should work.

* `paused` (false) <- Defines whether the pancake should be in pause mode.

## Window settings

The window parameter is a table containing information on how to display things. These informations are as follows

* `x` (0) <- Defines horizontal coordinate of the window.

* `y` (0) <- Defines vertical coordinate of the window.

* `width` (64) <- Defines how many wide the pancake display should be. It's measured in pixels.

* `height` (width) <- Defines how high the pancake display should be. It's also measured in pixels.

* `pixelSize` (5) <- Defines how many real pixels in width and height should pancake pixel have. For example when it had it's default value 5,every pancake display pixel will be a 5×5 square.

* `offsetX` (0) <- Defines how many pancake pixels should screen be moved towards left/right.

* `offsetY` (0) <- Defines how many pancake pixels should screen be moved towards up/down.

## Physics settings

Physics parameters determine how physic in your game will work.

* `gravityX` (0) <- Defines gravity's vector `x` parameter. It's probably going to be 0 most of the time, but hey, you can change it.

* `gravityY` (10×pancake.meter) <- Defines gravity's `y` parameter. 
