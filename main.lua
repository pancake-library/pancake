pancake =  require "pancake" 
function love.load()
	pancake.init({window = {pixelSize = love.graphics.getHeight()/64}}) --Initiating pancake and setting pixelSize, so that the pancake display will be the height of the window! pixelSize is how many pixels every pancake pixel should take
end

function pancake.onCollision() --This function will be called whenever a physic object collides with a colliding object!
	--Insert your amazing code here!
end

function pancake.onLoad() -- This function will be called when pancake start up is done (after the animation)
	--Insert your amazing code here!
end

function pancake.onOverlap(object1, object2, dt) -- This function will be called every time object "collides" with a non colliding object! Parameters: object1, object2 - objects of collision, dt - time of collision
	--Insert your amazing code here!
end

function love.draw()
	pancake.draw() --Sets the canvas right! If pancake.autoDraw is set to true (which is its default state) the canvas will be automatically drawn on the window x and y
end

function love.update(dt)
	pancake.update(dt) --Passing time between frames to pancake!
end

function love.mousepressed(x,y,button)
	pancake.mousepressed(x,y,button) -- Passing your presses to pancake!
end
