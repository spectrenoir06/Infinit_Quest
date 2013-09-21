	data = {}
	data.tab = {}

	
	local datajson = love.filesystem.read( "data/data.json", nil )
	local jsontab = json.decode(datajson)
	for k,v in pairs(jsontab) do
		data.tab[tonumber(k)] = v
	end