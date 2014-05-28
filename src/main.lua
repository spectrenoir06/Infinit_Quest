Map         = require "lib.spectre.map_json"
button      = require "lib.spectre.button" 
Camera      = require "lib.hump.camera"
Gamestate   = require "lib.hump.gamestate"
Timer       = require "lib.hump.timer"
Grid        = require "lib.jumper.grid"
Pathfinder  = require "lib.jumper.pathfinder"

require "class.data"
data = import_data("data/data.json")-- global data

	
require "gameState.StartScreen"		-- GameState_StartScreen
require "gameState.MainMenu" 		-- GameState_MainMenu
require "gameState.Option"			-- GameState_Option
require "gameState.Game"			-- GameState_Game
require "gameState.Pause"			-- GameState_Pause
  
resolution = 64

media = { images={}, musics={}, sounds={} }
		
		
if love.system.getOS()=="Android" then mobile = true end
		
function love.load(arg)
  
	Gamestate.registerEvents()
	
	cam = Camera()
	Gamestate.switch(GameState_Game)

end