server = {}
server.__index = server

function server_new()
  local a = {}
  setmetatable(a, server)
  
  a.host = enet.host_create()
  a.server = host:connect("localhost:12345")
  
  local done = false
  while not done do
    local event = host:service(100)
    if event then
      if event.type == "connect" then
        print("Connected to", event.peer)
        event.peer:send("hello world")
        done = true
        a.peer = event.peer
      else
      print(event.type)
    end
  end
  return a
end

function server:send_position(perso)
  local tab = {}
  tab.cmd = "pos_update"
  tab.data = {  posX = perso.posX,
                posY = perso.posY,
                dir = perso.direction,
                map = perso:getmapnb(),
             }
  self.peer:send(json.encode(tab))
end
