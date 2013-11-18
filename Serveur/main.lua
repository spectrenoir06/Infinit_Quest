   
	------------- LIB ----------------
	require "/lib/json/json"
	require "/lib/spectre/map_json"
    require "/lib/spectre/sprite"
	require "/lib/spectre/button" 
    --require "/lib/spectre/camera"
	camera = require "/lib/hump/camera"
	gamestate = require "/lib/hump/gamestate"
	Timer = require "/lib/hump/timer"
	----------------------------------
	
	--------function------------------
	require "/fonction/option"
    ----------------------------------
	
	require "/fonction/data" 
	
	Grid = require "lib.jumper.grid"
	Pathfinder = require "lib.jumper.pathfinder"
	
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
	
    import_data("/data/data.json")
    require "/fonction/perso"
    require "/fonction/dispinfo"  
    require "/fonction/Itemsprite"  
    require "/fonction/pnj"
	require "/fonction/mob"
	require "/fonction/Serveur"
	socket = require "socket"
	
	udp = socket.udp()
	udp:settimeout(0)
    udp:setsockname('*', 12345)
	
	loadmaps()

    info=true
	
    cursor_x=0
    cursor_y=0
    
	tab_perso = {}
	
	clients = clients_new()
	
	sync = 0
	sync_dt = 0.05
	
end

function game:draw()
	for k,v in ipairs(tab_perso) do
		love.graphics.print(k.." : X="..v.posX.."  ;  Y="..v.posY.." ; map="..v.mapnb, 10,15*k+10)
	end

	
	
end

function game:update(dt)
	sync = sync + dt
	
	local udp_data, msg_or_ip, port_or_nil = udp:receivefrom()
		if udp_data then
			local json_data = json.decode(udp_data)
			if json_data.cmd == "new_game" then
				print(json_data.cmd, msg_or_ip, port_or_nil)
				table.insert(tab_perso,perso_new("/textures/"..resolution.."/skin"..#tab_perso..".png",resolution,resolution) )
				clients:add(#tab_perso,msg_or_ip,port_or_nil)
				udp:sendto(#tab_perso, msg_or_ip,  port_or_nil)
			elseif json_data.cmd == "pos_update" then
				--print(json_data.cmd, msg_or_ip, port_or_nil)
				tab_perso[json_data.id]:setmap(json_data.map)
				tab_perso[json_data.id]:setX1(json_data.x1)
				tab_perso[json_data.id]:setY1(json_data.y1)
				tab_perso[json_data.id]:setdirection(json_data.dir)
			end
		end
	
	
	if sync > sync_dt then
		clients:update()
		sync = sync-sync_dt
	end
		

	
	
	
	-- for k,v in pairs(tab_perso) do
		-- v:update(dt)  -- update steve
	-- end

 
		-- if love.keyboard.isDown( "up" ) then
            -- steve:GoUp()
        -- elseif love.keyboard.isDown( "down" ) then
            -- steve:GoDown()
        -- elseif love.keyboard.isDown( "left" ) then
            -- steve:GoLeft()
        -- elseif love.keyboard.isDown( "right" ) then
           -- steve:GoRight()
        -- end
        -- if love.keyboard.isDown( " " ) then
            -- steve:use()
        -- end
		-- if love.keyboard.isDown("f") then
			-- finde = true
		-- else
			-- finde = false
		-- end
end

function game:mousepressed(x, y, button)

end
    
function game:keypressed(key)
    if key == "kp+" then
        if steve:getnbslot()<9 then
            steve:setslot(steve:getnbslot()+1)
        end
    elseif key == "kp-" then
        if steve:getnbslot()>1 then
            steve:setslot(steve:getnbslot()-1)
        end
	end
	
    if key == "i" then
        if info then
            info=false
        else
            info=true
        end
	end
	
	if key == "p" then
		gamestate.push(pause)
    end
	
	if key=="e" then
		if not mobile then
			p:start()
			p:setPosition(steve.posX, steve.posY)
		end
	end
	
	if key=="escape" then
		love.event.push("quit")
	end
	
	if key=="o" then

	end

end

---------------------------------------------------------------------
