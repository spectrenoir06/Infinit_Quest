require "lib.json.json"

function import_data(str)

	a = {}
	
	local data_json = json.decode(love.filesystem.read( str, nil ))
	local data_tileInfo = json.decode(love.filesystem.read( "/data/tileInfo.json", nil ))
	
	
	a.map = {} 						-- info map, position, fichier ...
	
	for k,v in pairs(data_json.map) do
		print(v.fichier)
		a.map[tonumber(k)] = v		-- copie data_json.map dans data.map
	end
	
	
	a.tab = {}						-- info tiles
	
	for k,v in pairs(data_tileInfo) do
		a.tab[tonumber(k)] = v
	end
	
	
	a.pnj = {}						-- info pnj
	
	for k,v in pairs(data_json.pnj) do
		a.pnj[tonumber(k)] = v
		a.pnj[tonumber(k)].talk = loadstring(a.pnj[tonumber(k)].talk_str) -- convertion talk_str to function talk
	end
	
	a.obj = {}
	
	for k,v in pairs(data_json.obj) do
		a.obj[tonumber(k)] = v
		a.obj[tonumber(k)].isOn = loadstring(a.obj[tonumber(k)].isOn_str) -- convertion isOn_str to function isOn
	end
	
	return a
end