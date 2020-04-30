# pancake.addObject()

## Description

Creates and saves an object with given attributes with other [objects](http://mightypancake.games/documentation/topics/objects).

## Inputs:

`object_data` <- Table containing all attributes that the object should have

## Outputs:

[`object`](http://mightypancake.games/documentation/topics/objects) <- Pancake object

## Example

`player = pancake.addObject({name = "Bob", x = 0, y = 0, width = 10, height = 10, colliding = true, image = "bob})`

Creates an object with attribute name set to "Bob", x to 0, etc.
