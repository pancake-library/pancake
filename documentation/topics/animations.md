# Animations

## What is a pancake animation?

Pancake animation is a table that contains important data that is needed to animate an [object](http://mightypancake.games/#/documentation/topics/objects); change its image every _x_ amount of time. Such animation can then be applied to an [object](http://mightypancake.games/#/documentation/topics/objects).

## How to create animation?

You create animation by typing:

```lua
pancake.addAnimation(object_name, animation_name, folder, speed)
```

Where `object_name` is the name of the [object](http://mightypancake.games/#/documentation/topics/objects) this animation will be able to be applied to `animation_name` is the name of action this animation represents (for example running, idle, etc.), `folder` is the path where the animation is and `speed` is the speed of the animation, so how long a frame should last (expressed in milliseconds; the base value being 150).

!> **NOTE:** Animation frames have to be named using following pattern: object_name + animation_name + frame. For example: player_idle1, player_idle2, player_idle3 etc.

!> **NOTE:** Adding animation only declares it, you have to use [pancake.changeAnimation()](http://mightypancake.games/#/documentation/functions/pancake.changeAnimation()) to apply it to [object](http://mightypancake.games/#/documentation/topics/objects)

## How to use animations?

You apply your wonderful animations by typing:
 ```lua
pancake.changeAnimation(object, animation_name)
```

Where `object` is the [object](http://mightypancake.games/#/documentation/topics/objects) you want the animation to be applied to and `animation_name` is the name you gave it upon creation.

!> **NOTE:** You can only apply animations to [objects](http://mightypancake.games/#/documentation/topics/objects) with the same name as the `object_name` parameter was used when creating the animation. For example:
```lua
player_object = pancake.addObject({x = 0, y = 0, width = 1, height = 1, name = "NAME"})
pancake.addAnimation("player", "idle", "images/animations) --Note that last parameter is empty, so it's set to 150
pancake.changeAnimation(player_object, "idle)
```

won't work because `player_object`'s name attribute is set to "NAME", instead of "player" and the animation won't load, because it was designed to be played only for [objects](http://mightypancake.games/#/documentation/topics/objects) with name equal to "player"!
