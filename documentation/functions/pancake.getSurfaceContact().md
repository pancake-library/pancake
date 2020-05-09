# pancake.getSurfaceContact()

## Description

This function returns how many pixels of each side of [object](http://mightypancake.games/#/documentation/topics/objects) are touching something collidable.

## Inputs

- [`object`](http://mightypancake.games/#/documentation/topics/objects) <- Which [object](http://mightypancake.games/#/documentation/topics/objects) should be inspected.

## Outputs
- `directions` <- Table containg surface contact for each side of the [object](http://mightypancake.games/#/documentation/topics/objects).
  * `left` <- Surface contact for left edge. This is the number of pancake pixels!
  * `right` <- Surface contact for right edge. This is the number of pancake pixels!
  * `up` <- Surface contact for up edge. This is the number of pancake pixels!
  * `down` <- Surface contact for down edge. This is the number of pancake pixels!

## Example

```lua
if pancake.getSurfaceContact(player).down > 3 then
  jump()
end
```

This example makes it so that `jump()` function will only be executed when player has contact with more then 3 pancake pixels.
