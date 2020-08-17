# Physics

## What are physics?

In pancake physics are set of rules that can be applied to certain [[object](http://mightypancake.games/#/documentation/topics/objects)s](http://mightypancake.games/#/documentation/topics/[object](http://mightypancake.games/#/documentation/topics/objects)s) in order to simulate our world. They include:
- Velocity and acceleration (with the use of [forces](http://mightypancake.games/#/documentation/topics/forces))
- Gravity
- Friction

!> **NOTE:** An [object](http://mightypancake.games/#/documentation/topics/objects) has to have physics applied in order to move (excluding use manually changing value of coordinate)!

## General use

Generally, you just apply physics to an [object](http://mightypancake.games/#/documentation/topics/objects) using [pancake.applyPhysics()](http://mightypancake.games/#/documentation/functions/pancake.applyPhysics()). Then you can apply [forces](http://mightypancake.games/#/documentation/topics/forces) to [objects](http://mightypancake.games/#/documentation/topics/objects))!

## Physic attributes for objects

After applying physics to an [object](http://mightypancake.games/#/documentation/topics/objects) you can access its phycics related attributes. These include:
- `velocityX`/`velocityY` <- Axis representing velocity of an [object](http://mightypancake.games/#/documentation/topics/objects).
- `mass`(pancake.physics.defaultMass) <- The mass of the [object](http://mightypancake.games/#/documentation/topics/objects).
- `friction` <- This parameter is responsible for how strongly friction should affect the [object](http://mightypancake.games/#/documentation/topics/objects). Set this to 0 if the [object](http://mightypancake.games/#/documentation/topics/objects) should be frictionless (like an ice, so [objects](http://mightypancake.games/#/documentation/topics/objects)) can slide on it!).
- `maxVelocity`/`maxVelocityX`/`maxVelocityY`(pancake.physics.maxVelocity) <- This controls how fast the given [object](http://mightypancake.games/#/documentation/topics/objects) can move.
- [forces](http://mightypancake.games/#/documentation/topics/forces) <- Table containg all [forces](http://mightypancake.games/#/documentation/topics/forces) that were added using [pancake.addForce()](http://mightypancake.games/#/documentation/functions/pancake.addForce()) and are still being applied.
- [force](http://mightypancake.games/#/documentation/topics/forces)
  * `x` <- `X` parameter of resultant [force](http://mightypancake.games/#/documentation/topics/forces) that is working on [object](http://mightypancake.games/#/documentation/topics/objects).
  * `y` <- `Y` parameter of resultant [force](http://mightypancake.games/#/documentation/topics/forces) that is working on [object](http://mightypancake.games/#/documentation/topics/objects).

!> **NOTE:** To get any of the above parameter, use [pancake.getStat()](http://mightypancake.games/#/documentation/functions/pancake.getStat())!

## Pancake physics attributes

There are also few attributes that change overall rules of how pancake physics behave. All of them can be accessed in a table; `pancake.physics`:

- `defaultMass`(10) <- Default mass for [objects](http://mightypancake.games/#/documentation/topics/objects).
- `gravityX`(0)/`gravityY`(12*pancake.meter) <- Axis of gravity vector.
- `defaultMaxVelocity`/`defaultMaxVelocityX`/`defaultMaxVelocityY`(15*pancake.meter for all 3 values) <- Defines default value for max velocity. You can set different values for each axis.
- `defaultFriction`(0.75) <- Defines what's the default friction parameter for [objects](http://mightypancake.games/#/documentation/topics/objects)
