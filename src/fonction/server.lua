server = {}
server.__index = server

require "enet"

function server_new(ip,port)
  local a = {}
  setmetatable(a, server)
  
  a.host = enet.host_create()
  a.server = a.host:connect(ip..":"..port)
  
  local done = false
  while not done do
    local event = a.host:service(100)
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
  --print(json.encode({cmd = cmd,data = data}))
  self.peer:send(json.encode({cmd = cmd,data = data}))
end

function server:connect(name)
  local cmd = "connect"
  local data = {  name = name }                
  self:send(cmd,data)
  while true do
    data = self:receive()
    if data then
        return data
    end
  end
end

function server:send_position(perso,nb)
  local cmd = "pos_update"
  local data = {  posX = perso.posX,
                  posY = perso.posY,
                  dir = perso.direction,
                  map = perso:getmapnb(),
                  nb = nb
                }
  --print(cmd,json.encode(data))                
  self:send(cmd,data)
end

function server:receive()
  local event = self.host:service()
  if event then
    if event.type == "receive" then
    --print(event.data)
      return json.decode(event.data)
    elseif event.type == "disconnect" then
      error("server disconnect")
    else
      print(event.type)
      return false
    end
  else
    return false
  end
end

function server:sendAndWait(cmd,data,rep)
  print(self.peer)
  self:send(cmd,data)
  while true do
    local t = self:receive()
    if t then
      if not rep or (t.cmd == rep) then
        return t.data
      end
    end
  end
end
