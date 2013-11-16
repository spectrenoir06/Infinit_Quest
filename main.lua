   
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
	
   -- require "/fonction/dataobj"
	
	--G_port = "4321"
	--G_host = "192.168.10.8"
	--require "/android/android"
	
	start_screen = {}
	game = {}
	option = {}
	pause = {}
	main_menu = {}
  
function love.load(arg)
  
	load_option()
	gamestate.registerEvents()
	cam = camera()
	--gamestate.switch(start_screen)
	gamestate.switch(game)
end
-----------------------------start_screen---------------------------

function start_screen:init()
	start = love.graphics.newImage("/textures/menu/720/start/start.png")
	avatar = love.graphics.newImage("/textures/menu/720/start/avatar.png")
	
	intro_music  = love.audio.newSource("/music/intro.mp3")
	love.audio.play(intro_music)
	
	cam:zoomTo(love.graphics.getHeight()/720)
	
	pos = {}
	pos.X , pos.Y = 0-avatar:getWidth(),0-avatar:getHeight()
	
	if not mobile then
		p = love.graphics.newParticleSystem( love.graphics.newImage("/textures/flame.png"), 1000 )
		p:setEmissionRate(400)
		p:setSpeed(300, 400)
		p:setSizes(0.5, 0.5,0.1,0.5,0.01)
		p:setColors(255, 255, 0, 128, 255, 125, 32, 255,192,92,32,255,240,64,32,255)
		p:setPosition(pos.X+avatar:getWidth()/2,pos.Y+avatar:getHeight()/1.5)
		p:setLifetime(-1)
		p:setParticleLife(0.5,2)
		p:setDirection(270)
		p:setSpread(360)
		p:setTangentialAcceleration(0,0)
		p:setRadialAcceleration(0,0)
		p:stop()
	end
	
	Timer.tween(5, pos, {X=love.graphics.getWidth()/2-avatar:getWidth()/2}, 'out-back')
	Timer.tween(5, pos, {Y=love.graphics.getHeight()/2-avatar:getHeight()/2}, 'bounce')
	
	Timer.add(6,function() gamestate.switch(main_menu) end)	
	
end

function start_screen:draw()
	cam:lookAt(1280/2,720/2)
	cam:attach()
	love.graphics.draw( start, 0, 0)
	if not mobile then
		p:setPosition(pos.X+avatar:getWidth()/2,pos.Y+avatar:getHeight()/2)
		love.graphics.draw(p, 0, 0)
	end
	love.graphics.draw( avatar, pos.X , pos.Y  )
	if not mobile then
		p:start()
	end
	--p:setPosition(steve.posX, steve.posY)
	cam:detach()
end

function start_screen:update(dt)
	Timer.update(dt)
	if not mobile then
		p:update(dt)
	end
end


-----------------------------Main_menu----------------------------
function main_menu:init()
	fond = love.graphics.newImage("/textures/menu/720/fond.png")
	hero = love.graphics.newImage("/textures/menu/720/hero.png")
	
	button_start = button_new(1280,150,"/textures/menu/720/barre_start.png")
	button_option = button_new(1280,350,"/textures/menu/720/barre_option.png")
	button_exit = button_new(1280,550,"/textures/menu/720/barre_exit.png")
	
	cam:zoomTo(love.graphics.getHeight()/720)
end

function main_menu:enter()
	
	button_start.x=1280
	button_option.x=1280
	button_exit.x=1280
	
	effect1 = Timer.tween(1.5, button_start, {x=600}, 'linear')
	effect2 = Timer.tween(1.5, button_option, {x=600}, 'linear')
	effect3 = Timer.tween(1.5, button_exit, {x=600}, 'linear')
	
end

function main_menu:draw()

	cam:lookAt(1280/2,720/2)
	cam:attach()
	love.graphics.draw( fond, 0, 0)
	love.graphics.draw( hero, -button_start.x+700, 40 )
	button_start:draw()
	button_option:draw()
	button_exit:draw()
	cam:detach()
	love.graphics.print(cam.scale,10,10)
	
end

function main_menu:update(dt)
	Timer.update(dt)
	button_start:update()
	button_option:update()
	button_exit:update()
end

function main_menu:mousepressed(Sx, Sy, button)
	local x,y = cam:mousepos()
	if button_start:isPress(x,y,button) then
		print("button start")
		
		Timer.cancel(effect1)
		Timer.cancel(effect2)
		Timer.cancel(effect3)
		
		local temp = ((1.5/680)*(1280-button_start.x))
		
		Timer.tween(temp, button_start, {x=1280}, 'linear')
		Timer.tween(temp, button_option, {x=1280}, 'linear')
		Timer.tween(temp, button_exit, {x=1280}, 'linear')
		Timer.add(temp,function() gamestate.switch(game) end)
		
	elseif button_option:isPress(x,y,button) then
		print("button option")
		
		Timer.cancel(effect1)
		Timer.cancel(effect2)
		Timer.cancel(effect3)
		
		local temp = ((1.5/680)*(1280-button_start.x))
		print((1280-button_start.x),temp)
		
		Timer.tween(temp, button_start, {x=1280}, 'linear')
		Timer.tween(temp, button_option, {x=1280}, 'linear')
		Timer.tween(temp, button_exit, {x=1280}, 'linear')
		
		Timer.add(temp,function() gamestate.switch(option) end)
		--gamestate.switch(option)
	elseif button_exit:isPress(x,y,button) then
		print("button quit")
		love.event.push("quit")
	end
