mob = {}
mob.__index = mob

function new_mob()

    local a={}
	
	a.X = 10*64
	a.Y = 10*64
	
	a.LX = 64
    a.LY = 64
	
	a.X1 = a.X - a.LX/2
	a.Y1 = a.Y - a.LY/2
	a.X2 = a.X + a.LX/2
	a.Y2 = a.Y + a.LY/2
	
    a.texture = "/textures/64/mob.png"
    a.sprite = sprite_new("/textures/64/mob.png",a.LX,a.LY)
    a.vie = 100
	a.speed = 3 * resolution
	
	a.sprite:addAnimation({9,10,11})
    a.sprite:addAnimation({0,1,2})
    a.sprite:addAnimation({3,4,5})
    a.sprite:addAnimation({6,7,8})

    a.direction = 2
	a.sprite:stop()
	a.sprite:setAnim(2,2)
	
    a.dx = 0
    a.dy =0
	
	--a.path

    return setmetatable(a, mob)
    
end

function mob:update(dt)
	self.sprite:update(dt)
	--print(dist(steve.posX,steve.posY,monster.X,monster.Y)/64)
	if dist(steve.posX,steve.posY,self.X,self.Y)/64 < 10 then
		--print("ennemi en vu")
		if dist(steve.posX,steve.posY,self.X,self.Y)/64 <=1 then
			
		else
			path = steve:getmap().pathfinder:getPath(math.ceil(self.X/64), math.ceil(self.Y/64), math.floor(steve:getX()/64), math.floor(steve:getY()/64))
			for node, count in path:nodes() do
				print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
				if count == 2 then
					self:Goto(node:getX(),node:getY())
				end
			end
		end
	end
	
	local grid = resolution/2
	
	if self.dx~=0 or self.dy ~=0 then -- si mouvement
		self.sprite:play()
			self:setX1( self.X1 +(dt*self.dx*self.speed) ) -- mouvement sur X
			self:setY1( self.Y1 +(dt*self.dy*self.speed) ) -- mouvement sur Y
			--self.sprite:play()
		
	else
		self.sprite:stop()
    end
	
	self:updatePos()
	self.dy = 0
	self.dx = 0
	
end

function mob:draw()
    self.sprite:draw(math.floor(self.X1),math.floor(self.Y1)) 
end

function mob:updatePos()
	self.X2 = self.X1 + self.LY
	self.X = self.X1 + (self.LX/2)
	self.Y2 = self.Y1 + self.LY
	self.Y = self.Y1 + (self.LY/2)
end

function mob:getPos()
	return self.X,self.Y,self.X1,self.Y1,self.X2,self.Y2
end

function dist(xa,ya,xb,yb)
	return math.sqrt(math.pow(xb-xa,2)+math.pow(yb-ya,2))
end


function mob:GoUp()
	self:setdirection(1)
    self.dy = -1
    self.dx = 0
end

function mob:GoDown()
	self:setdirection(2)
    self.dy = 1
    self.dx = 0
end

function mob:GoLeft()
	self:setdirection(3)
    self.dy = 0
    self.dx = -1
end

function mob:GoRight()
	self:setdirection(4)
    self.dy = 0
    self.dx = 1
end

function mob:setdirection(d)
    self.direction=d
    self.sprite:setAnim(d)
end

function mob:Goto(x,y)
	if self.X < x*64 then
		self:GoRight()
	elseif self.X > x*64 then
		self:GoLeft()
	elseif self.Y < y*64 then
		self:GoDown()
	elseif self.Y > y*64 then
		self:GoUp()
	end
end

function mob:setPosX(x)
	self.posX = x
	self.X1 = self.posX -self.LX/2
	self:updatePos()
end

function mob:setX1(x)
	self.X1 = x
	self:updatePos()
end

function mob:setPosY(y)
	self.posY = y
	self.Y1 = self.posY -self.LY/2
	self:updatePos()
end

function mob:setY1(y)
	self.Y1 = y
	self:updatePos()
end
