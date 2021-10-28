-- fonctions de base

function _init()
		create_player()
		enemies = {}
		create_all_e()
		guards = {}
		create_guard()
		e_verti = {}
		create_all_verti()
		pianist = {}
		create_pianist()
		dancers = {}
		create_all_d()
		cook = {}
		create_cuisiniere()
		message = {}
		init_msg()
		state = "menu"
 end
 
function _update()
	if state == "menu" then
	update_menu()
	elseif state == "game" then
	update_game()
	elseif state == "capy eau" or
	state == "dead" or state == "dead mate"
	then update_eau() --update mort
	end
	if state == "pause" then
	draw_pause()
	update_pause()
	end
	if state == "win" then
	update_next()
	end
end

function _draw()
	if state == "menu" then
	draw_menu()
	elseif state == "game" then
	draw_game()
	elseif state == "capy eau" then
	draw_eau()
	elseif state == "dead" then
	draw_dead()
	elseif state == "dead mate" then
	draw_deadmate()
	elseif state == "win" then
	draw_next()
	end
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
    camera(camx,camy)
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
		mate=0,
		objl2=0, --lax,npap,partition
		msg0=0,
		msg=0,
		msg2=0,
		piano=0,
		cake=0
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
		
		if (newx!=p.x or newy!=p.y) then
	 	if	not check_flag(0, newx, newy)
			then
  	p.x=mid(0, newx, 127)
  	p.y=mid(0,newy, 63)
  	p.start_ox=newox
  	p.start_oy=newoy
  	p.anim_t=1
  	else sfx(0)
  	end
 	end
 	
 	-- animation 
 	
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
		
		push_trash()
		interact_mate(newx,newy)
		interact_water(p.x,p.y)
		interact_videur()
		interact_obj(newx,newy)
		interact_pianist()
		interact_piano()
		interact_cuisiniere()
		interact_cake()
		
		if p.cake==1 and #message==0 then
		state = "win"
		end
	end	 

-- ennemies 

---creer tableau d'ennemies
function create_enemy(sp1,sp2,ex,ey)
		enn = {
		sprite1=sp1,sprite2=sp2,x=ex,
		y=ey,isleft=true,w=8,h=8,
		speed=1,ox=0,oy=0,start_ox=0,
		start_oy=0,anim_t=0
		}
		add(enemies,enn)
end

function create_all_e() --hori
--chiens roses
	create_enemy(19,20,12,4)
	create_enemy(19,20,15,14)
	create_enemy(19,20,7,7)
	create_enemy(19,20,17,20)
	create_enemy(19,20,16,27)
	create_enemy(19,20,23,28)
--karens
 create_enemy(24,24,21,8)
 create_enemy(25,25,22,8)
 create_enemy(9,9,22,7)
 
 create_enemy(24,24,14,14)
 create_enemy(25,25,15,14)
 create_enemy(9,9,15,13)
 
 create_enemy(24,24,2,16)
 create_enemy(25,25,3,16)
 create_enemy(9,9,3,15)
 
 create_enemy(24,24,13,24)
 create_enemy(25,25,14,24)
 create_enemy(9,9,14,23)
 
 create_enemy(24,24,33,5)
 create_enemy(25,25,34,5)
 create_enemy(9,9,34,4)
 
 create_enemy(24,24,32,25)
 create_enemy(25,25,33,25)
 create_enemy(9,9,33,24)
 
 create_enemy(24,24,43,19)
 create_enemy(25,25,44,19)
 create_enemy(9,9,44,18)
end

function draw_enemy(e)
	 spr(e.sprite,e.x*8+e.ox,e.y*8+e.oy,1,1,e.flip)
end

-- mouvement des ennemies 

