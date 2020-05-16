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
rock = pancake.addObject({image = "rock" , name = "object", x = 0, y = 0, width = 10, height = 16})

--Changing image
rock.image = "tree"
```

As you can see, you can freely set image attribute of an [object](http://mightypancake.games/#/documentation/topics/objects) on start aswell as after it's creation.
