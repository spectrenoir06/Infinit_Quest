server = {}
server.__index = server

function server_new(ip,port)
  local a = {}
  setmetatable(a, server)
  
  a.host = enet.host_create()
  a.server = a.host:connect(ip..":"..port)
  
  local done = false
  while not done do
    local event = host:service(100)
    if event then
      if event.type == "connect" then
        print("Connected to", event.peer)
        done = true
        a.peer = event.peer
      else
        print(event.type)
      end
    end
  end
  return a
end

function server:send(cmd,data)
  print(json.encode({cmd = cmd,data = data}))
  self.peer:send(json.encode({cmd = cmd,data = data}))
end

function server:connect(perso)
  local cmd = "connect"
  local data = {  posX = perso.posX,
                  posY = perso.posY,
                  dir = perso.direction,
                  skin = perso.skin,
                  map = perso:getmapnb(),
                }                
  self:send(cmd,data)
  local done = false
  while not done do
    local event = a.host:service(100)
    if event then
      if event.type == "receive" then
        print("receive from", event.peer)
        return json.decode(event.data) -- cmd = "connection" , data = { num = int , id = int , players = {} }
      else
        print(event.type)
      end
    end
  end
end

function server:send_position(perso)
  local cmd = "pos_update"
  local data = {  posX = perso.posX,
                  posY = perso.posY,
                  dir = perso.direction,
                  map = perso:getmapnb(),
                }                
  self:send(cmd,data)
end

function server:receive()
  local event = self.host:service()
  if event and event.type == "receive" then
    return json.decode(event.data)
  else
    return false
  end
end