end

function main_menu:keypressed(key)
	if key=="escape" then
		love.event.push("quit")
	end
end

----------------------------Option-----------------------------

function option:init()

	button_1 = button_new(1280,150,"/textures/menu/720/barre.png")
	button_2 = button_new(1280,350,"/textures/menu/720/barre.png")
	button_3 = button_new(1280,550,"/textures/menu/720/barre_exit.png")
	
end

function option:enter()
	
	button_1.x = 1280
	button_2.x = 1280
	button_3.x = 1280
	
	effect1 = Timer.tween(1.5, button_1, {x=600}, 'linear')
	effect2 = Timer.tween(1.5, button_2, {x=600}, 'linear')
	effect3 = Timer.tween(1.5, button_3, {x=600}, 'linear')
	
end


function option:draw()
	cam:attach()
	love.graphics.draw( fond, 0, 0)
	button_1:draw()
	button_2:draw()
	button_3:draw()
	cam:detach()
end

function option:update(dt)
	Timer.update(dt)
	button_1:update()
	button_2:update()
	button_3:update()
end

function option:mousepressed(Sx, Sy, button)

	local x,y = cam:mousepos()
	
	if button_1:isPress(x,y,button) then
		print("button_1")
	elseif button_2:isPress(x,y,button) then
		print("button_2")
	elseif button_3:isPress(x,y,button) then
		print("button_3")
		Timer.cancel(effect1)
		Timer.cancel(effect2)
		Timer.cancel(effect3)
		
		local temp = ((1.5/680)*(1280-button_1.x))
		
		Timer.tween(temp, button_1, {x=1280}, 'linear')
		Timer.tween(temp, button_2, {x=1280}, 'linear')
		Timer.tween(temp, button_3, {x=1280}, 'linear')
		
		Timer.add(temp,function() gamestate.switch(main_menu) end)
	end
	
end

function option:keypressed(key)
	if key=="escape" then
		love.event.push("quit")
	end
end

------------------------------Game---------------------------------

function game:init()

	cam:zoomTo(1)
	
    import_data("/data/data.json")
    require "/fonction/perso"
    require "/fonction/dispinfo"  
    require "/fonction/Itemsprite"  
    require "/fonction/pnj"
	require "/fonction/mob"
	socket = require "socket"
	
	udp = socket.udp()
	udp:settimeout(0)
    udp:setsockname('*', 12345)
	
	loadmaps()

    info=true
	
    cursor_x=0
    cursor_y=0
    
	tab_perso = {}
	steve = perso_new("/textures/"..resolution.."/sprite.png",resolution,resolution)
	table.insert(tab_perso,steve )
	
end

function game:draw()
	--love.graphics.setIcon(icone)
	cam:lookAt(math.floor(steve.X1), math.floor(steve.Y1))
	
    if cam.x<love.graphics.getWidth()/2 then
         cam.x = love.graphics.getWidth()/2
    elseif cam.x>steve:getmap():getLX()*resolution-(love.graphics.getWidth()/2) then
         cam.x = steve:getmap():getLX()*resolution-(love.graphics.getWidth()/2)
    end
    if cam.y<love.graphics.getHeight()/2 then
        cam.y = love.graphics.getHeight()/2
    elseif cam.y>steve:getmap():getLY()*resolution-(love.graphics.getHeight()/2) then
         cam.y = steve:getmap():getLY()*resolution-(love.graphics.getHeight()/2)
    end
	
	cam:attach()	 			-- mode camera
    
	steve:getmap():draw(0,0)  	-- afficher map
    
	for k,v in pairs(tab_perso) do
		v:draw() 				-- afficher perso
	end
	steve:getmap():drawdeco(0,0)-- afficher map deco
	
	
	cam:detach()				-- fin du mode camera
	
    if info then
        dispinfo(love.graphics.getWidth()-448,0)	-- cadre info
    end

	
	
end

function game:update(dt)

	udp_data, msg_or_ip, port_or_nil = udp:receivefrom()
	if udp_data then
		print(udp_data, msg_or_ip, port_or_nil)
		if udp_data == "New_game" then
		
			table.insert(tab_perso,perso_new("/textures/"..resolution.."/skin"..#tab_perso..".png",resolution,resolution) )
			udp:sendto("New_game")
		end
	end
	
	
	for k,v in pairs(tab_perso) do
		v:update(dt)  -- update steve
	end
 
		if love.keyboard.isDown( "up" ) then
            steve:GoUp()
        elseif love.keyboard.isDown( "down" ) then
            steve:GoDown()
        elseif love.keyboard.isDown( "left" ) then
            steve:GoLeft()
        elseif love.keyboard.isDown( "right" ) then
           steve:GoRight()
        end
        if love.keyboard.isDown( " " ) then
            steve:use()
        end
		if love.keyboard.isDown("f") then
			finde = true
		else
			finde = false
		end
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
