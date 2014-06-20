local Sprite = require "lib.spectre.Sprite"

local class = require 'lib.kikito.middleclass'

local Perso = class('Perso') 

function Perso:initialize(fichier,x,y,mapNb)
    
	if mapNb then
		self.map = data.map[mapNb]
	else
		print("pas de map en param map 1 select")
		self.map = data.map[1]
	end
	
	self.globalPosX = (self.map.X + x)
	self.globalPosY = (self.map.Y + x)
	
	self.LX = 64
	self.LY = 64
	
	self.posX 		= x					-- position X local
	self.posY 		= y					-- position Y local
	self.mapnb 	= mapNb				-- map nb
	
    self.texture 	= fichier
    self.sprite 	= Sprite.new(fichier,self.LX,self.LY)
    self.vie 		= 100
	
	self.sprite:addAnimation({9,10,11})
    self.sprite:addAnimation({0,1,2})
    self.sprite:addAnimation({3,4,5})
    self.sprite:addAnimation({6,7,8})

    self.speed 	= 4 * resolution
    self.direction = 1
    self.dx 		= 0
    self.dy 		= 0
	
	self.X1 		= self.posX - self.LX/2
	self.Y1 		= self.posY - self.LY/2
	self.X2 		= self.posX + self.LX/2
	self.Y2 		= self.posY + self.LY/2

end

function Perso:getmap()
    return self.map.map
end

function Perso:getmapnb()
    return self.mapnb
end

function Perso:setmap(map)
    self.map = data.map[map]
	self.mapnb = map
end


function Perso:update(dt)
	self:updatePos()
    self.sprite:update(dt)
	
	local grid = resolution/4
	
	if self.dx~=0 or self.dy ~=0 then 										-- si mouvement
		self.sprite:play()
		if self.dx~=0 and (self.Y1 % (grid))~=0 then 						-- si mouvement sur X mais Y pas sur le grid
			--print(self.posY % grid /grid)
			if ((self.Y1 % (grid)/grid)<=0.5) then 							-- realignement en -y
				if (((self.Y1 - dt*self.speed)%grid)/grid)>0.5 then
					self:setY1(math.floor(self.Y1/grid)*grid)
				else
					self:setY1(self.Y1 -(dt*self.speed))
				end
			else
				if (((self.Y1 +(dt*self.speed))%grid)<0.5) then 			-- realignement en +y
					self:setY1(math.ceil(self.Y1/grid)*grid)
				else
					self:setY1(self.Y1 +(dt*self.speed))
				end
			end
		elseif self.dy~=0 and (self.X1 % (grid))~=0 then 					-- si mouvement sur Y mais X pas sur le grid
			--print(self.X1 % grid /grid)
			if ((self.X1 % (grid)/grid)<=0.5) then
				if (((self.X1 - dt*self.speed)%grid)/grid)>0.5 then 		-- realignement en -x
					self:setX1(math.floor(self.X1/grid)*grid)
				else
					self:setX1(self.X1 -(dt*self.speed))
				end
			else
				if (((self.X1 +(dt*self.speed))%grid)<0.5) then 			-- realignement en +y
					self:setX1(math.ceil(self.X1/grid)*grid)
				else
					self:setX1(self.X1 +(dt*self.speed))
				end
			end
		elseif not self:colision(dt) then 					-- si aligner sur l'axe perpendiculaire au mouvement ( si +x alors y%grid = 0 ) et pas de colision
			self:setX1( self.X1 +(dt*self.dx*self.speed) ) 	-- mouvement sur X
			self:setY1( self.Y1 +(dt*self.dy*self.speed) ) 	-- mouvement sur Y
			--self.sprite:play()
		else
			if self.dx<0 then
				self:setX1(math.ceil((self.X1 +(dt*self.dx*self.speed))/resolution)*resolution) 	-- si colision en -x position arrondie au tile a gauche
			elseif self.dx>0 then
				self:setX1(math.floor((self.X1 +(dt*self.dx*self.speed))/resolution)*resolution) 	-- si colision en + position arrondie au tile e droite 
			end
			if self.dy<0 then
				self:setY1(math.ceil((self.Y1 +(dt*self.dy*self.speed))/resolution)*resolution) 	-- si colision en -y position arrondie au tile au dessus
				-- print(math.ceil(self.posY +(dt*self.dy*self.speed)/64))
			elseif self.dy>0 then
				self:setY1(math.floor((self.Y1 +(dt*self.dy*self.speed))/resolution)*resolution) 	-- si colision en +y position arrondie au tile au dessous
			end
			--print("stop")
		end
	else
		self.sprite:stop()
    end
	self:updatePos()
	self.dy = 0
	self.dx = 0
	
	if (self.posX < 0) or (self.posX>self.map.map.LX*resolution) then -- si Perso sort de la map local
	--	print("------------------")
	--	print("globalPosX = "..self.globalPosX)
	--	print("globalPosY = "..self.globalPosY)
	--	print(""                )
	--	print("scan map:")
		for k,v in ipairs(data.map) do
		--	print("map "..k)
		--	print(" X = "..v.X)
			--print(" Y = "..v.Y)
			--print(" LX = "..v.map.LX)
			--print(" LY = "..v.map.LY)
			if (v.X<(self.globalPosX/resolution)) and (v.Y<(self.globalPosX/resolution)) then
				if ((self.globalPosX-v.X*resolution) < v.map.LX*resolution) and ((self.globalPosY-v.Y*resolution) < v.map.LY*resolution) then
					--print("------------------")
					--print("= goto map "..k)
					--print("------------------")
					self.map = data.map[k]
					self:setPosX(self.globalPosX - v.X * resolution)
					self:setPosY(self.globalPosY - v.Y * resolution)
					self.mapnb = k
					if localgame.multi then
					  print("send changemap()",k)
					  localgame:changeMap()
					end
					break
				end
			end
		end
	end
	self:updatePos()
	
