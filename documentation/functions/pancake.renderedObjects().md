# pancake.renderedObjects()

## Description

This function is used to get all [objects](http://mightypancake.games/#/documentation/topics/objects) that are drawn to the screen!

!> **NOTE:** To prevent unnecessary drawing of off-screen [objects](http://mightypancake.games/#/documentation/topics/objects), pancake checks if their colliders are on the screen. Keep that in mind when setting [object's](http://mightypancake.games/#/documentation/topics/objects) width and height!

## Inputs

Nothing.

## Outputs

* [`objects`](http://mightypancake.games/#/documentation/topics/objects) <- List of all [objects](http://mightypancake.games/#/documentation/topics/objects) that are drawn on the current frame.

## Example

```lua
 for i = 1, #pancake.renderedObjects() do
   pancake.renderedObjects()[i].image = nil
 end
```

This will set images of all drawn [objects](http://mightypancake.games/#/documentation/topics/objects) to `nil`.
