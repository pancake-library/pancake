# Platformer tutorial

## Goal

The goal of this tutorial is to create a simple platformer game, where the player has to jump between platforms. It's not a complicated game, but once you get how the library works you can develop it however you want.

## Before you start

Make sure you're familiar with [Getting Started](http://mightypancake.games/#/tutorials/Getting_Started)  article, so you know the basics.

Also, keep in mind this tutorial is just kept as simple as possible, so it misses various information on different topics. However, whenever something is mentioned here you can always (and it's very advised to) click the link discussing the topic/function. Also, if you get lost, you can always visit the [platformer template](https://github.com/pancake-library/platformer-template) to see the goal and notice any mistakes of yours! With that being said, let's jump right into action!

## Quick set up

To start, download this empty game template for pancake library [here](https://github.com/pancake-library/empty-template).

After this, you have to search for the `main.lua` file (it should be in the main folder). Once you've found it, double click it and edit it in an editor of your choice.

Now search for this piece of code:
```lua
function love.load()
  pancake.init({window = {pixelSize = love.graphics.getHeight()/64}})
end
```

This is the line that [initiates the library](http://mightypancake.games/#/documentation/functions/pancake.init()). Long story short, it sets things up so they can work and loads [animation](http://mightypancake.games/#/documentation/topics/animations).

## Creating the player [object](http://mightypancake.games/#/documentation/topics/objects)

To create our player [object](http://mightypancake.games/#/documentation/topics/objects) simply use [pancake.addObject()](http://mightypancake.games/#/documentation/functions/pancake.addObject()) like this under the

```lua
pancake.init({window = {pixelSize = love.graphics.getHeight()/64}})
```

line of code:

```lua
player = pancake.addObject({x = 29, y = 30, width = 6, height = 11, name = "dexter", colliding = true, offsetX = -5, offsetY = -2})
```

This will create a variable named player and assign an [object](http://mightypancake.games/#/documentation/topics/objects) to it that has different [attributes](http://mightypancake.games/#/documentation/topics/objects?id=object39s-attributes). Now, we want to run our game to see the results of our work.

## Running the game

It's really simple. Press and hold the left mouse button on the folder that you store the game files in and drag it to "LÖVE.exe". If you don't have LÖVE yet, please head back to [Getting Started](http://mightypancake.games/#/tutorials/Getting_Started).

When you do this you should see that the pancake [animation](http://mightypancake.games/#/documentation/topics/animations) plays and nothing else really happens... Why is that? That's because our player [object](http://mightypancake.games/#/documentation/topics/objects) exists somewhere but it's actually invisible right now! Let's make him more alive, shall we?

## Invisible, yet alive

How do you make an [object](http://mightypancake.games/#/documentation/topics/objects) visible? Well, you give it an image or an [animation](http://mightypancake.games/#/documentation/topics/animations). In this case, we will create an [animation](http://mightypancake.games/#/documentation/topics/animations), so he doesn't look like he's dead. To make that, we need some images (frames), so that we can define our [animation](http://mightypancake.games/#/documentation/topics/animations)!
Go [here](https://github.com/pancake-library/platformer-template/tree/master/images) and download assets that are going to be used in this tutorial! After downloading them, copy the `images` folder and swap it with your `images` folder in your game folder!

Now, let's get back to coding. Under the line you've previously written, add these two:

```lua
pancake.addAnimation("dexter", "idle", "images/animations", 100)
pancake.addAnimation("dexter", "run", "images/animations", 50)
```

This adds two [animation](http://mightypancake.games/#/documentation/topics/animations)s that can be used by any [object](http://mightypancake.games/#/documentation/topics/objects) named `dexter`. You can read more on [animation](http://mightypancake.games/#/documentation/topics/animations)s [here](http://mightypancake.games/#/documentation/topics/animations).

While we're adding things, let's add images for the ground for boxes that the player will be able to interact with!

```lua
pancake.addImage("ground","images")
pancake.addImage("grass","images")
pancake.addImage("box","images")
```

This adds images that are going to be used. More on how it works [here](http://mightypancake.games/#/documentation/functions/pancake.addImage()).

Now, we need to apply the [animation](http://mightypancake.games/#/documentation/topics/animations) we made to the player [object](http://mightypancake.games/#/documentation/topics/objects) and it can be done with this line of code:

```lua
pancake.changeAnimation(player, "idle")
```

Now, let's check how the game looks! Once again drag the game folder to your LÖVE engine.

## Something is missing, I repeat, something is definitely missing

Everything works just fine!... Except, for a platformer game there is quite a small amount of platforms. Zero; to be precise. Let's quickly fix that!

Under this part of code:

```lua
function love.load()
  pancake.init({window = {pixelSize = love.graphics.getHeight()/64}})
  player = pancake.addObject({x = 29, y = 30, width = 6, height = 11, name = "dexter", colliding = true, offsetX = -5, offsetY = -2})
  pancake.addAnimation("dexter", "idle", "images/animations", 100)
  pancake.addAnimation("dexter", "run", "images/animations", 50)
  pancake.addImage("ground","images")
  pancake.addImage("grass","images")
  pancake.addImage("box","images")
  pancake.changeAnimation(player, "idle")
end
```

We are going to create a function; something that we can create easily platforms with! Let's write this down:

```lua
--Create a function to create a platform!
function createPlatform(x,y)
  for i = 0, 3 do
    pancake.addObject({x = x + i*8, y = y, image = "ground", colliding = true, width = 8, height = 8})
  end
end
```

This is a simple function that makes a platform by creating 4 [objects](http://mightypancake.games/#/documentation/topics/objects) named `ground` and placing them next to one another.

!>**Note:** This time we stated that `image` attribute of this [object](http://mightypancake.games/#/documentation/topics/objects) should be equal to `ground`. This refers to image that we added in the code (`pancake.addImage("ground", "images")`)

Now, let's use it! Go back to the body of love.load() function (the one you spent the most time in) and head to the last line of it, just before the `end` line.

Add this line to make use of `createPlatform()` function:

```lua
createPlatform(16, 56)
```

Now, run the game again by dragging its folder to the engine! You should see a platform covered in the grass below the player!

## Is this space?

Now, you might have noticed that the game is still missing something. That thing is definitely gravity for the player [object]((http://mightypancake.games/#/documentation/topics/objects), so it isn't just hovering above the platform forever. You can, of course, leave him like that, but in my opinion, it's not a very entertaining thing to do. So, let's apply physic to our player instead!

Under the line you've previously written add this piece of code:

```lua
pancake.applyPhysics(player)
```

Now, if you run the game the player [object](http://mightypancake.games/#/documentation/topics/objects) should fall on the platform!

## Last, _key_, component

With all of the above set up, we just need to make sure our `player` [object]((http://mightypancake.games/#/documentation/topics/objects) can actually be controlled! For this, we need to add buttons:

```lua
  pancake.addImage("right", "images")
  pancake.addImage("right_clicked", "images")
  right = pancake.addButton({name = "right", x = 18*pancake.window.pixelSize, y = love.graphics.getHeight() - 16*pancake.window.pixelSize, width = 14, height = 14, key = "d", scale = pancake.window.pixelSize})
```

This code adds images that should appear when a button named `right` is clicked and when it's not.  Now, let's do the same for other buttons like this:

```lua
  pancake.addImage("left", "images")
  pancake.addImage("left_clicked", "images")
  left = pancake.addButton({name = "left", x = 2*pancake.window.pixelSize, y = love.graphics.getHeight() - 16*pancake.window.pixelSize, width = 14, height = 14, key = "a", scale = pancake.window.pixelSize})
  pancake.addImage("jump", "images")
  pancake.addImage("jump_clicked", "images")
  jump = pancake.addButton({name = "jump", x = love.graphics.getWidth() - 16*pancake.window.pixelSize, y = love.graphics.getHeight() - 16*pancake.window.pixelSize, width = 14, height = 14, key = "w", scale = pancake.window.pixelSize})
```

Now, run the game and see what changes. You should see two buttons that can be clicked or just get pressed by hitting `a`, `w` or `d` key on your keyboard!

## Making buttons useful

Although the buttons can be freely pressed they still do nothing. Let's change that!

Navigate to the line that contains this piece of code:

```lua
function love.update(dt)
  pancake.update(dt) --Passing time between frames to pancake!
end
```

This is where all time-based things happen in pancake and LÖVE engine in general! The `dt` is a number that tells how many seconds have passed since the last update. For more info head to [Getting Started](http://mightypancake.games/#/tutorials/Getting_Started) or [LÖVE's documentation on love.update()](https://love2d.org/wiki/love.update).

Under this line

```lua
pancake.update(dt) --Passing time between frames to pancake!
```

add the following one:

```lua
if pancake.isButtonClicked(right) and pancake.facing(player).down then
  pancake.applyForce(player, {x = 200, y = 0, relativeToMass = true})
  pancake.changeAnimation(player, "run")
  player.flippedX = false
end
```

Now, let's discuss what each line does. First one:

```lua
if pancake.isButtonClicked(right) and pancake.facing(player).down then
```

opens an `if` that checks if the right button is clicked and if the player [object](http://mightypancake.games/#/documentation/topics/objects) is facing anything down (so that player won't be able to run while mid-air).

The second line:

```lua
pancake.applyForce(player, {x = 200, y = 0, relativeToMass = true})
```

makes sure that if conditions above are met, pancake should apply a force to `player` [object](http://mightypancake.games/#/documentation/topics/objects) that is only horizontal and relative to the [object](http://mightypancake.games/#/documentation/topics/objects)'s mass. This will move the `player` [object](http://mightypancake.games/#/documentation/topics/objects).

The third one:

```lua
pancake.changeAnimation(player, "run")
```

changes the [animation](http://mightypancake.games/#/documentation/topics/animations) of `player` [object](http://mightypancake.games/#/documentation/topics/objects) to "run". Pretty simple.

The next one:

```lua
player.flippedX = false
```

makes sure that our [object](http://mightypancake.games/#/documentation/topics/objects) isn't flipped on X-axis. In other words, makes sure that our image is "_facing_" right.

Now that you know what every line does let's mimic the code above to create the ability to move left!

```lua
if pancake.isButtonClicked(left) and pancake.facing(player).down then
  pancake.applyForce(player, {x = -200, y = 0, relativeToMass = true})
  pancake.changeAnimation(player, "run")
  player.flippedX = true
end
```

Finally, we want to make sure that when the player isn't moving the [animation](http://mightypancake.games/#/documentation/topics/animations) changes back! Let's add this piece of code below:

```lua
if not pancake.isButtonClicked(right) and not pancake.isButtonClicked(left) then
  if pancake.facing(player).down then
    if player.velocityX == 0 then
      pancake.changeAnimation(player, "idle")
    else
      player.image = "dexter_idle1"
      player.animation = nil  
    end
  else
    player.image = "dexter_run3"
    player.animation = nil
  end
end
```

This code makes sure that the `player` [object](http://mightypancake.games/#/documentation/topics/objects) won't look weird. If none of the movement keys are held and the player isn't moving, he'll go back to his `idle` [animation](http://mightypancake.games/#/documentation/topics/animations). If he is moving though, he will be standing still (which looks like he is stopping). Finally, if he is just not touching anything that is below him, the player will be having it's frame number 3 from `run` [animation](http://mightypancake.games/#/documentation/topics/animations) (which looks like he's jumping).

Run the game and observe what happens when you press the movement buttons!

## Let's bounce

The last thing we have to add is jumping, so let's do that! Add this code:

```lua
if pancake.isButtonClicked(jump) and pancake.facing(player).down then
  pancake.applyForce(player, {x = 0, y = -70, relativeToMass = true}, 1)
  player.image = "dexter_run3"
  player.animation = nil
end
```

This will make it so that when `jump` button is pressed a horizontal force of 70 (and also relative to mass) will be applied to `player` [object](http://mightypancake.games/#/documentation/topics/objects).

!>**NOTE:** This time we used 1 as the last parameter for `pancake.applyForce()` function. That is because by default all forces applied to an [object](http://mightypancake.games/#/documentation/topics/objects) are multiplied by the time this force is being applied, which by default is `dt`. This worked fine when we want to move because the same amount of time the button is pressed the [object](http://mightypancake.games/#/documentation/topics/objects) moves. However, this time the jump should always be the same height! That's why instead of leaving the last parameter blank, we set it to 1.

# What now?

Now you've mastered the basics of making a platformer in pancake! There are many, many things you can learn to improve your game, so please, take a look into the documentation [here](http://mightypancake.games/#/documentation).

You can add platforms, change jump height, movement speed and even [attach the camera to the player](http://mightypancake.games/#/documentation/topics/pancake_attributes?id=other)!

If by any chance you've lost, here's the [template](https://github.com/pancake-library/platformer-template) that you should end up with! Have fun baking!

-MightyPancake, developer
