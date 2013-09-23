perso = {}
perso.__index = perso

function perso_new(fichier,LX,LY,map)


    local a={}
	
	a.globalPosX= 110 * resolution
	a.globalPosY= 10 * resolution
    a.LX = LX
    a.LY = LY
	
	for k,v in ipairs(data.map) do
		if (v.X<(a.globalPosX/resolution)) and (v.Y<(a.globalPosX/resolution)) then
			if ((a.globalPosX-v.X*resolution) < v.map.LX*resolution) and ((a.globalPosY-v.Y*resolution) < v.map.LY*resolution) then
				a.map = data.map[k]
				a.posX = a.globalPosX - v.X * resolution
				a.posY = a.globalPosY - v.Y * resolution
				break
			end
		end
	end
	
    a.texture = fichier
    a.sprite = sprite_new(fichier,LX,LY)
    a.vie = 100
	
	a.sprite:addAnimation({9,10,11})
    a.sprite:addAnimation({0,1,2})
    a.sprite:addAnimation({3,4,5})
    a.sprite:addAnimation({6,7,8})

    a.speed = 4 * resolution
    a.direction = 1
	a.hitbox = {25,0,25,32}
    a.dx = 0
    a.dy =0
	a.X1 = a.posX - a.LX/2
	a.Y1 = a.posY - a.LY/2
	a.X2 = a.posX + a.LX/2
	a.Y1 = a.posY + a.LY/2
    
    
    a.inv={}
    for i=1,9 do
        a.inv["slot"..i]={}
        a.inv["slot"..i]["id"]=0
        a.inv["slot"..i]["nb"]=1
    end
    a["slot"]=1

    return setmetatable(a, perso)
    
end

function perso:getmap()
    return self.map.map
end

function perso:getmapnb()
    return self.map.map.nb
end

function perso:setmap(map)
    self.map = data.map[map]
end


function perso:update(dt)
    self.sprite:update(dt)

	self:isOn()
    if up==1 then
      self:setdirection(1)
      self.dy = -1
      self.dx = 0
    elseif down==1 then
      self:setdirection(2)
      self.dx = 0
      self.dy = 1
    elseif left==1 then
      self:setdirection(3)
      self.dy = 0
      self.dx = -1
    elseif right==1 then
      self.dy = 0
      self:setdirection(4)
      self.dx = 1
    else
		self.dy = 0
		self.dx = 0
	end
	if key_a == 1 then
		self:use()
	end
    if ( self.dx~=0 or self.dy ~=0) and not self:colision(self.posX+(dt*self.dx*self.speed),self.posY+(dt*self.dy*self.speed)) then
        self:setX( self.posX +(dt*self.dx*self.speed) )
        self:setY( self.posY +(dt*self.dy*self.speed) )
		self.sprite:play()
    else
		self.sprite:stop()
		--print("stop")
        self.dy = 0
		self.dx = 0
    end
	if (self.posX < 0) or (self.posX>self.map.map.LX*resolution) then
		print("------------------")
		print("scan map:")
		for k,v in ipairs(data.map) do
			print("map "..k)
			print(" X = "..v.X)
			print(" Y = "..v.Y)
			print(" LX = "..v.map.LX)
			print(" LY = "..v.map.LY)
			if (v.X<(self.globalPosX/resolution)) and (v.Y<(self.globalPosX/resolution)) then
				if ((self.globalPosX-v.X*resolution) < v.map.LX*resolution) and ((self.globalPosY-v.Y*resolution) < v.map.LY*resolution) then
					print("------------------")
					print("= goto map "..k)
					print("------------------")
					self.map = data.map[k]
					self.posX = self.globalPosX - v.X * resolution
					self.posY = self.globalPosY - v.Y * resolution
					break
				end
			end
		end
	end
	
	
end

-------------------------------------------------------------------------------------------------------------------------------
function perso:draw()
    self.sprite:draw((self.posX-self.LX/2)-camera.x,self.posY-self.LY/2-camera.y)
end

function perso:setPos(tilex,tiley,dir,map)
    self:setX(tilex*resolution+(resolution/2))
    self:setY(tiley*resolution+(resolution/2))
    if dir then
        self:setdirection(dir)
    end
    --if map then
       -- self:setmap(map)
        --love.audio.stop()
        --love.audio.play(self.map.music)
   -- end
end

function perso:getX()
    return self.posX
end

function perso:getY()
    return self.posY
end

function perso:getPos()
	self.X1 = self.posX -self.LX/2
	self.Y1 = self.posY -self.LY/2
	self.X2 = self.posX +self.LX/2
	self.Y2 = self.posY +self.LY/2
    return self.posX , self.posY , self.X1 ,  self.Y1 , self.X2 , self.Y2
end


function perso:setX(x)
	self.posX = x
	self.globalPosX = self.map.X*resolution + x
	self.X1 = self.posX -self.LX/2
	self.Y1 = self.posY -self.LY/2
	self.X2 = self.posX +self.LX/2
	self.Y2 = self.posY +self.LY/2
end

function perso:setY(y)
	self.posY = y
	self.globalPosY = self.map.Y*resolution + y
	self.X1 = self.posX -self.LX/2
	self.Y1 = self.posY -self.LY/2
	self.X2 = self.posX +self.LX/2
	self.Y1 = self.posY +self.LY/2
end


function perso:getvie()
    return self.vie
end

function perso:changevie(dx)
    self.vie=self.vie+dx
end

function perso:setvie(x)
    self.vie=x
end