function move_hori(e)
	local nx=e.x
	local ny=e.y
	
	if e.anim_t == 0 
	then
 nox = 0
 
	if e.isleft 
	then nx-=e.speed
	nox=8*e.speed
	e.flip = false
	else nx+=e.speed
	nox=-8*e.speed
	e.flip = true
	end
	end
 
 if nx!=e.x and
		not check_flag(0, nx, ny)
		then
  e.x=nx
  e.start_ox=nox
  e.anim_t=1
 end
 
 --animation
 
 e.anim_t = max(e.anim_t-0.125,0)
 e.ox=e.start_ox*e.anim_t
 
 if e.anim_t >= 0.5
 then e.sprite= e.sprite1
 else e.sprite= e.sprite2
 end
 
 if check_flag(0,(e.x-1),(e.y))
 then e.isleft = false
 else if check_flag(0,(e.x+1),(e.y))
 then e.isleft = true
 end
 end 
 end 

-- collision

function collision(a, b)
  return not (a.x > b.x
              or a.y > b.y
              or a.x < b.x
              or a.y < b.y)
end

-- interaction garde / poubelle

function create_guard()
		gu={sprite=68,sprite1=68,sprite2=69,
		x=41,y=25,w=8,h=8,isup=true,speed=1,
		ox=0,oy=0,start_ox=0,start_oy=0,
		anim_t=0}
		
		gu2={sprite=68,sprite1=68,sprite2=69,
		x=46,y=13,w=8,h=8,isup=false,speed=1,
		ox=0,oy=0,start_ox=0,start_oy=0,
		anim_t=0}
		
		add(guards,gu)
		add(guards,gu2)
end

function draw_guard(g)
	spr(g.sprite,g.x*8,g.y*8)
end

-- garde bouge si poubelle down

function update_guard(g)
	if g.isup then
		if check_flag(5,g.x,g.y-3) or
		check_flag(5,g.x,g.y-2) or
		check_flag(5,g.x,g.y-1) then
		move_verti(g)
		end
	elseif check_flag(5,g.x,g.y+3) or
		check_flag(5,g.x,g.y+2) or
		check_flag(5,g.x,g.y+1) then
		move_verti(g)
	end
end

-- mouvement garde et pianiste
		
function move_verti(g)
	local nx=g.x
	local ny=g.y
	
	if g.anim_t == 0 
	then
 noy = 0
 
	if g.isup 
	then ny-=g.speed
	noy=8*g.speed
	g.flip = false
	else ny+=g.speed
	noy=-8*g.speed
	g.flip = true
	end
	end
 
 if ny!=g.y and
		not check_flag(0, nx, ny)
		then
  g.y=ny
  g.start_oy=noy
  g.anim_t=1
 end
 
 g.anim_t = max(g.anim_t-0.125,0)
 g.oy=g.start_oy*g.anim_t
 
 if g.anim_t >= 0.5
 then g.sprite= g.sprite1
 else g.sprite= g.sprite2
 end
 
 if check_flag(0,(g.y-1),(g.x))
 then g.isup = false
 else if check_flag(0,(g.y+1),(g.x))
 then g.isup = true
 end
 end 
 end 
 
-- enemies verti (voiture)

function create_verti(sp,vx,vy)
	ver ={
  sprite=sp,x=vx,y=vy,isup=true,
		w=8,h=8,speed=1,ox=0,oy=0,start_ox=0,
		start_oy=0,anim_t=0
		}
		
	add(e_verti,ver)
end

function create_all_verti()
--cars (4 spr)
	create_verti(100,65,5)
 create_verti(101,66,5)
 create_verti(116,65,6)
 create_verti(117,66,6) 
end


function draw_verti(v)
	spr(v.sprite,v.x*8,v.y*8)
end

function move_e_verti(v)
	local nx=v.x
	local ny=v.y
	
	if v.anim_t == 0 
	then
 noy = 0
 
	if v.isup 
	then ny-=v.speed
	noy=8*v.speed
	else ny+=v.speed
	noy=-8*v.speed
	end
	end
 
 if ny!=v.y and
		not check_flag(0, nx, ny)
		then
  v.y=ny
  v.start_oy=noy
  v.anim_t=1
 end
 
 v.anim_t = max(v.anim_t-0.125,0)
 v.oy=v.start_oy*v.anim_t
 
