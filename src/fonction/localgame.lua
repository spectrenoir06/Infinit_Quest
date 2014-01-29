localgame = {}
localgame.__index = localgame

function create_localgame(multi)
  local a = {}
  setmetatable(a, localgame)
  
  a.players = {}
  
  if multi then
    a.multi = true
    a.server = server_new(localhost,12345) -- ouverture de le connection au serveur
    local tab = a.server:connect(a.me) -- connection au serveur envoit des position perso et reception de la liste des joueurs
    
    for k,v in ipairs(tab.data.players) do
      a.players[k] = perso_new("/textures/64/skin"..v.skin..".png",v.posX,v.posY)  -- creation des personnages
    end
    a.id = tab.data.id -- recuperation de mon id
    a.nb = tab.data.nb -- recuperation de qui je suis dans la liste
    a.me = a.players[nb] -- pointeur vers mon perso
  else
    a.mutli = false
    a.players[1]=perso_new("/textures/64/skin0.png",640,640) -- creation de l'unique personnage
    a.id = 1
    a.nb = 1
    a.me = a.players[1]
  end
  return a
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

function localgame:receive() -- recepetion 
  local tab = self.server:receive()
  if tab then
    if tab.cmd == "update_players_pos" then -- recepetion des positions des joueurs ( moi compris )
       localgame:update_players_pos(data) -- modification de la position des joueurs ( sauf moi )
    end
  end
end

function localgame:update_players(dt) -- update de tout les perso de self.player
  for k,v in pairs(self.players) do
    v:update(dt) -- update perso
  end
end

function localgame:draw_players(dt) -- affichage de tout les perso de self.player
  for k,v in pairs(self.players) do
    v:draw(dt) -- draw perso
  end
end


function localgame:update(dt)
  self:receive()
  
  
end