   
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
	require "/fonction/set_resolution"
	require "/fonction/option"
    ----------------------------------
	
	require "/fonction/data"  
   -- require "/fonction/dataobj"
	
	--G_port = "4321"
	--G_host = "192.168.10.8"
	--require "/android/android"
	
	game = {}
	pause = {}
	main_menu = {}
  
function love.load()
	load_option()
	gamestate.registerEvents()
	cam = camera()
	gamestate.switch(main_menu)
end

-----------------------------Main_menu----------------------------

function main_menu:init()
	fond = love.graphics.newImage("/textures/menu/720/fond.png")
	hero = love.graphics.newImage("/textures/menu/720/hero.png")
	button_start = button_new(1000,150,"/textures/menu/720/barre_start.png")
	button_option = button_new(1000,350,"/textures/menu/720/barre_option.png")
	button_exit = button_new(1000,550,"/textures/menu/720/barre_exit.png")
	Timer.tween(3, button_start, {x=600}, 'out-back')
	Timer.tween(3, button_option, {x=600}, 'out-back')
	Timer.tween(3, button_exit, {x=600}, 'out-back')
end

function main_menu:draw()
	love.graphics.draw( fond, 0, 0)
	love.graphics.draw( hero, -button_start.x+700, 40 )
	button_start:draw()
	button_option:draw()
	button_exit:draw()
end

function main_menu:update(dt)
	Timer.update(dt)
	button_start:update()
	button_option:update()
	button_exit:update()
end

function main_menu:mousepressed(x, y, button)
	if button_start:isPress(x,y,button) then
		print("button start")
		gamestate.switch(game)
	elseif button_option:isPress(x,y,button) then
		print("button option")
	elseif button_exit:isPress(x,y,button) then
		print("button quit")
		love.event.push("quit")
	end
end


------------------------------Game---------------------------------

function game:init()

	cam:attach()
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

	cam:attach()	
	
	--cam:lookAt(steve:getX()-9*resolution, steve:getY()-5.5*resolution)
	cam:lookAt(steve:getX(), steve:getY())
	
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
	
    love.graphics.setIcon(icone)
	
    love.graphics.scale(scale,scale)
    steve:getmap():draw(0,0)
    steve:draw()
	steve:getmap():drawdeco(0,0)
	
	cam:detach()
	
    if info then
        dispinfo(640,0)
    end
    --invent:draw(steve)
    --touchemobil:draw()
    if mobile then
        A_key:draw()
        keypad:draw()
    end
	
end

function game:update(dt)
    --map = steve:getmap()
    steve:update(dt)
    click = love.mouse.isDown( "l" )
 
    if invent:get(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click) then
        steve:setslot(invent:get(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click))
    end   
    if mobile then
        --if touchemobil:isPress(love.mouse.getX( )*scale,love.mouse.getY( )*scale,click) then
        --    mobile=false
        --    love.timer.sleep( 0.5 )
        --end
        touche = keypad:get(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click)
        if touche==1 or not love.keyboard.isDown( "up" ) then
            up=1
        else
            up=0
        end
        if touche == 2 or not love.keyboard.isDown( "down" ) then
            down=1
        else
            down=0
        end
        if touche==3 or not love.keyboard.isDown( "left" ) then
            left=1
        else
            left=0
        end
        if touche==4 or not love.keyboard.isDown( "right" ) then
            right=1
        else
            right=0
        end
        if A_key:isPress(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click) then
            key_a=1
        else
            key_a=0
        end
    else
        --if touchemobil:isPress(love.mouse.getX( )*scale,love.mouse.getY( )*scale,click) then
         --   mobile=true
         --   love.timer.sleep( 0.5 )
       -- end
        if love.keyboard.isDown( "up" ) then
            up=1
        else
            up=0
        end
        if love.keyboard.isDown( "down" ) then
            down=1
        else
            down=0
        end
        if love.keyboard.isDown( "left" ) then
            left=1
        else
            left=0
        end
        if love.keyboard.isDown( "right" ) then
            right=1
        else
            right=0
        end
        if love.keyboard.isDown( " " ) then
            key_a=1
        else
            key_a=0
        end
    end 
end

function game:mousepressed(x, y, button)
	cursor_x , cursor_y = cam:worldCoords(x,y)
    -- cursor_x=(x+camera.x)--/scale
    -- cursor_y=(y+camera.y)--/scale
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
		cam:zoom(1.1)
	end
end

---------------------------------------------------------------------