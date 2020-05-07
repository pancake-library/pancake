# pancake.applyPhysics()

## Description

Applie [physics](http://mightypancake.games/#/documentation/topics/physics) to given [object](http://mightypancake.games/#/documentation/topics/objects). This includes:
- Aplying gravity
- Creating parameters such as: `mass`, `velocityX`, `velocityY` etc.
- If it's a collidable [object](http://mightypancake.games/#/documentation/topics/objects), friction will be applied on it.

## Inputs

* [`object`](http://mightypancake.games/#/documentation/topics/objects) <- Which [object](http://mightypancake.games/#/documentation/topics/objects) should be changed into physic object.

## Outputs

* `object_with_physics` <- Inputed object with physics applied!

## Example

```lua
meteor = pancake.applyPhysics(pancake.addObject({name = "meteor", image = "rock", x = 0, y = 0, width = 12, height = 12}))
```

This will add meteor [`object`](http://mightypancake.games/#/documentation/topics/objects) and apply physics to it!
