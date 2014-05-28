------------- LIB ----------------
	Map         = require "lib.spectre.map_json"
	button      = require "lib.spectre.button" 
	camera      = require "lib.hump.camera"
	gamestate   = require "lib.hump.gamestate"
	Timer       = require "lib.hump.timer"
	Grid        = require "lib.jumper.grid"
	Pathfinder  = require "lib.jumper.pathfinder"
	require("lib/json/json")
----------------------------------

	require "/fonction/data"
	
  start_screen  = require "gameState.start_screen"
	main_menu     = require "gameState.main_menu" 
	option        = require "gameState.option"
	game          = require "gameState.game"
  pause         = require "gameState.pause"
  
	resolution = 64
   
   
if love.system.getOS()=="Android" then mobile = true end
		
function printT(tab) print(json.encode(tab)) end
  
function love.load(arg)
  
	gamestate.registerEvents()
	cam = camera()
	--gamestate.switch(start_screen)
	gamestate.switch(game)

end