function perso:colision(x,y) -- return true si perso en colision au coordoner

	local X1 = x - self.hitbox[1]
	local Y1 = y - self.hitbox[2]
	local X2 = x + self.hitbox[3]
	local Y2 = y + self.hitbox[4]
    return self:scancol(math.floor((X1)/resolution),math.floor((Y1)/resolution))
		or self:scancol(math.floor((X2)/resolution),math.floor((Y1)/resolution))
		or self:scancol(math.floor((X1)/resolution),math.floor((Y2)/resolution))
		or self:scancol(math.floor((X2)/resolution),math.floor((Y2)/resolution))
end
function perso:scancol(x,y) -- return true si colision
	local idsol, idblock, x, y, pnj = self:getblock(x,y)
		print(idsol,idblock)
	local blockDataSol = data.tab[idsol]
	local blockDataBlock = data.tab[idblock]
	if idblock==nil or idsol==nil then
		return false
	else
		return not blockDataSol.pass or not blockDataBlock.pass or pnj
	end
end

function perso:setdirection(direction)
    self.direction=direction
    self.sprite:setAnim(direction)
end

function perso:getdirection()
    return self.direction
end


function perso:getblock(tilex,tiley)
        local idsol, idblock = self.map.map:gettile(tilex,tiley)
        local pnj = self.map.map:getPnj(tilex,tiley)
        local obj = self.map.map:getObj(tilex,tiley)
        return idsol,idblock,tilex,tiley,pnj,obj
end
-------------------------------------------------
function perso:use()
	local posX , posY , X1 , Y1 , X2 ,Y2 = self:getPos()
	if self:getdirection()==1 then
		idsol,idblock,x,y,pnj,obj = self:getblock(math.floor(posX/resolution),math.floor(Y1/resolution))
    elseif	self:getdirection()==2 then
		idsol,idblock,x,y,pnj,obj = self:getblock(math.floor(posX/resolution),math.ceil(Y2/resolution))
	elseif self:getdirection()==3 then
		idsol,idblock,x,y,pnj,obj = self:getblock(math.floor(X1/resolution),math.floor(posY/resolution))
	elseif self:getdirection()==4 then
		idsol,idblock,x,y,pnj,obj = self:getblock(math.ceil(X2/resolution),math.ceil(posY/resolution))
	end
		
    if idblock then
        blockdata = data.tab[idblock]
    end
    local main = data.tab[self:getslot()]
    if main.type == "block" then
        if idblock==0 and not pnj then
            --self:place()
        else
            if blockdata.use then
                blockdata.use(x,y)
            elseif pnj then
                if pnj.data.talk then
                    pnj.data.talk()
                end
            end
        end
    elseif main.type == "item" then
        if blockdata.use then
                blockdata.use(x,y)
        elseif main.use then
            main.use(x,y)
        end
    end 
end

function perso:isOn()
    local idsol, idblock, x, y, pnj,obj = self:getblock(math.floor(self:getX()/resolution),math.floor(self:getY()/resolution))
    if idblock  == nil then
        error("Id non valide")
    else
        blockdata = data.tab[idblock]
        --if blockdata.isOn then
            -- blockdata.isOn(x,y)
        --elseif obj then
            -- if obj.data.isOn then
                -- obj.data.isOn()
            -- end
        -- end
    end
end

-----------------------------------

function perso:setslot(nb)
    self.slot=nb
end

function perso:getnbslot()
    return self.slot
end


function perso:getslot(slot)
    if slot== nil then
        return self.inv["slot"..self.slot]["id"] , self.inv["slot"..self.slot]["nb"]
    else
        return self.inv["slot"..slot]["id"] , self.inv["slot"..slot]["nb"]
    end
end

function perso:getslotid(slot)
    return self.inv["slot"..slot]["id"]
end

function perso:getslotnb(slot)
    return self.inv["slot"..slot]["nb"]
end

function perso:additem(id,nb)
    fini=false
    for i=1,9 do
        Sid , Snb = self:getslot(i)
        if Sid == id then
            self.inv["slot"..i]["nb"]=Snb+nb
            fini=true
            break
        end
    end
    if fini==false then
       for i=1,9 do
            Sid , Snb = self:getslot(i)
            if Sid==0 then
                self.inv["slot"..i]["id"]=id
                self.inv["slot"..i]["nb"]=nb
                break
            end
        end
    end
end

function perso:removeitem(slot,nb)
    self.inv["slot"..slot]["nb"]=self.inv["slot"..slot]["nb"]-nb
    if self.inv["slot"..slot]["nb"]<=0 then
        self.inv["slot"..slot]["id"]=0
        self.inv["slot"..slot]["nb"]=1
    end
end

--[[function perso:drawinv(x,y,img)
    love.graphics.print("V",x+(self.slot-1)*32+15,y-15)
    love.graphics.draw(img, x-4, y-4)
    for i=0,8 do
        if self:getslotid(i+1)~= 0 then
            inventaire:draw(x+i*32,y,self:getslotid(i+1))
            love.graphics.print(self:getslotnb(i+1),x+i*32,y+15)
        end
        --love.graphics.rectangle("line", x+i*32,y,32,32)
    end
end]]

function perso:dig()
    idsol,idblock,x,y = self:getblock()
    if idblock then
        blockData = data.tab[idblock]
        if blockData.dig then
            blockData.dig(x,y)
        end
    end
end

function perso:place()
    idsol,idblock,x,y = self:getblock()
    if idblock == 0 then
        if self:getslot()~=0 then
            self.map:settile(x,y,self:getslot(),2)
            self:removeitem(self.slot,1)
            return true
        else
            return false
        end
    end
end

function perso:scanMap()
	

end