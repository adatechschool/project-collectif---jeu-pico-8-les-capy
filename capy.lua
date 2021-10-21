function _init()
		create_player()
		create_enemy()
 end

function _update()
	player_movement()
	update_camera()
	move_hori()
	palt(0,true)
end
 
function _draw()
		cls()
		draw_map()
		draw_player()
		draw_enemy()
		draw_ui()
	end

-- map

function draw_map()
 	palt(0,true)
 	map(0,0,0,0,128,64)
end
 
function check_flag(flag,x,y)
	 local sprite=mget(x,y)
	 return fget(sprite,flag)
	end
	
function update_camera()
    local map_width = 127
    local map_height = 63
    local camx = mid(0, (p.x - 7.5) * 8 + p.ox, (map_width - 15) * 8)
    local camy = mid(0, (p.y - 7.5) * 8 + p.oy, (map_height - 15) * 8)
    camera(camx, camy)
	end

-- player

function create_player()
	p={
		x=4,
		y=4,
		sprite=1,
		speed=1,
		max_speed=2,
		w=8,
		h=7,
		ox=0,
		oy=0,
		start_ox=0,
		start_oy=0,
		anim_t=0,
		keys=0,
		mate=0
		}
end

function draw_player()
 spr(p.sprite,p.x*8+p.ox,p.y*8+p.oy,
 1,1,p.flip,p.flip2)
end
 
function player_movement()
  newx = p.x
  newy = p.y
   if p.anim_t == 0 then
   newox = 0
   newoy = 0
   if btn(⬅️) then
            newx -= p.speed
            newox = 8*p.speed
            p.flip=true
            p.flip2=false
   elseif btn(➡️) then
            newx += p.speed
            newox = -8*p.speed
            p.flip=false
            p.flip2=false
   elseif btn(⬆️) then
            newy -= p.speed
            newoy = 8*p.speed
            p.flip2=false
   elseif btn(⬇️) then
            newy += p.speed
            newoy = -8*p.speed
            p.flip2=true
  end
    end 
		
		if (newx!=p.x or newy!=p.y) and
		not check_flag(0, newx, newy)
		then
  p.x=mid(0, newx, 127)
  p.y=mid(0,newy, 63)
  p.start_ox=newox
  p.start_oy=newoy
  p.anim_t=1
 	end
 	p.anim_t=max(p.anim_t-0.125,0)
 	p.ox=p.start_ox*p.anim_t
 	p.oy=p.start_oy*p.anim_t
 	
 	if p.anim_t>=0.5
 		then if btn(➡️) or btn(⬅️)
 				then p.sprite=2
 		elseif btn(⬆️) or btn(⬇️)
 				then p.sprite=4
 		end
 	elseif btn(➡️) or btn(⬅️)
 		then p.sprite=1
 	elseif btn(⬆️) or btn(⬇️)
 		then p.sprite=3
 	end
		
		interact_key(newx,newy)
		interact_mate(newx,newy)
		
	end	 

-- ennemies 

function create_enemy()
		e={
		sprite=20,
		x=13,
		y=4,
		isleft = true 
		}
end

function draw_enemy()
	 spr(e.sprite,e.x*8,e.y*8)
end

function move_hori()
	local nx=e.x
	local ny=e.y
	if e.isleft then nx-=0.4
	else nx+=0.4
	end
	e.x=nx
 e.y=ny
 if check_flag(0,(e.x-1),(e.y))
 then e.isleft = false
 else if check_flag(0,(e.x+1),(e.y))
 then e.isleft = true
 end
 end
end 

function move_left()
 if not check_flag(0,(e.x-1),(e.y))
 then nx-=1
	e.x=nx
 e.y=ny
 end
end 

function move_right()
	local nx=e.x
	local ny=e.y
 nx+=1
	e.x=nx
 e.y=ny
end

--interactions objets 

function next_tile(x,y)
	local sprite = mget(x,y)
	mset(x,y,sprite+1)
end 

-- interaction cle

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	--ajouter sfx
end

function interact_key(x,y)
	if check_flag(1,x,y) 
	then pick_up_key(x,y)
	elseif check_flag(2,x,y)
	and p.keys > 0
	then open_door(x,y)
	end
end

function open_door(x,y)
	next_tile(x,y)
	p.keys-=1
end 

-- interaction mate 

function pick_up_mate(x,y)
	next_tile(x,y)
	p.mate+=1
	--ajouter sfx
end

function interact_mate(x,y)
	if check_flag(3,x,y) 
	then pick_up_mate(x,y)
	elseif check_flag(4,x,y)
	and p.mate > 0
	then trash_down(x,y)
	end
--ajouter sfx 
end

function trash_down(x,y)
	next_tile(x,y)
	p.mate-=1
end 

--user interface 

function draw_ui()
	camera()
	palt(7, true)
	palt(6, true)
	palt(0,false)
	spr(52,2,2)
	spr(13,20,2)
	palt()
	print_outline("𝘹"..p.keys,10,2,7)
	print_outline("𝘹"..p.mate,28,2,7)
end 	

function print_outline(text,x,y)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y,7)
end
