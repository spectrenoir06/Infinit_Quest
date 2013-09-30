   
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
	gamestate.switch(start_screen)
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
	
	Timer.tween(5, pos, {X=love.graphics.getWidth()/2-avatar:getWidth()/2}, 'out-back')
	Timer.tween(5, pos, {Y=love.graphics.getHeight()/2-avatar:getHeight()/2}, 'bounce')
	
	Timer.add(6,function() gamestate.switch(main_menu) end)	
	
end

function start_screen:draw()
	cam:lookAt(1280/2,720/2)
	cam:attach()
	love.graphics.draw( start, 0, 0)
	p:setPosition(pos.X+avatar:getWidth()/2,pos.Y+avatar:getHeight()/2)
	love.graphics.draw(p, 0, 0)
	love.graphics.draw( avatar, pos.X , pos.Y  )
	p:start()
	--p:setPosition(steve.posX, steve.posY)
	cam:detach()
end

function start_screen:update(dt)
	Timer.update(dt)
	p:update(dt)
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

	love.audio.stop(intro_music)
	music = love.audio.newSource("/music/main.mp3")
	love.audio.play(music)

	cam:zoomTo(1)
	p = love.graphics.newParticleSystem( love.graphics.newImage("/textures/flame.png"), 200 )
	p:setEmissionRate(1000)
	p:setSpeed(300, 400)
	p:setSizes(2, 1)
	p:setColors(220, 105, 20, 255, 194, 30, 18, 0)
	p:setPosition(400, 300)
	p:setLifetime(0.1)
	p:setParticleLife(0.2)
	p:setDirection(0)
	p:setSpread(360)
	p:setTangentialAcceleration(1000)
	p:setRadialAcceleration(-2000)
	p:stop()
	
	
    import_data("/data/data.json")
	
    require "/fonction/perso"
    require "/fonction/dispinfo"  
    require "/fonction/Itemsprite"  
    require "/fonction/pnj"
	--require "/map/mapinfo"
	
	loadmaps()
    --love.graphics.setMode( 16*resolution, 9*resolution)
    info=true
    up,down,left,right=0,0,0,0
    move=false
    cursor_x=0
    cursor_y=0
    
    
    steve = perso_new("/textures/"..resolution.."/sprite.png",resolution,resolution) --,data.map[1]["map"])
    
    inventaire = invsprite_new("/textures/"..resolution.."/tileset.png",resolution,resolution)
    map = steve:getmap()
    
    cache = love.graphics.newImage("/textures/"..resolution.."/cache.png")
    
    --love.audio.play(steve.map.music)
    invent = inv_new(5.375*resolution,10*resolution,"/textures/"..resolution.."/inv.png")
    --touchemobil = button_new(432*(resolution/32),16*(resolution/32),"/textures/mobil"..resolution..".png")
    A_key = button_new(16*resolution,9*resolution,"/textures/"..resolution.."/A.png")
    keypad = keypad_new(0.30*resolution,8*resolution,"/textures/"..resolution.."/key.png")
    touche=0
    mouse_x=0
    mouse_y=0
    click=0
   
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
    steve:draw() 				-- afficher perso
	steve:getmap():drawdeco(0,0)-- afficher map deco
	love.graphics.draw(p, 0, 0)	-- afficher particule
	cam:detach()				-- fin du mode camera
	
    if info then
        dispinfo(love.graphics.getWidth()-448,0)	-- cadre info
    end
    --invent:draw(steve)
    --touchemobil:draw()
    if mobile then -- aff touche mobil
        A_key:draw()
        keypad:draw()
    end
	
end

function game:update(dt)

    steve:update(dt)  -- update steve
	p:update(dt) --update particule
	
    local click , cursor_x , cursor_y = love.mouse.isDown( "l" ) , cam:worldCoords(love.mouse.getX(),love.mouse.getY())  -- detection du click souris
 
    if invent:get(love.mouse.getX( ),love.mouse.getY( ),click) then
        steve:setslot(invent:get(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click))
    end   
	
    if mobile then -- mode tactile mobil
        local touche = keypad:get(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click)
        if touche==1 then
            steve:GoUp()
        elseif touche == 2 then
            steve:GoDown()
        elseif touche==3 then 
            steve:GoLeft()
        elseif touche==4 then
            steve:GoRight()
		end
		
        if A_key:isPress(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click) then
            steve:use()
        end
    else -- mode clavier
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
		p:start()
		p:setPosition(steve.posX, steve.posY)
	end
	
	if key=="escape" then
		love.event.push("quit")
	end
	
	if key=="o" then
		cam:rotate(math.pi/8)
	end


end

---------------------------------------------------------------------