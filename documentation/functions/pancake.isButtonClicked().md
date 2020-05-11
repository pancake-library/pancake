# pancake.isButtonClicked()

## Description

Checks whether the given [button](http://mightypancake.games/#/documentation/topics/buttons) is clicked.

## Inputs

- [`button`](http://mightypancake.games/#/documentation/topics/buttons) <- Table containg all data for [button](http://mightypancake.games/#/documentation/topics/objects).

## Outputs

- `isClicked` <- Boolean that is `true` when [button](http://mightypancake.games/#/documentation/topics/buttons) is pressed. Otherwise, it's `false`.

## Example

```lua
if pancake.isButtonClicked(right_button) then
  move()
end
```

The example will execute `move()` only when `righ_button` [button](http://mightypancake.games/#/documentation/topics/buttons) is clicked.
