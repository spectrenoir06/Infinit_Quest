mob = {}
mob.__index = mob

function new_mob()

    local a={}
	
	a.X = 640
	a.Y = 512
	
	a.LX = 64
    a.LY = 64
	
	a.X1 = a.X - a.LX/2
	a.Y1 = a.Y - a.LY/2
	a.X2 = a.X + a.LX/2
	a.Y2 = a.Y + a.LY/2
	
    a.texture = "/textures/64/mob.png"
    a.sprite = sprite_new("/textures/64/sprite.png",a.LX,a.LY)
    a.vie = 100
	
	a.sprite:addAnimation({9,10,11})
    a.sprite:addAnimation({0,1,2})
    a.sprite:addAnimation({3,4,5})
    a.sprite:addAnimation({6,7,8})

    --a.direction = 2
	a.sprite:stop()
	a.sprite:setAnim(2,2)
	
    a.dx = 0
    a.dy =0

    return setmetatable(a, mob)
    
end

function mob:update(dt)

	self.sprite:update(dt)
	print(dist(steve.posX,steve.posY,monster.X,monster.Y)/64)
	if dist(steve.posX,steve.posY,monster.X,monster.Y)/64 < 5 then
		print("ennemi en vu")
	end
	
end

function mob:draw()
    self.sprite:draw(math.floor(self.X1),math.floor(self.Y1)) 
end

function mob:getPos()
	return self.X,self.Y,self.X1,self.Y1,self.X2,self.Y2
end

function dist(xa,ya,xb,yb)
	return math.sqrt(math.pow(xb-xa,2)+math.pow(yb-ya,2))
end