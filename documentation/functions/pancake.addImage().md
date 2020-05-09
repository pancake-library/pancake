# pancake.addImage()

## Description

Function that adds given image to `pancake.images`, so it can be easily used many times!

!> **NOTE:** All images in pancake **HAVE** to be `.png` files!

?> **TIP:** All images added that way are stored in `pancake.images[image_name]`, where `image_name` is the name that was called when adding it, thus, filename **without** `.png` extension.

## Inputs

- `name` <- Name of the image. This is the name of the files, aswell as the name of where the image will be stored in `pancake.images`. This doesn't include `.png`!
- `path` <- This is the path to the image **FOLDER**.

## Outputs

- `image` <- Image drawable of the given image.

## Example

```lua
pancake.addImage("rock", "images")
rock_object.image = "rock"
```

The example above will add an image named "rock" from "images/rock.png". Then, it changes the image attribute of `rock_object` [object](http://mightypancake.games/#/documentation/topics/objects) to "rock", which reffers to the image.
