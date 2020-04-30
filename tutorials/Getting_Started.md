# Getting started

First of all, to get you up and running you have to know some basics of Lua and LÖVE engine since pancake uses them. Lua is **really** simple, so I advise getting yourself an app that teaches you Lua or learning it in any other way you want.

*NOTE:*

Pancake is a library made of LÖVE engine and it *won't* work without it. If you don't have LÖVE engine yet, head to https://love2d.org/[this site] and download the version that is appropriate to your system!

If this step is already made, you have to get the concept of LÖVE callbacks. I'll briefly discuss what they are, but you can always visit https://love2d.org/wiki/Tutorial:Callback_Functions[LÖVE's official tutorial].

So a callback is a function that will run when something else happens. For example, if you create a function named love.draw() it will run every time your game tries to update the display, so it will run every frame.

# Pancake Callbacks

Pancake has 3 main callbacks:

* **pancake.onCollision()** <- Triggers whenever two colliding bodies collide

* **pancake.onOverlap()** <- Triggers whenever two bodies overlap (collide, but they don't have to be colliding bodies)

* **pancake.onLoad()** <- Triggers after load animation finishes

## LÖVE Callbacks

Here are some LÖVE callbacks that you might want to get familiar with:

* **love.load()** <- Triggers after your project loads

* **love.update(dt)** <- Triggers after dt amount of seconds (NOTE: dt is not a constant value and it's usually small)

* **love.draw()** <- Triggers on each frame being drawn. Here's where you want to render things!
