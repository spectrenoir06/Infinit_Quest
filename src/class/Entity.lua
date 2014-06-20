local class = require 'lib.kikito.middleclass'

local Entity = class('Entity')

function Entity:initialize(x, y, lx, ly)
  self.x = x
  self.y = y
  self.lx = lx
  self.ly = ly
end

function Entity:update(dt)

end

function Entity:draw()

end

return Entity