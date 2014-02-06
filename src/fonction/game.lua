------------------------------Game---------------------------------


game = {}

function game:init()

	--love.audio.stop(intro_music)
	--music = love.audio.newSource("/music/main.mp3")
	--love.audio.play(music)

	cam:zoomTo(1)
	if not mobile then
		p = love.graphics.newParticleSystem( love.graphics.newImage("/textures/flame.png"), 200 )
		p:setEmissionRate(1000)
		p:setSpeed(300, 400)
		p:setSizes(2, 1)
		p:setColors(220, 105, 20, 255, 194, 30, 18, 0)
		p:setPosition(400, 300)
		p:setEmitterLifetime(0.1)
		p:setParticleLifetime(0.2)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(1000)
		p:setRadialAcceleration(-2000)
		p:stop()
	end
	
  import_data("/data/data.json")
  require "/fonction/perso"
  require "/fonction/dispinfo"  
  require "/fonction/Itemsprite"  
  require "/fonction/pnj"
  require "/fonction/mob"
  require "/fonction/localgame"
  require "/fonction/clients"
  require "/fonction/server"
  loadmaps()
  
  multi= true

  localgame = create_localgame(multi)

      --[[
	local_clients = clients_new()
	
  	if multi then
  		while 1 do
  			event = host:service(100)
  			if event then
  				print(event.type,event.data)
  				if event.type == "connect" then
  					event.peer:send(json.encode( { cmd = "connect" , data = {name = "Antoine"}} ))
  				elseif event.type == "receive" then
  					local tab = json.decode(event.data)
  					if tab.cmd == "new_player" then
  						local id = table.getn(tab.data)
  						clients:set_main_client(id)
  						for i=1,id do
  							print("newplayer",rep_data)
  							local_clients:add(tab.data[i])
  						end
  						break
  					end
  				end
  			end
  		end
  	else
  		local tab = {map=1,name="Antoine",skin=0,id=1,dir=1,posY=640,posX=640}
  		local_clients:add(tab)
  		clients:set_main_client(1)
  	end
    ]]--
    info=true
	
    --cursor_x=0
   --cursor_y=0
    
    inventaire = invsprite_new("/textures/"..resolution.."/tileset.png",resolution,resolution)
    cache = love.graphics.newImage("/textures/"..resolution.."/cache.png")
    --invent = inv_new(5.375*resolution,10*resolution,"/textures/"..resolution.."/inv.png")
    A_key = button_new(16*resolution,9*resolution,"/textures/"..resolution.."/A.png")
    keypad = keypad_new(0.30*resolution,8*resolution,"/textures/"..resolution.."/key.png")
    
end

function game:draw()
	--love.graphics.setIcon(icone)
	cam:lookAt(math.floor(localgame.me.X1), math.floor(localgame.me.Y1))
	
    if cam.x<love.graphics.getWidth()/2 then
         cam.x = love.graphics.getWidth()/2
    elseif cam.x>localgame.me:getmap():getLX()*resolution-(love.graphics.getWidth()/2) then
         cam.x = localgame.me:getmap():getLX()*resolution-(love.graphics.getWidth()/2)
    end
    if cam.y<love.graphics.getHeight()/2 then
        cam.y = love.graphics.getHeight()/2
    elseif cam.y>localgame.me:getmap():getLY()*resolution-(love.graphics.getHeight()/2) then
         cam.y = localgame.me:getmap():getLY()*resolution-(love.graphics.getHeight()/2)
    end
	
	cam:attach()	 			-- mode camera
    
	localgame.me:getmap():draw(0,0)  	-- afficher map
	localgame:draw()
	localgame.me:getmap():drawdeco(0,0)-- afficher map deco
	

	-- if monster.nodes then
		-- for count, node in pairs(monster.nodes) do
			-- love.graphics.setPointSize( 20 )
			-- love.graphics.setColor( 0, 0, 255)
			-- if count>1 then
				-- love.graphics.line( node:getX()*64+32, node:getY()*64+32, monster.nodes[count-1]:getX()*64+32, monster.nodes[count-1]:getY()*64+32)
			-- end
			-- if count == 2 then
				-- love.graphics.setColor( 255, 0, 0)
			-- end
			-- love.graphics.point( node:getX()*64+32, node:getY()*64+32 )
			-- love.graphics.setColor(255, 255, 255)
		-- end
	-- end
	-- for k,v in ipairs(tab_perso) do
		-- love.graphics.print(k.." : X="..v.posX.."  ;  Y="..v.posY.." ; map="..v.mapnb, 10,15*k+10)
	-- end
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

	--[[if multi then
		local event = host:service(100)
		if event and event.type == "receive" then
			local_clients:receive(event.data)
		end
	end]]--
	
    localgame:update(dt)
	
    local click , cursor_x , cursor_y = love.mouse.isDown( "l" ) , cam:worldCoords(love.mouse.getX(),love.mouse.getY())  -- detection du click souris
 
    --if invent:get(love.mouse.getX(),love.mouse.getY(),click) then
    --    localgame.me:setslot(invent:get(love.mouse.getX( )/scale,love.mouse.getY( )/scale,click))
    --end   
	
    if mobile then -- mode tactile mobil
        local touche = keypad:get(love.mouse.getX(),love.mouse.getY(),click)
		--print(touche)
        if touche==1 then
             localgame.me:GoUp()
        elseif touche == 2 then
             localgame.me:GoDown()
        elseif touche==3 then 
             localgame.me:GoLeft()
        elseif touche==4 then
             localgame.me:GoRight()
		end
		
        if A_key:isPress(love.mouse.getX(),love.mouse.getY(),click) then
            localgame.me:use()
        end
    else -- mode clavier
        if love.keyboard.isDown( "up" ) then
            localgame.me:GoUp()
        elseif love.keyboard.isDown( "down" ) then
            localgame.me:GoDown()
        elseif love.keyboard.isDown( "left" ) then
            localgame.me:GoLeft()
        elseif love.keyboard.isDown( "right" ) then
             localgame.me:GoRight()
        end
        if love.keyboard.isDown( " " ) then
            localgame.me:use()
        end
    end
end

function game:mousepressed(x, y, button)

end
    
function game:keypressed(key)	
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
			p:setPosition(localgame.me.posX, localgame.me.posY)
		end
	end
	
	if key=="escape" then
		love.event.push("quit")
	end
	
	if key=="o" then

	end

end
