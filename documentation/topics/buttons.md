# Buttons

## What is a pancake button?

As the name suggest, it's a table that contains all data that pancake needs to create a clickable button! So, a button is just a special table that is added to pancake!

!> **NOTE:** The `x` and `y` coordinates are in the real display, not [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas)!

## Button attributes

In order to create a button, our table must have few attributes!

Buttons have their attributes that help you decide how they look, where they are and what they do. These are:
- `name` <- This is a string that **must** be asigned manually and has no default value!
- `x`(0)/`y`(0) <- Poisition on the display of the button. This is the position **ON THE SCREEN**, not on the [pancake canvas](http://mightypancake.games/#/documentation/topics/pancake_canvas)!
- `offsetX`(0)/`offsetY`(0) <- Offset of the image for the button. The value is in pancake pixels.
- `width`(image_width)/`height`(image_height) <- These are width and height of hitboxes of this button!
- `image`(button.name) <- String containg name of the pancake image that should be used to display button.
- `imageClicked`(button.name + "\_clicked") <- This is the image that should be displayed when button is pressed.
- `key`("b") <- What key on keyboard corresponds to this button. If this key will be pressed, the button will be pressed too!
- `func` <- Function that will run everytime this button is pressed

## How to add a button?

You add a button by using [`pancake.addButton()`](http://mightypancake.games/#/documentation/functions/pancake.addButton())

```lua
pancake.addButton({name = "left_button", height = 8, width = 8, func = leftPressed, key = "a"})
```

The command above will create a button with `name`, `height`, `width`, `func` and `key`.

For more information read [this article](http://mightypancake.games/#/documentation/functions/pancake.addButton())!

## How to check if a button is pressed?

You can check whether a button is pressed using [`pancake.isButtonClicked()`](http://mightypancake.games/#/documentation/functions/pancake.addButton()).
