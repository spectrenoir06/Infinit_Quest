clients = {}
clients.__index = clients

function clients_new()
	local a = {}
	setmetatable(a, clients)
	a.tab_perso = {}
	a.id=nil
	a.sync = 0
	a.sync_dt=0.1
	return a
end

function clients:add(skin,x,y)
	local new = perso_new("/textures/64/skin"..skin..".png",x,y)
	table.insert(self.tab_perso,new)
end

function clients:set_main_client(id)
	self.id = id
end

function clients:receive(data,msg)
	--
	local tab = json.decode(data)
	if tab.cmd == "new_player" then
		print("receive : port="..port.." ; cmd="..json.decode(data).cmd)
		local nb = table.getn(tab.data)
		print(json.encode(tab.data[nb].skin,tab.data[nb].posX,tab.data[nb].posY))
		self:add(tab.data[nb].skin,tab.data[nb].posX,tab.data[nb].posY)
	elseif tab.cmd == "update" then
		self:perso_set_info(tab.data)
	end

end

function clients:draw()
	for k,v in pairs(self.tab_perso) do
			print(json.encode(v.sprite))
			v:draw() 				-- afficher perso
	end
end

function clients:update(dt)
	if self.sync > self.sync_dt then
		local send = {	cmd = "pos_update",
						map = self:main():getmapnb(),
						data = { id = self.id,
								 posX=self:main().posX,
								 posY=self:main().posY,
								 dir=self:main().direction
							   }
					 }
		udp:send(json.encode(send))
		self.sync = 0
	end
	for k,v in pairs(self.tab_perso) do
		--print(v.posX)
		v:update(dt) -- update perso
	end
	self.sync = self.sync +dt
end

function clients:main()
	return self.tab_perso[self.id]
end

function clients:perso_set_info(data)
	for k,v in ipairs(data) do
		--print(k,json.encode(v))
		if k~=self.id then
			self.tab_perso[k]:setPosX(v.posX)
			self.tab_perso[k]:setPosY(v.posY)
			self.tab_perso[k]:setdirection(v.dir)
		end
	end
end