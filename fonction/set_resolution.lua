
function set_resolution(res)
	if res == 64 then
		--love.graphics.setMode( 20*res, 11.25*res)
		scale = 1
	elseif res== 32 then
		love.graphics.setMode( 25*res, 15*res,false, true, 0 )
		scale = 1.25
	elseif res== 40 then
		love.graphics.setMode( 20*res, 12*res,false, true, 0 )
		scale =1
	end
end