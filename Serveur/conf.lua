function love.conf(t)
    t.title = "Serveur" 
    t.author = "Spectrenoir"
    t.screen.width =  480	-- The window width (number)
    t.screen.height = 240
    t.screen.fullscreen = false
    t.console = true           -- Attach a console (boolean, Windows only)
	t.screen.vsync = false
    --t.android_native_screen = true
	t.screen.fsaa = 10
end
