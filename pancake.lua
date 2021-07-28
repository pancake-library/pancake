local pancake = {	}
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----		_____                        		_              	_       _  _
----   |  __ \                         | |             | |     (_)| |
----   | |__) |__ _  _ __    ___  __ _ | | __ ___      | |      _ | |__   _ __  __ _  _ __  _   _
----   |  ___// _` || '_ \  / __|/ _` || |/ // _ \     | |     | || '_ \ | '__|/ _` || '__|| | | |
----   | |   | (_| || | | || (__| (_| ||   <|  __/     | |____ | || |_) || |  | (_| || |   | |_| |
----   |_|    \__,_||_| |_| \___|\__,_||_|\_\\___|     |______||_||_.__/ |_|   \__,_||_|    \__, |
----                                                                                         __/ |
----                                                                                        |___/
----																																										BY MIGHTYPANCAKE		----
----																																									  	(Filip Król)			----
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
---------------v.4.0(added pathfinding, lights, pseudofont "Garry" and some performence improvements)-----------
--LIBRARIES USED:
local smallfolk = require "libraries/smallfolk" --smallfolk: https://github.com/gvx/Smallfolk

function pancake.init (settings)
	local settings = settings or {}
	--Applying scale filter...
	love.graphics.setDefaultFilter( "nearest", "nearest", 1)
	pancake.lightShader = love.graphics.newShader("shaders/pancakeLightShader.glsl", "shaders/vertex.glsl")
	--Creating important tables such as objects or images...
	pancake.objects = {}
	pancake.visuals = {}
	pancake.images = {}
	pancake.sounds = {}
	pancake.buttons = {}
	pancake.timers = {}
	pancake.trashbin = {}
	pancake.groupShaders = {}
	pancake.lastID = 0
	pancake.cameraFollow = nil
	defineLetters()
	--Applying other settings...
	pancake.debugMode = settings.debugMode or false
	--Setting window...
	local window = settings.window or {}
	window.pixelSize = window.pixelSize or 5
	pancake.lastPixelSize = window.pixelSize
	local pixelSize = window.pixelSize
	window.width = window.width or 64
	window.height = window.height or window.width
	window.x = window.x or love.graphics.getWidth()/2 - pixelSize*window.width/2
	window.y = window.y or love.graphics.getHeight()/2 - pixelSize*window.height/2
	window.offsetX = window.offsetX or 0
	window.offsetY = window.offsetY or 0
	local renderExtension = window.renderExtension or {}
	renderExtension.x = renderExtension.x or 0
	renderExtension.y = renderExtension.y or 0
	window.renderExtension = renderExtension
	pancake.window = window
	pancake.canvas = love.graphics.newCanvas(pancake.window.width*pixelSize, pancake.window.height*pixelSize)
	pancake.lightCanvas = love.graphics.newCanvas(pancake.window.width + 2*renderExtension.x, pancake.window.height + 2*renderExtension.y)
	pancake.lightCanvasRenderer = love.graphics.newCanvas(pancake.window.width + 2*renderExtension.x, pancake.window.height + 2*renderExtension.y)
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
	pancake.os = love.system.getOS( )
	pancake.lastdt = 0.001
	pancake.smoothRender = settings.smoothRender or false
	pancake.target = nil
	pancake.targetLock = false
	pancake.autoDraw = true
	pancake.layerDepth = settings.layerDepth or 0.75
	pancake.animations = {}
	pancake.lights = {}
	pancake.screenShake = true
	pancake.loadAnimation = {}
	pancake.paused = false
	if pancake.loadAnimation then
		for i = 1, 6 do
			pancake.addSound("pancake".. i, "sounds")
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

	pancake.addImage("pixel_pancake_icon", "images")

	local debug = settings.debug or {}
	debug.scale = debug.scale or love.graphics.getHeight()/1080
	debug.editMode = false
	debug.stringFocused = nil
	debug.stringTimer = {time = 300, duration = 0, state = false}
	debug.linePosition = 0
	debug.camera = {x = 0, y = 0}
	debug.clipboard = nil
	debug.categoriesCanvas = love.graphics.newCanvas(1080, 50)
	debug.objectEditCategory = "general"
	local strings = {}
	pancake.lastSave = "Level_1"
	strings[1] = {tip = "Save name", clickable = true, name = "saveName", x = 170, y = 60, value = pancake.lastSave, maxWidth = 60, scale = 6, width = 80, height = 60, box = {x = 160, y = 50, width = 564, height = 68}}

	debug.strings = strings

	local show = {}
	show.tools = false
	show.displayLayer = false
	show.vectors = false
	show.hitboxes = false
	show.info = false
	debug.show = show

	debug.showToolsCanvas = love.graphics.newCanvas(90, 30)
	debug.hideToolsCanvas = love.graphics.newCanvas(90, 30)
	love.graphics.setCanvas(debug.showToolsCanvas)
	love.graphics.setColor(0.2,0.2,0.2,1)
	love.graphics.rectangle("fill",0,0,90,30)
	love.graphics.setColor(0.5,0.5,0.5,1)
	pancake.print("Tools",16,7,2)

	love.graphics.setCanvas(debug.hideToolsCanvas)
	love.graphics.setColor(0.2,0.2,0.2,1)
	love.graphics.rectangle("fill",0,0,90,30)
	love.graphics.setColor(0.5,0.5,0.5,1)
	pancake.print("Hide",25,7,2)
	love.graphics.setCanvas()

	pancake.debug = debug
	pancake.functions = {}
	--pancake.shader = love.graphics.newShader("shaders/collisionObjectsShaderPixel.txt", "shaders/vertex.txt")
end

----------------------
--Drawing functions!--
----------------------
function pancake.draw()
	if pancake.cameraFollow then
		cameraFollowObjects()
	end
	--love.graphics.setShader(pancake.shader)
	local scale = pancake.window.pixelSize
	local window = pancake.window
	--Drawing mask for light!
	if pancake.useLights then
		love.graphics.translate(-window.offsetX,-window.offsetY)
		drawLightMask()
		love.graphics.translate(window.offsetX,window.offsetY)
	end
	--Drawing pancake canvas! WITH BORDERS!!
	love.graphics.setCanvas(pancake.canvas)
	love.graphics.clear()
	love.graphics.scale(scale)
	drawBackground()
	love.graphics.translate(-window.offsetX,-window.offsetY)
	if pancake.shake and pancake.shake.mode == "internal" then
		love.graphics.translate(pancake.shake.offsetX,pancake.shake.offsetY)
	end
	love.graphics.setColor(1,1,1,1)
	drawObjects()
	love.graphics.setColor(1,1,1,1)
	--pancake.drawLine(pancake.lineFromPoints(player, pancake.find(pancake.objects, "box3", "name")))
	--DELETE LATER
	if player and enemies then
		for _, enemy in ipairs(enemies) do
			--pancake.drawLine(pancake.lineFromPoints(player, pancake.find(pancake.objects, "box3", "name")))
			--[[love.graphics.setColor(0,0,1,1)
			local object1 = player
			local object2 = enemy
			local point1 = {x = object1.x + object1.width/2, y = object1.y + object1.height/2}
			local point2 = {x = object2.x + object2.width/2, y = object2.y + object2.height/2}
			--
			local mainLine = pancake.lineFromPoints(point1, point2)
			--pancake.drawLine(mainLine)
			local object = enemy
			local destination = player
			local x = destination.x - object.x
			local y = destination.y - object.y
			mainLines = {}
			local point = {x = object.x, y = object.y}
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
			point = {x = (object.x + object.width), y = object.y}
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
			point = {x = object.x, y = object.y + object.height}
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
			point = {x = (object.x + object.width), y = object.y + object.height}
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = object.x + x, y = object.y + y}, {x = object.x + object.width + x, y = object.y + y})
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = object.x + object.width + x, y = object.y + y}, {x = object.x + object.width + x, y = object.y + object.height + y})
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = object.x + x, y = object.y + y}, {x = object.x + x, y = object.y + object.height + y})
			mainLines[#mainLines + 1] = pancake.lineFromPoints({x = object.x + x, y = object.y + object.height + y}, {x = object.x + object.width + x, y = object.y + object.height + y})

			for i, line in ipairs(mainLines) do
				pancake.drawLine(line)
			end]]--
			--[[if enemy.path then
				love.graphics.setColor(0,1,0,1)
				for p, point in ipairs(enemy.path) do
					if p == 1 then
						pancake.drawLine(pancake.lineFromPoints({x = enemy.x + enemy.width/2, y = enemy.y + enemy.height/2}, {x = point.x + enemy.width/2, y = point.y + enemy.height/2}))
					else
						local lastPoint = enemy.path[p-1]
						pancake.drawLine(pancake.lineFromPoints({x = point.x + enemy.width/2, y = point.y + enemy.height/2}, {x = lastPoint.x + enemy.width/2, y = lastPoint.y + enemy.height/2}))
					end
				end
			end
			local sightLine = pancake.lineFromPoints({x = player.x + player.width/2, y = player.y + player.height/2}, {x = enemy.x + enemy.width/2, y = enemy.y + enemy.height/2})
			if canEnemySeePlayer(enemy) then
				love.graphics.setColor(0.2,0.6,0.9)
			else
				love.graphics.setColor(1,0.2,0.2)
			end
			pancake.drawLine(sightLine)
		end]]--
		--[[
		local hitboxLines
		love.graphics.setColor(1,0,0,1)
		for _, object in ipairs(pancake.objects) do
			if object.colliding then
				hitboxLines = {}
				hitboxLines[1] = pancake.lineFromPoints({x = object.x, y = object.y}, {x = object.x + object.width, y = object.y})
				hitboxLines[2] = pancake.lineFromPoints({x = object.x + object.width, y = object.y}, {x = object.x + object.width, y = object.y + object.height})
				hitboxLines[3] = pancake.lineFromPoints({x = object.x, y = object.y}, {x = object.x, y = object.y + object.height})
				hitboxLines[4] = pancake.lineFromPoints({x = object.x, y = object.y + object.height}, {x = object.x + object.width, y = object.y + object.height})
				for i, line in ipairs(hitboxLines) do
					pancake.drawLine(line)
				end
			end]]--
		end
	end
	love.graphics.setColor(1,1,1,1)
	--
	if pancake.debugMode and pancake.debug.show.hitboxes then
		drawHitboxes()
	end
	if pancake.debugMode then
		if pancake.debug.editMode then
			love.graphics.setColor(0,1,1,0.7)
			for l, light in ipairs(pancake.lights) do
				love.graphics.circle("fill", light.x, light.y, scale/4)
			end
			love.graphics.setColor(1,1,1,1)
		end
		if pancake.debug.show.info then
			drawNerdData()
		end
		if pancake.debug.show.vectors then
			love.graphics.scale(1/scale)
			drawMoveVectors()
			love.graphics.scale(scale)
		end
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

		--Lights :/
		if pancake.useLights then
			local renderExtension = pancake.window.renderExtension
			love.graphics.origin()
			pancake.sendDataToShader()
			love.graphics.setCanvas(pancake.lightCanvasRenderer)
			love.graphics.setShader(pancake.lightShader)
			love.graphics.draw(pancake.lightCanvas)
			love.graphics.setShader()
			love.graphics.setCanvas(pancake.canvas)
			--love.graphics.rectangle("fill", 0, 0, pancake.window.width, pancake.window.height)
			love.graphics.scale(scale)
			love.graphics.draw(pancake.lightCanvasRenderer, -renderExtension.x, -renderExtension.y)
			love.graphics.setCanvas()
		end
		love.graphics.origin()
		love.graphics.setShader(pancake.defaultShader)
		love.graphics.draw(pancake.canvas, pancake.window.x, pancake.window.y)
	end
	pancake.drawButtons()
	if pancake.debugMode then
		--pancake.drawInfo(love.graphics.getWidth()-400*pancake.debug.scale, 200)
		drawDebug()
		love.graphics.origin()
		--pancake.print(love.timer.getFPS() .. " FPS", 0, 0, 20)
	end
end

function drawLightMask()
	local renderExtension = pancake.window.renderExtension
	love.graphics.setCanvas(pancake.lightCanvasRenderer)
	love.graphics.clear()
	love.graphics.setCanvas(pancake.lightCanvas)
	love.graphics.clear()
	love.graphics.translate(renderExtension.x,renderExtension.y)
	for i, object in pairs(pancake.objectsToRender) do
		if object.lightBlocker and object.colliding == true then
			drawObject(object)
		end
	end
	love.graphics.translate(-renderExtension.x,-renderExtension.y)
end

function pancake.sendDataToShader()
	local amount = 100
	local window = pancake.window
	local lightsColors = {}
	local lights = {}
	local limits = {}
	for i, light in ipairs(pancake.lights) do
		local start = light.start or 1.0
		local finish = light.finish or 0.0
		lights[i] = {light.x, light.y, light.radius, 1.0}
		lightsColors[i] = {light.color.r, light.color.g, light.color.b, 1.0}
		limits[i] = {start, finish}
	end
	if #pancake.lights < amount then
		for i = #pancake.lights + 1, amount - #pancake.lights do
			lights[i] = {0.0,0.0,0.0,0.0}
			lightsColors[i] = {0.0,0.0,0.0, 1.0}
			limits[i] = {0.0, 0.0}
		end
	end

	pancake.lightShader:send("lights", unpack(lights))
	pancake.lightShader:send("limits", unpack(limits))
	pancake.lightShader:send("lightsColors", unpack(lightsColors))
	--pancake.lightShader:send("pixelSize", pancake.window.pixelSize)
	pancake.lightShader:send("pancakeWindow", {window.x, window.y, window.width, window.height})
	pancake.lightShader:send("camera", {-window.offsetX,-window.offsetY})
	pancake.lightShader:send("renderExtension", {window.renderExtension.x, window.renderExtension.y})
end

