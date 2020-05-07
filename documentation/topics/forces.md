# Forces

## What is a force?

Force is a thing that works on an [object](http://mightypancake.games/#/documentation/topics/objects) to change its velocity. In pancake, forces are just a simple table! You can apply those forces or add them. A great example of force would be gravity or friction.

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

Now, if we were to apply this force it would change the velocity of and [object](http://mightypancake.games/#/documentation/topics/objects) by 10/[object](http://mightypancake.games/#/documentation/topics/objects).mass to left and 10/[object](http://mightypancake.games/#/documentation/topics/objects).mass to down every second!

## Optional parameters

Every force can also have one or all of the parameters above:

- `relativeToMass` <- Bolean. If `true`, the force will always be multiplied by [object](http://mightypancake.games/#/documentation/topics/objects)'s mass.
- `time`(Only when using [pancake.addForce()](http://mightypancake.games/#/documentation/functions/pancake.addForce())) <- Time in milliseconds that the force should be applied. If set to "infinite" it will be, well, infinit, meaning it won't decrease or change its value in any way.

## How to use a force?

After creating a force:
 ```lua
my_force = {x = 0, y = 10}
```

You still have to apply it. In order to do this, you have two options:
- Use [pancake.applyForce()](http://mightypancake.games/#/documentation/functions/pancake.applyForce()) - This will apply a force once when called. Usefull for a a quick action like jumping! It can also be moved every update for example.
- Use [pancake.addForce()](http://mightypancake.games/#/documentation/functions/pancake.addForce()) - This will add a force which then will be applied to this [object](http://mightypancake.games/#/documentation/topics/objects) until it's time parameter `force.time` (default value 1000 ms) hits 0. This is usefull when making a bullet that just has to fly! This is also the way gravity is implemented!

?> **TIP:** You can read about these functions just by clicking on them! You'll find everything covered with a lot more detail then here.
