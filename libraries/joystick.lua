local joystick = {}
--------------------------------------------------------------------------------
---------       A small library for virtual joysticks in LOVE2D        ---------
--------------------------------------------------------------------------------
--------------------------------------by MightyPancake (Filip Król)-------------
--------------------------------------------------------------------------------

joystick.joysticks = {}

function joystick.new(x,y,r,size,borderColor, mainColor)
  local x = x or 0
  local y = y or 0
  local r = r or 150
  local size = size or 50
  local borderColor = borderColor or {}
  borderColor.r = borderColor.r or 1
  borderColor.g = borderColor.g or 1
  borderColor.b = borderColor.b or 1
  borderColor.a = borderColor.a or 1
  local mainColor = mainColor or borderColor
  mainColor.r = mainColor.r or 1
  mainColor.g = mainColor.g or 1
  mainColor.b = mainColor.b or 1
  mainColor.a = mainColor.a or 1
  local button = {x=x+r,y=y+r}
  joystick.joysticks[#joystick.joysticks + 1] = {x=x,y=y,size=size,radius=r,mainColor = mainColor, borderColor = borderColor, button = button}
  return joystick.joysticks[#joystick.joysticks]
end

function joystick.getState(joy)
  local ret = {}
  ret.x = (joy.button.x - (joy.x + joy.radius))/joy.radius
  ret.y = (joy.button.y - (joy.y + joy.radius))/joy.radius
  return ret
end

function joystick.update(dt)
  for i, joy in ipairs(joystick.joysticks) do
    if joy.touchID then
      local x, y = love.touch.getPosition(joy.touchID)
      if x and y then
        local dist = calcDistance({x = joy.x + joy.radius, y = joy.y + joy.radius}, {x=x, y=y})
        if dist <= joy.radius then
          joy.button.x = x
          joy.button.y = y
        else
          local distX = x - (joy.x + joy.radius)
          local distY = y - (joy.y + joy.radius)
          joy.button.x = joy.x + joy.radius + distX/dist*joy.radius
          joy.button.y = joy.y + joy.radius + distY/dist*joy.radius
        end
      end
    end
  end
end

function joystick.touchreleased( id, x, y, dx, dy, pressure )
  for i, joy in ipairs(joystick.joysticks) do
    if id == joy.touchID then
      joy.touchID = nil
      joy.button = {x=joy.x + joy.radius, y = joy.y + joy.radius}
    end
  end
end

function joystick.draw()
  local r,g,b,a = love.graphics.getColor()
  for i, joy in ipairs(joystick.joysticks) do
    local bColor = joy.borderColor
    love.graphics.setColor(bColor.r, bColor.g, bColor.b, bColor.a)
    love.graphics.circle("line", joy.x + joy.radius, joy.y + joy.radius, joy.radius)
    local mColor = joy.mainColor
    love.graphics.setColor(mColor.r, mColor.g, mColor.b, mColor.a)
    love.graphics.circle("fill", joy.button.x, joy.button.y, joy.size)
  end
  love.graphics.setColor(r, g, b, a)
end

function joystick.touchpressed(id, x, y, dx, dy, pressure )
  for i, joy in ipairs(joystick.joysticks) do
    if not joy.touchID and calcDistance({x = joy.x + joy.radius, y = joy.y + joy.radius}, {x=x, y=y}) <= joy.radius then
      joy.touchID = id
    end
  end
end

function calcDistance(p1, p2)
  return math.sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y))
end

return joystick
