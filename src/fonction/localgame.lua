localgame = {}
localgame.__index = localgame

function create_localgame(multi)
  local a = {}
  setmetatable(a, localgame)
  
  a.players = {}
  
  if multi then
    a.multi = true
    a.server = server_new("192.168.10.3","12345") -- ouverture de le connection au serveur
    local tab = a.server:connect("spectre") -- connection au serveur envoit des position perso et reception de la liste des joueurs
    
    for k,v in ipairs(tab.data.players) do
      a.players[k] = perso_new("/textures/64/skin"..v.skin..".png",v.posX,v.posY)  -- creation des personnages
    end
    a.id = tab.data.id -- recuperation de mon id
   
    a.nb = #a.players
     print("nombre de joueurs = "..a.nb)
    a.me = a.players[a.nb] -- pointeur vers mon perso
  else
    a.mutli = false
    a.players[1]=perso_new("/textures/64/skin0.png",640,640) -- creation de l'unique personnage
    a.id = 1
    a.nb = 1
    a.me = a.players[1]
  end
  return a
end

function localgame:new_player(data) -- nouveau joueur
    local perso = perso_new("/textures/64/skin"..data.skin..".png",data.posX,data.posY)
    table.insert(self.players,perso)
    print("nombre de joueurs="..#self.players)
end

function localgame:rem_player(data) -- nouveau joueur
    table.remove(self.players,data.nb)
    print("player "..data.nb.."disconnect")
    print("nombre de joueurs="..#self.players)
end

function localgame:update_players_pos(data) -- rempli self.players avec le contenue de data sauf "me"
    for k,v in ipairs(data) do
      --print(json.encode(v))
      if self.nb~=k then
        self.players[k]:setPosX(v.posX)
        self.players[k]:setPosY(v.posY)
        self.players[k]:setdirection(v.dir)
      end
    end
end

function localgame:receive() -- recepetion 
  local tab = self.server:receive()
  if tab then
    --print(tab.cmd,tab.data)
    if tab.cmd == "update_players_pos" then -- recepetion des positions des joueurs ( moi compris )
       localgame:update_players_pos(tab.data) -- modification de la position des joueurs ( sauf moi )
    elseif tab.cmd =="new_player" then
       localgame:new_player(tab.data)
    elseif tab.cmd =="player_disconnect" then
       localgame:rem_player(tab.data)
    else
      print("cmd inconu",tab.cmd)
    end
  end
end

function localgame:update_players(dt) -- update de tout les perso de self.player
  for k,v in pairs(self.players) do
    v:update(dt) -- update perso
  end
end

function localgame:draw() -- affichage de tout les perso de self.player
  for k,v in pairs(self.players) do
    v:draw() -- draw perso
  end
end

function localgame:send(dt) -- envoit ma nouvelle position
  self.server:send_position(self.me,self.nb)
end


function localgame:update(dt)
  if self.multi then self:receive() end -- reception des donnes serveur
  self:update_players(dt) -- maj des perso
  if self.multi then self:send(dt) end   -- envoit des donne au serveur
end