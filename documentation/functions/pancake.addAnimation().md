# pancake.addAnimation()

## Description

This function is used to create [animation](http://mightypancake.games/#/documentation/topics/animations) data!

## Inputs

* `object_name` <- This is the name of the [object](http://mightypancake.games/#/documentation/topics/objects) that this [animation](http://mightypancake.games/#/documentation/topics/animations) will be used on. For more information head to [this article](http://mightypancake.games/#/documentation/topics/animations)
* `animation_name` <- Name of the action this [animation](http://mightypancake.games/#/documentation/topics/animations) is suppose to represent!
* `folder` <- String containing path to the [animation](http://mightypancake.games/#/documentation/topics/animations).
* `speed` (150) <- Time between frames in milliseconds.

## Outputs

* `animation` <- Table containing all data like frames, time between them, object name etc.

## Example

```lua
  pancake.addAnimation("player", "run", )
```

This will set images of all drawn [objects](http://mightypancake.games/#/documentation/topics/objects) to `nil`.
