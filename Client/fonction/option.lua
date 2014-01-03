function load_option()
	resolution = 64  -- taile des tiles

	if love.keyboard.isDown( "up" ) and love.keyboard.isDown( "down" ) then
        mobile=true
	end
end