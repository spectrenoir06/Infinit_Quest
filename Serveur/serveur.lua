   
	------------- LIB ----------------
	require "/lib/json/json"
	require "/fonction/data" 
	require "/fonction/Serveur"
	socket = require "socket"
	
	udp = socket.udp()
	udp:settimeout(0)
    udp:setsockname('*', 12345)
	server = serveur_new()
	print("serveur start on : "..udp:getsockname())
	
	sync_dt = 0.075
	temp = 0
	dt=0

while 1 do
	temp = temp + dt
	sync = socket.gettime()
	local udp_data, msg_or_ip, port_or_nil = udp:receivefrom()

	if udp_data then
		server:receive(udp_data, msg_or_ip, port_or_nil)
	end
	
	if temp>sync_dt then
		server:update(1)
		temp = temp-sync_dt
	end
	dt = socket.gettime()-sync
	
end