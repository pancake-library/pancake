# Layers

## What are the layers?

Layers exist so that the pancake library can see which [object](http://mightypancake.games/#/documentation/topics/objects) should be displayed before which. Pancake takes all [objects](http://mightypancake.games/#/documentation/topics/objects) which have the layer set to 1 or just don't have the layer set (which is the same for the library) and draws them. However, if there's an [object](http://mightypancake.games/#/documentation/topics/objects) with layer set to number bigger then 1 **(whole number)**, it will draw this [object](http://mightypancake.games/#/documentation/topics/objects) before drawing the rest. Basically, it defines which [objects](http://mightypancake.games/#/documentation/topics/objects) should be displayed at the top of which. For example, you might wanna set layers to 2 for your background [object](http://mightypancake.games/#/documentation/topics/objects)!

## How to change an [object]((http://mightypancake.games/#/documentation/topics/objects)'s layer?

You just type:

`object.layerDepth = value`

Where `object` is the [object](http://mightypancake.games/#/documentation/topics/objects) you want to change and `value` is a **whole** number that is bigger than 1.

## Layer depth

It's important to note that by default pancake will try to darken the below layers to make them look like a background. You can define how much they should be darkened (and if they should be at all) by setting the **pancake.layerDepth** to different values, where 0 will cause them not to get darker at all.

`pancake.layerDepth = 0.75`

> pancake library line that sets layer depth to 0.75
