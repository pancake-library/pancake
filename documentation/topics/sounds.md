# Sounds

## What is a pancake sound?

It's a sound that can be added, played or muted with ease!

!> **NOTE:** Pancake only supports `.wav` files as sounds!

## How to add a sound?

You create a sound using [`pancake.addSound()`](http://mightypancake.games/#/documentation/functions/pancake.addSound()):

```lua
pancake.addSound("clap", "sounds")
```

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
