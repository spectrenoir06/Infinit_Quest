	
function import_data(str)

	data = {}
	
	local datajson = json.decode(love.filesystem.read( str, nil ))
		
	data.tab = {}
	
	for k,v in pairs(datajson.tile) do
		data.tab[tonumber(k)] = v
	end
	
	data.pnj = {}
	
	for k,v in pairs(datajson.pnj) do
		data.pnj[tonumber(k)] = v
		data.pnj[tonumber(k)].talk = loadstring(data.pnj[tonumber(k)].talk_str)
	end
	
	data.obj = {}
	
	for k,v in pairs(datajson.obj) do
		data.obj[tonumber(k)] = v
		data.obj[tonumber(k)].isOn = loadstring(data.obj[tonumber(k)].isOn_str)
	end
end
	
	
	