function pancake.drawLine(line, scale, smooth)
	local scale = scale or 1
	if smooth then
		if line.y then
			love.graphics.line(line.start, line.start*line.a + line.b, line.finish, line.finish*line.a + line.b)
		else
			love.graphics.line(line.b, line.start, line.b, line.finish)
		end
	else
		if (not line.y) and (line.a) then
			love.graphics.rectangle("fill", pancake.round(line.start), pancake.round(line.start*line.a + line.b), scale, math.abs(line.finish-line.start)*scale)
		elseif line.a then
			local longerAxis = pancake.boolConversion(math.abs(line.a) > 1, "y", "x")
			local start, finish
			if longerAxis == "x" then
				start = pancake.round(line.start)
				finish = pancake.round(line.finish)
				for i = start, finish do
					love.graphics.rectangle("fill", i*scale, pancake.round(i*line.a + line.b)*scale, scale, scale)
				end
			else
				start = pancake.round(line.start*line.a + line.b)
				finish = pancake.round(line.finish*line.a + line.b)
				for i = start, finish, pancake.sigma(finish - start) do
					love.graphics.rectangle("fill", pancake.round((i - line.b)/line.a)*scale, i*scale, scale, scale)
				end
			end
		end
	end
end

function pancake.getCenter(object)
	return {x = object.x + object.width/2, y = object.y + object.height/2}
end

function drawDebug()
	local scale = pancake.debug.scale
	local debug = pancake.debug
	local show = debug.show
	love.graphics.scale(scale)
	pancake.print(love.timer.getFPS() .. " FPS", 0, 0, 2)

	if debug.editMode then
		if pancake.target then
			drawObjectEditor()
		end
		--Draw display layer menu
		if show.displayLayer then
			love.graphics.setColor(0.2,0.2,0.2,1)
			love.graphics.rectangle("fill", 820, 0, 630, 116)
			love.graphics.setColor(0.9,0.9,0.9,1)
			pancake.print("Display Layer:", 975, 7, 4)
			love.graphics.setColor(0.2,0.2,0.2,1)
			love.graphics.rectangle("fill", 1090, 116, 90, 30)
			love.graphics.setColor(0.5,0.5,0.5,1)
			pancake.print("Hide", 1114, 119, 2)
			for i = 1, 10 do
				love.graphics.setColor(0.3,0.3,0.3,1)
				if debug.displayLayer == i or (i == 10 and not debug.displayLayer) then
					love.graphics.setColor(0.6,0.6,0.6,1)
				end
				love.graphics.rectangle("fill", i*60 + 780, 55, 50, 50)
				love.graphics.setColor(0.9,0.9,0.9,1)
				if debug.displayLayer == i or (i == 10 and not debug.displayLayer) then
					love.graphics.setColor(0.2,0.2,0.2,1)
				end
				if i ~= 10 then
					pancake.print(i,i*60 + 795, 65, 4)
				else
					pancake.print("ALL",i*60 + 784, 73, 2)
				end
			end
		else
			love.graphics.setColor(0.2,0.2,0.2,1)
			love.graphics.rectangle("fill", 1090, 0, 90, 30)
			love.graphics.setColor(0.6,0.6,0.6,1)
			pancake.print("Layers", 1100, 3, 2)
		end--end of drawing display layer menu
		--Draw toolbar
		if debug.show.tools then
			love.graphics.setColor(0.2,0.2,0.2,1)
			love.graphics.rectangle("fill",0, 170, 300, 600)
			love.graphics.setColor(1,1,1,1)
			pancake.print("TOOLS", 90, 180, 3)
			love.graphics.draw(debug.hideToolsCanvas,300+30,420,math.pi/2)
			love.graphics.setColor(0.25,0.25,0.25,1)
			for i = 0,2 do
				love.graphics.rectangle("fill", 10+i*95,225, 87, 60)
			end
			love.graphics.setColor(1,1,1,1)
			pancake.print("Copy",27,245,2.5)
			pancake.print("Cut",123,245,2.5)
			pancake.print("Paste",209,245,2.5)
			pancake.print("SHOW/HIDE", 50, 310, 3)
			love.graphics.setColor(0.25,0.25,0.25,1)
			for i = 0,2 do
				love.graphics.rectangle("fill", 10+i*95,345, 87, 60)
			end
			love.graphics.setColor(0.35,0.35,0.35,1)
			if debug.show.hitboxes then
				love.graphics.rectangle("fill", 10+0*95,345, 87, 60)
			end
			if debug.show.vectors then
				love.graphics.rectangle("fill", 10+1*95,345, 87, 60)
			end
			if debug.show.info then
				love.graphics.rectangle("fill", 10+2*95,345, 87, 60)
			end
			love.graphics.setColor(1,1,1,1)
			pancake.print("Hitboxes",15,365,1.8)
			pancake.print("Vectors",110,365,1.8)
			pancake.print("Info",214,363,2.5)

			pancake.print("Camera", 90, 420, 3)
			love.graphics.setColor(0.25,0.25,0.25,1)
			for i = 0,1 do
				love.graphics.rectangle("fill", 10+i*95,460, 87, 60)
			end
			if pancake.cameraFollow and (pancake.target == pancake.cameraFollow or not pancake.target) then
				love.graphics.setColor(0.35,0.35,0.35,1)
				love.graphics.rectangle("fill", 10,460, 87, 60)
			end
			love.graphics.setColor(1,1,1,1)
			pancake.print("Folllow",17,482,2.2)
			pancake.print("Reset",110,478,2.7)
			local cam_x = pancake.round(pancake.window.offsetX)
			local cam_y = pancake.round(pancake.window.offsetY)
			pancake.print("x:" .. pancake.boolConversion(string.len(cam_x)<6,cam_x,string.sub(cam_x,0,5) .. "..."),205,460,2.5)
			pancake.print("y:" .. pancake.boolConversion(string.len(cam_y)<6,cam_y,string.sub(cam_y,0,5) .. "..."),205,485,2.5)
			pancake.print("Other", 105, 540, 3)
			love.graphics.setColor(0.25,0.25,0.25,1)
			for i = 0,2 do
				love.graphics.rectangle("fill", 10+i*95,580, 87, 60)
			end
			love.graphics.setColor(0.35,0.35,0.35,1)
			if pancake.paused then
				love.graphics.rectangle("fill", 10,580, 87, 60)
			end
			if pancake.smoothRender then
				love.graphics.rectangle("fill", 10+95,580, 87, 60)
			end
			love.graphics.setColor(1,1,1,1)
			pancake.print("Pause",18,598,2.5)
			pancake.print("Smooth",117,590,1.8)
			pancake.print("Render",118,612,1.8)
			pancake.print("Save",214,600,2.5)

		else
			love.graphics.draw(debug.showToolsCanvas,0+30,420,math.pi/2)
		end--end of drawing toolbar
		for i, str in ipairs(debug.strings) do
			if string.len(str.name) < 7 or string.sub(str.name,1,7) ~= "object_" or pancake.target then
				love.graphics.setColor(0.2,0.2,0.2,1)
				local box = str.box
				love.graphics.rectangle("fill", box.x, box.y ,box.width, box.height)
				love.graphics.setColor(0.3,0.3,0.3,1)
				if debug.stringFocused == str.name then
					love.graphics.setColor(0.4,0.4,0.4,1)
				end
				love.graphics.rectangle("fill", box.x + 4, box.y + 4 ,box.width - 8, box.height -8)
				local color = {r = 0.45, g = 0.55, b = 1}
				if str.type == "number" then
					color = {r = 0.8, g = 0.8, b = 0.4}
				elseif str.type == "boolean" then
					if str.value then
						color = {r = 0.4, g = 0.7, b = 0.4}
					else
						color = {r = 0.7, g = 0.4, b = 0.4}
					end
				elseif str.value == nil or string.sub(str.name,1,7) ~= "object_" then
					color = {r = 0.7, g = 0.7, b = 0.7}
				end
				if debug.stringFocused == str.name then
					color.r = color.r *7/5
					color.g = color.g *7/5
					color.b = color.b*7/5
				end
				love.graphics.setColor(color.r, color.g, color.b, 1)
				local text = ""
				if str.type == "boolean" then
					if str.value then
						text = "true"
					else
						text = "false"
					end
				else
					if str.value then
						text = pancake.boolConversion(pancake.getStringWidth(str.value) < str.maxWidth, str.value, string.sub(str.value, 0, str.maxWidth/4) .. "...")
					end
					if debug.stringFocused == str.name and debug.stringTimer.state then
						text = string.sub(text,0, debug.linePosition) .. "|" .. string.sub(text,debug.linePosition + 1)
					end
					if text == "" then
						text = str.tip
					end
				end
				pancake.print(text, str.x, str.y, str.scale)
				if str.desc then
					love.graphics.setColor(0.9,0.9,0.9,1)
					pancake.print(str.desc.text, str.desc.x, str.desc.y, str.desc.scale)
				end
			end
		end
	end

	if love.keyboard.isDown("rshift") or pancake.collisionCheck({x = 2.8*scale*10.8, y = 2.8*scale*10.8, width = 12*scale*10.8, height = 8*scale*10.8}, {x = love.mouse.getX(), y = love.mouse.getY(), width = 1, height = 1}) then
		love.graphics.setColor(0,0,0,1)
		love.graphics.draw(pancake.images.pixel_pancake_icon, -3.53*10.8, -3.3*10.8, 0, 1.5*10.8)
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(pancake.images.pixel_pancake_icon, -0.3*10.8, -0.3*10.8, 0, 1.1*10.8)
	else
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(pancake.images.pixel_pancake_icon, 0.5, 0.5, 0, 1*10.8)
	end

	if pancake.debug.stringFocused and pancake.find(debug.strings, debug.stringFocused, "name") and pancake.os == "Android" then
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill", 0,0,1920,1080)
		love.graphics.setColor(1,1,1,1)
		pancake.print(pancake.find(debug.strings, debug.stringFocused, "name").value,10,10,20)
	end
	love.graphics.origin()
	if (love.keyboard.isDown("lctrl") or love.keyboard.isDown("lctrl")) and pancake.debug.clipboard and pancake.collisionCheck({x = pancake.window.x, y = pancake.window.y, width = pancake.window.width*pancake.window.pixelSize, height = pancake.window.height*pancake.window.pixelSize}, {x=love.mouse.getX(),y=love.mouse.getY(),width=1,height=1}) then
		love.graphics.setColor(0.3, 0.8, 0.25, 0.5)
		love.graphics.rectangle("fill", love.mouse.getX(), love.mouse.getY(), pancake.debug.clipboard.width*pancake.window.pixelSize, pancake.debug.clipboard.height*pancake.window.pixelSize)
	end
end

function drawObjectEditor()
	local scale = pancake.debug.scale
	local debug = pancake.debug
	love.graphics.setColor(0.2,0.2,0.2,1)
	love.graphics.rectangle("fill", 1500, 0, 420, 1080)
	love.graphics.setColor(0.9,0.9,0.9,1)
	pancake.print("Object editor", 1550, 20, 5)
	--Drawing section buttons
	love.graphics.scale(1/debug.scale)
	love.graphics.setCanvas(pancake.debug.categoriesCanvas)
	love.graphics.clear()
	love.graphics.setColor(0.2, 0.2, 0.2, 1)
	love.graphics.rectangle("fill", 0, 0, 200, 50)
	love.graphics.setColor(0.9,0.9,0.9,1)
	pancake.print("General", 20, 8, 4)
	if debug.objectEditCategory ~= "general" then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, 200, 50)
	end
	love.graphics.setColor(0.2, 0.2, 0.2, 1)
	love.graphics.rectangle("fill", 200, 0, 200, 50)
	love.graphics.setColor(0.9,0.9,0.9,1)
	pancake.print("Display", 230, 8, 4)
	if debug.objectEditCategory ~= "display" then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 200, 0, 200, 50)
	end
	love.graphics.setColor(0.2, 0.2, 0.2, 1)
	love.graphics.rectangle("fill", 400, 0, 200, 50)
	love.graphics.setColor(0.9,0.9,0.9,1)
	pancake.print("Physics", 420, 8, 4)
	if debug.objectEditCategory ~= "physics" then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 400, 0, 200, 50)
	end
	love.graphics.setColor(0.2, 0.2, 0.2, 1)
	love.graphics.rectangle("fill", 600, 0, 200, 50)
	love.graphics.setColor(0.9,0.9,0.9,1)
	pancake.print("Other", 645, 8, 4)
	if debug.objectEditCategory ~= "other" then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 600, 0, 200, 50)
	end
	love.graphics.setCanvas()
	love.graphics.scale(debug.scale)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(pancake.debug.categoriesCanvas, 1450, 1000, 3/2*math.pi)
	if debug.objectEditCategory == "display" then
		love.graphics.setColor(pancake.background.r,pancake.background.g,pancake.background.b,pancake.background.a)
		love.graphics.rectangle("fill", 1530, 70, 370, 370)
		love.graphics.setColor(1,1,1,1)
		local object = pancake.target
		if not object.textured then
			if object.image then
				local i = {width = pancake.images[object.image]:getWidth(), height = pancake.images[object.image]:getHeight()}
				local objectScale = pancake.boolConversion(object.textured, 370/object.width,pancake.boolConversion(i.width > i.height,370/i.height,370/i.width))
				local offsetX = object.offsetX or 0
				local offsetY = object.offsetY or 0
				drawObject(object, 1530-offsetX*objectScale, 70-offsetY*objectScale, objectScale)
			end
		else
			local image = pancake.images[object.image]
			local textureWidth = object.textureWidth or pancake.boolConversion(pancake.images[object.image], pancake.images[object.image]:getWidth(), 16)
			love.graphics.draw(image, 1530, 70 ,0, 370/textureWidth)
		end
	end
end

function switchEditMode()
	pancake.debug.editMode =  not pancake.debug.editMode
	local on = pancake.debug.editMode
end

