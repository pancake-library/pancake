# Physics

## What are physics?

In pancake physics are set of rules that can be applied to certain objects in order to simulate our world. They include:
- Velocity and acceleration (with the use of [forces](http://mightypancake.games/#/documentation/topics/forces))
- Gravity
- Friction

!> **NOTE:** An object has to have physics applied in order to move (excluding use manually changing value of coordinate)!

## General use

Generally, you just apply physics to an object using [pancake.applyPhysics()](http://mightypancake.games/#/documentation/functions/pancake.applyPhysics()). Then you can apply forces to [forces](http://mightypancake.games/#/documentation/topics/forces))!

## Physic attributes

After applying physics to an object you can access its phycics related attributes. These include:
- `velocityX`/`velocityY` <- Axis representing velocity of an object.
- `mass` <- Object mass

The window parameter is a table containing information on how to display things. You can read about them [here](http://mightypancake.games/#/documentation/topics/pancake_canvas?id=attributes)!
## Physics settings

Physics parameters determine how physic in your game will work.

* `gravityX` (0) <- Defines gravity's vector `x` parameter. It's probably going to be 0 most of the time, but hey, you can change it.

* `gravityY` (10×pancake.meter) <- Defines gravity's `y` parameter.
