# pancake.addButton()

## Description

This function adds a clickable [button](http://mightypancake.games/#/documentation/topics/buttons) to the `pancake.buttons` table.

## Inputs

- [`button_data`](http://mightypancake.games/#/documentation/topics/buttons) <- Table containg all data for [button](http://mightypancake.games/#/documentation/topics/objects).

## Outputs

- [`button`](http://mightypancake.games/#/documentation/topics/buttons) <- A clickable button!

## Example

```lua
pancake.addSound({name = "left_button", height = 8, width = 8, func = leftPressed, key = "a"})
```

The example above will add a button with given attributes.
