# pancake.round()

## Description

Rounds a number.

## Inputs

- `number` <- This is the number that will be rounded.

## Outputs

* `rounded_number` <- This is the number we inputed, but it's whole after being rounded.

## Example

```lua
  love.draw()
    pancake.print(pancake.round(meters_to_go) .. " meters to go!", 0, 0, pancake.window.pixelSize)
  end
```

The example above will display `meters_to_go` rounded, so they won't take too much space. This is a very usefeul function, keep it in mind!