-- if v.anim_t >= 0.5
-- then v.sprite= v.sprite1
-- else v.sprite= v.sprite2
-- end
 
 if check_flag(0,(v.x),(v.y-1))
 then v.isup = false
 else if check_flag(0,(v.x),(v.y+1))
 then v.isup = true
 end
 end 
 end 
 
 --pianiste
 
function create_pianist()
	pi1={sprite=22,sprite1=22,sprite2=22,
	isup=true,
	x=91,y=8,w=8,h=8,speed=2,ox=0,oy=0,
	start_ox=0,start_oy=0,anim_t=0}
		
	pi2={sprite=38,sprite1=38,sprite2=38,
	isup=true,x=91,y=9,w=8,h=8,speed=2,ox=0,
	oy=0,start_ox=0,start_oy=0,anim_t=0}
		
	add(pianist,pi1)
	add(pianist,pi2)
end

function draw_pianist(pi)
	spr(pi.sprite,pi.x*8,pi.y*8)
end

function interact_pianist()
	for pi in all(pianist) do
		if collision(pi,p) and p.msg==0 
		then 
		create_msg("pianiste:", "que j'ai soif!", "degage ! le piano \nc'est pas pour \nles rats")
		p.msg+=1
		elseif collision(pi,p) and p.msg==1 then
		create_msg("capy:","si seulement elle pouvait \npartir aux toilettes")
	 p.msg+=1
		elseif collision(pi,p)
		and p.mate==1 and p.objl2>0 
		then 
		 for pi in all(pianist) do 
				move_verti(pi)
			end
			p.mate-=1
			p.objl2-=1	
		end
	end
end	

function update_pianist()
	if check_flag(0,pi1.x,pi1.y-1) then
	deli(pianist,1)
	deli(pianist,2)
	end
end  		

-- danseurs mariage 

function create_dancer(sp,dx,dy,ax,ay)
		dan = {
		sprite=sp,sprite1=sp,sprite2=sp,
		x=dx,y=dy,altx=ax,alty=ay,isleft=true,w=8,h=8,
		speed=1,ox=0,oy=0,start_ox=0,
		start_oy=0,anim_t=0
		}
		add(dancers,dan)
end

function create_all_d()
	create_dancer(21,91,12,119,10) 
	create_dancer(37,91,13,119,11) 
	create_dancer(22,92,12,120,10)
	create_dancer(38,92,13,120,11)
	
	create_dancer(21,101,14,115,10) --tete
	create_dancer(37,101,15,115,11) --pied
	create_dancer(22,100,14,116,10)
	create_dancer(38,100,15,116,11)
	
	create_dancer(21,94,16,119,20) 
	create_dancer(37,94,17,119,21) 
	create_dancer(21,95,16,120,20)
	create_dancer(38,95,17,120,21)
	
	create_dancer(22,99,18,116,19) 
	create_dancer(38,99,19,116,20) 
	create_dancer(19,98,19,115,20)
end

function draw_dancer(d)
	 spr(d.sprite,d.x*8+d.ox,d.y*8+d.oy,1,1,d.flip)
end

function update_dancer(d)
	if p.piano == 0 then
	move_hori(d) else 
	d.x = d.altx
	d.y = d.alty
	end
end

-- cuisiniere

function create_cuisiniere()
	cu1={sprite=104,
	altx=111, alty=19,x=100,y=23,w=8,h=8,
	start_ox=0,start_oy=0,anim_t=0}
		
	cu2={sprite=120,x=100,y=24,w=8,h=8,
	altx=111,alty=20,
	start_ox=0,start_oy=0,anim_t=0}
		
	add(cook,cu1)
	add(cook,cu2)
end

