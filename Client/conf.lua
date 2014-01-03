function love.conf(t)
    t.title = "RPG" 
    t.author = "Spectrenoir"
    t.screen.width =  500	-- The window width (number)
    t.screen.height = 500
    t.screen.fullscreen = false
	t.window.icon = "icone.png"
    t.console = true           -- Attach a console (boolean, Windows only)
	t.screen.vsync = false
    --t.android_native_screen = true
	t.screen.fsaa = 10
end

