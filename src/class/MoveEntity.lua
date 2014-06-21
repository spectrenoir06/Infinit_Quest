local class  = require 'lib.kikito.middleclass'
local Entity = require "class.Entity"
local Sprite = require "lib.spectre.Sprite"

local MoveEntity = class('MoveEntity',Entity)

function MoveEntity:initialize(x, y, lx, ly, map)

  Entity.initialize(self, x, y, lx, ly, map)
  
  self.dx = 0         -- [-1 a 1] 
  self.dy = 0         -- [-1 a 1]
  
  self.maxSpeed = 200 -- [ pixel/second when dx or dy = 1 or -1 ]
    
end

function MoveEntity:update(dt)

  if (self.dx~=0) or (self.dy~=0) then
    if self:collide(dt) then

    else
      self.setX( self.getX + (self.dx * self.maxSpeed * (dt) ))
      self.setY( self.getY + (self.dy * self.maxSpeed * (dt) ))
    end
  end

end

function MoveEntity:draw()

end

function MoveEntity:collide(dt)

  local x1 = self.x1 + ((self.dx * self.speed) * dt)
  local x2 = self.x2 + ((self.dx * self.speed) * dt)
  
  local y1 = self.y1 + ((self.dy * self.speed) * dt)
  local y2 = self.y2 + ((self.dy * self.speed) * dt)
  
  local tileX1 = math.floor(x1/self.map:getResolution())
  local tileX2 = math.floor(x2/self.map:getResolution())
  
  local tileY1 = math.floor(y1/self.map:getResolution())
  local tileY2 = math.floor(y2/self.map:getResolution())
  
  return  self.map:scanCol(tileX1,tileY1)
      or  self.map:scanCol(tileX1,tileY2)
      or  self.map:scanCol(tileX2,tileY1)
      or  self.map:scanCol(tileX2,tileY2)
end


return MoveEntity