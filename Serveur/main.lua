   
	------------- LIB ----------------
	require "/lib/json/json"
	camera = require "/lib/hump/camera"
	gamestate = require "/lib/hump/gamestate"
	Timer = require "/lib/hump/timer"
	---------------------------------
	
	require "/fonction/data" 
	
	start_screen = {}
	game = {}
	option = {}
	pause = {}
	main_menu = {}
  
function love.load(arg)
  
	gamestate.registerEvents()
	gamestate.switch(game)
end

------------------------------Game---------------------------------

function game:init()

	require "/fonction/Serveur"
	socket = require "socket"
	
	udp = socket.udp()
	udp:settimeout(0)
    udp:setsockname('*', 12345)
	
	server = serveur_new()
	
	sync = 0
	sync_dt = 0.05
	
end

function game:draw()
	-- for k,v in ipairs(serveur:getlist()) do
		-- love.graphics.print(k.." : X="..v.posX.."  ;  Y="..v.posY.." ; map="..v.map, 10,15*k+10)
	-- end
end

function game:update(dt)
	
	sync = sync + dt	
	local udp_data, msg_or_ip, port_or_nil = udp:receivefrom()
		
	if udp_data then
		server:receive(udp_data, msg_or_ip, port_or_nil)
	end
	
	if sync > sync_dt then
		server:update()
		sync = sync-sync_dt
	end
end

function game:mousepressed(x, y, button)
	
end
    
function game:keypressed(key)
	if key=="escape" then
		love.event.push("quit")
	end
end