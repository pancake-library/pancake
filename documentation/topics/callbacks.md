# Callbacks

## What are callbacks?

A callback is a function that runs whenever something else happens. For example, if you create a function named love.draw() it will run every time your game tries to update the display, so it will run every frame.

## Pancake Callbacks

Pancake has 3 main callbacks:

* **pancake.onCollision()** <- Triggers whenever two colliding bodies collide

* **pancake.onOverlap()** <- Triggers whenever two bodies overlap (collide, but they don't have to be colliding bodies)

* **pancake.onLoad()** <- Triggers after load animation finishes

## LÖVE Callbacks

Here are some LÖVE callbacks that you might want to get familiar with:

* **[love.load()](https://love2d.org/wiki/love.load)** <- Triggers after your project loads

* **[love.update(dt)](https://love2d.org/wiki/love.update)** <- Triggers after dt amount of seconds (NOTE: dt is not a constant value and it's usually small)

* **[love.draw()](https://love2d.org/wiki/love.draw)** <- Triggers on each frame being drawn. Here's where you want to render things!

You can also visit [LÖVE's official tutorial](https://love2d.org/wiki/Tutorial:Callback_Functions). on callbacks!
