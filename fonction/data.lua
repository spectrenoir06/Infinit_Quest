	
	data = {}
	
--------------------------------------------------------------------------------------------------------------
	
	data.tab = {}

	local datajson = love.filesystem.read( "data/data.json", nil )
	local jsontab = json.decode(datajson)
	
	for k,v in pairs(jsontab) do
		data.tab[tonumber(k)] = v
	end
	
--------------------------------------------------------------------------------------------------------------
	
	data.pnj = {}
	
	local data_pnj_json = json.decode(love.filesystem.read( "data/data_pnj.json", nil ))
	
	for k,v in pairs(data_pnj_json) do
		data.pnj[tonumber(k)] = v
		data.pnj[tonumber(k)].talk = loadstring(data.pnj[tonumber(k)].talk_str)
		print("test")--data.pnj[tonumber(k)].talk_str)
	end
	
--------------------------------------------------------------------------------------------------------------
	
	
	
	