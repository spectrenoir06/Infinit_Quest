function load_option()
	resolution = 64  -- taile des tiles
	
    icone=( love.image.newImageData( "icone.png" ) )  -- icone de la fenetre
    love.window.setIcon(icone)

	if love.keyboard.isDown( "up" ) and love.keyboard.isDown( "down" ) then
        mobile=true
	end
end