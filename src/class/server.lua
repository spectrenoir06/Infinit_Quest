server = {}
server.__index = server

require "enet"

function server_new(ip,port)
  local a = {}
  setmetatable(a, server)
  
  a.host = enet.host_create() -- creation de l'host
  a.server = a.host:connect(ip..":"..port) -- connection a l'host

  while true do
    local event = a.host:service(100) 
    if event then
      if event.type == "connect" then
        print("Connected to", event.peer)
        a.peer = event.peer  -- sauvegarde du server
        return a
      else
        print(event.type)
      end
    end
  end
end

function server:send(cmd,data)
  --print(json.encode({cmd = cmd,data = data}))
  self.peer:send(json.encode({cmd = cmd,data = data}))
end

function server:login(name) 
  self:send("login",{name=name})
  while true do
    local data = self:receive()
    if data then
        return data
    end
  end
end

function server:send_position(perso)
  local cmd = "pos_update"
  local data = {  posX = perso.posX,
                  posY = perso.posY,
                  dir = perso.direction,
                  map = perso:getmapnb(),
                  name = perso.name
                }
  --print(cmd,json.encode(data))                
  self:send(cmd,data)
end

function server:receive(wait)
  repeat
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
  until wait
end

function server:wait(cmd)
  while true do
    local t = self:receive()
    if t then
      if (t.cmd == cmd) then
        return t.data
      else
        print(t.cmd)
      end
    end
  end
end
