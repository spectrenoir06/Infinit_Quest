local Server = require "class.server"
local Perso	 = require "class.Perso"

local Localgame={}
Localgame.__index = Localgame

function Localgame.new(multi,psedo,host,port)
	local a = {}
	setmetatable(a, Localgame)
	  
	a.players = {}																				-- list de tout les joueurs sur map
	a.psedo = psedo
	
	if multi then
		a.multi = true
		a.server = Server:new(host,port) 														-- ouverture de le connection au serveur
		local tab = a.server:login(psedo) 														-- connection au serveur envoit des position perso et reception de la liste des joueurs
    
		for k,v in ipairs(tab.data.players) do
			--print("perso_new",v.skin,v.posX,v.posY)
			a.players[k] = perso_new("/textures/64/skin"..v.skin..".png",v.posX,v.posY,v.map)  -- creation des personnages
		end
    
		a.nb = #a.players
		print("nombre de joueurs = "..a.nb)
		a.me = a.players[a.nb] 																	-- pointeur vers mon perso
		a.players[a.nb].name = psedo
	else
		a.mutli = false
		a.players[1] = Perso.new("/textures/64/skin0.png",640,640,1) 								-- creation de l'unique personnage
		a.id = 1
		a.nb = 1
		a.me = a.players[1]
	end
	
	return a

end

function Localgame:new_player(data) 															-- nouveau joueur

	local perso = Perso.new("/textures/64/skin"..data.skin..".png",data.posX,data.posY,data.map)
	table.insert(self.players,perso)
	print("perso new , nombre de joueurs="..#self.players)

end

function Localgame:rem_player(data) 															-- rm joueur

	table.remove(self.players,data.nb)
	print("player "..data.nb.." disconnect","nombre de joueurs="..#self.players)

end

function Localgame:update_players_pos(data) -- rempli self.players avec le contenue de data sauf "me"
    
	for k,v in ipairs(data) do
		--print(json.encode(v))
		if self.nb~=k then
			self.players[k]:setPosX(v.posX)
			self.players[k]:setPosY(v.posY)
			self.players[k]:setdirection(v.dir)
		end
	end

end

function Localgame:receive() -- recepetion 

	local tab = self.server:receive()
	if tab then
		--print(tab.cmd,tab.data)
		if tab.cmd == "update_players_pos" then -- recepetion des positions des joueurs ( moi compris )
			Localgame:update_players_pos(tab.data) -- modification de la position des joueurs ( sauf moi )
		elseif tab.cmd =="player_join_map" then
			Localgame:new_player(tab.data)
		elseif tab.cmd =="player_exit_map" then
			Localgame:rem_player(tab.data)
		else
			print("cmd inconu",tab.cmd)
		end
	end

end

function Localgame:update_players(dt) -- update de tout les perso de self.player
	
	for k,v in pairs(self.players) do
		v:update(dt) -- update perso
	end
	
end

function Localgame:draw() -- affichage de tout les perso de self.player

	for k,v in pairs(self.players) do
		v:draw() -- draw perso
	end

end

function Localgame:send(dt) -- envoit ma nouvelle position
	self.server:send_position(self.me,self.nb)
end

function Localgame:changeMap()
	local cmd = "change_map"
	local data=	{	posX = self.me.posX,
					posY = self.me.posY,
					dir  = self.me.direction,
					map  = self.me:getmapnb(),
					name = self.me.name
				}
               
	self.server:send(cmd,data)
	local tab = self.server:wait("join_map")
	--print(json.encode(tab))   
	self.players = {}
   
	for k,v in ipairs(tab.players) do
		self.players[k] = perso_new("/textures/64/skin"..v.skin..".png",v.posX,v.posY,v.map)  -- creation des personnages
	end
   
	self.nb = #self.players
	print("nombre de joueurs sur nouvelle map = "..self.nb)
	self.me = self.players[self.nb] -- pointeur vers mon perso
	self.me.name = self.psedo
   
end

function Localgame:update(dt)
	if self.multi then self:receive() end -- reception des donnes serveur
	self:update_players(dt) -- maj des perso
	if self.multi then self:send(dt) end   -- envoit des donne au serveur
end

return Localgame