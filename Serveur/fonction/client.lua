clients = {}
clients.__index = clients

function clients_new()
	local a = {}
	setmetatable(a, clients)
	a.list = {}
	a.data={}
	return a
end

function clients:add(psedo,ip,port)
	table.insert(self.list,{psedo = psedo , ip = ip , port = port })
end

function clients:rem(id)
	table.remove(self.list,id)
end

function clients:get_nb()
	return #self.list
end

function clients:update()
	self.data = {}
	for k,v in ipairs(tab_perso) do
		self.data[k]={x1=v.X1,y1=v.Y1}
	end
	for k,v in ipairs(self.list) do
		udp:sendto(json.encode(self.data), v.ip,  v.port)
	end
end
