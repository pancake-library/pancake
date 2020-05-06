# Camera Follow

## What is pancake.cameraFollow?

Camera follow is a [pancake attribute](http://mightypancake.games/#/documentation/topics/pancake_attributes) that specifies which object the camera should follow! If set to `nil`, the camera won't update it's position.

## Example

```lua
function love.load()
  --Creating a player object and attaching camera to it
  player = pancake.addObject({name = "player", x = 0, y = 0, width = 8, height = 12, colliding = true, image = "human"})
  pancake.cameraFollow = player
end
```
