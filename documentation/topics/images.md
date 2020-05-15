# Images

## What is a pancake image?

It's an image that can be added and will be stored in `pancake.images[image_name]`, where `image_name` is the name of image.

!> **NOTE:** Pancake only supports `.png` files as images!

## How to add an image?

You create a sound using [`pancake.addImage()`](http://mightypancake.games/#/documentation/functions/pancake.addImage()):

```lua
pancake.addSound("rock", "images")
```

For more information read [this article](http://mightypancake.games/#/documentation/functions/pancake.addImage())!

## How use an image?

You can use your images by providing their name as `image` attribute for:

- [`buttons`](http://mightypancake.games/#/documentation/topics/buttons)
- [`objects`](http://mightypancake.games/#/documentation/topics/objects)

For example:

```lua
pancake.addImage("rock", "images")
pancake.addImage("tree", "images")

--Setting image upon creation...
pancake.addObject({image = "rock" , name = "object", x = 0, y = 0, width = 10, height = 16})
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
