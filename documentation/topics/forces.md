# Forces

## What is a force?

Force is a thing that works on an object to change its velocity. In pancake, forces are just a simple table! You can apply those forces or add them. A great example of force would be gravity or friction.

!> **NOTE:** Just like in real life, it takes more force to push something that has a bigger mass and less force to push something with smaller mass. The formula is **force/mass**. Keep that in mind!

## How to create a force?

Since they're just a table, you can start like that:

```lua
my_force = {}
```
That's just a blank table though... In order to make it a force we have to make an `x` and `y` value, like this:

```lua
my_force = {x = 10, y = 10}
```

Now, if we were to apply this force it would change the velocity of and object by 10/object.mass to left and 10/object.mass to down every second!

## Optional parameters

Every force can also have one or all of the parameters above:

- `relativeToMass` <- Bolean. If `true`, the force will always be multiplied by object's mass.
- `time`(Only when using [pancake.addForce()]()) <- Time in milliseconds that the force should be applied.

## How to use a force?

After creating a force:
 ```lua
my_force = {x = 0, y = 10}
```

You can apply it. In order to do this, you have two options:
- Use p

Where `object` is the [object](http://mightypancake.games/#/documentation/topics/objects) you want the animation to be applied to and `animation_name` is the name you gave it upon creation.

**NOTE:**

You can only apply animations to [objects](http://mightypancake.games/#/documentation/topics/objects) with the same name as the `object_name` parameter was used when creating the animation. For example:
```lua
player_object = pancake.addObject({x = 0, y = 0, width = 1, height = 1, name = "NAME"})
pancake.addAnimation("player", "idle", "images/animations) --Note that last parameter is empty, so it's set to 150
pancake.changeAnimation(player_object, "idle)
```

won't work because `player_object`'s name attribute is set to "NAME", instead of "player" and the animation won't load, because it was designed to be played only for [objects]((http://mightypancake.games/#/documentation/topics/objects) with name equal to "player"!
