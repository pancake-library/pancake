# pancake.changeAnimation()

## Description

Function used to apply previously added [animation](http://mightypancake.games/#/documentation/topics/animations) to an [object](http://mightypancake.games/#/documentation/topics/objects).

!> **NOTE:** As stated above, these [animations](http://mightypancake.games/#/documentation/topics/animations) **have to be added before using this function**. To add them, simply use [pancake.addAnimation()](http://mightypancake.games/#/documentation/functions/pancake.addAnimation())

## Inputs

* [`object`](http://mightypancake.games/#/documentation/topics/objects) <- Target [object](http://mightypancake.games/#/documentation/topics/objects). This object will have its [animation](http://mightypancake.games/#/documentation/topics/animations) changed!

## Outputs

Nothing.

## Example

```lua
 pancake.changeAnimation(player, "run")
```

This will change the [animation](http://mightypancake.games/#/documentation/topics/animations) of `player` [object](http://mightypancake.games/#/documentation/topics/objects) to "run".
