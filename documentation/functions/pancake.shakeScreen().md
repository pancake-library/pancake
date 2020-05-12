# pancake.shakeScreen()

## Description

Shakes the screen a little bit (or more, depending on your needs of course)!

## Inputs

- `iterations`(6) <- How many times the jump between two different positions of [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas) should there be.
- `amplitude`(1) <- How much what's the biggest distance (in pancake pixels) that [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas) can move.
- `duration`(50) <- Duration (in milliseconds) of each "jump" between different positions of [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas).
- `mode`("external") <- String that determines the mode of shake. If set to **"internal"**, the content of [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas) will move instead of the whole [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas) itself. Otherwise, if left empty or set to **"external"**, the whole [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas) will shake.

## Outputs

Nothing.

## Example

```lua
pancake.shakeScreen()
```

The example above will make a screen shake effect using basic values!
