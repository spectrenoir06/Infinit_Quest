local class = require 'lib.kikito.middleclass'

local Entity = class('Entity')

function Entity:initialize(x, y, lx, ly, map)

  self.x = x
  self.y = y
  
  self.x1 = x - (lx/2)
  self.y1 = x - (ly/2)
  
  self.x2 = x + (lx/2)
  self.y2 = x + (ly/2)
  
  self.lx = lx
  self.ly = ly
  
  self.map = map
  
end

function Entity:update(dt)

end

function Entity:draw()

end

function Entity:setX(x) 
  self.x  = x
  self.x1 = x - (self.lx/2)
  self.x2 = x + (self.lx/2)
end

function Entity:setX1(x1) 
  self.x  = x1 + (self.lx/2)
  self.x1 = x1
  self.x2 = x1 + self.lx
end

function Entity:setX2(x2) 
  self.x  = x2 - (self.lx/2)
  self.x1 = x2 - self.lx
  self.x2 = x2 
end

function Entity:setY(y) 
  self.y  = y
  self.y1 = y - (self.ly/2)
  self.y2 = y + (self.ly/2)
end

function Entity:setY1(y1) 
  self.y  = y1 + (self.ly/2)
  self.y1 = y1
  self.y2 = y1 + self.ly
end

function Entity:setY2(y2) 
  self.y  = y2 - (self.ly/2)
  self.y1 = y2 - self.ly
  self.y2 = y2 
end

function Entity:getX() 
  return self.x, self.x1, self.x2
end

function Entity:getY() 
  return self.y, self.y1, self.y2
end

return Entity