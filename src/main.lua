---test   
	------------- LIB ----------------

	require "/lib/spectre/map_json"
	require "/lib/spectre/button" 
	camera = require "/lib/hump/camera"
	gamestate = require "/lib/hump/gamestate"
	Timer = require "/lib/hump/timer"
	Grid = require "lib.jumper.grid"
	Pathfinder = require "lib.jumper.pathfinder"
	require("lib/json/json")
	----------------------------------
	
	--------function------------------
	--require "/fonction/option"
	require "/fonction/data"
	require "/fonction/start_screen"
	require "/fonction/main_menu" 
	require "/fonction/option"
	require "/fonction/game"
	require "/fonction/pause"
    ----------------------------------

		resolution = 64
		if love.system.getOS()=="Android" then
		  mobile = true
		end
		
		function printT(tab)
		  print(json.encode(tab))
		end
  
function love.load(arg)

	gamestate.registerEvents()
	cam = camera()
	--gamestate.switch(start_screen)
	gamestate.switch(game)
end




---------------------------------------------------------------------