end

-------------------------------------------------------------------------------------------------------------------------------
function Perso:draw()
    self.sprite:draw(math.floor(self:getX()-32),math.floor(self:getY()-32)) 
end

function Perso:setPos(tilex,tiley,dir,map)
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

function Perso:getX()
    return self.posX
end

function Perso:getY()
    return self.posY
end

function Perso:getPos()
	self:updatePos()
    return self.posX , self.posY , self.X1 ,  self.Y1 , self.X2 , self.Y2
end


function Perso:setPosX(x)
	self.posX = x
	self.X1 = self.posX - self.LX/2
	self:updatePos()
end

function Perso:setX1(x)
	self.X1 = x
	self:updatePos()
end

function Perso:setPosY(y)
	self.posY = y
	self.Y1 = self.posY -self.LY/2
	self:updatePos()
end

function Perso:setY1(y)
	self.Y1 = y
	self:updatePos()
end

function Perso:updatePos()
	self.X2 = self.X1 + self.LY
	self.Y2 = self.Y1 + self.LY
	self.posX = self.X1 + (self.LX/2)
	self.posY = self.Y1 + (self.LY/2)
	self.globalPosX = self.map.X*resolution + self.posX
	self.globalPosY = self.map.Y*resolution + self.posY
end


function Perso:getvie()
    return self.vie
end

function Perso:changevie(dx)
    self.vie=self.vie+dx
end

function Perso:setvie(x)
    self.vie=x
end

function Perso:colision(dt) -- return true si Perso en colision au coordoner
	return self:scancol(math.floor((self.X1+dt*self.dx*self.speed)/resolution),math.floor((self.Y1+dt*self.dy*self.speed)/resolution))
		or self:scancol(math.floor(((self.X2+dt*self.dx*self.speed)-1)/resolution),math.floor((self.Y1+dt*self.dy*self.speed)/resolution))
		or self:scancol(math.floor((self.X1+dt*self.dx*self.speed)/resolution),math.floor(((self.Y2+dt*self.dy*self.speed)-1)/resolution))
		or self:scancol(math.floor(((self.X2+dt*self.dx*self.speed)-1)/resolution),math.floor(((self.Y2+dt*self.dy*self.speed)-1)/resolution))
				
				
		-- if self:scancol(math.floor((self.X1+dt*self.dx*self.speed)/resolution),math.floor((self.Y1+dt*self.dy*self.speed)/resolution)) then
			-- print("x1,y1=true")
			-- return true
		-- end
		-- if self:scancol(math.floor(((self.X2+dt*self.dx*self.speed)-1)/resolution),math.floor((self.Y1+dt*self.dy*self.speed)/resolution)) then
			-- print("x2,y1=true")
			-- return true
			
		-- end
		-- if self:scancol(math.floor((self.X1+dt*self.dx*self.speed)/resolution),math.floor(((self.Y2+dt*self.dy*self.speed)-1)/resolution)) then
			-- print("x1,y2=true")
			-- return true
		-- end
		-- if self:scancol(math.floor(((self.X2+dt*self.dx*self.speed)-1)/resolution),math.floor(((self.Y2+dt*self.dy*self.speed)-1)/resolution)) then
			-- print("x2,y2=true")
			-- print("X2="..self.X2/64 .."   Y2="..self.Y2/64)
			-- print(math.floor((self.X2+dt*self.dx*self.speed)/resolution),math.floor((self.Y2+dt*self.dy*self.speed)/resolution))
			-- return true
		-- end
end

function Perso:scancol(tilex,tiley) -- return true si colision
	local block = self:getblock(tilex,tiley)
		--print(idsol,idblock)
	local blockDataSol = data.tab[block.idsol]
	local blockDataBlock = data.tab[block.idblock]
	if block.idblock==nil or block.idsol==nil then
		return false
	else
		return not blockDataSol.pass or not blockDataBlock.pass or block.pnj
	end