function drawLoadAnimation()
	local pixelSize = pancake.window.pixelSize
	local width = pancake.window.width
	local height = pancake.window.height
	local animation = pancake.loadAnimation
	local lowerCoord = pancake.boolConversion(pancake.window.width > pancake.window.height, "height", "width")
	local scale = pixelSize*pancake.window[lowerCoord]/16
	local x
	local y
	if pancake.window.width == pancake.window.height then
		x = 0
		y = 0
	elseif lowerCoord == "height" then
		y = 0
		x = (width/2*pixelSize - 8*scale)/scale
	elseif lowerCoord == "width" then
		y = (height/2*pixelSize - 8*scale)/scale
		x = 0
	end
	love.graphics.scale(scale)
	if not (animation.frame == 35 and animation.time >= 2500) then
		if animation.frame > 11 then
			love.graphics.setColor(243/256,199/256,46/256,1)
		end
		love.graphics.rectangle("fill", 0, 0, width/scale*pixelSize, height/scale*pixelSize)
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(pancake.images[animation[animation.frame]], x, y)
	end
	if animation.frame == 1 then
		love.graphics.setColor(0,0,0,1-(animation.time + 100)/animation.duration)
		love.graphics.rectangle("fill", 0, 0, width/scale*pixelSize, height/scale*pixelSize)
	elseif animation.frame == 35 and animation.time <= 2500 then
		love.graphics.setColor(0,0,0,(animation.time-1500)/1000)
		love.graphics.rectangle("fill", 0, 0, width/scale*pixelSize, height/scale*pixelSize)
	elseif animation.frame == 35 and animation.time >= 2500 then
		love.graphics.setColor(0,0,0,1-(animation.time - 2500)/1000)
		love.graphics.rectangle("fill", 0, 0, width/scale*pixelSize, height/scale*pixelSize)
	end
	love.graphics.setColor(1,1,1,1)
end

function drawMoveVectors()
	local pixelSize = pancake.window.pixelSize
	local scale = scale or pancake.window.pixelSize/6
	for i, object in ipairs(pancake.objectsToRender) do
		if object.physics then
			local layer = object.layer or 1
			if not pancake.debug.displayLayer or pancake.debug.displayLayer == layer then
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
end