function draw_cuisiniere(cu)
	spr(cu.sprite,cu.x*8,cu.y*8)
end

function interact_cuisiniere()
	for cu in all(cook) do
		if collision(cu,p) and p.msg2==0 then 
		create_msg("cuisiniere:", "pas touche au gateau !", "vivement la marche \nnuptiale...")
		p.msg2+=1	
		end
	end
end	

function update_cuisiniere(cu)
	if p.piano>0 then
	cu.x = cu.altx
	cu.y = cu.alty
	end
end 		

--interactions objets 

-- modif des sprites 
function next_tile(x,y)
	local sprite = mget(x,y)
	mset(x,y,sprite+1)
end

function push_tile(x,y,a)
	local sprite = mget(x,y)
	mset(x,y,sprite+a)
end 

-- interaction cle

-- a utiliser dans la banque
function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	--ajouter sfx
end

function interact_key(x,y)
	if check_flag(1,x,y) -- changer flag (conflit gateau)
	then pick_up_key(x,y)
	create_msg("capy","viva la revolucion!")
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
	if newx==39 and newy==10
	then create_msg("capy:","merci aux producteurs locaux \npour ce delicieux mate !\nje vais surement pouvoir \nrenverser ces poubelles \ncapitalistes !")
	--ajouter sfx
	end
	if p.mate>1 then 
	state = "dead mate"
	end
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

-- poubelle

function trash_down(x,y)
	next_tile(x,y)
	p.mate-=1
end 

function push_trash()
 if check_flag(4,p.x+1,p.y) 
 and btn(➡️) and p.mate == 0
 then
 	if not check_flag(0,p.x+2, p.y)
 	then
 push_tile(p.x+1,p.y,2)
 push_tile(p.x+2,p.y,11)
  end 
 elseif check_flag(4,p.x-1,p.y) 
 and btn(⬅️) and p.mate == 0
 then 
 	if not check_flag(0,p.x-2, p.y)
 	then push_tile(p.x-1,p.y,2)
   push_tile(p.x-2,p.y,11)
   end
 end 
end
  
 -- eau
 
 function interact_water(x,y)
 if check_flag(6,x,y) and check_flag(0,x,y) then 
 state = "capy eau"
 end
 end

-- videur
function interact_videur()
	if check_flag(7,p.x+1,p.y) 
		then if p.objl2==0 and p.msg0==0
		then create_msg("videur:","tenue correcte exigee !")
		p.msg0+=1
		elseif p.objl2>0 and p.msg0==1 
		then create_msg("videur:","bien fringant! \nje pars en pause camarade \n**winkwink**")
		push_tile(71,15,-48)
		push_tile(71,16,-64)
		p.msg0-=1
		p.objl2-=1
		end
	end
end

-- noeud papillon
function interact_obj(x,y) --np, lax, partition
	if check_flag(5,x,y) and not check_flag(0,x,y)
	then pick_up_obj(x,y)
	create_msg("capy","viva la revolucion!")
	end
end

function pick_up_obj(x,y)
	next_tile(x,y)
	p.objl2+=1
	--ajouter sfx
end

-- jouer du piano

function interact_piano()
	if #pianist==0 and check_flag(6,p.x,p.y-1) 
	then if p.objl2>0 then
		sfx(0)
		p.piano+=1
		elseif p.msg==2
		then create_msg("capy:","il manque \nune partition")
		p.msg-=1
		end
	end
end

--interact gateau
function interact_cake()
	if p.piano > 0 and check_flag(1,p.x,p.y)
	then 
	next_tile(p.x,p.y)
	create_msg("capy:","miam, ca me donne \nl'energie de braquer \nune banque !")
 p.cake+=1
	end
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

--messages

function init_msg()
	message = {}
end

function update_msg()
	if btnp(❎) then 
	deli(message,1)
	end
end

function draw_msg()

if message[1] then
	-- titre
