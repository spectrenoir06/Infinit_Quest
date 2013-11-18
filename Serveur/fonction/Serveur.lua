serveur = {}
serveur.__index = serveur

function serveur_new()
	local a = {}
	setmetatable(a, serveur)
	a.client_list = {}
	--a.data={}
	return a
end

function serveur:add_client(psedo,ip,port)
	local new = player_new(psedo,ip,port)
	table.insert(self.client_list,new)
	self:broadcast({cmd = "new_player", data = {psedo = new.psedo , skin = new.skin}})
end

function serveur:rem_client(id)
	table.remove(self.list,id)
end

function serveur:broadcast(data)
	for k,v in ipairs(self.client_list) do
		udp:sendto(json.encode(data), v.ip,  v.port)
	end
end

function serveur:get_nb()
	return #self.client_list
end

function serveur:update()
	self.data = {}
	for k,v in ipairs(self.client_list) do
		self.data[k]=v:getinfo()
	end
	for k,v in ipairs(self.list) do
		udp:sendto(json.encode(self.data), v.ip,  v.port)
	end
end


-----

player = {}
player.__index = player

function player_new(psedo,ip,port)
	local a = {}
	setmetatable(a, player)
	
	a.skin=math.random(0, 8)
	a.posX=10*64
	a.posY=10*64
	a.psedo=psedo
	a.map=1
	a.ip=ip
	a.port=port
	
	return a
end

function player:getinfo()
	return 
	{
	psedo = self.psedo,
	skin = self.skin,
	map = self.map,
	posX = self.posX,
	posY = self.posY,
	dir = self.dir
	}
end
