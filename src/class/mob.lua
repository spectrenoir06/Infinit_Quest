local class = require 'lib.kikito.middleclass'

local MoveEntity = require "class.MoveEntity"
local Sprite = require "lib.spectre.Sprite"

local Mob = class('Mob',MoveEntity) 

Mob.static.SPEED = 256

function Mob:initialisaion(x,y, lx, ly, map, texture)

  MoveEntity.initialize(self, x, y, lx, ly, map)

  self.life = 100
  self.texture = texture or "/textures/64/mob.png"
  self.sprite = Sprite:new(self.texture,lx,ly)
  self.speed = Mob.SPEED
	
  self.sprite:addAnimation({9,10,11})
  self.sprite:addAnimation({0,1,2})
  self.sprite:addAnimation({3,4,5})
  self.sprite:addAnimation({6,7,8})

  self.direction = 2
  self.sprite:stop()

	--a.path = steve:getmap().pathfinder:getPath(math.floor(a.X/64), math.floor(a.Y/64), math.floor(steve:getX()/64), math.floor(steve:getY()/64))
	--a.nodes = {}
	--for node, count in a.path:nodes() do
--		a.nodes[count]=node
	--end
	--a.path
	 
end

function Mob:update(dt)
  
  MoveEntity.update(self)
	self.sprite:update(dt)
	
	if not self:collide() then
    self:setX( self:getX() + self.dx )
    self:setY( self:getY() + self.dy )
	end
	
	self.dy = 0
	self.dx = 0
	
end

function Mob:draw()
  MoveEntity.draw(self)
  self.sprite:draw(self.x1,self.y1) 
end

function Mob:GoUp()
	self:setdirection(1)
  self.dy = -1
  self.dx = 0
end

function Mob:GoDown()
	self:setdirection(2)
  self.dy = 1
  self.dx = 0
end

function Mob:GoLeft()
	self:setdirection(3)
  self.dy = 0
  self.dx = -1
end

function Mob:GoRight()
	self:setdirection(4)
  self.dy = 0
  self.dx = 1
end

function Mob:setdirection(d)
  self.direction=d
  self.sprite:setAnim(d)
end