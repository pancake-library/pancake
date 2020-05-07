# Objects

## What is a pancake object?

Pancake object is part of data that you give to pancake so it can simulate things about this object. For example, you can create an object named player and give it animation/static image, apply physics to it, define if it should collide, etc.

## Object's attributes
### Here are the values that **every pancake object should have:**
* `x` <- Horizontal coordinate of the object. Combined with `y`, it defines the position of the object. This defines where the left edge of an object should be.

* `y` <- Vertical coordinate of the object. Combined with `x`, it defines the position of the object. This defines where the top edge of an object should be.

* `width` <- The width of the object. It's used for collision.

* `height` <- The height of the object. It's used for collision.

### Here are some parameters that are **optional:**

* `colliding` <- Tells if the object should collide with other objects with colliding set to true. If it's not set to anything, it will act as if it's false.

* `name` <- This tells pancake what name the object should have. It's very important when you want to animate the object using pancake's built-in animation system

* `image` <- This defines what image should be displayed for this object. *Remember, it is a string* containing the name you've given the image while adding it using pancake.addImage. If the object has no image set, it will be invisible, but will still collide and act as it was there!

* [`layer`](http://mightypancake.games/#/documentation/topics/layers) <- Defines what [layer](http://mightypancake.games/#/documentation/topics/layers) the object should be in.
### Other (less important):

* [`animation`](http://mightypancake.games/#/documentation/topics/animations) <- This contains the animation table of the object. You generally don't use it anywhere because you can use pancake.changeAnimation(object, animation_name) and that's easier. This table contains frames, speed, the current time of frame and its name in it.

* [`forces`](http://mightypancake.games/#/documentation/#/topics/forces)<- This contains all [forces](http://mightypancake.games/#/documentation/topics/forces) that are being applied on the object *(if physics were applied to it)* such as gravity.

### Physic attributes

It's advised to use [pancake.getStat()](http://mightypancake.games/#/documentation/functions/pancake.getStat()) to get a parameter that is related to physics such as friction, velocity, acceleration, mass or direction!

For a table of physic attributes, [click here](http://mightypancake.games/#/documentation/topics/physics?id=attributes)

## How to add an object?

Using [pancake.addObject()](http://mightypancake.games/documentation/functions/pancake.addObject()).
