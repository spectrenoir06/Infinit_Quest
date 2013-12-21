   
	------------- LIB ----------------
	require "/lib/json/json"
	require "/fonction/data" 
	require "/fonction/Serveur"
	socket = require "socket"
	
	udp = socket.udp()
	tcp = socket.tcp()
	
	
	
	udp:settimeout(0)
    udp:setsockname('*', 12345)
	server = serveur_new()
	print("serveur start on : "..udp:getsockname())

while 1 do
	local udp_data, msg_or_ip, port_or_nil = udp:receivefrom()

	if udp_data then
		server:receive(udp_data, msg_or_ip, port_or_nil)
	end
	
	server:update()
	
end