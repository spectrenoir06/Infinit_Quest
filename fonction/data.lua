	
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
	end
	
--------------------------------------------------------------------------------------------------------------
	
	data.obj = {}
	
	local data_obj_json = json.decode(love.filesystem.read( "data/data_obj.json", nil ))
	
	for k,v in pairs(data_obj_json) do
		data.obj[tonumber(k)] = v
		data.obj[tonumber(k)].isOn = loadstring(data.obj[tonumber(k)].isOn_str)
	end
	
--------------------------------------------------------------------------------------------------------------
	
	
	