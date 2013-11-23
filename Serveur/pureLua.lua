   
	------------- LIB ----------------
	require "/lib/json/json"
	require "/fonction/data" 
	require "/fonction/Serveur"
	socket = require "socket"
	
	udp = socket.udp()
	udp:settimeout(0)
    udp:setsockname('*', 12345)
	server = serveur_new()
	
	sync = 0
	sync_dt = 0.05
	


while 1 do
	
	sync = sync + 0.1	
	local udp_data, msg_or_ip, port_or_nil = udp:receivefrom()
	

	if udp_data then
		server:receive(udp_data, msg_or_ip, port_or_nil)
	else
		server:update(1)
		sync = sync-sync_dt
		socket.sleep(0.05)
	end

end