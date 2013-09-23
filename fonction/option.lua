function load_option()

	resolution = 64  -- taile des tiles
    icone=( love.graphics.newImage( "icone.png" ) )  -- icone de la fenetre
    love.graphics.setIcon(icone)

	if love.keyboard.isDown( "up" ) and love.keyboard.isDown( "down" ) then
        mobile=true
		scale = 1
    else
		set_resolution(resolution)
	end
end