function dispinfo(x,y)
    if x == nil then 
      x=0
    end
    if y == nil then
      y=0
    end
    love.graphics.draw(cache, x+0, 0)
    love.graphics.print("Fps = "..love.timer.getFPS(), x+10, y+10)
    love.graphics.print("OS = "..love.system.getOS( ), x+100, y+10)
    love.graphics.print("map = "..localgame.me:getmap().fichier, x+300, y+10)
    love.graphics.print("Perso X1 = "..localgame.me.X1,x+10,y+30)
    love.graphics.print("Perso Y1 = "..localgame.me.Y1,x+10,y+50)
    love.graphics.print("Perso tileX = "..localgame.me.X1/resolution,x+300,y+30)
    love.graphics.print("Perso tileY = "..localgame.me.Y1/resolution,x+300,y+50)
    
    local cursor_x , cursor_y = cam:worldCoords(love.mouse.getX(),love.mouse.getY())
    
    love.graphics.print("Curseur x = "..cursor_x,x+10,y+70)
    love.graphics.print("Curseur y = "..cursor_y,x+10,y+90)
    love.graphics.print("Curseur x = "..math.floor(cursor_x/resolution),x+300,y+70)
    love.graphics.print("Curseur y = "..math.floor(cursor_y/resolution),x+300,y+90)
	
	love.graphics.print("global x = "..(localgame.me.globalPosX/resolution),x+300,y+110)
    love.graphics.print("global y = "..(localgame.me.globalPosY/resolution),x+300,y+125)
	
    
    love.graphics.print("dx = "..localgame.me.dx,x+10,y+110)
    love.graphics.print("dy = "..localgame.me.dy,x+10,y+120)
	
	love.graphics.print("rot = "..cam.rot.." rad",x+10,y+150)
	love.graphics.print("rot = "..(cam.rot/math.pi) * 180  .." °",x+10,y+165)
	
	--love.graphics.print("dist = "..dist(localgame.me.posX,localgame.me.posY,monster.X,monster.Y)/resolution,x+10,y+180)
	
    -- love.graphics.print("up = "..up,x+10,y+140)
    -- love.graphics.print("down = "..down,x+10,y+155)
    -- love.graphics.print("left = "..left,x+10,y+170)
    -- love.graphics.print("right = "..right,x+10,y+185)
    -- love.graphics.print("key_a = "..key_a,x+10,y+200)

    --if  localgame.me:getblock() then
       -- love.graphics.print("Id Sol devant = "..localgame.me:getblock(),x+10,y+230)
   -- end
    --if  localgame.me:getblock(0) then
     --   love.graphics.print("Id sol au pied = "..localgame.me:getblock(0),x+10,y+250)
   -- end
   -- if  localgame.me:getblock() then
       -- local idsol , idblock = localgame.me:getblock()
       -- love.graphics.print("Id block devant = "..idblock,x+150,y+230)
   -- end
    --if  localgame.me:getblock(0) then
    --    local idsol , idblock = localgame.me:getblock(0)
    --    love.graphics.print("Id block au pied = "..idblock,x+150,y+250)
--end 
    
    
    
    
    love.graphics.print("slot de l'inventaire = "..localgame.me:getnbslot(),x+10,y+270)
    
    love.graphics.print("x1 = "..localgame.me.X1,x+300,y+270)
    love.graphics.print("y1 = "..localgame.me.Y1,x+300,y+280)
	love.graphics.print("x2 = "..localgame.me.X2,x+300,y+295)
    love.graphics.print("y2 = "..localgame.me.Y2,x+300,y+305)
	
    
    love.graphics.print("camera.x = "..cam.x,x+10,y+290)
    love.graphics.print("camera.y = "..cam.y,x+10,y+310)
    
end