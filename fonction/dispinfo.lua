function dispinfo(x,y)
    if x == nil then 
      x=0
    end
    if y == nil then
      y=0
    end
    love.graphics.draw(cache, x+0, 0)
    love.graphics.print("Fps = "..love.timer.getFPS(), x+10, y+10)
    love.graphics.print("map = "..steve:getmap().fichier, x+300, y+10)
    love.graphics.print("Perso X = "..steve:getX(),x+10,y+30)
    love.graphics.print("Perso Y = "..steve:getY(),x+10,y+50)
    love.graphics.print("Perso tileX = "..math.floor(steve:getX()/resolution),x+300,y+30)
    love.graphics.print("Perso tileY = "..math.floor(steve:getY()/resolution),x+300,y+50)
    
    love.graphics.print("Curseur x = "..cursor_x,x+10,y+70)
    love.graphics.print("Curseur y = "..cursor_y,x+10,y+90)
    love.graphics.print("Curseur x = "..math.floor(cursor_x/resolution),x+300,y+70)
    love.graphics.print("Curseur y = "..math.floor(cursor_y/resolution),x+300,y+90)
	
	love.graphics.print("global x = "..(steve.globalPosX/resolution),x+300,y+110)
    love.graphics.print("global y = "..(steve.globalPosY/resolution),x+300,y+125)
	
    
    love.graphics.print("dx = "..steve.dx,x+10,y+110)
    love.graphics.print("dy = "..steve.dy,x+10,y+120)
    love.graphics.print("up = "..up,x+10,y+140)
    love.graphics.print("down = "..down,x+10,y+155)
    love.graphics.print("left = "..left,x+10,y+170)
    love.graphics.print("right = "..right,x+10,y+185)
    love.graphics.print("key_a = "..key_a,x+10,y+200)

    --if  steve:getblock() then
       -- love.graphics.print("Id Sol devant = "..steve:getblock(),x+10,y+230)
   -- end
    --if  steve:getblock(0) then
     --   love.graphics.print("Id sol au pied = "..steve:getblock(0),x+10,y+250)
   -- end
   -- if  steve:getblock() then
       -- local idsol , idblock = steve:getblock()
       -- love.graphics.print("Id block devant = "..idblock,x+150,y+230)
   -- end
    --if  steve:getblock(0) then
    --    local idsol , idblock = steve:getblock(0)
    --    love.graphics.print("Id block au pied = "..idblock,x+150,y+250)
--end 
    
    
    
    
    love.graphics.print("slot de l'inventaire = "..steve:getnbslot(),x+10,y+270)
    
    love.graphics.print("x1 = "..steve.posX-32,x+300,y+270)
    love.graphics.print("y1 = "..steve.posY-32,x+300,y+280)
	
    
    love.graphics.print("camera.x = "..cam.x,x+10,y+290)
    love.graphics.print("camera.y = "..cam.y,x+10,y+310)
    
end