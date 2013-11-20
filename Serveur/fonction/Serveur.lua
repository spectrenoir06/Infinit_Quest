serveur = {}
serveur.__index = serveur

function serveur_new()
	local a = {}
	setmetatable(a, serveur)
	a.player_map = {}
	a.player_map[1] = {}
	a.id = 1
	return a
end

function serveur:add_client(name,ip,port)
	local client = {perso = player_new(name,self.id) , ip = ip , port = port}
	table.insert(self.player_map[1],client)
	self:broadcast("new_player",self:getperso(1),nil)
	--self:update(1)
	self.id = self.id +1
end

function serveur:rem_client(id)
	--table.remove(self.list,id)
end

function serveur:broadcast(cmd,data,map)
	local send = {cmd = cmd , data = data}
	if map then
		for nb,client in ipairs(self.player_map[map]) do
			udp:sendto(json.encode(send), client.ip,  client.port)
			--print("send : cmd="..cmd.." ; port="..client.port)
		end
	else
		for k,v in ipairs(self.player_map) do
			for nb,client in ipairs(v) do
				udp:sendto(json.encode(send), client.ip,  client.port)
				--print("send : cmd="..cmd.." ; port="..client.port)
			end
		end
	end
end

function serveur:receive(data, ip, port)
	--print(data)
	--print("receive : port="..port.." ; cmd="..json.decode(data).cmd)
	local tab = json.decode(data)
	if tab.cmd == "connect" then
		self:add_client(tab.data.name,ip,port)
	elseif tab.cmd == "pos_update" then
		local list = self.player_map[tab.map]
		for nb,client in ipairs(list) do
			if client.perso.id == tab.data.id then
				client.perso:setinfo(tab.data)
				break
			end
		end
	end

end

function serveur:get_nb()
	return #self.player_map
end

function serveur:update(map)
	if map then
		for nb,client in ipairs(self.player_map[map]) do
			self:broadcast("update",self:getperso(map),k)
		end
	else
		for k,zone in ipairs(self.player_map) do
			for nb,client in ipairs(zone) do
				self:broadcast("update",self:getperso(k),k)
			end
		end
	end
end

function serveur:getlist()
	local tab = {}
	for k,zone in ipairs(self.player_map) do
		for nb,client in ipairs(zone) do
			--print(json.encode(client))
			table.insert(tab,{ 	name = client.perso.name,
								ip = client.ip,
								port = client.port,
								map = k ,
								id = client.perso.id,
								posX=client.perso.posX, 
								posY=client.perso.posY
							 } )
		end
	end
	return tab
end

function serveur:getperso(map)
	local tab = {}
	if map then
		for nb,client in ipairs(self.player_map[map]) do
			table.insert(tab,client.perso:getinfo())
		end
	else
		error("no map")
	end
	return tab
end


-----

player = {}
player.__index = player

function player_new(name,id)
	local a = {}
	setmetatable(a, player)
	
	a.id = id
	a.skin=math.random(0, 7)
	a.posX=10*64
	a.posY=10*64
	a.name=name
	a.map=1
	
	return a
end

function player:getinfo()
	return {
	id = self.id,
	name = self.name,
	skin = self.skin,
	map = self.map,
	posX = self.posX,
	posY = self.posY,
	dir = self.dir}
end

function player:setinfo(data)
	self.posX = data.posX
	self.posY = data.posY
	self.dir = data.dir
end
