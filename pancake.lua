local pancake = {	}
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----                                  			    _                                 	  _											----
----                                      	   | |                                   (_)										----
----   __ __     __ _  _ __     ___     ___   | |  __   ___      ___   _ __     __ _   _   _ __     ___			----
----	|  _  \  / _  | |  _  \  / __|  / _  |  | |/ /  / _ \    / _ \ |  _ \   / _  | | | |  _ \   / _ \			----
----	| |_) | | (_| | | | | | | (__  | (_| | 	|   <  |  __/   |  __/ | | | | | (_| | | | | | | | |  __/			----
----	| .__/   \__,_| |_| |_|  \___|  \__,_| |_|\_\  \___|    \___| |_| |_|  \__, | |_| |_| |_|  \___|			----
----	| |                                                                     __/ |													----
----	|_|                                                                    |___/													----
----																																																				----
----																																										BY MIGHTYPANCAKE		----
--																																																					----
-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------v.1.0
--LIBRARIES USED:
local smallfolk = require "libraries/smallfolk" --smallfolk: https://github.com/gvx/Smallfolk

function pancake.init (settings)
	--Applying scale filter...
	love.graphics.setDefaultFilter( "nearest", "nearest", 1)
	--Creating important tables such as objects or images...
	pancake.objects = {}
	pancake.images = {}
	pancake.sounds = {}
	pancake.buttons = {}
	pancake.timers = {}
	pancake.trashbin = {}
	pancake.lastID = 0
	pancake.cameraFollow = nil
	defineLetters()
	--Applying other settings...
	pancake.debugMode = settings.debugMode or false
	--Setting window...
	local window = settings.window or {}
	window.pixelSize = window.pixelSize or 5
	local pixelSize = window.pixelSize
	window.width = window.width or 64
	window.height = window.height or window.width
	window.x = window.x or love.graphics.getWidth()/2 - pixelSize*window.width/2
	window.y = window.y or love.graphics.getHeight()/2 - pixelSize*window.height/2
	window.offsetX = window.offsetX or 0
	window.offsetY = window.offsetY or 0
	pancake.window = window
	pancake.canvas = love.graphics.newCanvas(pancake.window.width*pixelSize, pancake.window.height*pixelSize)
	--Setting background...
	local background = settings.background or {}
	background.r = background.r or 1
	background.g = background.g or 1
	background.b = background.b or 1
	background.a = background.a or 1
	pancake.background = background
	pancake.meter = settings.meter or 10
	local physics = settings.physics or {}
	physics.gravityX = physics.gravityX or 0*pancake.meter
	physics.gravityY = physics.gravityY or 12*pancake.meter
	physics.defaultmaxVelocity = physics.defaultmaxVelocity or 15*pancake.meter --quite fast to be honest
	physics.defaultMass = physics.defaultMass or 10 -- 10 is a rough equivalent of a pancake on plate :P
	physics.defaultBounciness = physics.defaultBounciness or 1
	physics.defaultFriction = physics.defaultFriction or 0.75
	physics.airResistance = physics.airResistance or 7 --how many Newtons/pixel should physics apply?
	physics.energyLoss = physics.energyLoss or 0
	pancake.physics = physics
	--End of physics
	pancake.onCollision = nil
	pancake.lastdt = 0.001
	pancake.smoothRender = settings.smoothRender or false
	pancake.target = nil
	pancake.targetLock = false
	pancake.autoDraw = true
	pancake.layerDepth = settings.layerDepth or 0.75
	pancake.animations = {}
	pancake.screenShake = true
	pancake.loadAnimation = {}
	pancake.paused = false
	if pancake.loadAnimation then
		for i = 1, 6 do
			pancake.addSound("pancake".. i)
		end
		pancake.paused = true
		pancake.addAnimation("pancake", "anim", "images/pancake animation", 200)
		local animation = pancake.loadAnimation
		animation.frames = 35
		animation.frame = 1
		animation.duration = 1000
		animation.time = 0
		animation[1] = pancake.animations.pancake.anim[1]
		animation[2] = pancake.animations.pancake.anim[2]
		animation[3] = pancake.animations.pancake.anim[1]
		animation[4] = pancake.animations.pancake.anim[2]
		animation[5] = pancake.animations.pancake.anim[1]
		animation[6] = pancake.animations.pancake.anim[2]
		animation[7] = pancake.animations.pancake.anim[3]
		for i = 4, 30 do
			animation[4+i] = pancake.animations.pancake.anim[i]
		end
		animation[35] = pancake.animations.pancake.anim[20]
	end
end
----------------------
--Drawing functions!--
----------------------
function pancake.draw()
	local scale = pancake.window.pixelSize
	local window = pancake.window
	--Drawing pancake canvas! WITH BORDERS!!
	love.graphics.setCanvas(pancake.canvas)
	love.graphics.clear()
	love.graphics.scale(scale)
	drawBackground()
	love.graphics.translate(-window.offsetX,-window.offsetY)
	if pancake.shake and pancake.shake.mode == "internal" then
		love.graphics.translate(pancake.shake.offsetX,pancake.shake.offsetY)
	end
	if pancake.debugMode then
		drawHitboxes()
	end
	drawObjects()
	if pancake.debugMode then
		drawNerdData()
		love.graphics.scale(1/scale)
		drawMoveVectors()
		love.graphics.scale(scale)
	end
	love.graphics.origin()
	if pancake.loadAnimation then
		drawLoadAnimation()
		love.graphics.origin()
	end
	--Drawing canvas...
	love.graphics.setCanvas()
	if pancake.autoDraw then
		if pancake.shake and pancake.shake.mode == "external" then
			love.graphics.translate(pancake.shake.offsetX*scale,pancake.shake.offsetY*scale)
		end
		love.graphics.draw(pancake.canvas, pancake.window.x, pancake.window.y)
		love.graphics.origin()
	end
	pancake.drawButtons()
	if pancake.debugMode then
		pancake.drawInfo()
	end
end

function drawLoadAnimation()
	local animation = pancake.loadAnimation
	local scale = pancake.window.pixelSize*pancake.window.height/16
	love.graphics.scale(scale)
	if not (animation.frame == 35 and animation.time >= 2500) then
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill", 0, 0, 16, 16)
		love.graphics.draw(pancake.images[animation[animation.frame]])
	end
	if animation.frame == 1 then
		love.graphics.setColor(0,0,0,1-(animation.time + 100)/animation.duration)
		love.graphics.rectangle("fill", 0, 0, 16, 16)
	elseif animation.frame == 35 and animation.time <= 2500 then
		love.graphics.setColor(0,0,0,(animation.time-1500)/1000)
		love.graphics.rectangle("fill", 0, 0, 16, 16)
	elseif animation.frame == 35 and animation.time >= 2500 then
		love.graphics.setColor(0,0,0,1-(animation.time - 2500)/1000)
		love.graphics.rectangle("fill", 0, 0, 16, 16)
	end
	love.graphics.setColor(1,1,1,1)
end

function drawMoveVectors()
	local pixelSize = pancake.window.pixelSize
	local scale = scale or pancake.window.pixelSize/6
	for i = 1, #pancake.renderedObjects() do
		local object = pancake.renderedObjects()[i]
		if object.physics then
			local valueX = object.velocityX
			local valueY = object.velocityY
			local x = object.x
			local y = object.y
			if not pancake.smoothRender then
				x = pancake.round(x)
				y = pancake.round(y)
			end
			x = x*pixelSize + object.width*pixelSize/2
			y = y*pixelSize + object.height*pixelSize/2
			love.graphics.line(x, y, x + valueX*scale,y + valueY*scale)
			love.graphics.setColor(0.2,0.2, 1, 1)
			x = object.x*pixelSize + object.width*pancake.window.pixelSize/2 + valueX*scale
			y = object.y*pixelSize + object.height*pancake.window.pixelSize/2 + valueY*scale
			love.graphics.line(x, y, x + object.force.x*scale/3,y + object.force.y*scale/3)
			love.graphics.setColor(1,1,1,1)
		end
	end
end

function pancake.renderedObjects()
	local window = pancake.window
	local ret = {}
	for i = 1, #pancake.objects do
		local object = pancake.objects[i]
		if pancake.collisionCheck({x = window.offsetX, y = window.offsetY, width = window.width, height = window.height}, object) then
			ret[#ret + 1] = object
		end
	end
	return ret
end

function pancake.drawInfo(x, y)
	local x = x or pancake.window.x
	local y = y or pancake.window.y
	love.graphics.translate(x, y)
	if pancake.target then

		local target = pancake.target
		pancake.print("Name: ".. pancake.boolConversion(target.name, target.name, " "), 0,0,3)
		pancake.print("X :" .. target.x or " ", 0,16,3)
		pancake.print("Y :" .. target.y or " ", 0,32,3)
		pressure = {down = pancake.getStat(target, "pressureDown"), up = pancake.getStat(target, "pressureUp"), right = pancake.getStat(target, "pressureRight"), left = pancake.getStat(target, "pressureLeft")}
		pancake.print("VX:" .. pancake.getStat(target, "velocityX"), 0,48,3)
		pancake.print("VY:" .. pancake.getStat(target, "velocityY"), 0,64,3)
		pancake.print("AX:" .. pancake.getStat(target, "accelarityX"), 0,80,3)
		pancake.print("AY:" .. pancake.getStat(target, "accelarityY"), 0,96,3)
		pancake.print("DOWN   surface:" .. pancake.getSurfaceContact(target).down .. "     pressure: " .. pressure.down, 0,112,3)
		pancake.print("UP        surface:" .. pancake.getSurfaceContact(target).up .. "    pressure: " .. pressure.up, 0,128,3)
		pancake.print("RIGHT surface:" .. pancake.getSurfaceContact(target).right .. "    pressure: " .. pressure.right, 0,144,3)
		pancake.print("LEFT   surface:" .. pancake.getSurfaceContact(target).left .. "    pressure: " .. pressure.left, 0,160,3)
		pancake.print("Friction: " .. pancake.getStat(target, "friction") or " ", 0,176,3)
		if not target.physics then
			pancake.print("no physics applied", 0,192,3)
		end
	end
	love.graphics.translate(-x, -y)
end

function pancake.windowToDisplay(x,y, cameraRelative)
	local ret
	if pancake.smoothRender then
		ret = {x = pancake.window.x + pancake.window.pixelSize*(x - pancake.boolConversion(cameraRelative, pancake.window.offsetX,0)), y = pancake.window.y + pancake.window.pixelSize*(y - pancake.boolConversion(cameraRelative,pancake.window.offsetY, 0))}
	else
		ret = {x = pancake.window.x + pancake.window.pixelSize*(pancake.round(x) - pancake.boolConversion(cameraRelative, pancake.round(pancake.window.offsetX),0)), y = pancake.window.y + pancake.window.pixelSize*(pancake.round(y) - pancake.boolConversion(cameraRelative, pancake.round(pancake.window.offsetY), 0))}
	end
	return ret
end

function drawBackground()
	local background = pancake.background
	love.graphics.setColor(background.r, background.g, background.b, background.a)
	if background.image then
		love.graphics.draw(background.image)
	else
		love.graphics.rectangle("fill", 0, 0, pancake.window.width, pancake.window.height)
	end
	love.graphics.setColor(1,1,1,1)
end

function drawObjects()
	local scale = pancake.window.pixelSize
	local x = 0
	local y = 0
	local objects = pancake.renderedObjects()
	--How many layers there are?
	local layers = 1
	for i = 1, #objects do
		local layer = objects[i].layer or 1
		layers = pancake.boolConversion(layer > layers, layer, layers)
	end
	for l = layers, 1, -1 do
		if l == 1 then
			love.graphics.setColor(1,1,1,1)
		else
			love.graphics.setColor(1 - (l-1)*pancake.layerDepth/layers, 1 - (l-1)*pancake.layerDepth/layers, 1 - (l-1)*pancake.layerDepth/layers, 1)
		end
		for i = 1, #objects do
			local object = objects[i]
			local layer = object.layer or 1
			if l == layer then
				if pancake.andCheck(object, {"x","y","image"}) then
					x = object.x
					y = object.y
					if not pancake.smoothRender then
						x = pancake.round(x)
						y = pancake.round(y)
					end
					local offsetX = pancake.boolConversion(object.offsetX, object.offsetX, 0)*pancake.boolConversion(object.flippedX, -1, 1)
					local offsetY = pancake.boolConversion(object.offsetY, object.offsetY, 0)*pancake.boolConversion(object.flippedY, -1, 1)
					love.graphics.draw(pancake.images[object.image], x + offsetX + pancake.boolConversion(object.flippedX, object.width, 0), y + offsetY + pancake.boolConversion(object.flippedY, object.height, 0), 0, pancake.boolConversion(object.flippedX, -1, 1),pancake.boolConversion(object.flippedY, -1, 1))
				end
			end
		end
	end
end

function pancake.changeAnimation(object, animationName)
	local animations = pancake.animations
	if animations[object.name] and animations[object.name][animationName] then
		if not (object.animation and object.animation.name == animationName) then
			local animationTemplate = animations[object.name][animationName]
			local animation = {}
			animation.name = animationName
			animation.frame = 1
			animation.frames = animationTemplate.frames
			animation.duration = animationTemplate.speed
			animation.time = 0
			for i = 1, #animationTemplate do
				animation[i] = animationTemplate[i]
			end
			object.animation = animation
		end
	end
end

function pancake.addAnimation(objectName, animationName, folder, speed)
	local speed = speed or 150
	local animations = pancake.animations
	if not animations[objectName] then
		animations[objectName] = {}
	end
	animations[objectName][animationName] = {}
	local animation = animations[objectName][animationName]
	local broke = false
	if #love.filesystem.getDirectoryItems(folder) > 1 then
		for frame = 1, 1000 do
			local addedFrame = false
			for i = 1, #love.filesystem.getDirectoryItems(folder) do
				local filename = love.filesystem.getDirectoryItems(folder)[i]
				if filename == objectName.."_"..animationName..frame..".png" then
					pancake.addImage(objectName.."_"..animationName..frame,folder)
					animation[frame] = objectName.."_"..animationName..frame
					addedFrame = true
				elseif i == #love.filesystem.getDirectoryItems(folder) and not addedFrame then
					broke = true
				end
			end
			if broke then
				animation.frames = frame - 1
				animation.speed = speed
				break
			end
		end
	end
	return animation
end

function drawNerdData()
local scale = pancake.window.pixelSize
	for i = 1, #pancake.renderedObjects() do
		local object = pancake.renderedObjects()[i]
		local x = object.x
		local y = object.y
		if not pancake.smoothRender then
			x = pancake.round(x)
			y = pancake.round(y)
		end
		pancake.print(i,x,y, 2/scale)
		pancake.print(object.ID, x, y + 10/scale, 2/scale)
	end
end

function drawHitboxes()
	local objects = pancake.renderedObjects()
	for i = 1, #objects do
		local object = pancake.renderedObjects()[i]
		local x = object.x
		local y = object.y
		if not pancake.smoothRender then
			x = pancake.round(x)
			y = pancake.round(y)
		end
		if pancake.andCheck(object, {"x", "y", "height", "width"}) then
			love.graphics.setColor(0.4, 1 ,0.4, 0.3)
			love.graphics.rectangle("fill", x, y, object.width, object.height)
		end
		if object.width and object.height and object.x and object.y then
			for i = 0, object.width - 1 do
				love.graphics.setColor(1,0,0,0.5)
				love.graphics.rectangle("fill", x + i, y + object.height, 1, 1)
				love.graphics.setColor(1,0.5,0,0.5)
				love.graphics.rectangle("fill", x + i, y - 1, 1, 1)
			end
			for i = 0, object.height - 1 do
				love.graphics.setColor(1,1,0,0.5)
				love.graphics.rectangle("fill", x - 1, y + i, 1, 1)
				love.graphics.setColor(1,0,1,0.5)
				love.graphics.rectangle("fill", x + object.width, y + i, 1, 1)
			end
		end
	end
	love.graphics.setColor(1,1,1,1)
end
-- Object functions!
function pancake.addObject(object)
	pancake.objects[#pancake.objects + 1] = pancake.assignID(object)
	return pancake.objects[#pancake.objects]
end
--Physics functions
function pancake.applyPhysics(object, settings)
	local physics = pancake.physics
	object.physics = true
	local settings = settings or {}
	object.mass = settings.mass or physics.defaultMass
	object.maxVelocity = settings.maxVelocity or physics.defaultmaxVelocity
	object.maxVelocityX = object.maxVelocity
	object.maxVelocityY = object.maxVelocity
	object.bounciness = settings.bounciness or physics.defaultBounciness
	object.velocityX = 0
	object.velocityY = 0
	object.friction = settings.friction or physics.defaultFriction or 0.8
	object.forces = {}
	object.force = {x = 0, y = 0}

	pancake.addForce(object, {time = "infinite", x = physics.gravityX,  y = physics.gravityY, relativeToMass = true})
	return object
end

function pancake.getFacingObjects(object)
	local step = 0.00001
	--down
	object.y = object.y + step
	local down = pancake.getCollidingObjects(object)
	object.y = object.y - step
	--up
	object.y = object.y - step
	local up = pancake.getCollidingObjects(object)
	object.y = object.y + step
	--left
	object.x = object.x - step
	local left = pancake.getCollidingObjects(object)
	object.x = object.x + step
	--right
	object.x = object.x + step
	local right = pancake.getCollidingObjects(object)
	object.x = object.x - step
	return {down = down, up = up, left = left, right = right}
end

function pancake.facing(object)
	local up = pancake.getSurfaceContact(object).up > 0
	local down = pancake.getSurfaceContact(object).down > 0
	local right = pancake.getSurfaceContact(object).right > 0
	local left = pancake.getSurfaceContact(object).left > 0
	return {left = left, up = up, right = right, down = down}
end

function pancake.addForce(object, force) --force is a table of strength; x and y parameters that create a vector and time it should work. For example force = {x = 5, y = 0, time = 1000} will push a body of mass equal to 5 one meter per second squared for 1 seconds
	force.x = force.x or 0
	force.y = force.y or 0
	force.time = force.time or 1000
	object.forces[#object.forces + 1] = pancake.assignID(force)
	return force
end

function pancake.addTimer(time, mode, func) --TIME IS IN MS! Mode can be repetetive or single. If single is pick timer will run once and execute func function once, then delete itself. Repetitive basically acts like a timed loop executing func every x seconds
	local time = time or 1000
	local mode = mode or "single"
	local timer = pancake.assignID({duration = time, time = 0, mode = mode, func = func})
	pancake.timers[#pancake.timers + 1] = timer
	return timer
end

-------------------------
--ON UPDATE FINCTIONS----
-------------------------
function pancake.update(dt)
	--Handle load animation
	if pancake.loadAnimation then
		updateLoadAnimation(dt)
	end
	local dt = pancake.boolConversion(pancake.paused, 0, dt)
	pancake.lastdt = pancake.boolConversion(dt == 0, pancake.lastdt, dt)
	updateTimers(dt)
	--APPLY PHYSICS
	pancake.updateObjects(dt)
	updateForces(dt) --changes velocity!!!
	--END OF PHYSICS
	switchTarget(love.mouse.getX(), love.mouse.getY())
	cameraFollowObjects()
	--Handle scren shake
	updateScreenShake(dt)
	--THIS SHOULD ALWAYS BE LAST
	emptyTrash()
end

function updateLoadAnimation(dt)
	local animation = pancake.loadAnimation
	animation.time = animation.time + dt*1000
	if animation.time >= animation.duration then
		animation.time = animation.time - animation.duration
		animation.frame = animation.frame + 1
		local frame = animation.frame
		if frame == 2 then
			pancake.playSound("pancake1")
			animation.duration = 120
		elseif frame == 3 then
			pancake.playSound("pancake2")
		elseif frame == 4 then
			pancake.playSound("pancake1")
		elseif frame == 5 then
			pancake.playSound("pancake2")
		elseif frame == 6 then
			pancake.playSound("pancake1")
		elseif frame == 7 then
			pancake.playSound("pancake2")
		elseif frame == 9 then
			animation.duration = 80
			pancake.playSound("pancake3")
		elseif frame == 12 then
			animation.duration = 400
		elseif frame == 13 then
			animation.duration = 85
		elseif frame == 14 then
			pancake.playSound("pancake4")
		elseif frame == 21 then
			animation.duration = 800
		elseif frame == 22 then
			animation.duration = 80
			pancake.playSound("pancake5")
		elseif frame == 24 then
			animation.duration = 800
		elseif frame == 25 then
			animation.duration = 100
			pancake.playSound("pancake6")
		elseif frame == 35 then
			animation.duration = 3500
		end
		if animation.frame > animation.frames then
			pancake.loadAnimation = nil
			pancake.paused = false
			pancake.onLoad()
		end
	end
end

function updateScreenShake(dt)
	if not pancake.screenShake then
		pancake.shake = nil
	end
	local shake = pancake.shake
	if shake then
		shake.time = shake.time + dt*1000
		if shake.time >= shake.duration then
			shake.time = shake.time - shake.duration
			shake.iteration = shake.iteration + 1
			shake.axis = pancake.opposite(shake.axis)
			if shake.iteration%2 == 0 then
				shake.direction = -shake.direction
			end
			shake["offset" .. string.upper(shake.axis)] = shake.direction*math.random(0, shake.amplitude)
			shake["offset" .. string.upper(pancake.opposite(shake.axis))] = 0
		end
		if shake.iteration > shake.iterations then
			pancake.shake = nil
		end
	end
end

function cameraFollowObjects()
	local object = pancake.cameraFollow
	local window = pancake.window
	if object then
		if pancake.smoothRender then
			window.offsetX = object.x - window.width/2 + object.width/2
			window.offsetY = object.y - window.height/2 + object.height/2
		else
			window.offsetX = pancake.round(object.x - window.width/2 + math.floor(object.width/2))
			window.offsetY = pancake.round(object.y - window.height/2 + math.floor(object.height/2))
		end
	else
		window.offsetX = 0
		window.offsetY = 0
	end
end

function pancake.getRoadTime(s, v, a)
local ret
local del = pancake.delta(1/2*a, v, -s)
	local a = a or 0
	if a == 0 then
		ret = s/v
	elseif del >= 0 then
		ret = (-v+math.sqrt(del))/a --This the time necessary to travel s with speed of v and acceleraty of a
	end
	return ret
end

function pancake.updateObjects(dt)
	local objects = pancake.objects
	local collisions = {}
	local colls = {}
	pancake.collidingObjects = {}
	pancake.physicObjects = {}
	for i = 1, #objects do
		local object = objects[i]
		checkForOverlap(object)
		object.pressureDown = nil
		object.pressureUp = nil
		object.pressureLeft = nil
		object.pressureRight = nil
		object.collidedWith = nil
		if object.physics then
			pancake.physicObjects[#pancake.physicObjects + 1] = object
			object.force.x = 0
			object.force.y = 0
		end
		if object.colliding == true then
			pancake.collidingObjects[#pancake.collidingObjects + 1] = object
		end
	end
	--Moving objects with remaining time!
	for i = 1, #objects do
		local object = objects[i]
		if object.animation then
			local animation = object.animation
			animation.time = animation.time + dt*1000
			if animation.time >= animation.duration then
				animation.frame = animation.frame + 1
				animation.time = animation.time - animation.duration
				if animation.frame > animation.frames then
					animation.frame = 1
				end
			end
			object.image = animation[animation.frame]
		end
		if object.physics then
			local t = dt
			local ax = pancake.getStat(object, "accelarityX")
			local vx = pancake.getStat(object, "velocityX")
			local ay = pancake.getStat(object, "accelarityY")
			local vy = pancake.getStat(object, "velocityY")
			colls = pancake.move(object, vx*t + 1/2*ax*t*t, vy*t + 1/2*ay*t*t)
			if colls and colls[1] then
				for i = 1, #colls do
					collisions[#collisions + 1] = colls[i]
				end
			end
		end
	end
	if collisions[1] then
		for i = 1, #collisions do
			local collision = collisions[i]
			pancake.applyForce(collision.object, collision.force, dt)
		end
	end
end

function checkForOverlap(object)
	local dt = pancake.lastdt
	local objects = pancake.objects
	for i = 1, #objects do
		local object2 = objects[i]
		if object2 ~= object and pancake.collisionCheck(object, object2) then
			if pancake.onOverlap then
				pancake.onOverlap(object, object2, dt)
			end
		end
	end
end

function pancake.delta(a,b,c)
	return b*b - (4*a*c)
end

function pancake.getPressure(object, axisName)
local force = 0
	if object.physics then
		if axisName == "down" then
			force = pancake.getStat(object, "forceY") + object.velocityY*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(axisName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(axisName))
					force = force + pancake.boolConversion(press >= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[axisName]
				end
			end
		elseif axisName == "up" then
			force = -pancake.getStat(object, "forceY") - object.velocityY*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(axisName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(axisName))
					force = force + pancake.boolConversion(press <= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[axisName]
				end
			end
			--X AXIS
		elseif axisName == "right" then
			force = pancake.getStat(object, "forceX") + object.velocityX*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(axisName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(axisName))
					force = force + pancake.boolConversion(press >= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[axisName]
				end
			end
		elseif axisName == "left" then
			force = -pancake.getStat(object, "forceX") - object.velocityX*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(axisName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(axisName))
					force = force + pancake.boolConversion(press <= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[axisName]
				end
			end
		end
	end


	force = pancake.boolConversion(force <= 0, 0, force)
	object["pressure" .. pancake.intoCaps(axisName)] = force
	return force
end

function pancake.getStat(object, stat)
	local ret = object[stat] or 0
	if stat == "forceX" then
		if object.forces and object.forces[1] then
			for i = 1, #object.forces do
				local force = object.forces[i]
				local mr = pancake.boolConversion(force.relativeToMass, object.mass, 1)
				ret = ret + force.x*mr
			end
		end
	elseif stat == "forceY" then
		if object.forces and object.forces[1] then
			for i = 1, #object.forces do
				local force = object.forces[i]
				local mr = pancake.boolConversion(force.relativeToMass, object.mass, 1)
				ret = ret + force.y*mr
			end
		end
	elseif stat == "mass" then
		ret = object.mass or 1
	elseif stat == "velocityX" or stat == "velocityY" then
		ret = object[stat] or 0
	elseif stat == "bounciness" then
		ret = object[stat] or 1
	elseif stat == "friction" then
		ret = object[stat] or 1
	elseif stat == "accelarityX" then
		ret = pancake.getStat(object, "forceX")/pancake.getStat(object, "mass")
	elseif stat == "accelarityY" then
		ret = pancake.getStat(object, "forceY")/pancake.getStat(object, "mass")
	elseif stat == "directionX" then
		ret = pancake.boolConversion(pancake.getStat(object, "velocityX") == 0, 0, pancake.getStat(object, "velocityX")/math.abs(pancake.getStat(object, "velocityX")))
	elseif stat == "directionY" then
		ret = pancake.boolConversion(pancake.getStat(object, "velocityY") == 0, 0, pancake.getStat(object, "velocityY")/math.abs(pancake.getStat(object, "velocityY")))
	elseif stat == "momentumX" then
		ret = math.abs(pancake.getStat(object, "velocityX")*pancake.getStat(object, "mass"))
	elseif stat == "momentumY" then
		ret = math.abs(pancake.getStat(object, "velocityY")*pancake.getStat(object, "mass"))
	elseif stat == "pressureDown" then
		ret = object.pressureDown or pancake.getPressure(object, "down")
	elseif stat == "pressureUp" then
		ret = object.pressureUp or pancake.getPressure(object, "up")
	elseif stat == "pressureLeft" then
		ret = object.pressureLeft or pancake.getPressure(object, "left")
	elseif stat == "pressureRight" then
		ret = object.pressureRight or pancake.getPressure(object, "right")
	end

	return ret
end

function pancake.applyForce(object, force, dt, unsaved)
	local dt = dt or pancake.lastdt
	local unsaved = unsaved or false
	force.x = force.x or 0
	force.y = force.y or 0
	if object.physics then
		local mr = pancake.boolConversion(force.relativeToMass, object.mass, 1)
		object.velocityX = object.velocityX + force.x*dt/object.mass*mr
		object.velocityY = object.velocityY + force.y*dt/object.mass*mr
		if not unsaved then
			object.force.x = object.force.x + force.x/object.mass*mr
			object.force.y = object.force.y + force.y/object.mass*mr
		end
	end
end

function updateForces(dt)
	local deleteThese
	local objects = pancake.physicObjects
	for i = 1, #objects do
		local object = objects[i]
		if object.physics then
			deleteThese = {}
			local forces = object.forces
			if forces[1] then
				for f = 1, #forces do
					local force = forces[f]
					local finaldt = dt
					if force.time ~= "infinite" then
						force.time = force.time - dt*1000
						if force.time <= 0 then
							finaldt = dt + force.time/1000
							deleteThese[#deleteThese + 1] = force.ID
						end
					end
					pancake.applyForce(object, force, finaldt)
				end
				--Cap to max velocity and max velocity on each axis
				local velocityCap = pancake.boolConversion(object.maxVelocity <= object.maxVelocityX, object.maxVelocity, object.maxVelocityX)
				if math.abs(object.velocityX) > velocityCap then
					object.velocityX = object.velocityX - pancake.sigma(object.velocityX)*(math.abs(object.velocityX) - velocityCap)
				end
				velocityCap = pancake.boolConversion(object.maxVelocity <= object.maxVelocityY, object.maxVelocity, object.maxVelocityY)
				if math.abs(object.velocityY) > velocityCap then
					object.velocityY = object.velocityY - pancake.sigma(object.velocityY)*(math.abs(object.velocityY) - velocityCap)
				end

				if deleteThese[1] then
					for u = 1, #deleteThese do
						pancake.smartDelete(forces, deleteThese[u], "ID")
					end
				end
			end
		end
	end
end

function collide(object1, objects, axis, direction, sc, oa) --sc is a short for simultanously collisions it indicates how many simultanious collisions happen
	local collisions = {}
	local originalCord = object1[axis]
	local dt = pancake.lastdt
	local axisParam = pancake.boolConversion(axis == "x", "width", "height")
	local forceSum = {x = 0, y = 0}
	local object2 = objects[1]
	local ret = {}
	local destination = pancake.boolConversion(direction == 1, object2[axis] - object1[axisParam], object2[axis] + object2[axisParam])
	local distance = math.abs(object1[axis] - destination)
	local biggestDistance = distance

	for i = 1, #objects do
		object2 = objects[i]
		destination = pancake.boolConversion(direction == 1, object2[axis] - object1[axisParam], object2[axis] + object2[axisParam])
		distance = math.abs(object1[axis] - destination)
		if biggestDistance < distance then
			ret = {object2}
			biggestDistance = distance
		elseif biggestDistance == distance then
			ret[#ret+1] = object2
		end
	end
	local objects = ret
	local object2 = objects[1]
	sc = #objects
	object1[axis] = pancake.boolConversion(direction == 1, object2[axis] - object1[axisParam], object2[axis] + object2[axisParam])

	if pancake.isObjectColliding(object1) then
		object1[axis] = oa
	end

	--call custom collision function!
	for i = 1, #objects do
		object2 = objects[i]
		if not didTheyCollide(object1, object2) then
			if pancake.onCollision then
				pancake.onCollision(object1, object2, axis, direction, sc)
			end
			local force2 = pancake.getCollisionForces(object1, object2, axis, direction, sc)[2]
			collisions[#collisions + 1] = {object = object2, force = force2}
			forceSum.x = forceSum.x + pancake.getCollisionForces(object1, object2, axis, direction, sc)[1].x
			forceSum.y = forceSum.y + pancake.getCollisionForces(object1, object2, axis, direction, sc)[1].y
			if not object2.collidedWith then
				object2.collidedWith = {}
			end
			object2.collidedWith[object1.ID] = true
		end
	end
	local force1 = {}
	force1 = forceSum
	collisions[#collisions + 1] = {object = object1, force = force1}
	return collisions
end

function didTheyCollide(object1, object2)
	local ret = false
	if object1.collidedWith then
		if object1.collidedWith[object2.ID] then
			ret = true
		end
	end
	return ret
end

function pancake.getCollisionForces(object1, object2, axis, direction, sc)
	local dt = pancake.lastdt
	local sc = sc or 1
	local axisName = pancake.getAxisName(axis, direction)
	local physics = pancake.physics
	local bounciness1 = pancake.getStat(object1, "bounciness")
	local bounciness2 = pancake.getStat(object2, "bounciness")
	local pressure1 = pancake.getStat(object1, "pressure" .. pancake.intoCaps(axisName))
	local pressure2 = pancake.getStat(object2, "pressure" .. pancake.intoCaps(pancake.opposite(axisName)))
	local pressureSum = pressure1 + pressure2
	local force1 = {x = 0, y = 0}
	force1[axis] = -direction*pressureSum*(bounciness1-bounciness2 + 1)*(1-physics.energyLoss)/sc
	local force2 = {x = 0, y = 0}
	force2[axis] = direction*pressureSum*(bounciness2-bounciness1 + 1)*(1-physics.energyLoss)/sc
	--Calculate friction force...
	frictionAxis = pancake.opposite(axis)
	local friction1 = 0
	local friction2 = 0
	local maxFriction1 = -pancake.getStat(object1, "velocity" .. string.upper(frictionAxis))*pancake.getStat(object1, "mass")/dt/sc
	friction1 = -pancake.getStat(object1,"direction" .. string.upper(frictionAxis))*pressureSum*(pancake.getStat(object1, "friction")+pancake.getStat(object2, "friction"))/2/sc
	if math.abs(friction1) > math.abs(maxFriction1) then
		friction1 = maxFriction1
	end
	force1[frictionAxis] = friction1
	force2[frictionAxis] = -friction1
	local ret = {}
	ret[1] = force1
	ret[2] = force2
	return ret
end

function pancake.opposite(value)
	local ret
	if value == "x" then
		ret = "y"
	elseif value == "y" then
		ret = "x"
	elseif value == "down" then
		ret = "up"
	elseif value == "up" then
		ret = "down"
	elseif value == "left" then
		ret = "right"
	elseif value == "right" then
		ret = "left"
	end
	return ret
end

function updateTimers(dt)
	local deleteThese = {}
	local timers = pancake.timers
	if timers[1] then
		for i = 1, #timers do
			local timer = timers[i]
			timer.time = timer.time + dt*1000
			if timer.time >= timer.duration then
				if timer.func then
					timer.func()
				end
				if timer.mode == "single" then
					deleteThese[#deleteThese + 1] = timer.ID
				elseif timer.mode == "repetetive" then
					timer.time = timer.time - timer.duration
				end
			end
		end
		if deleteThese[1] then
			for i = 1, #deleteThese do
				pancake.smartDelete(timers, deleteThese[i], "ID")
			end
		end
	end
end

function collideMultiple(object, axis, direction, oa)
	local ret = {}
	if pancake.isObjectColliding(object) then
		local objects = pancake.getCollidingObjects(object)
		ret = collide(object, objects, axis, direction, #objects, oa)
	end
	return ret
end

function pancake.move(object, x, y)
	local collisions = {}
	local x = x or 0
	local y = y or 0
	local b = {}
	b.x = false
	b.y = false
	local o = {}
	o.x = x
	o.y = y
	local s = {}
	s.x = pancake.sigma(x)
	s.y = pancake.sigma(y)
	local a = {}
	a.x = math.floor(math.abs(x))
	a.y = math.floor(math.abs(y))
	local p = {}
	p.x = a.x
	p.y = a.x
	local biggerAxis = pancake.boolConversion(a.x == a.y, "xy", pancake.boolConversion(a.x > a.y, "x", "y"))
	local smallerAxis = pancake.boolConversion(biggerAxis == "x", "y", "x")
	if a.x ~= 0 or a.y ~= 0 then
		if biggerAxis == "xy" then
			for i = 1, a.x do
				if not b.x and not b.y then
					object.x = object.x + s.x
					if pancake.isObjectColliding(object) then
						pancake.sumTables(collisions, collideMultiple(object, "x", s.x, object.x - s.x))
						b.x = true
					end
					object.y = object.y + s.y
					if pancake.isObjectColliding(object) then
						pancake.sumTables(collisions, collideMultiple(object, "y", s.y, object.y - s.y))
						b.y = true
					end
				end
			end
		else
		local step = pancake.boolConversion(a[smallerAxis] == 0, a[biggerAxis], math.floor(a[biggerAxis]/a[smallerAxis]))
		local steps = 0
			for i = 1, a.x + a.y do
				if steps == step then
					steps = 0
					if not b[smallerAxis] then
						object[smallerAxis] = object[smallerAxis] + s[smallerAxis]
						p[smallerAxis] = p[smallerAxis] - 1
						if pancake.isObjectColliding(object) then
							pancake.sumTables(collisions, collideMultiple(object, smallerAxis, s[smallerAxis], object[smallerAxis] - s[smallerAxis]))
							b[smallerAxis] = true
						end
					end
				else
					steps = steps + 1
					if not b[biggerAxis] then
						object[biggerAxis] = object[biggerAxis] + s[biggerAxis]
						p[biggerAxis] = p[biggerAxis] - 1
						if pancake.isObjectColliding(object) then
							pancake.sumTables(collisions,collideMultiple(object, biggerAxis, s[biggerAxis], object[biggerAxis] - s[biggerAxis]))
							b[biggerAxis] = true
						end
					end
				end
			end
		end

	end

	biggerAxis = pancake.boolConversion(math.abs(x - s.x*a.x) >= math.abs(y - s.y*a.y), "x", "y") --(x - s.x*a.x)
	smallerAxis = pancake.boolConversion(biggerAxis == "x", "y", "x")
	if not b[biggerAxis] then
		local distance = (o[biggerAxis] - s[biggerAxis]*a[biggerAxis])
		object[biggerAxis] = object[biggerAxis] + distance
		if pancake.isObjectColliding(object) then
			pancake.sumTables(collisions, collideMultiple(object, biggerAxis, s[biggerAxis], object[biggerAxis] - distance))
			b[biggerAxis] = true
		end
	end

	if not b[smallerAxis] then
		local distance = (o[smallerAxis] - s[smallerAxis]*a[smallerAxis])
		object[smallerAxis] = object[smallerAxis] + distance
		if pancake.isObjectColliding(object) then
			pancake.sumTables(collisions, collideMultiple(object, smallerAxis, s[smallerAxis], object[smallerAxis] - distance))
			b[smallerAxis] = true
		end
	end--]]
	return collisions
end

function pancake.getCollidingObjects(object)
	local ret = {}
	local objects = pancake.collidingObjects
	for i = 1, #objects do
		local currObject = objects[i]
		if object ~= currObject then
			if pancake.andCheck(currObject, {"x", "y", "width", "height"}) and pancake.collisionCheck(object, currObject) and object.colliding and currObject.colliding then
				ret[#ret + 1] = currObject
			end
		end
	end
	return ret
end

function pancake.isObjectColliding(object)
local ret = false
local objects = pancake.collidingObjects
	for i = 1, #objects do
		local currObject = objects[i]
		if object ~= currObject then
			if pancake.andCheck(currObject, {"x", "y", "width", "height"}) and pancake.collisionCheck(object, currObject) and object.colliding and currObject.colliding then
				ret = true
			end
		end
	end
	return ret
end

function pancake.collisionCheck(object1, object2)
local ret = false
	if ((object1.x > object2.x and object1.x < object2.x + object2.width) or (object2.x > object1.x and object2.x < object1.x + object1.width) or object1.x == object2.x) and ((object1.y > object2.y and object1.y < object2.y + object2.height) or (object2.y > object1.y and object2.y < object1.y + object1.height) or object1.y == object2.y) then
		ret = true
	end
return ret
end

function pancake.getSurfaceContact(object)
local step = 0.00001
	--DOWN and UP
	local up = 0
	local down = 0
	local left = 0
	local right = 0
	if object.width and object.height and object.x and object.y then
		for i = 0, object.width - 1 do
			if pancake.isObjectColliding({x = object.x + i, y = object.y + object.height, width = 1, height = step, colliding = true}) then
				down = down + 1
			end
			if pancake.isObjectColliding({x = object.x + i, y = object.y - step, width = 1, height = step, colliding = true}) then
				up = up + 1
			end
		end
		for i = -1, object.height - 1 do
			if pancake.isObjectColliding({x = object.x + object.width, y = object.y + i, width = step, height = 1, colliding = true}) then
				right = right + 1
			end
			if pancake.isObjectColliding({x = object.x - step, y = object.y + i, width = step, height = 1, colliding = true}) then
				left = left + 1
			end
		end
	end
	return {up = up, down = down, left = left, right = right}
end

---------------------------------
--- PANCAKE IMAGES/ANIMATIONS ---
---------------------------------
function pancake.addImage(image, folders)
	local subfolderString = ""
	if folders then
		if type(folders) == "table" then
			for i = 1, #folders do
				subfolderString = subfolderString .. folders[i] .. "/"
			end
		elseif type(folders) == "string" then
			subfolderString = subfolderString .. folders .. "/"
		end
	end
	pancake.images[image] = love.graphics.newImage(subfolderString .. image .. ".png")
	return pancake.images[image]
end

---------------------
--- PANCAKE SOUND ---
---------------------
function pancake.addSound (name, subfolder)
	local sounds = pancake.sounds
	sounds[#sounds + 1] = {	}
	sounds[#sounds].name = name
	if subfolder == nil then
		sounds[#sounds].sound = love.audio.newSource("sounds/" .. name .. ".wav", "static")
	else
		sounds[#sounds].sound = love.audio.newSource("sounds/" .. subfolder .. "/".. name .. ".wav", "static")
	end
end

function pancake.playSound(name, overlap)
local overlap = overlap or false
local sounds = pancake.sounds
	if type(name) == "string" then
		local sound = pancake.find(sounds, name, "name")
		if sound.sound:isPlaying( ) and not overlap then
			sound.sound:stop()
		end
			sound.sound:play()
	else
		if sounds[name].sound:isPlaying( ) and not overlap then
			sounds[name].sound:stop()
		end
		sounds[name].sound:play()
	end
end

-----------------------
--- PANCAKE BUTTONS ---
-----------------------
function pancake.addButton (button) --example: {name = imageName, x = 0, y = 0, width = 10*pixelSize, height = 10*pixelSize, hitboxOffsetX = 1, hitboxOffsetY = 1, scale = pixelSize}
	button.scale = button.scale or 1
	button.x = button.x or 0
	button.y = button.y or 0
	button.offsetX = button.offsetX or 0
	button.offsetY = button.offsetY or 0
	button.image = button.image or pancake.images[button.name]
	button.imageClicked = button.imageClicked or pancake.images[button.name .. "_clicked"]
	button.width = button.width or button.image:getWidth()*button.scale
	button.height = button.height or button.image:getHeight()*button.scale
	button.key = button.key or "b"
	pancake.buttons[#pancake.buttons + 1] = button
	return pancake.buttons[#pancake.buttons]
end

function pancake.drawButtons()
	if pancake.buttons[1] then
		for i=1, #pancake.buttons do
			local button = pancake.buttons[i]
			love.graphics.draw(pancake.boolConversion(pancake.isButtonClicked(button), button.imageClicked, button.image), button.x, button.y, 0, button.scale)
		end
	end
end

function pancake.isButtonClicked(button)
	local ret = false
	if (love.mouse.isDown(1) and pancake.collisionCheck({x = love.mouse.getX(), y = love.mouse.getY(), width = 1, height = 1}, {x = button.x, y = button.y, width = button.width*button.scale, height = button.height*button.scale})) or love.keyboard.isDown(button.key) then
		ret = true
	end
	return ret
end

function pancake.checkButtonPresses(x,y,button)
	local buttons = pancake.buttons
	if buttons[1] then
		for i = 1, #buttons do
			local button = buttons[i]
			if pancake.isButtonClicked(button) and button.func then
				button.func()
			end
		end
	end
end

--------------------------
--- PANCAKE MOUSePRESS ---
--------------------------
function pancake.mousepressed(x, y, button)
	--checking if ant button was pressed
	pancake.checkButtonPresses(x,y,button)
	--switching target (in debug mode)
	switchTarget(x,y, true)
end

function switchTarget(x,y, lock)
	local ret
	for i = 1, #pancake.renderedObjects() do
		local object = pancake.renderedObjects()[i]
		local hitboxes1 = {x = x, y = y, width = 1, height = 1}
		local hitboxes2 = {x = pancake.windowToDisplay(object.x, 0, true).x, y = pancake.windowToDisplay(0, object.y, true).y, width = object.width*pancake.window.pixelSize, height = object.height*pancake.window.pixelSize}
		if pancake.collisionCheck(hitboxes1, hitboxes2) then
			ret = object
		end
	end
	if lock and not ret then
		pancake.targetLock = false
	elseif lock and ret then
		pancake.targetLock = true
	end
	if ret then
		pancake.target = ret
	elseif not pancake.targetLock then
		pancake.target = nil
	end
end

-------------------------
--- PANCAKE SAVE/LOAD ---
-------------------------
function pancake.save(data, filename)
	if type(data) == "table" then
		data = smallfolk.dumps(data)
	end
	love.filesystem.write(filename, data)
end

function pancake.load(filename, type)
	local type = type or "string"
	local ret = love.filesystem.read(filename)
	if type == "table" then
		ret = smallfolk.loads(ret)
	end
	return ret
end

function pancake.saveState(filename)
	local save = {}
	save.objects = pancake.objects
	save.timers = pancake.timers
	local string = smallfolk.dumps(save)
	pancake.save(string, filename)
end

function pancake.loadState(filename)
	local save = smallfolk.loads(pancake.load(filename))
	pancake.objects = save.objects
	pancake.timers = save.timers
end

------------------------
--- PANCAKE TRASHBIN ---
------------------------
function pancake.trash(table, value, searchParam)
	local trashbin = pancake.trashbin
	trashbin[#trashbin + 1] = {table = table, value = value, searchParam = searchParam}
end

function emptyTrash()
	local trashbin = pancake.trashbin
	if trashbin[1] then
		for i = 1, #trashbin do
			local table = trashbin[i]
			if table.searchParam then
				pancake.smartDelete(table.table, table.value, table.searchParam)
			end
		end
	end
	pancake.trashbin = {}
end
----------------------------
-- PANCAKE PRINT RELATED ---
----------------------------
function pancake.print(text, x, y, scale)
	local text = text or " "
	local length = string.len(text)
	local x = x or 0
	local y = y or 0
	local scale = scale or 1
	for i = 1, length do
		local char = string.sub(text, i, i)
		if char == " " then
			x = x + scale*2
		else
			printLetter(char, x, y, scale)
			if letters[char] then
				x = x + letters[char].width*scale + scale
			else
				x = x + scale*3
			end
		end
	end
end

function printLetter(char, x, y, scale)
	 local x = x or 0
	 local y = y or 0
	 local char = char or "a"
	 local scale = scale or 1
	 if letters[char] then
		 local letter = letters[char]
		 for i = 1, #letter do
			love.graphics.rectangle("fill", x + (letter[i].x - 1)*scale, y + (letter[i].y - 1)*scale, scale, scale)
		end
	else
		love.graphics.print("Your font doesn't have: " .. char)
	end
 end
function defineLetters()
	letters = {}
	letters.a = {pix(13), pix(22), pix(24), pix(32), pix(33), pix(34), width = 3}
	letters.b = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(24), pix(33), width = 3}
	letters.c = {pix(13), pix(22), pix(24), pix(32), pix(34), width = 3}
	letters.d = {pix(13), pix(22), pix(24),pix(31), pix(32), pix(33), pix(34), width = 3}
	letters.e = {pix(12), pix(13), pix(21), pix(22), pix(24), pix(32), width = 3}
	letters.f = {pix(13), pix(21), pix(22), pix(23), pix(24), pix(31),pix(33), width = 3}
	letters.g = {pix(12), pix(13), pix(21), pix(23), pix(31), pix(32), pix(33), pix(34), pix(25), pix(35), width = 3}
	letters.h = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(33), pix(34),width = 3}
	letters.i = {pix(11), pix(13), pix(14), width = 1}
	letters.j = {pix(21), pix(23), pix(24), pix(14), width = 2}
	letters.k = {pix(11), pix(12), pix(13), pix(14), pix(23), pix(32), pix(34), width = 3}
	letters.l = {pix(11), pix(12), pix(13), pix(14), pix(24), width = 2}
	letters.m = {pix(12), pix(13), pix(14), pix(23), pix(32), pix(33), pix(42), pix(43), pix(44), width = 4}
	letters.n = {pix(12), pix(13), pix(14), pix(22), pix(33), pix(34), width = 3}
	letters.o = {pix(12), pix(13), pix(14), pix(22), pix(24), pix(32), pix(33), pix(34), width = 3}
	letters.p = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(32), pix(33), width = 3}
	letters.r = {pix(12), pix(13), pix(14), pix(23), pix(32), width = 3}
	letters.s = {pix(12), pix(14), pix(21), pix(23), pix(24), width = 2}
	letters.t = {pix(12), pix(21), pix(22), pix(23), pix(24), pix(32), width = 3}
	letters.u = {pix(12), pix(13), pix(24), pix(32), pix(33), pix(34), width = 3}
	letters.v = {pix(12), pix(13), pix(24), pix(32), pix(33), width = 3}
	letters.w = {pix(12), pix(13), pix(24), pix(33), pix(34), pix(42), pix(43), width = 4}
	letters.x = {pix(12), pix(14), pix(23), pix(32), pix(34), width = 3}
	letters.y = {pix(12), pix(13), pix(23), pix(24), pix(32), pix(33), width = 3}
	letters.z = {pix(11), pix(14), pix(21), pix(23), pix(24), pix(31), pix(34), pix(32), width = 3}
	letters.A = {pix(12), pix(13), pix(14), pix(21), pix(23), pix(31), pix(33), pix(42), pix(43), pix(44), width = 4}
	letters.B = {pix(12), pix(13), pix(14), pix(11), pix(21), pix(23), pix(24), pix(31), pix(32), pix(34), pix(43), pix(44), width = 4}
	letters.C = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(34), width = 3}
	letters.D = {{x = 1, y = 2}, {x = 1, y = 3}, {x = 1, y = 4}, {x = 2, y = 1}, pix(24), pix(31), pix(34), pix(42), pix(43), pix(11), width = 4}
	letters.E = {pix(12), pix(13), pix(14), pix(11), pix(21), pix(22), pix(24), pix(31), pix(32), pix(34), pix(41), pix(44),width = 4}
	letters.F = {pix(12), pix(13), pix(14), pix(11), pix(21), pix(23), pix(31), pix(33), pix(41), width = 4}
	letters.G = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(34), pix(41), pix(43), pix(44), width = 4}
	letters.H = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(32), pix(41), pix(42), pix(43), pix(44), width = 4}
	letters.I = {pix(11), pix(14), pix(21), pix(22), pix(23), pix(24), pix(31), pix(34),  width = 3}
	letters.J = {pix(11), pix(13), pix(21), pix(24), pix(31), pix(34), pix(41), pix(42), pix(43), width = 4}
	letters.K = {pix(11), pix(12), pix(13), pix(14), pix(23), pix(32), pix(33), pix(41), pix(44), width = 4}
	letters.L = {pix(11), pix(12), pix(13), pix(14), pix(24), pix(34), pix(44), width = 4}
	letters.M = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(23),pix(32), pix(33), pix(41), pix(42), pix(43), pix(44), width = 4}
	letters.N = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(33), pix(42), pix(43), pix(44), pix(41), width = 4}
	letters.O = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(34), pix(42), pix(43), width = 4}
	letters.P = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(31), pix(33), pix(42), width = 4}
	letters.R = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(31), pix(33), pix(42), pix(44),  width = 4}
	letters.S = { pix(12), pix(14), pix(21), pix(22), pix(24), pix(31), pix(33), pix(34), pix(41), pix(43), pix(44), width = 4}
	letters.T = {pix(11), pix(21), pix(22), pix(23), pix(24), pix(31), pix(32), pix(33), pix(34), pix(41),width = 4}
	letters.U = {pix(11), pix(12), pix(13), pix(24), pix(34), pix(41), pix(42), pix(43), width = 4}
	letters.V = {pix(11), pix(12), pix(13), pix(23), pix(24), pix(33), pix(34), pix(41), pix(42), pix(43), width = 4}
	letters.W = {pix(11), pix(12), pix(13), pix(14), pix(23), pix(24), pix(33), pix(34), pix(41), pix(42), pix(43), pix(44), width = 4}
	letters.X = {pix(11), pix(14), pix(22), pix(23), pix(32), pix(33), pix(41), pix(44), width = 4}
	letters.Y = {pix(11), pix(12), pix(23), pix(24), pix(33), pix(34), pix(41), pix(42), width = 4}
	letters.Z = {pix(11), pix(14), pix(21), pix(23), pix(24), pix(31), pix(32), pix(34), pix(41), pix(44), width = 4}
	letters["!"]= {pix(11), pix(12), pix(14), width = 1}
	letters.q = {pix(13), pix(14), pix(22), pix(24), pix(32), pix(33), pix(34), pix(35), width = 3}
	letters.Q = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(33), pix(34), pix(42), pix(43), pix(44), width = 4}
	letters["."] = {pix(14), width = 1}
	letters[":"] = {pix(12), pix(14), width = 1}
	letters[","] = {pix(14), pix(15), width = 1}
	letters["1"] = {pix(12), pix(21), pix (22), pix(23), pix(24), width = 2}
	letters["2"] = {pix(12), pix(14), pix(21), pix(24), pix(31), pix(33), pix(34), pix(42), pix(44), width = 4}
	letters["3"] = {pix(11), pix(14), pix(21), pix(22), pix(24), pix(31), pix(32), pix(34), pix(33), width = 3}
	letters["4"] = {pix(12), pix(13), pix(11), pix(23), pix(31), pix(32), pix(33), pix(34), pix(43), width = 4}
	letters["5"] = {pix(11), pix(12), pix(14), pix(21), pix(23), pix(24), pix(31), pix(33), pix(34), width = 3}
	letters["6"] = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(24), pix(31), pix(33), pix(34), width = 3}
	letters["7"] = {pix(11), pix(21), pix(31), pix(32), pix(33), pix(34), width = 3}
	letters["8"] = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(22), pix(24), pix(31), pix(32), pix(33), pix(34), width = 3}
	letters["9"] = {pix(11), pix(12), pix(14), pix(21), pix(22), pix(24), pix(31), pix(32), pix(33), pix(34), width = 3}
	letters["0"] = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(24), pix(31), pix(32), pix(33), pix(34), width = 3}
	letters["?"] = {pix(11), pix(21), pix(23), pix(25), pix(21), pix(31), pix(32), width = 3}
	letters["-"] = {pix(13), pix(23), pix(33), width = 3}

end

function pix(number)
	local x = math.floor(number/10)
	local y = number - x*10
	return {x = x, y = y}
end

---------------------------
--- Pancake screenshake ---
---------------------------
function pancake.shakeScreen(iterations, amplitude, duration, mode)
	if pancake.screenShake then
		local shake = {}
		shake.offsetX = 0
		shake.offsetY = 0
		shake.time = 0
		shake.duration = duration or 50
		shake.iterations = iterations or 6
		shake.iteration = 0
		shake.axis = pancake.boolConversion(math.random(1,2) == 1, "x", "y")
		shake.direction = 1
		shake.amplitude = amplitude or 1 --in pixels!
		if mode == "external" or mode =="internal" then
			shake.mode = mode-- external or internal
		else
			shake.mode = "external"
		end
		pancake.shake = shake
	end
end

-- UTITLITY FUNCTIONS!

function getUsableChars()
	local ret = {}
	for i = 48, 57 do
		ret[#ret + 1] = i
	end
	for i = 65, 90 do
		ret[#ret + 1] = i
	end
	for i = 97, 122 do
		ret[#ret + 1] = i
	end
	return ret
end

function pancake.assignID(table)
	local table = table or {}
	if not table.ID then
		pancake.lastID = pancake.lastID + 1
		table.ID = pancake.lastID
	end
	return table
end

function pancake.smartDelete (table, value, searchParam)
local value = value or #table
local searchParam = searchParam or "name"
local tableLength = #table
	if type(value) == "number" and searchParam == name then
		if table[value] and tableLength >= value then
			for n=0, tableLength - value do
				table[value+n] = table[value+n+1]
			end
			table[tableLength] = nil
		end
	else

		for i=1, #table do
			if table[i] and table[i][searchParam] == value then
				value = i
			end
		end
		if type(value) == "number" then
			if table[value] and tableLength >= value then
				for n=0, tableLength - value do
					table[value+n] = table[value+n+1]
				end
				table[tableLength] = nil
			end
		end

	end
end

function pancake.find(table, value, key)
local key = key or "name"
local ret = nil
	for i=1, #table do
		if table[i][key] == value then
			ret = table[i]
			ret.i = i
		end
	end
	return ret
end

function pancake.andCheck(table, values)
	local ret = true
	if table then
		for i = 1, #values do
			if not table[values[i]] then
				ret = false
				break
			end
		end
	else
		ret = false
	end

	return ret
end

function pancake.boolConversion(bool, ifTrue, ifFalse)
	local ifTrue = ifTrue or "true"
	local ifFalse = ifFalse or "false"
	local ret = ifFalse
	if bool then
		ret = ifTrue
	end
	return ret
end

function pancake.sigma(value)
	local ret
	if value < 0 then
		ret = -1
	elseif value > 0 then
		ret = 1
	elseif value == 0 then
		ret = 0
	end
	return ret
end

function pancake.round(number)
	return math.floor(number) + pancake.boolConversion(number - math.floor(number) >= 0.5, 1, 0)
end

function calcOffset(value)
	return value - math.floor(value)
end

function pancake.sumTables(table1, table2)
	for i = 1, #table2 do
		table1[#table1 + 1] = table2[i]
	end
	return table1
end


function pancake.getAxisName(axis, direction)
	local ret
	if axis == "x" then
		if direction == 1 then
			ret = "right"
		else
			ret = "left"
		end
	elseif axis == "y" then
		if direction == 1 then
			ret = "down"
		else
			ret = "up"
		end
	end
	return ret
end

function pancake.intoCaps(string)
	return string.upper(string.sub(string,1,1)) .. string.sub(string,2,-1)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return pancake
