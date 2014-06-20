local Server = {}
Server.__index = Server

local socket = require "socket"
local struct = require "struct"

function Server.new(ip,port)
	local a = {}
	setmetatable(a, Server)
	  
	a.tcpSocket = assert(socket.connect(ip, port))		-- connection socket tcp
	a.tcpSocket:settimeout(0)
	a.udpSocket = assert(socket.udp())
	a.udpSocket:settimeout(0)
	a.udpSocket:setpeername(ip,port)					-- connection socket udp
	
	a.udp_ip, a.udp_port = a.udpSocket:getsockname()	-- recuper info socket udp
	
	a:udpSend("getUdp")
	local tab
	while not tab do
		tab = a:udpReceive()
	end
	print(tab.cmd,tab.data.ip,tab.data.port)
	
	a:tcpSend("udpInfo",{ip = tab.data.ip..":"..tab.data.port})
	return a
end

function Server:tcpSend(cmd,data)
	--print(json.encode({cmd = cmd,data = data}))
	local s
  
  if cmd == "udpInfo" then
	    s = stuct.pack("Bs",0x00,data.ip)
	end
	self.tcpSocket:send(s.."\n")
end

function Server:udpSend(cmd,data)
  local s
	if cmd=="getUdp" then
	   s = struct.pack("B",0x00)
	elseif cmd == "pos_update" then
      s = struct.pack("BffBB", 0x01, data.posX, data.posY, data.dir,data.mv )
  end
	self.udpSocket:send(s)
end

function Server:login(name)
	print"login"
	self:tcpSend("login",{name=name})
	while true do
		local data = self.tcpSocket:receive()
		if data then
			return json.decode(data)
		end
	end
end

function Server:send_position(perso)
	local cmd = "pos_update"
	local data = {
	        posX = perso.posX,
					posY = perso.posY,
					dir = perso.direction,
					mv  = (perso.dx~=0 or perso.dy~=0)
				}
	--print(cmd,json.encode(data))                
	self:udpSend(cmd,data)
end

function Server:udpReceive()
	local data = self.udpSocket:receive()
	
	if data then
		--print(data)
		return json.decode(data)
	end
end

function Server:tcpReceive()
	local data, status, partial = self.tcpSocket:receive()
	if data then
		--print(data)
		return json.decode(data)
	end
	if status=="closed" then
		error("Server closed")
	end
end

return Server