--rectfill(x,y,x+4,y+4,8)
--rect(6,y-1,6,y+7,0)
print(msg_title,p.x*8-40,p.y*8+25)
	-- message
--rectfill(3,y+8,124,y+24,2)
--rect(3,y+8,124,y+24,0)
print(message[1],p.x*8-40,p.y*8+32)
	end
end

function create_msg(name,...)
	msg_title = name
	message = {...}
end

-- state menu
function update_menu()
	if btnp(❎) then state = "game"
	end
end

function draw_menu()
	cls()
	camera()
	local menux = 10
	local menuy = 64
	print("oh non ! on a construit \nun quartier de riches \nsur mon marais !\n\npress x to start you revenge",menux,menuy)
end

function update_pause()
	if btnp(❎) then state = "game"
	end
	end

function draw_pause()
	cls()
	camera()
	local menux = 20
 local menuy = 64
	print("press x to continue",menux,menuy)
end

function draw_next()
 cls()
	camera()
	local menux = 20
 local menuy = 64
	print("bravo ! \npress x to next level",menux,menuy)
end

function update_next()
	if btnp(❎) then 
	state = "game"
	p.x = 30
	p.y = 49
	p.cake-=1
	end
	end
	

-- state game
function update_game()
	if #message==0 then
	player_movement()
	end
	update_camera()
	update_pianist()
	for e in all(enemies) do
	move_hori(e)
	end
 for e in all(enemies) do
 	if collision(e,p)
		then state = "dead"
		end
	end
	for g in all(guards) do
 	if collision(g,p)
		then state = "dead"
		end
	end
	for v in all(e_verti) do
 	if collision(v,p)
		then state = "dead"
		end
	end
	for d in all(dancers) do
 	if collision(d,p)
		then state = "dead"
		end
	end
	for v in all(e_verti) do
	move_e_verti(v)
	end
	for d in all(dancers) do
	 update_dancer(d)
	end
	for cu in all(cook) do 
	update_cuisiniere(cu)
	end
	
	if btnp(🅾️) 
	then state = "pause"
	end
	
	palt(0,true)
	update_msg()
	
	for g in all(guards) do
	update_guard(g)
	end
end

function draw_game()
		cls()
		draw_map()
		draw_player()
		draw_msg()
		for g in all(guards) do
		draw_guard(g)
		end
		for v in all(e_verti) do
		draw_verti(v)
		end
		for e in all(enemies) do
		draw_enemy(e)
		end
		for pi in all(pianist) do
		draw_pianist(pi)
		end
		for d in all(dancers) do
		draw_dancer(d)
		end
		for cu in all(cook) do 
		draw_cuisiniere(cu)
		end
		draw_ui()
	end
	
	-- state capy_eau
	function update_eau() --ok all death
	if btnp(❎) then _init()
	end
	end
	
	function draw_eau()
	cls()
	local menux = mid(0, (p.x - 7.5) * 8 + p.ox, (128 - 15) * 8)
 local menuy = mid(0, (p.y - 7.5) * 8 + p.oy, (64 - 15) * 8)
	print("trop chill dans l'eau \n tu abandonnes la mission \n press x to return \n to menu",menux+29,menuy+62)	
	end
	
	-- state dead collision
	function draw_dead()
	cls()
	local menux = mid(0, (p.x - 7.5) * 8 + p.ox, (128 - 15) * 8)
 local menuy = mid(0, (p.y - 7.5) * 8 + p.oy, (64 - 15) * 8)
	print("rencontre fatale \navec l'ennemi \npress x to return \nto menu",menux+29,menuy+62)	
	end
	
	-- state dead mate
	function draw_deadmate()
	cls()
	local menux = mid(0, (p.x - 7.5) * 8 + p.ox, (128 - 15) * 8)
 local menuy = mid(0, (p.y - 7.5) * 8 + p.oy, (64 - 15) * 8)
	print("overdose de mate \npress x to return \nto menu",menux+29,menuy+62)	
	end
	