function pancake.renderedObjects()
	local window = pancake.window
	local re = window.renderExtension
	local ret = {}
	for i, object in ipairs(pancake.objects) do
		if pancake.collisionCheck({x = window.offsetX - re.x, y = window.offsetY - re.y, width = window.width + re.x*2, height = window.height + re.y*2}, object) then
			ret[#ret + 1] = object
		end
	end
	for i, object in ipairs(pancake.visuals) do
		local object = pancake.visuals[i]
		if pancake.collisionCheck({x = window.offsetX - re.x, y = window.offsetY - re.y, width = window.width + re.x*2, height = window.height + re.y*2}, object) then
			ret[#ret + 1] = object
		end
	end
	table.sort(ret, pancake.compareObjectRenderPriority)
	return ret
end

function pancake.compareObjectRenderPriority(a,b)
	local fa = a.layer or 1
	local fb = b.layer or 1
	if fa == fb then
		return a.ID < b.ID
	else
		return fa > fb
	end
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

function pancake.displayToWindow(x, y)
	local x = pancake.round((love.mouse.getX() - pancake.window.x)/pancake.window.pixelSize)
	local y = pancake.round((love.mouse.getY() - pancake.window.y)/pancake.window.pixelSize)
	return {x = x, y = y}
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

function deegreesToRadians(number)
	if number and type(number) == "number" then
		return number*(math.pi/180)
	end
end

function pancake.queueToUpdateEnd(func, argument)
	if not pancake.updateEndQueue then
		pancake.updateEndQueue = {}
	end
	pancake.updateEndQueue[#pancake.updateEndQueue + 1] = {func = func, argument = argument}
end

function drawObject(object,x,y,scale)
	local rotation = deegreesToRadians(object.rotation) or 0
	local objects = pancake.objectsToRender
	local layers = objects[1].layer or 1
	local scale = scale or 1
	local layer = object.layer or 1
	local color = object.color or {}
	color.r = color.r or 1
	color.g = color.g or 1
	color.b = color.b or 1
	color.a = color.a or 1
	love.graphics.setColor(color.r - (layer-1)*pancake.layerDepth/layers, color.g - (layer-1)*pancake.layerDepth/layers, color.b - (layer-1)*pancake.layerDepth/layers, color.a)
	if pancake.andCheck(object, {"x","y","image"}) and (not pancake.debug.displayLayer or pancake.debug.displayLayer == layer) then
		local x = x or object.x or 0
		local y = y or object.y or 0
		if not pancake.smoothRender then
			x = pancake.round(x)
			y = pancake.round(y)
		end
		local offsetX = pancake.boolConversion(object.offsetX, object.offsetX, 0)*pancake.boolConversion(object.flippedX, -1, 1)
		local offsetY = pancake.boolConversion(object.offsetY, object.offsetY, 0)*pancake.boolConversion(object.flippedY, -1, 1)
		if object.image == "rectangle" then
			love.graphics.rectangle("fill", x + offsetX*scale, y + offsetY*scale, object.width, object.height)
		elseif object.image == "text" then
			pancake.print(object.text, x + offsetX*scale, y + offsetY*scale, scale)
		elseif object.image == "line" then
			--if not object.line then
				--object.line =
			--end
			pancake.drawLine(pancake.lineFromPoints({x=object.x,y=object.y}, {x=object.x + object.width*pancake.boolConversion(object.flippedX, -1, 1),y= object.y + object.height*pancake.boolConversion(object.flippedY, -1, 1)}), scale)
		elseif pancake.images[object.image] then
			local image
			if object.textured then
				image = object.textureCanvas
			else
				image = pancake.images[object.image]
			end
			local rotationOffset = calcRotationOffset(object)
			love.graphics.draw(image, x + offsetX*scale + pancake.boolConversion(object.flippedX, object.width, 0)*scale + rotationOffset.x, y + offsetY*scale + pancake.boolConversion(object.flippedY, object.height, 0)*scale + rotationOffset.y, rotation, pancake.boolConversion(object.flippedX, -1, 1)*scale,pancake.boolConversion(object.flippedY, -1, 1)*scale)
		end
	end
end

function calcRotationOffset(object)
	local offsetX = object.offsetX or 0
	local offsetY = object.offsetY or 0
	local rotation = object.rotation or 0
	if rotation == 90 then
		return {x=object.width, y=0}
	elseif rotation == 180 then
		return {x=object.width, y=object.height}
	elseif rotation == 270 then
		return {x=0, y=object.height}
	else
		return {x=0, y=0}
	end
end

function createTexturedObjectCanvas(object)
	love.graphics.setColor(1,1,1,1)
	local texture = {width = object.textureWidth or pancake.boolConversion(pancake.images[object.image], pancake.images[object.image]:getWidth(), 16), height = object.textureHeight or pancake.boolConversion(pancake.images[object.image], pancake.images[object.image]:getHeight(), 16)}
	if not object.textureCanvas then
		object.textureCanvas = love.graphics.newCanvas(object.width, object.height)
	else
		love.graphics.setCanvas(object.textureCanvas)
		love.graphics.clear()
		love.graphics.setCanvas()
	end
	love.graphics.setCanvas(object.textureCanvas)
	for px = 0, math.ceil(object.width/texture.width) do
		for py = 0, math.ceil(object.height/texture.height) do
			love.graphics.draw(pancake.images[object.image],px*texture.width, py*texture.height)
		end
	end
	love.graphics.setCanvas()
	object.textureWidth = texture.width
	object.textureHeight = texture.height
end

function drawObjects()
	love.graphics.setCanvas(pancake.canvas)
	local x = 0
	local y = 0
	local lightBlockers = {}
	local objects = pancake.objectsToRender
	local lastGroup = "default"
	if objects then
		for i, object in pairs(objects) do
			local layer = object.layer or 1
			local shaderGroup = object.shaderGroup or "default"
			if lastGroup ~= shaderGroup then
				local shader = pancake.groupShaders[shaderGroup]
				love.graphics.setShader(shader)
			end
			lastGroup = shaderGroup
			drawObject(object)
		end
	end
	love.graphics.setShader()
end


function pancake.displayableObjects()
	return pancake.sumTables(pancake.objects, pancake.visuals)
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
	return object
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
			local filepath = folder .."/" .. objectName.."_"..animationName..frame..".png"
			local info = love.filesystem.getInfo(filepath)
			if info and info.type == "file" then
				pancake.addImage(objectName.."_"..animationName..frame,folder)
				animation[frame] = objectName.."_"..animationName..frame
			else
				animation.frames = frame - 1
				animation.speed = speed
				break
			end
		end
	end
	return animation
end

function drawNerdData()
local scale = pancake.window.pixelSize/pancake.debug.scale/2
	for i, object in ipairs(pancake.objectsToRender) do
		local x = object.x
		local y = object.y
		if not pancake.smoothRender then
			x = pancake.round(x)
			y = pancake.round(y)
		end
		local layer = object.layer or 1
		if not pancake.debug.displayLayer or pancake.debug.displayLayer == layer then
			pancake.print("DO:" .. i,x,y, 2/scale)
			pancake.print("ID: " .. object.ID, x, y + 20/scale, 2/scale)
		end
	end
end

function drawHitboxes()
	for i, object in ipairs(pancake.objectsToRender) do
		local x = object.x
		local y = object.y
		if not pancake.smoothRender then
			x = pancake.round(x)
			y = pancake.round(y)
		end
		local layer = object.layer or 1
		if not pancake.debug.displayLayer or pancake.debug.displayLayer == layer then
			if pancake.andCheck(object, {"x", "y", "height", "width"}) then
				love.graphics.setColor(0.4, 1 ,0.4, 0.3)
				if pancake.target == object then
					love.graphics.setColor(1, 1 ,1, 0.4)
				end
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
	end
	love.graphics.setColor(1,1,1,1)
end
-- Object functions!
function pancake.addObject(object)
	pancake.objects[#pancake.objects + 1] = pancake.assignID(object)
	return pancake.objects[#pancake.objects]
end

function pancake.addVisual(visual)
	pancake.visuals[#pancake.visuals + 1] = pancake.assignID(visual)
	return pancake.visuals[#pancake.visuals]
end

function pancake.addLight(light)
	light.color = light.color or {r=1,g=1,b=1}
	pancake.lights[#pancake.lights + 1] = pancake.assignID(light)
	return pancake.lights[#pancake.lights]
end

--Physics functions
function pancake.applyPhysics(object, settings)
	local physics = pancake.physics
	object.physics = true
	local settings = settings or {}
	object.mass = settings.mass or physics.defaultMass
	object.maxVelocity = settings.maxVelocity or object.maxVelocity or physics.defaultmaxVelocity
	object.maxVelocityX = object.maxVelocityX or object.maxVelocity
	object.maxVelocityY = object.maxVelocityY or object.maxVelocity
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

function pancake.addTimer(time, mode, func, arguments, name, params) --TIME IS IN MS! Mode can be repetitive or single. If single is pick timer will run once and execute func function once, then delete itself. Repetitive basically acts like a timed loop executing func every x seconds
	local time = time or 1000
	local mode = mode or "single"
	local timer = pancake.assignID({duration = time, time = 0, mode = mode, func = func, arguments = arguments, name = name})
	if params then
		for i, param in pairs(params) do
			timer[i] = param
		end
	end
	pancake.timers[#pancake.timers + 1] = timer
	return timer
end

-------------------------
--ON UPDATE FINCTIONS----
-------------------------
function pancake.update(dt)
	--Handle load animation
	if pancake.window.pixelSize ~= pancake.lastPixelSize then
		pancake.canvas = love.graphics.newCanvas(pancake.window.width*pancake.window.pixelSize, pancake.window.height*pancake.window.pixelSize)
	end
	pancake.lastPixelSize = pancake.window.pixelSize
	if pancake.loadAnimation then
		updateLoadAnimation(dt)
	end
	if pancake.debugMode then
		updateDebug(dt)
	end
	local dt = pancake.boolConversion(pancake.paused, 0, dt)
	pancake.lastdt = pancake.boolConversion(dt == 0, pancake.lastdt, dt)
	updateTimers(dt)
	--APPLY PHYSICS
	pancake.updateObjects(dt)
	updateForces(dt) --changes velocity!!!
	--END OF PHYSICS
	--switchTarget(love.mouse.getX(), love.mouse.getY(), false)
	--Handle scren shake
	updateScreenShake(dt)
	--Handle end update queue
	doEndUpdateQueue()
	--THIS SHOULD ALWAYS BE LAST
	emptyTrash()
	pancake.objectsToRender = pancake.renderedObjects()
end

function doEndUpdateQueue()
	if pancake.updateEndQueue then
		for i, task in ipairs(pancake.updateEndQueue) do
			task.func(task.argument)
			pancake.updateEndQueue[i] = nil
		end
	end
end

function updateDebug(dt)
	local debug = pancake.debug
	local strings = debug.strings
	local target = pancake.target
	debug.scale = love.graphics.getHeight()/1080
	if not target and debug.objectStringsAdded then
	debug.objectStringsAdded = false
		for i,v in ipairs(pancake.debug.strings) do
			if string.len(v.name) >= string.len("object_") and string.sub(v.name, 0, 7) == "object_" then
				pancake.trash(pancake.debug.strings, v.name, "name")
			end
		end
	elseif pancake.target then
		for i, v in ipairs(pancake.debug.strings) do
			if string.len(v.name) >= string.len("object_") and string.sub(v.name, 0, 7) == "object_" and v.name ~= debug.stringFocused then
				v.value = target[string.sub(v.name, 8)]
			end
		end
	end
	if pancake.debug.editMode then
		if pancake.target then
			moveTarget(dt)
		else
			moveDebugCamera(dt)
		end
		local timer = pancake.debug.stringTimer
		timer.duration = timer.duration + dt*1000
		if timer.duration >= timer.time then
			timer.duration = timer.duration - timer.time
			timer.state = not timer.state
		end
	end

	if pancake.debug.editMode and not pancake.debugMode then
		pancake.debug.editMode = false
		local debug = pancake.debug
		debug.stringFocused = nil
		debug.displayLayer = nil
	end
end

function addObjectStrings()
	local debug = pancake.debug
	local strings = debug.strings
	local target = pancake.target
	local lists = {general ={}, physics = {}}
	debug.objectStringsAdded = true
	for i,v in ipairs(pancake.debug.strings) do
		if string.len(v.name) >= string.len("object_") and string.sub(v.name, 1, 7) == "object_" then
			pancake.trash(pancake.debug.strings, v.name, "name")
		end
	end
	lists.general = {"name", "ID","x","y","width","height", "colliding"}
	lists.physics = {"physics","mass","velocityX", "velocityY", "maxVelocityX", "maxVelocityY", "maxVelocity", "friction", "bounciness"}
	lists.display = {"image","layer", "offsetX", "offsetY", "flippedX", "flippedY", "textured", "textureWidth", "textureHeight"}
	local i = 0
	local category = pancake.debug.objectEditCategory
	if category == "general" then
		for i, attribute in ipairs(lists[category]) do
			local value = pancake.target[attribute]
			local desc_scale = pancake.boolConversion(95/pancake.getStringWidth(attribute .. ":") > 4, 4, 95/pancake.getStringWidth(attribute .. ":"))
			local desc_x = 1505 + (47.5-pancake.getStringWidth(attribute .. ":")/2*desc_scale)
			local y = 50
			strings[#strings+1] = {tip = "Object " .. attribute, name = "object_" .. attribute, x = 1605, y = y + 7 + i*52, value = value, maxWidth = 67, scale = 4, width = 80, height = 60, box = {x = 1595, y = y+i*52, width = 315, height = 48}, desc = {text = attribute, x = desc_x, y = y + 9+i*52, scale = desc_scale}, type = pancake.boolConversion(type(value) == "string", nil, type (value))}
			if attribute == "colliding" then
				strings[#strings].type = "boolean"
			end
		end
	elseif category == "physics" then
		for i, attribute in ipairs(lists[category]) do
			local value = pancake.target[attribute]
			local desc_scale = pancake.boolConversion(95/pancake.getStringWidth(attribute .. ":") > 4, 4, 95/pancake.getStringWidth(attribute .. ":"))
			local desc_x = 1505 + (47.5-pancake.getStringWidth(attribute .. ":")/2*desc_scale)
			local y = 50
			strings[#strings+1] = {tip = "Object " .. attribute, name = "object_" .. attribute, x = 1605, y = y + 7 + i*52, value = value, maxWidth = 67, scale = 4, width = 80, height = 60, box = {x = 1595, y = y+i*52, width = 315, height = 48}, desc = {text = attribute, x = desc_x, y = y + 9+i*52, scale = desc_scale}, type = pancake.boolConversion(type(value) == "string", nil, type (value))}
			if attribute == "physics" then
				strings[#strings].type = "boolean"
			end
		end
	elseif category == "display" then
		for i, attribute in ipairs(lists[category]) do
			local value = pancake.target[attribute]
			local desc_scale = pancake.boolConversion(95/pancake.getStringWidth(attribute .. ":") > 4, 4, 95/pancake.getStringWidth(attribute .. ":"))
			local desc_x = 1505 + (47.5-pancake.getStringWidth(attribute .. ":")/2*desc_scale)
			strings[#strings+1] = {tip = "Object " .. attribute, name = "object_" .. attribute, x = 1605, y = 420 + i*52, value = value, maxWidth = 67, scale = 4, width = 80, height = 60, box = {x = 1595, y = 415+i*52, width = 315, height = 48}, desc = {text = attribute, x = desc_x, y = 424+i*52, scale = desc_scale}, type = pancake.boolConversion(type(value) == "string", nil, type (value))}
			if attribute == "textured" or attribute == "flippedX" or attribute == "flippedY" then
				strings[#strings].type = "boolean"
			end
		end
	elseif category == "other" then
		for attribute, value in pairs(target) do
			if type(value) == "string" or type(value) == "number" then
				local desc_scale = pancake.boolConversion(95/pancake.getStringWidth(attribute .. ":") > 4, 4, 95/pancake.getStringWidth(attribute .. ":"))
				local desc_x = 1505 + (47.5-pancake.getStringWidth(attribute .. ":")/2*desc_scale)
				local y = 90
				local add = true
				for category, cat_list in pairs(lists) do
					for i, l_value in ipairs(cat_list) do
						if l_value == attribute then
							add = false
						end
					end
				end
				if add then
					strings[#strings+1] = {tip = "Object " .. attribute, name = "object_" .. attribute, x = 1605, y = y + 11 + i*52, value = value, maxWidth = 67, scale = 4, width = 80, height = 60, box = {x = 1595, y = y+i*52, width = 315, height = 48}, desc = {text = attribute, x = desc_x, y = y + 15+i*52, scale = desc_scale}, type = pancake.boolConversion(type(value) == "string", nil, type (value))}
					i = i + 1
				end
			end
		end
	end
end

function moveDebugCamera(dt)
	local debug = pancake.debug
	local camera = debug.camera
	if ((love.keyboard.isDown("down") and love.keyboard.isDown("up")) or love.mouse.isDown(3)) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		camera.x = 0
		camera.y = 0
	elseif (love.keyboard.isDown("right") or love.mouse.getX() > love.graphics.getWidth() - 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		camera.x = camera.x + 100*dt
	elseif (love.keyboard.isDown("left") or love.mouse.getX() < 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		camera.x = camera.x - 100*dt
	elseif (love.keyboard.isDown("down") or love.mouse.getY() > love.graphics.getHeight() - 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		camera.y = camera.y + 100*dt
	elseif (love.keyboard.isDown("up") or love.mouse.getY() < 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		camera.y = camera.y - 100*dt
	end
end

function moveTarget(dt)
	local debug = pancake.debug
	local target = pancake.target
	local speed = 100
	if (love.keyboard.isDown("right") or love.mouse.getX() > love.graphics.getWidth() - 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		pancake.move(target, speed*dt, 0)
	elseif (love.keyboard.isDown("left") or love.mouse.getX() < 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		pancake.move(target, -speed*dt, 0)
	elseif (love.keyboard.isDown("down") or love.mouse.getY() > love.graphics.getHeight() - 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		pancake.move(target, 0, speed*dt)
	elseif (love.keyboard.isDown("up") or love.mouse.getY() < 20*debug.scale) and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) then
		pancake.move(target, 0, -speed*dt)
	end
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
	if pancake.debug.editMode then
		window.offsetY = window.offsetY + pancake.debug.camera.y
		window.offsetX = window.offsetX + pancake.debug.camera.x
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
		if object.colliding then
			pancake.collidingObjects[#pancake.collidingObjects + 1] = object
		end
		if object.textured and not object.textureCanvas then
			createTexturedObjectCanvas(object)
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
			if object.textured then
				createTexturedObjectCanvas(object)
			end
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
	for i, object in ipairs(pancake.objects) do
		if object.anchor then
			local anchorOffset = object.anchorOffset or {x=0, y=0}
			object.x = object.anchor.x + anchorOffset.x
			object.y = object.anchor.y + anchorOffset.y
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

function pancake.getPressure(object, directionName)
local force = 0
	if object.physics then
		if directionName == "down" then
			force = pancake.getStat(object, "forceY") + object.velocityY*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(directionName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(directionName))
					force = force + pancake.boolConversion(press >= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[directionName]
				end
			end
		elseif directionName == "up" then
			force = -pancake.getStat(object, "forceY") - object.velocityY*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(directionName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(directionName))
					force = force + pancake.boolConversion(press <= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[directionName]
				end
			end
			--X AXIS
		elseif directionName == "right" then
			force = pancake.getStat(object, "forceX") + object.velocityX*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(directionName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(directionName))
					force = force + pancake.boolConversion(press >= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[directionName]
				end
			end
		elseif directionName == "left" then
			force = -pancake.getStat(object, "forceX") - object.velocityX*object.mass/pancake.lastdt
			local objects = pancake.getFacingObjects(object)[pancake.opposite(directionName)]
			if #objects > 0 then
				for i = 1,#objects do
					local press = pancake.getStat(objects[i], "pressure" .. pancake.intoCaps(directionName))
					force = force + pancake.boolConversion(press <= 0, press, 0)/#objects/#pancake.getFacingObjects(objects[i])[directionName]
				end
			end
		end
	end


	force = pancake.boolConversion(force <= 0, 0, force)
	object["pressure" .. pancake.intoCaps(directionName)] = force
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
		local ret = true
		if not didTheyCollide(object1, object2) then
			if pancake.onCollision then
				ret = pancake.onCollision(object1, object2, axis, direction, sc)
				if ret == nil then
					ret = true
				end
			end
			if ret then
				local force2 = pancake.getCollisionForces(object1, object2, axis, direction, sc)[2]
				collisions[#collisions + 1] = {object = object2, force = force2}
				forceSum.x = forceSum.x + pancake.getCollisionForces(object1, object2, axis, direction, sc)[1].x
				forceSum.y = forceSum.y + pancake.getCollisionForces(object1, object2, axis, direction, sc)[1].y
			end
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
	local directionName = pancake.getDirectionName(axis, direction)
	local physics = pancake.physics
	local bounciness1 = pancake.getStat(object1, "bounciness")
	local bounciness2 = pancake.getStat(object2, "bounciness")
	local pressure1 = pancake.getStat(object1, "pressure" .. pancake.intoCaps(directionName))
	local pressure2 = pancake.getStat(object2, "pressure" .. pancake.intoCaps(pancake.opposite(directionName)))
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
	elseif value == "" then
		ret = ""
	end
	return ret
end

function updateTimers(dt)
	local timers = pancake.timers
	if timers[1] then
		for i, timer in ipairs(timers) do
			if (not pancake.timerUpdateCondition) or pancake.timerUpdateCondition(timer) then
				timer.time = timer.time + dt*1000
				if timer.time >= timer.duration then
					if timer.func then
						if type(timer.func) == "function" then
							timer.func(timer.arguments)
						elseif (type(timer.func) == "string" or type(timer.func) == "number") and pancake.functions[timer.func] then
							pancake.functions[timer.func](timer.arguments)
						end
					end
					if timer.mode == "single" then
						pancake.trash(pancake.timers, timer.ID, "ID")
					elseif timer.mode == "repetitive" then
						timer.time = timer.time - timer.duration
					end
				end
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
						pancake.addTable(collisions, collideMultiple(object, "x", s.x, object.x - s.x))
						b.x = true
					end
					object.y = object.y + s.y
					if pancake.isObjectColliding(object) then
						pancake.addTable(collisions, collideMultiple(object, "y", s.y, object.y - s.y))
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
							pancake.addTable(collisions, collideMultiple(object, smallerAxis, s[smallerAxis], object[smallerAxis] - s[smallerAxis]))
							b[smallerAxis] = true
						end
					end
				else
					steps = steps + 1
					if not b[biggerAxis] then
						object[biggerAxis] = object[biggerAxis] + s[biggerAxis]
						p[biggerAxis] = p[biggerAxis] - 1
						if pancake.isObjectColliding(object) then
							pancake.addTable(collisions,collideMultiple(object, biggerAxis, s[biggerAxis], object[biggerAxis] - s[biggerAxis]))
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
			pancake.addTable(collisions, collideMultiple(object, biggerAxis, s[biggerAxis], object[biggerAxis] - distance))
			b[biggerAxis] = true
		end
	end

	if not b[smallerAxis] then
		local distance = (o[smallerAxis] - s[smallerAxis]*a[smallerAxis])
		object[smallerAxis] = object[smallerAxis] + distance
		if pancake.isObjectColliding(object) then
			pancake.addTable(collisions, collideMultiple(object, smallerAxis, s[smallerAxis], object[smallerAxis] - distance))
			b[smallerAxis] = true
		end
	end
	return collisions
end

function pancake.getIntersection(line1, line2)
	local ret = false
	local x = 0
	--line = {y = true, a = 2, b = 4, start = 0, finish = 10} equals to 1*y = 1*x + 4 from start to finish
	--if a = 0, then y = b (obviously)
	--if not y, then line is x = b (VERY IMPORTANT)
	if line1.y then
		if not line2.y then
			if (line1.start < line2.b and line1.finish > line2.b) and (not line2.start or line1.a*line2.b + line1.b > line2.start) and (not line2.finish or line1.a*line2.b + line1.b < line2.finish) then
				ret = {x = line2.b, y = line1.a*line2.b + line1.b}
			end
		else
			local left = line1.a - line2.a
			local right = line2.b - line1.b
			if left ~= 0 then
				local x = right/left
				local decPrecision = 5
				local rx = pancake.round(x, decPrecision)
				if ((not line1.start) or (rx > pancake.round(line1.start, decPrecision))) and ((not line2.start) or (rx > pancake.round(line2.start, decPrecision))) and ((not line1.finish) or (rx < pancake.round(line1.finish, decPrecision))) and ((not line2.finish) or (rx < pancake.round(line2.finish, decPrecision))) then
					--if pancake.round(x) ~= pancake.round(line1.start) then
						ret = {x = x, y = line1.a*x + line1.b}
					--end
				end
			end
		end
	elseif line2.y then
		ret = pancake.getIntersection(line2, line1)
	end
	return ret
end

function pancake.checkPointToLine(point, line)
	local ret = false
	--Point is a table with coordinates; for example point = {x=1, y=3}
	--Line is a line table; line = {y = true, start = 0, finish = 100, a = 1, b = 5} then y = 1*x + 5
	if (line.start and point.x < line.start) or (line.finish and point.x > line.finish) then
		ret = false
	elseif line.a*point.x + line.b == point.y then --our point is on the line
		ret = 0 --Not above, not below
	elseif not line.y then
		ret = pancake.sigma(point.x - line.b)
	else
		ret = pancake.sigma(point.y - (point.x*line.a + line.b))
	end
	return ret
end

function pancake.lineFromPoints(point1, point2)
	local ret
	if point1.x >= point2.x then
		if point1.x == point2.x then
			ret = {b = point1.x, start = tonumber(pancake.boolConversion(point1.y < point2.y, point1.y, point2.y)), finish = tonumber(pancake.boolConversion(point1.y > point2.y, point1.y, point2.y))}
		elseif point1.y == point2.y then
			ret = {y = true, a = 0, b = point1.y, start = tonumber(pancake.boolConversion(point1.x < point2.x, point1.x, point2.x)), finish = tonumber(pancake.boolConversion(point1.x > point2.x, point1.x, point2.x))}
		else
			local left = point1.x - point2.x
			local right = point1.y - point2.y
			local a = right/left
			local b = point1.y - a*point1.x
			ret = {y = true, a = a, b = b, start = tonumber(pancake.boolConversion(point1.x < point2.x, point1.x, point2.x)), finish = tonumber(pancake.boolConversion(point1.x > point2.x, point1.x, point2.x))}
		end
	else
		ret = pancake.lineFromPoints(point2, point1)
	end
	return ret
end

function pancake.calcLine(line, x)
	local ret
	if line.y then
		if x >= line.start and x <= line.finish then
			ret = line.a*x + line.b
		else
			ret = false
		end
	end
	return ret
end

function pancake.getCollidingObjects(object)
	local ret = {}
	local objects = pancake.collidingObjects
	for i = 1, #objects do
		local currObject = objects[i]
		if object.ID ~= currObject.ID then
			if pancake.areObjectsColliding(object, currObject) then
				ret[#ret + 1] = currObject
			end
		end
	end
	return ret
end

function pancake.getOverlapingObjects(object)
	local ret = {}
	local objects = pancake.objects
	for i, currObject in ipairs(objects) do
		local currObject = objects[i]
		if object.ID ~= currObject.ID then
			if pancake.collisionCheck(object, currObject) then
				ret[#ret + 1] = currObject
			end
		end
	end
	return ret
end

function pancake.isObjectColliding(object)
	local ret = false
	if not object.colliding then
		return false
	else
		local objects = pancake.collidingObjects
		if not objects then
			pancake.update(0)
			objects = pancake.collidingObjects
		end
		for i, currObject in ipairs (objects) do
			if object.ID ~= currObject.ID then
				if pancake.areObjectsColliding(object, currObject) then
					ret = true
				end
			end
		end
		return ret
	end
end

function pancake.areObjectsColliding(object1, object2)
	local ret = false
	if pancake.andCheck(object1, {"x", "y", "width", "height"}) and pancake.collisionCheck(object1, object2) then
		if object1.colliding and object2.colliding then
			ret = true
			if (object1.colliding == "staticOnly" and object2.physics) or (object2.colliding == "staticOnly" and object1.physics) then
				ret = false
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
			if pancake.isObjectColliding({x = object.x + i, y = object.y + object.height, width = 1, height = step, colliding = object.colliding, physics = object.physics}) then
				down = down + 1
			end
			if pancake.isObjectColliding({x = object.x + i, y = object.y - step, width = 1, height = step, colliding = object.colliding, physics = object.physics}) then
				up = up + 1
			end
		end
		for i = -1, object.height - 1 do
			if pancake.isObjectColliding({x = object.x + object.width, y = object.y + i, width = step, height = 1, colliding = object.colliding, physics = object.physics}) then
				right = right + 1
			end
			if pancake.isObjectColliding({x = object.x - step, y = object.y + i, width = step, height = 1, colliding = object.colliding, physics = object.physics}) then
				left = left + 1
			end
		end
	end
	return {up = up, down = down, left = left, right = right}
end

function pancake.getPathLines(object, destination)
	local x = destination.x - object.x
	local y = destination.y - object.y
	local point = {x = object.x, y = object.y}
	--Defining path lines
	local pathLines = {}
	--Hitboxes while moving
	pathLines[#pathLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
	point = {x = (object.x + object.width), y = object.y}
	pathLines[#pathLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
	point = {x = object.x, y = object.y + object.height}
	pathLines[#pathLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
	point = {x = (object.x + object.width), y = object.y + object.height}
	pathLines[#pathLines + 1] = pancake.lineFromPoints({x = point.x, y = point.y}, {x = point.x + x, y = point.y + y})
	return pathLines
end

function pancake.getPathObstacles(object, destination)
	local objectCopy = pancake.copyTable(object)
	local broke
	local ret = {}
	local point = {x = object.x, y = object.y}
	--Defining path lines
	local pathLines = pancake.getPathLines(object, destination)
	--Hitboxes while moving
	for _, cObject in ipairs(pancake.collidingObjects) do
		objectCopy.x = cObject.x
		objectCopy.y = cObject.y
		if pancake.areObjectsColliding(objectCopy, cObject) then
			local objectHitlines = {}
			objectHitlines[#objectHitlines + 1] = pancake.lineFromPoints({x = cObject.x, y = cObject.y}, {x = cObject.x + cObject.width, y = cObject.y})
			objectHitlines[#objectHitlines + 1] = pancake.lineFromPoints({x = cObject.x, y = cObject.y + cObject.height}, {x = cObject.x + cObject.width, y = cObject.y + cObject.height})
			--local line1 = objectHitlines[1]
			--if line1.a then
				--if line1.a > 0 then
				--	objectHitlines[#objectHitlines + 1] = pancake.lineFromPoints({x = cObject.x, y = cObject.y}, {x = cObject.x, y = cObject.y + cObject.height})
			--	else
				--	objectHitlines[#objectHitlines + 1] = pancake.lineFromPoints({x = cObject.x + cObject.width, y = cObject.y}, {x = cObject.x + cObject.width, y = cObject.y + cObject.height})
			--	end
		--	else
				objectHitlines[#objectHitlines + 1] = pancake.lineFromPoints({x = cObject.x + cObject.width, y = cObject.y}, {x = cObject.x + cObject.width, y = cObject.y + cObject.height})
				objectHitlines[#objectHitlines + 1] = pancake.lineFromPoints({x = cObject.x, y = cObject.y}, {x = cObject.x, y = cObject.y + cObject.height})
		--	end
			for ohl, hitline in ipairs(objectHitlines) do
				if broke then
					broke = false
					break
				end
				for pl, pathline in ipairs(pathLines) do
					if pancake.getIntersection(hitline, pathline) then
						--[[
						daprint = "Object with ID " .. object.ID .. " would collide with object with ID " .. cObject.ID .. "\nPath line number " .. pl .. " intersected with hit line number " .. ohl
						if hitline.y then
							daprint = daprint .. "\nLine 1: y = " .. hitline.a .. "x + " .. hitline.b .. ", start: " .. hitline.start .. ", finish: " .. hitline.finish
						else
							daprint = daprint .. "\nLine 1: x = " .. hitline.b .. ", start: " .. hitline.start .. ", finish: " .. hitline.finish
						end
						if pathline.y then
							daprint = daprint .. "\nLine 2: y = " .. pathline.a .. "x + " .. pathline.b .. ", start: " .. pathline.start .. ", finish: " .. pathline.finish
						else
							daprint = daprint .. "\nLine 2: x = " .. pathline.b .. ", start: " .. pathline.start .. ", finish: " .. pathline.finish
						end
						daprint = daprint .. "\nIntersection at x = " .. pancake.getIntersection(hitline, pathline).x .. ", y = " .. pancake.getIntersection(hitline, pathline).y
						]]--
						ret[#ret + 1] = cObject
						broke = true
						break
					end
				end
			end
		end
	end
	return ret
end

function pancake.findPath(object, destination)
	local banned = {}
	local obstacles
	local nearest
	local point
	local points = {{x=object.x, y=object.y, path = {}}}
	local path = {}
	local result = false
	local destination = {x = destination.x, y = destination.y}
	local objectCopy = pancake.copyTable(object)
	while not result do
		point = points[1]
		local i = 1
		if point then
			for _, p in ipairs(points) do
				if pancake.calculateDistance(p, destination) < pancake.calculateDistance(point, destination) then
					point = p
					i = _
				end
			end
			objectCopy.x = point.x
			objectCopy.y = point.y
			obstacles = pancake.getPathObstacles(objectCopy, destination)
			if #obstacles == 0 then
				path = point.path
				path[#path + 1] = {x = destination.x, y = destination.y}
				result = true
			else
				nearest = obstacles[1]
				for _, obstacle in ipairs(obstacles) do
					if pancake.calculateDistance({x = objectCopy.x, y = objectCopy.y}, obstacle) < pancake.calculateDistance({x = objectCopy.x, y = objectCopy.y}, nearest) then
						nearest = obstacle
					end
				end
				--I have the closest obstacle now!
				local corners = {}
				local step = 0
				corners[#corners + 1] = {x = nearest.x - objectCopy.width - step, y = nearest.y - objectCopy.height - step} --up left
				corners[#corners + 1] = {x = nearest.x - objectCopy.width - step, y = nearest.y + nearest.height + step} --down left
				corners[#corners + 1] = {x = nearest.x + nearest.width + step, y = nearest.y - objectCopy.height - step} --up right
				corners[#corners + 1] = {x = nearest.x + nearest.width + step, y = nearest.y + nearest.height + step} --down right
				for cor, corner in ipairs(corners) do
					if not banned[nearest.ID .. "c" .. cor] and #pancake.getPathObstacles(objectCopy, corner) == 0 then
						points[#points + 1] = corner
						points[#points].path = pancake.copyTable(point.path)
						points[#points].path[#points[#points].path + 1] = {x = corner.x, y = corner.y}
						banned[nearest.ID .. "c" .. cor] = true
					end
				end
				table.remove(points, i)
			end
		else
			result = true
			path = nil
		end
	end
	return path
end

function pancake.calculateDistance(p1, p2)
	local h1 = p1.height or 0
	local h2 = p2.height or 0
	local w1 = p1.width or 0
	local w2 = p2.width or 0
	cp1 = {x = p1.x + w1/2, y = p1.y + h1/2}
	cp2 = {x = p2.x + w2/2, y = p2.y +h2/2}
	return math.sqrt((cp1.x - cp2.x)*(cp1.x - cp2.x) + (cp1.y - cp2.y)*(cp1.y - cp2.y))
end

function calcAboslute(p1, p2)
	return {x = p2.x - p1.x, y = p2.y - p1.y}
end

---------------------------------
--- 			PANCAKE FILES 			---
---------------------------------
function pancake.addFolder(path)
	local type =  love.filesystem.getInfo(path).type
	if type == "directory" then
		local items = love.filesystem.getDirectoryItems(path)
		if #items > 0 then
			for i = 1, #items do
				local item = items[i]
				local itemPath = path .. "/" .. item
				if love.filesystem.getInfo(itemPath).type == "directory" then
					pancake.addFolder(itemPath)
				else
					local extension = string.sub(item, -3)
					if extension == "png" then
						pancake.addImage(string.sub(item,0, -5), path)
					elseif extension == "wav" then
						pancake.addSound(string.sub(item,0, -5), path)
					end
				end
			end
		end
	end
end

function pancake.addAssets()
	pancake.addFolder("")
end

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
		sounds[#sounds].sound = love.audio.newSource(name .. ".wav", "static")
	else
		sounds[#sounds].sound = love.audio.newSource(subfolder .. "/".. name .. ".wav", "static")
	end
end

function pancake.playSound(name, overlap, pitch)
	local pitch = pitch or 1
	local source
	if not pancake.soundMuted then
		local overlap = overlap or false
		local sounds = pancake.sounds
		if type(name) == "string" then
			local sound = pancake.find(sounds, name, "name")
			source = sound.sound
		else
			source = sounds[name].sound
		end
		--Actually playing the source
		if source:isPlaying( ) and not overlap then
			source:stop()
		end
		source:setPitch(pitch)
		source:play()
	end
end

function pancake.muteSounds(option)
	if option then
		pancake.soundMuted = true
	else
		pancake.soundMuted = false
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
	button.width = button.width or button.image:getWidth()
	button.height = button.height or button.image:getHeight()
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
	if pancake.os == "Android" then
		local touches = love.touch.getTouches()
		if #touches > 0 then
			for i = 1, #touches do
				local x, y = love.touch.getPosition(touches[i])
				if (pancake.collisionCheck({x = x, y = y, width = 1, height = 1}, {x = button.x, y = button.y, width = button.width*button.scale, height = button.height*button.scale})) or (love.keyboard.isDown(button.key) and not pancake.debug.stringFocused ) then
					ret = true
				end
			end
		end
	else
		if (love.mouse.isDown(1) and pancake.collisionCheck({x = love.mouse.getX(), y = love.mouse.getY(), width = 1, height = 1}, {x = button.x, y = button.y, width = button.width*button.scale, height = button.height*button.scale})) or (love.keyboard.isDown(button.key) and not pancake.debug.stringFocused ) then
			ret = true
		end
	end
	return ret
end

function pancake.checkButtonPresses(x,y)
local ret = false
	local buttons = pancake.buttons
	if buttons[1] then
		for i = 1, #buttons do
			local button = buttons[i]
			if pancake.collisionCheck({x = x, y = y, width = 1, height = 1}, {x = button.x, y = button.y, width = button.width*button.scale, height = button.height*button.scale}) then
				ret = true
				if type(button.func) == "function" then
					button.func()
				end
			end
		end
	end
	return ret
end

--------------------------
--- PANCAKE MOUSEPRESS ---
--------------------------
	function pancake.mousepressed(x, y, button)
	if pancake.os ~= "Android" then
		pancake.clicked(x,y)
	end
end

function pancake.touchpressed( id, x, y, dx, dy, pressure )
	pancake.clicked(x,y)
end

function pancake.touchmoved(id, x, y, dx, dy, pressure )
	local window = pancake.window
	if pancake.target and pancake.collisionCheck({x = window.x, y = window.y, width = window.width*window.pixelSize, height = window.height*window.pixelSize},{x=x,y=y,width=1,height=1}) and pancake.debugMode and pancake.debug.editMode then--and pancake.collisionCheck({x = pancake.windowToDisplay(pancake.target.x, 0, true).x, y = pancake.windowToDisplay(0, pancake.target.y, true).x, width = pancake.target.width*window.pixelSize, height = pancake.target.height*window.pixelSize},{x=x-dx,y=y-dy,width=1,height=1}) then
		pancake.move(pancake.target, dx/window.pixelSize, dy/window.pixelSize)
	elseif pancake.collisionCheck({x = window.x, y = window.y, width = window.width*window.pixelSize, height = window.height*window.pixelSize},{x=x,y=y,width=1,height=1}) and pancake.debugMode and pancake.debug.editMode then
		local debug = pancake.debug
		local camera = debug.camera
		camera.x = camera.x - dx/window.pixelSize
		camera.y = camera.y - dy/window.pixelSize
	end
end

function pancake.clicked(x,y)
	local mouse = {x = x, y = y, width = 1, height = 1}
	local scale = pancake.debug.scale
	local debug = pancake.debug
	if pancake.collisionCheck({x = 2.8*scale*10.8, y = 2.8*scale*10.8, width = 12*scale*10.8, height = 8*scale*10.8}, {x = x, y = y, width = 1, height = 1}) and pancake.debugMode then
		switchEditMode()
	elseif pancake.collisionCheck({x = 1450*scale, y = 200*scale, width = 50*scale, height = 800*scale}, {x = x, y = y, width = 1, height = 1}) and pancake.debugMode and pancake.debug.editMode then
		if y > 800*scale then
			debug.objectEditCategory = "general"
		elseif y > 600*scale then
			debug.objectEditCategory = "display"
		elseif  y > 400*scale then
			debug.objectEditCategory = "physics"
		else
			debug.objectEditCategory = "other"
		end
		if pancake.find(debug.strings, pancake.debug.stringFocused, "name") and string.sub(pancake.find(debug.strings, pancake.debug.stringFocused, "name").name,1,7) == "_object" then
			debug.stringFocused = nil
		end
		addObjectStrings()
	elseif pancake.debugMode and pancake.debug.editMode and getClickedDebugString(x,y) then
		--
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=1090*debug.scale, y=0, width = 90*debug.scale, height = 30*debug.scale},mouse) and not debug.show.displayLayer then
		debug.show.displayLayer = true
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=1090*debug.scale, y=116*debug.scale, width = 90*debug.scale, height = 30*debug.scale},mouse) and debug.show.displayLayer then
		debug.show.displayLayer = false
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=300*debug.scale, y=420*debug.scale, width = 30*debug.scale, height = 90*debug.scale},mouse) and debug.show.tools then
		debug.show.tools = false
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=0, y=420*debug.scale, width = 30*debug.scale, height = 90*debug.scale},mouse) and not debug.show.tools then
		debug.show.tools = true
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=10*debug.scale,y=225*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and pancake.target and debug.show.tools then
		pancake.debug.clipboard = pancake.target
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10+95)*debug.scale,y=225*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and pancake.target and debug.show.tools then
		pancake.debug.clipboard = pancake.target
		pancake.smartDelete(pancake.objects, pancake.target.ID, "ID")
		pancake.target = nil
	elseif pancake.debugMode and debug.editMode and debug.show.tools and pancake.collisionCheck({x=(10+190)*debug.scale,y=225*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.clipboard then
		pasteObject()
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=10*debug.scale,y=345*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		debug.show.hitboxes = not debug.show.hitboxes
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10+95)*debug.scale,y=345*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		debug.show.vectors = not debug.show.vectors
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10+190)*debug.scale,y=345*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		debug.show.info = not debug.show.info
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=10*debug.scale,y=460*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		if pancake.target == pancake.cameraFollow or not pancake.target then
			pancake.cameraFollow = nil
			debug.camera.x = pancake.window.offsetX
			debug.camera.y = pancake.window.offsetY
		else
			pancake.cameraFollow = pancake.target
			debug.camera.x = 0
			debug.camera.y = 0
		end
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10+95)*debug.scale,y=460*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		debug.camera.x = 0
		debug.camera.y = 0
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10)*debug.scale,y=580*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		pancake.paused = not pancake.paused
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10 + 95)*debug.scale,y=580*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		pancake.smoothRender = not pancake.smoothRender
	elseif pancake.debugMode and debug.editMode and pancake.collisionCheck({x=(10 + 190)*debug.scale,y=580*debug.scale, width=87*debug.scale,height=60*debug.scale},mouse) and debug.show.tools then
		pancake.saveState(pancake.debug.strings[1].value or "no_name_save")
	else
		if pancake.debug.stringFocused then
			enterDebugString()
		end
		for i = 1, 10 do
			if pancake.collisionCheck({x = (i*60 + 780)*pancake.debug.scale, y = 55*pancake.debug.scale, width = 50*pancake.debug.scale, height = 50*pancake.debug.scale}, {x = x, y = y, width = 1, height = 1}) and pancake.debugMode and pancake.debug.editMode and pancake.debug.show.displayLayer then
				click = true
				if i == 10 then
					pancake.debug.displayLayer = nil
				else
					pancake.debug.displayLayer = i
				end
			end
		end
	--checking if ant button was pressed
		if pancake.checkButtonPresses(x,y) then
			--
		else
		--switching target (in debug mode)
			switchTarget(x,y, true)
		end
	end
end

function getClickedDebugString(x,y)
	local ret = false
	for i, str in ipairs(pancake.debug.strings) do
		local box = str.box
		if pancake.collisionCheck({x = box.x*pancake.debug.scale, y = box.y*pancake.debug.scale, width = box.width*pancake.debug.scale, height = box.height*pancake.debug.scale}, {x = x, y = y, width = 1, height = 1}) then
			ret = true
			if str.type == "boolean" then
				if str.value then
					str.value = false
				else
					str.value = true
				end
				if pancake.target and string.sub(str.name, 1,7) == "object_" then
					pancake.target[string.sub(str.name, 8)] = str.value
				end
			else
				pancake.debug.stringFocused = str.name
				str.value = str.value or ""
				pancake.debug.linePosition = string.len(str.value or "")
				pancake.debug.stringTimer.duration = 0
				pancake.debug.stringTimer.state = true
				love.keyboard.setTextInput(true, str.box.x, str.box.y, str.box.width, str.box.height)
			end
		end
	end
	return ret
end

function pancake.keypressed(key)
	local pressDone = false
	if pancake.loadAnimation and key == "space" then
		pancake.loadAnimation = nil
		pancake.paused = false
		pancake.onLoad()
	elseif pancake.debugMode and key == "rshift" then
		switchEditMode()
		pressDone = true
	elseif pancake.debugMode and key == 'p' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl"))then
		pancake.paused = not pancake.paused
		pressDone = true
	elseif pancake.debugMode and key == 'f' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pancake.cameraFollow = pancake.target
		pressDone = true
	elseif pancake.debugMode and key == 'c' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pancake.debug.clipboard = pancake.target
		pressDone = true
	elseif pancake.debugMode and key == 'x' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pancake.debug.clipboard = pancake.target
		pressDone = true
		pancake.smartDelete(pancake.objects, pancake.target.ID, "ID")
	elseif pancake.debugMode and key == 'v' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pasteObject(love.mouse.getX(), love.mouse.getY())
		pressDone = true
	elseif pancake.debugMode and key == 's' and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pancake.saveState(pancake.debug.strings[1].value or "no_name_save")
		pressDone = true
	elseif pancake.debugMode and (key == "1" or key == "2" or key == "3" or key == "4" or key == "5" or key == "6" or key == "7" or key == "8" or key == "9") and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pancake.debug.displayLayer = tonumber(key)
		pressDone = true
	elseif pancake.debugMode and key == "0" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		pancake.debug.displayLayer = nil
		pressDone = true
	end
	if pancake.debug.editMode then
		local focString = pancake.find(pancake.debug.strings, pancake.debug.stringFocused, "name")
		if focString then
			if not focString.value then
				focString.value = ""
			end
			local text = pancake.find(pancake.debug.strings, pancake.debug.stringFocused, "name").value
			if key == "backspace" then
				pancake.find(pancake.debug.strings, pancake.debug.stringFocused, "name").value = string.sub(text, 0, pancake.debug.linePosition-1) .. string.sub(text, pancake.debug.linePosition+1)
				pancake.debug.linePosition = pancake.debug.linePosition - 1
				pressDone = true
			elseif key == "left" then
				pancake.debug.linePosition = pancake.debug.linePosition - 1
				pressDone = true
			elseif key == "right" then
				pancake.debug.linePosition = pancake.debug.linePosition + 1
				pressDone = true
			elseif key == "space" then
				pancake.find(pancake.debug.strings, pancake.debug.stringFocused, "name").value = string.sub(text, 0, pancake.debug.linePosition) .. " " .. string.sub(text, pancake.debug.linePosition+1)
				pancake.debug.linePosition = pancake.debug.linePosition + 1
				pressDone = true
			elseif key == "return" then
				enterDebugString()
			elseif letters[key] then
				pressDone = true
				local ch = pancake.boolConversion(love.keyboard.isDown("rshift") or love.keyboard.isDown("rshift"), string.upper(key), key)
				if ch == "-" and love.keyboard.isDown("rshift") or love.keyboard.isDown("rshift") then
					ch = "_"
				end
				if focString and (focString.value == nil or not focString.type or type(focString.value) == "string" or (focString.type == "number" and (tonumber(ch) or (ch == "-" and debug.linePosition == 0) or (ch == "." and focString.value == pancake.round(focString.value))))) then
					if focString.value == nil then
						focString.value = ch
					else
						focString.value = string.sub(text, 0, pancake.debug.linePosition) .. ch .. string.sub(text, pancake.debug.linePosition+1)
					end
					pancake.debug.linePosition = pancake.debug.linePosition + 1
					if focString.type == "number" and ch ~= "." and ch ~= "-" then
						focString.value = tonumber(focString.value)
					end
				end
				--correct input pos
				if pancake.debug.linePosition > string.len(focString.value) then
					pancake.debug.linePosition = string.len(focString.value)
				elseif pancake.debug.linePosition < 0 then
					pancake.debug.linePosition = 0
				end
			end
		end
	end
	if not pancake.debug.stringFocused then
		local buttons = pancake.buttons
		if buttons[1] then
			for i = 1, #buttons do
				local button = buttons[i]
				if button.key == key and button.func and not pressDone then
					pressDone = true
					button.func()
				end
			end
		end
	end
end

function enterDebugString()
	local debug = pancake.debug
	local fString = pancake.find(debug.strings, debug.stringFocused, "name")
	local target = pancake.target
	if fString then
		if string.sub(fString.name, 1,7) == "object_" then
			if fString.value == "" then
				target[string.sub(fString.name,8)] = nil
			else
				local value = pancake.boolConversion(tonumber(fString.value), tonumber(fString.value), fString.value)
				target[string.sub(fString.name,8)] = value
			end
		end
		debug.stringFocused = nil
		if pancake.os == "Android" then
			love.keyboard.setTextInput(false)
		end
		if pancake.target then
			addObjectStrings()
		end
	end
	pancake.stringFocused = nil
end

function pasteObject(x,y)
	local x = x or pancake.window.x + pancake.window.width/2*pancake.window.pixelSize
	local y = y or pancake.window.y + pancake.window.height/2*pancake.window.pixelSize
	if pancake.debug.clipboard and pancake.collisionCheck({x = pancake.window.x, y = pancake.window.y, width = pancake.window.width*pancake.window.pixelSize, height = pancake.window.height*pancake.window.pixelSize}, {x=x,y=y,width=1,height=1}) then
		local finalObject = pancake.copyTable(pancake.debug.clipboard)
		finalObject.x = (x - pancake.window.x)/pancake.window.pixelSize	+ pancake.window.offsetX
		finalObject.y = (y - pancake.window.y)/pancake.window.pixelSize + pancake.window.offsetY
		finalObject.ID = nil
		pancake.addObject(finalObject)
	end
end

function switchTarget(x,y, lock)
	local window = pancake.window
	if pancake.debugMode and pancake.collisionCheck({x = window.x, y = window.y, width = window.width*window.pixelSize, height = window.height*window.pixelSize},{x=x, y=y, height=1,width=1}) then
		local ret = nil
		for i, object in ipairs(pancake.objectsToRender) do
			local layer = object.layer or 1
			local hitboxes1 = {x = x, y = y, width = 1, height = 1}
			local hitboxes2 = {x = pancake.windowToDisplay(object.x, 0, true).x, y = pancake.windowToDisplay(0, object.y, true).y, width = object.width*pancake.window.pixelSize, height = object.height*pancake.window.pixelSize}
			if pancake.collisionCheck(hitboxes1, hitboxes2) and (not pancake.debug.displayLayer or pancake.debug.displayLayer == layer) then
				ret = object
			end
		end
		if lock then
			pancake.targetLock = pancake.boolConversion(ret, true, false)
			pancake.target = ret
			if ret then
				addObjectStrings()
			end
		end
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
	local save = pancake.getState()
	local string = smallfolk.dumps(save)
	pancake.save(string, filename)
end

function pancake.loadState(filename)
	local state = smallfolk.loads(pancake.load(filename))
	pancake.setState(state)
	pancake.lastSave = filename
	pancake.debug.strings[1].value = filename
end

function pancake.getState()
	local state = {}
	state.objects = pancake.objects
	state.timers = pancake.timers
	state.visuals = pancake.visuals
	state.lights = pancake.lights
	return state
end

function pancake.setState(state)
	pancake.objects = state.objects
	pancake.timers = state.timers
	pancake.visuals = state.visuals
	pancake.lights = state.lights
end

function pancake.clearState()
	pancake.objects = {}
	pancake.visuals = {}
	pancake.timers = {}
	pancake.lights = {}
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

function pancake.getStringWidth(text)
	local ret = 0
	local length = string.len(text)
	for i = 1, length do
		local char = string.sub(text, i, i)
		if char == " " then
			ret = ret + 2
		else
			if letters[char] then
				ret = ret + letters[char].width + 1
			else
				ret = ret + 4
			end
		end
	end
	return ret
end

function printLetter(char, x, y, scale)
	local x = x or 0
	local y = y or 0
	local char = char or "a"
	local scale = scale or 1
	if pancake.savedPseudoFonts and pancake.savedPseudoFonts[pancake.currentPseudoFont] and pancake.savedPseudoFonts[pancake.currentPseudoFont][char] then
		love.graphics.draw(pancake.savedPseudoFonts[pancake.currentPseudoFont][char], x, y, 0, scale)
	else
		 if letters[char] then
			 local letter = letters[char]
			 for i = 1, #letter do
				local pixel
				if type(letter[i]) == "number" then
					pixel = {x = pix(letter[i]).x, y = pix(letter[i]).y}
				else
					pixel = {x = letter[i].x, y = letter[i].y}
				end
				love.graphics.rectangle("fill", x + (pixel.x - 1)*scale, y + (pixel.y - 1)*scale, scale, scale)
			end
		else
			love.graphics.print("Your font doesn't have: " .. char)
		end
	 end
 end
function defineLetters()
	local fonts = {}
	local liliputh = {}
	liliputh.a = {pix(13), pix(22), pix(24), pix(32), pix(33), pix(34), width = 3}
	liliputh.b = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(24), pix(33), width = 3}
	liliputh.c = {pix(13), pix(22), pix(24), pix(32), pix(34), width = 3}
	liliputh.d = {pix(13), pix(22), pix(24),pix(31), pix(32), pix(33), pix(34), width = 3}
	liliputh.e = {pix(12), pix(13), pix(14), pix(21), pix(23), pix(25), pix(32), pix(33), width = 3}
	liliputh.f = {pix(13), pix(21), pix(22), pix(23), pix(24), pix(31),pix(33),pix(25), width = 3}
	liliputh.g = {pix(12), pix(13), pix(14), pix(22), pix(24), pix(32), pix(33), pix(34), pix(35), pix(26), pix(36), width = 3}
	liliputh.h = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(33), pix(34),width = 3}
	liliputh.i = {pix(11), pix(13), pix(14), width = 1}
	liliputh.j = {pix(21), pix(23), pix(24), pix(14), width = 2}
	liliputh.k = {pix(11), pix(12), pix(13), pix(14), pix(23), pix(32), pix(34), width = 3}
	liliputh.l = {pix(11), pix(12), pix(13), pix(14), pix(24), width = 2}
	liliputh.m = {pix(13), pix(14), pix(22), pix(33), pix(42), pix(53), pix(54), width = 5}
	liliputh.n = {pix(12), pix(13), pix(14), pix(22), pix(33), pix(34), width = 3}
	liliputh.o = {pix(12), pix(13), pix(14), pix(22), pix(24), pix(32), pix(33), pix(34), width = 3}
	liliputh.p = {pix(12), pix(13), pix(14), pix(15), pix(22), pix(24), pix(33), width = 3}
	liliputh.r = {pix(12), pix(13), pix(14), pix(23), pix(32), width = 3}
	liliputh.s = {pix(12), pix(14), pix(21), pix(23), pix(24), width = 2}
	liliputh.t = {pix(12), pix(21), pix(22), pix(23), pix(24), pix(32), width = 3}
	liliputh.u = {pix(12), pix(13),pix(14), pix(24), pix(32), pix(33), pix(34), width = 3}
	liliputh.v = {pix(12), pix(13), pix(24), pix(32), pix(33), width = 3}
	liliputh.w = {pix(12), pix(13), pix(24), pix(32), pix(33), pix(44), pix(52),pix(53), width = 5}
	liliputh.x = {pix(12), pix(14), pix(23), pix(32), pix(34), width = 3}
	liliputh.y = {pix(12), pix(13), pix(23), pix(24), pix(32), pix(33),pix(25), width = 3}
	liliputh.z = {pix(11), pix(14), pix(21), pix(23), pix(24), pix(31), pix(34), pix(32), width = 3}
	liliputh.A = {pix(12), pix(13), pix(14), pix(21), pix(23), pix(31), pix(33), pix(42), pix(43), pix(44), width = 4}
	liliputh.B = {pix(12), pix(13), pix(14), pix(11), pix(21), pix(23), pix(24), pix(31), pix(32), pix(34), pix(43), pix(44), width = 4}
	liliputh.C = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(34), width = 3}
	liliputh.D = {{x = 1, y = 2}, {x = 1, y = 3}, {x = 1, y = 4}, {x = 2, y = 1}, pix(24), pix(31), pix(34), pix(42), pix(43), pix(11), width = 4}
	liliputh.E = {pix(12), pix(13), pix(14), pix(11), pix(21), pix(22), pix(24), pix(31), pix(34),width = 3}
	liliputh.F = {pix(12), pix(13), pix(14), pix(11), pix(21), pix(23), pix(31), width = 3}
	liliputh.G = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(34), pix(41), pix(43), pix(44), width = 4}
	liliputh.H = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(32), pix(41), pix(42), pix(43), pix(44), width = 4}
	liliputh.I = {pix(11), pix(14), pix(21), pix(22), pix(23), pix(24), pix(31), pix(34),  width = 3}
	liliputh.J = {pix(11), pix(13), pix(21), pix(24), pix(31), pix(34), pix(41), pix(42), pix(43), width = 4}
	liliputh.K = {pix(11), pix(12), pix(13), pix(14), pix(23), pix(32), pix(33), pix(41), pix(44), width = 4}
	liliputh.L = {pix(11), pix(12), pix(13), pix(14), pix(24), pix(34), width = 3}
	liliputh.M = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(33),pix(42), pix(51), pix(52), pix(53), pix(54), width = 5}
	liliputh.N = {pix(11), pix(12), pix(13), pix(14), pix(22), pix(33), pix(42), pix(43), pix(44), pix(41), width = 4}
	liliputh.O = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(34), pix(42), pix(43), width = 4}
	liliputh.P = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(31), pix(33), pix(42), width = 4}
	liliputh.R = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(31), pix(33), pix(42), pix(44),  width = 4}
	liliputh.S = { pix(12), pix(14), pix(21), pix(22), pix(24), pix(31), pix(33), pix(34), pix(41), pix(43), pix(44), width = 4}
	liliputh.T = {pix(11), pix(21), pix(22), pix(23), pix(24), pix(31),width = 3}
	liliputh.U = {pix(11), pix(12), pix(13), pix(24), pix(34), pix(41), pix(42), pix(43), width = 4}
	liliputh.V = {pix(11), pix(12), pix(13), pix(23), pix(24), pix(31), pix(32), pix(33), width = 3}
	liliputh.W = {pix(11), pix(12), pix(13), pix(24), pix(33), pix(44), pix(51), pix(52), pix(53), width = 5}
	liliputh.X = {pix(11), pix(14), pix(22), pix(23), pix(32), pix(33), pix(41), pix(44), width = 4}
	liliputh.Y = {pix(11), pix(12), pix(23), pix(24), pix(31), pix(32), width = 3}
	liliputh.Z = {pix(11), pix(14), pix(21), pix(23), pix(24), pix(31), pix(32), pix(34), pix(41), pix(44), width = 4}
	liliputh["!"]= {pix(11), pix(12), pix(14), width = 1}
	liliputh.q = {pix(13), pix(14), pix(22), pix(24), pix(32), pix(33), pix(34), pix(35), width = 3}
	liliputh.Q = {pix(12), pix(13), pix(21), pix(24), pix(31), pix(33), pix(34), pix(42), pix(43), pix(44), width = 4}
	liliputh["."] = {pix(14), width = 1}
	liliputh[":"] = {pix(12), pix(14), width = 1}
	liliputh[","] = {pix(14), pix(15), width = 1}
	liliputh["'"] = {pix(11), pix(12), width = 1}
	liliputh["1"] = {pix(12), pix(21), pix (22), pix(23), pix(24), width = 2}
	liliputh["2"] = {pix(12), pix(14), pix(21), pix(24), pix(31), pix(33), pix(34), pix(42), pix(44), width = 4}
	liliputh["3"] = {pix(11), pix(14), pix(21), pix(22), pix(24), pix(31), pix(32), pix(34), pix(33), width = 3}
	liliputh["4"] = {pix(12), pix(13), pix(11), pix(23), pix(31), pix(32), pix(33), pix(34), pix(43), width = 4}
	liliputh["5"] = {pix(11), pix(12), pix(14), pix(21), pix(23), pix(24), pix(31), pix(33), pix(34), width = 3}
	liliputh["6"] = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(23), pix(24), pix(31), pix(33), pix(34), width = 3}
	liliputh["7"] = {pix(11), pix(21), pix(31), pix(32), pix(33), pix(34), width = 3}
	liliputh["8"] = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(22), pix(24), pix(31), pix(32), pix(33), pix(34), width = 3}
	liliputh["9"] = {pix(11), pix(12), pix(14), pix(21), pix(22), pix(24), pix(31), pix(32), pix(33), pix(34), width = 3}
	liliputh["0"] = {pix(11), pix(12), pix(13), pix(14), pix(21), pix(24), pix(31), pix(32), pix(33), pix(34), width = 3}
	liliputh["?"] = {pix(11), pix(21), pix(23), pix(25), pix(21), pix(31), pix(32), width = 3}
	liliputh["-"] = {pix(13), pix(23), pix(33), width = 3}
	liliputh["/"] = {pix(13), pix(14), pix(21),pix(22), width = 2}
	liliputh["_"] = {pix(14), pix(24), pix(34), width = 3}
	liliputh["|"] = {pix(11), pix(12), pix(13),pix(14), width = 1}
	liliputh["+"] = {pix(13), pix(22), pix(23),pix(24), pix(33), width = 3}
	fonts.liliputh = liliputh

	local david = {}
	david.a = {pix(15), pix(16), pix(17), pix(24), pix(28), pix(34), pix(38), pix(44), pix(48), pix(54), pix(55), pix(56), pix(57), pix(68), width = 6}
	david.b = {11,12,13,14,15,16,17,18,28,38,48,57,56,55,44,34,24, width = 5}
	david.c = {pix(15), pix(16), pix(17), pix(24), pix(28), pix(34), pix(38), pix(44), pix(48), pix(55), pix(57), width = 5}
	david.d = {15,16,17,24,28,34,38,44,48,51,52,53,54,55,56,57,68, width = 6}
	david.e = {15,16,17,28,38,48,26,24,36,34,44,46,55,56, width = 5}
	david.f = {15,22,23,24,25,26,27,28, 31, 41, 35, 45, width = 4}
	david.g = {15,16,17,24,34,44,54,28,38,48,58,57,56,46, width = 5}
	david.h = {11,12,13,14,15,16,17,18,24,34,44,55,56,57,58,width = 5}
	david.i = {15,13,16,17,18, width = 1}
	david.j = {32,34, 35, 36, 37, 28, 17, width = 3}
	david.k = {11,12,13,14,15,16,17,18,26, 37,48, 35, 44, width = 4}
	david.l = {11,18,21,22,23,24,25,26,27,28,38, width = 3}
	david.m = {14,15,16,17,18,25,34,45,46,47,48,54,65,66,67,68, width = 6}
	david.n = {14,15,16,17,18,25,34,44,55,56,57,58, width = 5}
	david.o = {15,16,17,24,28,34,38,45,46,47, width = 4}
	david.p = {13,14,15,16,17,18,23,26,33,36,44,45, width = 4}
	david.q = {14,15,23,26,33,36,43,44,45,46,47,48, width = 4}
	david.r = {15,24,35,36,37,38,44,54, width = 5}
	david.s = {15,18,24,26,28,34,36,38,44,46,48,54,57, width = 5}
	david.t = {14,21,22,23,24,25,26,27,38,47,34, width = 4}
	david.u = {17,16,15,14,28,38,48,54,55,56,57,68, width = 6}
	david.v = {38,27,16,15,14,47,56,55,54, width = 5}
	david.w = {15,16,17,28,37,36,48,57,56,55,54,14, width = 5}
	david.x = {14,18,25,27,36,45,47,54,58, width = 5}
	david.y = {28,37,26,15,14,46,55,54, width = 5}
	david.z = {18,28,38,48,58,14,24,34,44,54,27,36,45, width = 5}
	david.A = {pix(13), pix(14), pix(15), pix(16), pix(17), pix(18), pix(22), pix(23), pix(26), pix(31),pix(32), pix(36), pix(41), pix(46), pix(51), pix(52), pix(56), pix(62), pix(63), pix(66), pix(73), pix(74), pix(75), pix(76), pix(77), pix(78), width = 7}
	david.B = {pix(11), pix(12), pix(13), pix(14), pix(15), pix(16), pix(17), pix(18), pix(21), pix(31), pix(41), pix(52), pix(53), pix(24), pix(34), pix(44), pix(54), pix(65), pix(66), pix(67), pix(28), pix(38), pix(48), pix(58), width = 6}
	david.C = {pix(13), pix(14), pix(15), pix(16), pix(22), pix(27), pix(31), pix(38), pix(41), pix(48), pix(51), pix(58), pix(62), pix(67), width = 6}
	david.D = {pix(11),{x = 1, y = 2}, {x = 1, y = 3}, {x = 1, y = 4}, {x = 1, y = 5}, pix(16), pix(17), pix(18), pix(21), pix(28), pix(31),pix(38), pix(41), pix(48), pix(52), pix(57), 63, 64, 65, 66, width = 6}
	david.E = {11, 12, 13, 14, 15, 16, 17, 18, 21, 31, 41, 51, 61, 24, 34, 44, 28, 38, 48, 58, 68, width = 6}
	david.F = {11, 12, 13, 14, 15, 16, 17, 18, 21, 31, 41, 51, 61, 24, 34, 44, width = 6}
	david.G = {13, 14, 15, 16, 22, 27, 31, 38, 41, 48, 51, 58, 62, 67, 45, 55, 65, 66, width = 6}
	david.H = {11,12,13,14,15,16,17,18, 24,34,44,54,61,62,63,64,65,66,67,68, width = 6}
	david.I = {11,18, 21, 28, 31,32,33,34,35,36,37,38, 41,48,51,58, width = 5}
	david.J = {11,21,31,41,51,52,53,54,55,56,57,48,38,28,17,16, width = 5}
	david.K = {11,12,13,14,15,16,17,18, 25,35,34,43,52,61,46, 57,68, width = 6}
	david.L = {11,12,13,14,15,16,17,18,28,38,48,58,68, width = 6}
	david.M = {11,12,13,14,15,16,17,18,22,33,44,53,62,71,72,73,74,75,76,77,78, width = 7}
	david.N = {11,12,13,14,15,16,17,18,22,33,44,55,61,62,63,64,65,66,67,68,width = 6}
	david.O = {13,14,15,16,22,27,31,38,41,48,51,58, 62,67,73,74,75,76, width = 7}
	david.P = {11,12,13,14,15,16,17,18,21,24,31,34,41,44,52,53, width = 5}
	david.Q = {13,14,15,16,22,27,31,38,41,48,51,58, 62,67,73,74,75,76,78,56, width = 7}
	david.R = {11,12,13,14,15,16,17,18,21,24,31,34,41,44,52,53, 55,56,57,58, width = 5}
	david.S = {12,13,17,21,24,28,31,34,38,41,44,48,51,54,58,62,65,66,67, width = 6}
	david.T = {11,21,31,41,51,61,71,42,43,44,45,46,47,48,width = 7}
	david.U = {13,14,15,16,12,27,11,38,48,58,71,72,67,73,74,75,76, width = 7}
	david.V = {11,12,13,14,25,26,37,48,57,66,65,71,72,73,74, width = 7}
	david.W = {11,12,13,24,25,26,37,38,46,45,57,58,66,65,64,73,72,71, width = 7}
	david.X = {11,18,21,22,27,28,33,36,44,45,54,55,66,63,72,77,71,78,81,88, width = 8}
	david.Y = {11,12,13,24,35,36,37,38,44,53,52,51, width = 5}
	david.Z = {11,21,31,41,51,61,71,72,63,54,45,36,27,18,28,38,48,58,68,78, width = 7}
	david["!"]= {11,12,14,15,16,18,22,23,24,25, width = 2}
	david["."] = {18, width = 1}
	david[":"] = {14,16, width = 1}
	david[","] = {17,18, width = 1}
	david["1"] = {13,18,22,23,28,31,32,33,34,35,36,37,38,48,58,width = 5}
	david["2"] = {12,13,17,18,21,26,28,31,35,38,41,44,48,52,53,58, width = 5}
	david["3"] = {12,17,21,28,31,34,38,41,44,48,52,53,55,56,57, width = 5}
	david["4"] = {15,16,24,23,32,31,26,36,46,45,47,48,56, width = 5}
	david["5"] = {11,21,31,41,51,12,13,14,24,34,44,55,56,57,48,38,28,17, width = 5}
	david["6"] = {12,13,14,15,16,17,28,38,48,57,56,55,44,34,24,21,31,41, width = 5}
	david["7"] = {11,21,31,41,51,52,43,44,35,36,27,28, width = 5}
	david["8"] = {12,13,15,16,17,21,24,28,31,34,38,41,44,48,52,53,55,56,57, width = 5}
	david["9"] = {12,13,14,21,25,28,31,35,38,41,45,48,52,53,54,55,56,57, width = 5}
	david["0"] = {12,13,14,15,16,17,21,28,31,38,41,48,52,53,54,55,56,57, width = 5}
	david["?"] = {12,13,21,31,41,52,53,44,35,36,38, width = 5}
	david["-"] = {15,25,35, width = 3}
	david["/"] = {41,42,33,34,25,26,17,18, width = 4}
	david["_"] = {18,28,38,48, width = 4}
	david["|"] = {12,13,14,15,16,17,18, width = 1}
	fonts.david = david

	local garry = {}
	garry.A = {12,13,14,15, 21,23, 31,33, 41,43, 52,53,54,55, width = 5}
	garry.B = {11,12,13,14,15, 21,23,25, 32,33,35, 44 , width = 4}
	garry.C = {12,13,14, 21,25, 31,35, 41, 45, width = 4}
	garry.D = {11,12,13,14,15, 21,25, 31,35, 42,43,44, width = 4}
	garry.E = {11,12,13,14,15, 21,23,25, 31,33,35, 41,45, width = 4}
	garry.F = {11,12,13,14,15, 21,23, 31,33, width = 4}
	garry.G = {12,13,14, 21,25, 31,33,35, 41,43,44,45, width = 4}
	garry.H = {11,12,13,14,15, 23, 33, 41,42,43,44,45, width = 4}
	garry.I = {11,12,13,14,15, width = 1}
	garry.J = {11,14, 21,25,31,35,41,42,43,44, width = 4}
	garry.K = {11,12,13,14,15, 23, 32, 34, 41, 45, width = 4}
	garry.L = {11,12,13,14,15, 25, 35, 45, width = 4}
	garry.M = {11,12,13,14,15, 22, 33, 42, 51,52,53,54,55, width = 5}
	garry.N = {11,12,13,14,15, 22, 33, 41,42,43,44,45, width = 4}
	garry.O = {11,12,13,14,15, 21, 25, 31,35, 41,42,43,44,45, width = 4}
	garry.P = {11,12,13,14,15, 21,23, 31,33, 42,43, width = 4}
	garry.Q = {11,12,13,14,15, 21,25, 31,33,35, 41,44, 51,52,53,55, width = 5}
	garry.R = {11,12,13,14,15, 21,23, 31,33,34, 42,43,45, width = 4}
	garry.S = {12,15, 21,23,25, 31,33,35, 41,43,45, 54, width = 5}
	garry.T = {11,21, 31,32,33,34,35, 41, 51, width = 5}
	garry.U = {11,12,13,14, 25, 35, 41,42,43,44, width = 4}
	garry.V = {11,12,13, 24, 35, 44, 51,52,53, width = 5}
	garry.W = {11,12,13,14, 25, 33,34, 45, 51,52,53,54, width = 5}
	garry.X = {11,12,14,15, 23,33, 41,42,44,45, width = 4}
	garry.Y = {11,12, 23, 34,35, 43, 51,52, width = 5}
	garry.Z = {11,15, 21,24,25, 31,33,35, 41,42,45, 51,55, width = 5}
	garry.a = {13,14, 22,25,32,35, 42,43,44, 55, width = 5}
	garry.b = {11,12,13,14,15, 22,25, 32,35, 43,44, width = 4}
	garry.c = {13,14, 22,25, 32,35, 42,45, width = 4}
	garry.d = {13,14, 22,25, 32,35, 41,42,43,44,55, width = 4}
	garry.e = {13,14,15, 22,24,26, 32,34,36, 43,44, width = 4}
	garry.f = {13, 22,23,24,25, 31, 33, width = 3}
	garry.g = {13,14,16, 22,24,26, 32,34,36, 42,43,44,45, width = 4}
	garry.h = {11,12,13,14,15, 23, 33, 44,45, width = 4}
	garry.i = {11, 13,14,15, width = 1}
	garry.j = {16, 21,23,24,25, width = 2}
	garry.k = {11,12,13,14,15, 23, 33, 42,44,45, width = 4}
	garry.l = {11,12,13,14,15, 25, width = 2}
	garry.m = {12,13,14,15, 22, 33,34, 42, 53,54,55, width = 5}
	garry.n = {12,13,14,15, 22, 32, 43,44,45, width = 4}
	garry.o = {13,14, 22,25, 32,35, 43,44, width = 4}
	garry.p = {12,13,14,15,16, 22,24, 32,34, 43,44, width = 4}
	garry.q = {12,13,14, 22,24, 32,34, 42,43,44,45,46, 55 ,width = 5}
	garry.r = {12, 23,24,25, 32, 42, width = 4}
	garry.s = {13,15, 22,23,25, 32,34,35, 42,44, width = 4}
	garry.t = {12, 21,22,23,24, 32,35, 42,44,45, width = 4}
	garry.u = {12,13,14, 25, 35, 42,43,44,45, width = 4}
	garry.v = {12,13,14, 25, 32,33,34, width = 3}
	garry.w = {12,13,14, 25, 32,33,34, 45, 52,53,54, width = 5}
	garry.x = {12,14,15, 23, 33, 42,44,45, width = 4}
	garry.y = {12,13, 24,26, 34,36, 42,43,44,45, width = 4}
	garry.z = {12,15, 22,24,25, 32,33,35, 42,45, width = 4}

	garry['.'] = {15, width = 1}
	garry[','] = {14,16,24,25, width = 2}
	garry['!'] = {11,12,13,14, 16, width = 1}
	garry['?'] = {11,12, 21, 24,26, 31,32,33, width = 3}
	garry['"'] = {11,13,21,22, 41,43,51,52, width = 5}
	garry["'"] = {11,13,21,22, width = 2}
	garry[':'] = {13,15, width = 1}
	garry['/'] = {15,16, 23,24, 31,32, width = 3}
	garry['_'] = {15,25,35,45, width = 4}

	garry['1'] = {12,15, 21,22,23,24,25, 35 , width = 3}
	garry['2'] = {12,15, 21,24,25, 31,33,35, 42,45, width = 4}
	garry['3'] = {12,14, 21,25, 31,33,35, 42,44, width = 4}
	garry['4'] = {11,12,13,14, 24, 33,34,35, 44, width = 4}
	garry['5'] = {11,12,13,15, 21,23,25, 31,33,35, 41,44, width = 4}
	garry['6'] = {12,13,14, 21,23,25, 31,33,35, 44, width = 4}
	garry['7'] = {11, 21,24,25, 31,33, 41,42, width = 4}
	garry['8'] = {11,12,14,15, 21,23,25, 31,33,35, 41,42,44,45, width = 4}
	garry['9'] = {11,12,13, 21,23,25, 31,33,35, 41,42,43,44, width = 4}
	garry['0'] = {12,13,14, 21,23,25, 31,32,35, 42,43,44, width = 4}

	fonts.garry = garry


	pancake.fonts = fonts
	pancake.changeFont("garry")
	pancake.savePseudoFont("garry")
end

function pancake.savePseudoFont(name)
	love.graphics.push()
	love.graphics.reset()
	love.graphics.setDefaultFilter( "nearest", "nearest", 1)
	local maxHeight = 64
	if pancake.fonts[name] then
		local currentFont = pancake.currentPseudoFont
		pancake.changeFont(name)
		if not pancake.savedPseudoFonts then
			pancake.savedPseudoFonts = {}
		end
		pancake.savedPseudoFonts[name] = {}
		for sign, pixels in pairs(letters) do
			local canvas = love.graphics.newCanvas(pixels.width, maxHeight)
			love.graphics.setCanvas(canvas)
			printLetter(sign)
			pancake.savedPseudoFonts[name][sign] = canvas
		end
		love.graphics.setCanvas()
		pancake.changeFont(currentFont)
	end
	love.graphics.pop()
end

function pix(num)
	local x = math.floor(num/10)
	local y = num - x*10
	return {x = x, y = y}
end

function pancake.changeFont(name)
	local fonts = pancake.fonts
	if fonts[name] then
		pancake.currentPseudoFont = name
		letters = fonts[name]
	end
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

--Other
function endDebugStringFocus()
	local str = pancake.debug.strings[pancake.debug.stringFocused]
end

function deglitchPhysicObjects()
	local objects = pancake.objects
	for i = #objects, 1, -1 do
		local object = objects[i]
		if pancake.isObjectColliding(object) and object.physics then

		end
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

function pancake.smartDelete(t, value, searchParam)
	local value = value
	local searchParam = searchParam or "name"
	for i, v in ipairs(t) do
		if v[searchParam] == value then
			table.remove(t, i)
			break
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
			break
		end
	end
	return ret
end

function pancake.checkTable(table, key, value)
	local ret = {}
	for i, o in ipairs(table) do
		if o[key] == value then
			ret[#ret + 1] = o
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

function pancake.round(number, decPlace)
	local decPlace = decPlace or 0
	if decPlace == 0 then
		return math.floor(number) + pancake.boolConversion(number - math.floor(number) >= 0.5, 1, 0)
	else
		return (math.floor(number*math.pow(10, decPlace)) + pancake.boolConversion(number*math.pow(10, decPlace) - math.floor(number*math.pow(10, decPlace)) >= 0.5, 1, 0))/math.pow(10, decPlace)
	end
end

function calcOffset(value)
	return value - math.floor(value)
end

function pancake.sumTables(table1, table2)
	local ret = {}
	n = 0
	for _,v in ipairs(table1) do n=n+1; ret[n]=v end
	for _,v in ipairs(table2) do n=n+1; ret[n]=v end
	return ret
end

function pancake.addTable(table1, table2)
	if #table2 > 0 then
		for i = 1, #table2 do
			table1[#table1 + 1] = table2[i]
		end
	end
	return table1
end



function pancake.getDirectionName(axis, direction)
	local ret
	if axis == "x" then
		if direction > 0 then
			ret = "right"
		else
			ret = "left"
		end
	elseif axis == "y" then
		if direction > 0 then
			ret = "down"
		else
			ret = "up"
		end
	end
	if direction == 0 or axis == "xy" then
		ret = ""
	end
	return ret
end

function pancake.intoCaps(string)
	return string.upper(string.sub(string,1,1)) .. string.sub(string,2,-1)
end

function pancake.copyTable(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[pancake.copyTable(orig_key)] = pancake.copyTable(orig_value)
      end
      setmetatable(copy, pancake.copyTable(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return pancake
