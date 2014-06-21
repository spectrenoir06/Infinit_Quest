local Server = require "class.Server"
local Perso	 = require "class.Perso"

local Localgame={}
Localgame.__index = Localgame

function Localgame.new(multi,psedo,ip,port)
	local a = {}
	setmetatable(a, Localgame)
	  
	a.players = {}																				-- list de tout les joueurs sur map
	a.psedo = psedo
	a.sync = 0.05
	a.time = 0
	a.globalTime = 0
	
	for i=0,1000 do
		if not love.filesystem.exists( "/log"..i..".txt" ) then
			a.log = ("/log"..i..".txt")
			love.filesystem.write(a.log,"")
			break
		end
	end
	--print("fichier log : "..a.log)
	
	
	if multi then
		a.multi 	= true
		a.server 	= Server.new(ip,port) 															-- ouverture de le connection au serveur
		local tab 	= a.server:login(psedo) 														-- connection au serveur envoit des position perso et reception de la liste des joueurs
		
		for k,v in ipairs(tab.data.players) do
			--print("perso_new",v.skin,v.posX,v.posY,v.map)
			a.players[k] = Perso:new("/textures/64/skin"..v.skin..".png",v.posX,v.posY,v.map)  -- creation des personnages
		end
    
		a.nb = #a.players
		print("nombre de joueurs = "..a.nb)
		a.me = a.players[a.nb] 																	-- pointeur vers mon perso
		a.players[a.nb].name = psedo
	else
		a.mutli = false
		a.players[1] = Perso:new(640,640,"/textures/64/skin0.png",data.map[1]) 							-- creation de l'unique personnage
		a.id = 1
		a.nb = 1
		a.me = a.players[1]
	end
	
	return a

end

function Localgame:new_player(data) 															-- nouveau joueur
	print("new perso",self.player)
	local perso = Perso:new("/textures/64/skin"..data.skin..".png",data.posX,data.posY,data.map)
	table.insert(self.players,perso)
	print("perso new , nombre de joueurs="..#self.players)

end

function Localgame:rem_player(data)
	table.remove(self.players,data.nb)
	print(" nb"..data.nb.." disconnect","nombre de joueurs="..#self.players)

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

	local udpTab = self.server:udpReceive()
	local tcpTab = self.server:tcpReceive()
	
	if tcpTab then
		if self.log then
			love.filesystem.append(self.log, (self.globalTime.."	tcp	"..tcpTab.cmd.."\n"))
		end
		if tcpTab.cmd == "player_join_map" then
			self:new_player(tcpTab.data)
		elseif tcpTab.cmd =="player_exit_map" then
			self:rem_player(tcpTab.data)
		else
			print("cmd tcp inconu",tcpTab.cmd)
		end
	end
	
	if udpTab then
		--print(udpTab.cmd)
		if self.log then
			love.filesystem.append(self.log, (self.globalTime.."	udp	"..udpTab.cmd.."\n"))
		end
		if udpTab.cmd == "update_players_pos" then 	-- recepetion des positions des joueurs ( moi compris )
			self:update_players_pos(udpTab.data) 	-- modification de la position des joueurs ( sauf moi )
		else
			print("cmd udp inconu",udpTab.cmd)
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
	self.time = self.time + dt
	if self.time > self.sync then
		--print("send")
		self.server:send_position(self.me,self.nb)
		self.time = 0
	end
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
	self.globalTime = self.globalTime + dt
	--print(self.globalTime)
	if self.multi then self:receive() end -- reception des donnes serveur
	self:update_players(dt) -- maj des perso
	if self.multi then self:send(dt) end   -- envoit des donne au serveur
end

return Localgame