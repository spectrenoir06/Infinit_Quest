-----------------------------start_screen---------------------------

start_screen = {}

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
		p:setEmitterLifetime(-1)
		p:setParticleLifetime(0.5,2)
		p:setDirection(270)
		p:setSpread(360)
		p:setTangentialAcceleration(0,0)
		p:setRadialAcceleration(0,0)
		p:stop()
	
	Timer.tween(5, pos, {X=love.graphics.getWidth()/2-(avatar:getWidth()/2)}, 'out-back')
	Timer.tween(5, pos, {Y=love.graphics.getHeight()/2-(avatar:getHeight()/2)}, 'bounce')
	
	Timer.add(6,function() gamestate.switch(main_menu) end)	
	
end

function start_screen:draw()
	cam:lookAt(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
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