end

function Perso:setdirection(direction)
    self.direction=direction
    self.sprite:setAnim(direction)
end

function Perso:getdirection()
    return self.direction
end


function Perso:getblock(tilex,tiley)

        local idsol, idblock, iddeco = self.map.map:gettile(tilex,tiley)
        local pnj = self.map.map:getPnj(tilex,tiley)
        local obj = self.map.map:getObj(tilex,tiley)
		local tab =
		{pnj=pnj,
		 idsol = idsol,
		 idblock = idblock,
		 iddeco = iddeco,
		 obj = obj,
		 pnj = pnj,
		 tilex=tilex,
		 tiley=tiley,
		}
        return tab
end
-------------------------------------------------
function Perso:use()
	local posX , posY , X1 , Y1 , X2 ,Y2 = self:getPos()
	local x,y = 0,0
	
	if self:getdirection()==1 then
		x,y = math.floor(X1/resolution) , math.floor(Y1/resolution)-1
    elseif	self:getdirection()==2 then
		x,y = math.floor(X1/resolution),math.floor(Y1/resolution)+1
	elseif self:getdirection()==3 then
		x,y = math.floor(X1/resolution)-1,math.floor(Y1/resolution)
	elseif self:getdirection()==4 then
		x,y = math.floor(X1/resolution)+1,math.floor(Y1/resolution)
	end
	
	local block = self:getblock(x,y)
	
    if data.tab[block.idblock].use then
		data.tab[block.idblock].use(block.tileX,block.tiley)
	elseif data.tab[block.idsol].use then
		data.tab[block.idsol].use(block.tileX,block.tiley)
    elseif block.pnj then
		if block.pnj.data.talk then
			block.pnj.data.talk()
		end
	end
	
	--if blockdata.use then
                -- blockdata.use(x,y)
            -- elseif pnj then
                -- if pnj.data.talk then
                    -- pnj.data.talk()
                -- end
	
    -- local main = data.tab[self:getslot()]
    -- if main.type == "block" then
        -- if idblock==0 and not pnj then
            --self:place()
        -- else
            -- if blockdata.use then
                -- blockdata.use(x,y)
            -- elseif pnj then
                -- if pnj.data.talk then
                    -- pnj.data.talk()
                -- end
            -- end
        -- end
    -- elseif main.type == "item" then
        -- if blockdata.use then
                -- blockdata.use(x,y)
        -- elseif main.use then
            -- main.use(x,y)
        -- end
    -- end 
end

function Perso:isOn()
    local block = self:getblock(math.floor(self:getX()/resolution),math.floor(self:getY()/resolution))
    if block.idblock  == nil then
        error("Id non valide")
    else
        blockdata = data.tab[idblock]
        if data.tab[block.idsol].isOn then
            data.tab[block.idsol].isOn(block.tilex,block.tiley)
        elseif block.obj then
            if block.obj.data.isOn then
                block.obj.data.isOn()
            end
        end
    end
end

-----------------------------------

function Perso:setslot(nb)
    self.slot=nb
end

function Perso:getnbslot()
    return self.slot
end


function Perso:getslot(slot)
    if slot== nil then
        return self.inv["slot"..self.slot]["id"] , self.inv["slot"..self.slot]["nb"]
    else
        return self.inv["slot"..slot]["id"] , self.inv["slot"..slot]["nb"]
    end
end

function Perso:getslotid(slot)
    return self.inv["slot"..slot]["id"]
end

function Perso:getslotnb(slot)
    return self.inv["slot"..slot]["nb"]
end

function Perso:additem(id,nb)
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

function Perso:removeitem(slot,nb)
    self.inv["slot"..slot]["nb"]=self.inv["slot"..slot]["nb"]-nb
    if self.inv["slot"..slot]["nb"]<=0 then
        self.inv["slot"..slot]["id"]=0
        self.inv["slot"..slot]["nb"]=1
    end
end

--[[function Perso:drawinv(x,y,img)
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

function Perso:dig()
    idsol,idblock,x,y = self:getblock()
    if idblock then
        blockData = data.tab[idblock]
        if blockData.dig then
            blockData.dig(x,y)
        end
    end
end

function Perso:place()
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

function Perso:scanMap()
	

end

function Perso:GoUp()
	self:setdirection(1)
    self.dy = -1
    self.dx = 0
end

function Perso:GoDown()
	self:setdirection(2)
    self.dy = 1
    self.dx = 0
end

function Perso:GoLeft()
	self:setdirection(3)
    self.dy = 0
    self.dx = -1
end

function Perso:GoRight()
	self:setdirection(4)
    self.dy = 0
    self.dx = 1
end

return Perso