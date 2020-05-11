# Buttons

## What is a pancake button?

As the name suggest, it's a table that contains all data that pancake needs to create a clickable button! So, a button is just a special table that is added to pancake!

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
pancake.addSound({name = "left_button", height = 8, width = 8, func = leftPressed, key = "d"})
```

The command above will create a button with

For more information read [this article](http://mightypancake.games/#/documentation/functions/pancake.addSound())!

## How to play sounds?

You play previously added sounds using [`pancake.playSound()`](http://mightypancake.games/#/documentation/functions/pancake.playSound()):

 ```lua
pancake.playSound("clap")
```

For more information read [this article](http://mightypancake.games/#/documentation/functions/pancake.playSound())!

## How to mute sounds?

To mute all sounds added to pancake use [`pancake.muteSounds()`](http://mightypancake.games/#/documentation/functions/pancake.muteSounds())

```lua
pancake.muteSounds(true)
```
For more information read [this article](http://mightypancake.games/#/documentation/functions/pancake.muteSounds())!

## What sound includes and how to find them?

All [sounds](http://mightypancake.games/#/documentation/topics/sounds) added that way are stored in `pancake.sounds[sound_name]`, where `sound_name` is the name that was called when adding it, thus, filename **without** `.wav` extension.

Every sound is a table containing:
- `name` <- Name of the sound.
- `sound` <- Sound itself.

These values can be edited however you want!
