-----------------------------Main_menu----------------------------

local main_menu = {}

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
		multi = false
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

return main_menu
