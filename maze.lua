function random_discovered(walls)
	discovered = {}
	for i,w in ipairs(walls) do
		if w == "d" then
			table.insert(discovered, i)
		end
	end
	return discovered[math.random(#discovered)]
end

function contains_undiscovered(walls)
	for i,w in ipairs(walls) do
	 if w == "d" then
		 return true
		end
	end
	return false
end

-- Prim's algorithm
function gen_maze()
	walls={}
	for x=0,29 do
		for y=0,16 do
			walls[y*30+x] = "u"
		end
	end
	walls[0] = "m"
	walls[1] = "d"
	walls[30] = "d"
	while contains_undiscovered(walls) do
		next = random_discovered(walls)
		wall_x = next % 30
		wall_y = next // 30
		rect(wall_x*8, wall_y*8, 10, 10, 6)
		num_visited = 0
		if wall_x - 1 >= 0 and walls[wall_y*30+wall_x-1] == "m" then
			num_visited = num_visited + 1
		end
		if wall_x + 1 < 30 and walls[wall_y*30+wall_x+1] == "m" then
				num_visited = num_visited + 1
		end
		if wall_y - 1 >= 0 and walls[(wall_y-1)*30+wall_x] == "m" then
			num_visited = num_visited + 1
		end
		if wall_y + 1 < 17 and walls[(wall_y+1)*30+wall_x] == "m" then
				num_visited = num_visited + 1
		end
		if num_visited < 2 then
			walls[next] = "m"
			if wall_x - 1 >= 0 and walls[wall_y*30+wall_x-1] == "u" then walls[wall_y*30+wall_x-1] = "d" end
			if wall_x + 1 < 30 and walls[wall_y*30+wall_x+1] == "u" then walls[wall_y*30+wall_x+1] = "d" end
			if wall_y - 1 >= 0 and walls[(wall_y-1)*30+wall_x] == "u" then walls[(wall_y-1)*30+wall_x] = "d" end
			if wall_y + 1 < 17 and walls[(wall_y+1)*30+wall_x] == "u" then walls[(wall_y+1)*30+wall_x] = "d" end
		else
			walls[next] = "w"
		end
	end
	for i,w in ipairs(walls) do
		if w ~= "m" then
			table.insert(blocks,
			{
				x=8*(i%30),
				y=8*(i//30)
			})
		end
	end
end

function init()
	t=0
	won = false
	p={
		x=2,
		y=2,
		vx=0,
		vy=0
	}

	blocks = {}
	gen_maze()
end

init()
function TIC()
	update()
	draw()
end

function update()
	t=t+1
	if not won then
		update_player()
	end
end

function draw()
	cls(1)
	draw_goal()
	draw_blocks()
	draw_shadows()
	draw_player()
end

function update_player()
	if btn(0) then p.vy=-1 end
	if btn(1) then p.vy= 1 end
	if btn(2) then p.vx=-1 end
	if btn(3) then p.vx= 1 end


	for i,b in ipairs(blocks) do
		if  p.x+p.vx+2 >= b.x and p.y+2 >= b.y
		and p.x+p.vx-2 <= b.x+9 and p.y-2 <= b.y+9 then
			p.vx=0
		end
		if  p.x+2 >= b.x and p.y+p.vy+2 >= b.y
		and p.x-2 <= b.x+9 and p.y+p.vy-2 <= b.y+9 then
			p.vy=0
		end
	end

	p.x=p.x+p.vx
	p.y=p.y+p.vy

	if p.x - 2 < 0 then
		p.x = 2
	end

	if p.x + 2 >= 240 then
		p.x = 237
	end

	if p.y - 2 < 0 then
		p.y = 2
	end

	if p.y + 2 >= 136 then
		p.y = 133
	end

	p.vx=0
	p.vy=0

	if p.x + 2 >= 226 and p.y >= 122 then
		won = true
	end
end

function draw_player()
	rect(p.x-2,p.y-2,5,5,15)
end

function draw_blocks()
	for i,block in ipairs(blocks) do
		rect(block.x, block.y, 10, 10, 11)
	end
end

function draw_shadows()
	for i,block in ipairs(blocks) do
		draw_shadow(block)
	end
end

function draw_goal()
	rect(224, 120, 24, 24, 6)
end

function draw_shadow(b)
	r_corner = {x=0,y=0}
	l_corner = {x=0,y=0}

	-- top left
	if p.x <= b.x+1 and p.y <= b.y+1 then
		r_corner = {x=b.x+9, y=b.y+1}
		l_corner = {x=b.x+1, y=b.y+9}
	-- top right
	elseif p.x >= b.x+9 and p.y <= b.y+1 then
		r_corner = {x=b.x+1, y=b.y+1}
		l_corner = {x=b.x+9, y=b.y+9}
	-- bottom left
	elseif p.x <= b.x+1 and p.y >= b.y+9 then
		l_corner = {x=b.x+9, y=b.y+9}
		r_corner = {x=b.x+1, y=b.y+1}
	-- bottom right
	elseif p.x >= b.x+9 and p.y >= b.y+9 then
		r_corner = {x=b.x+9, y=b.y+1}
		l_corner = {x=b.x+1, y=b.y+9}
	-- top mid
	elseif p.y <= b.y+1 then
		r_corner = {x=b.x+1, y=b.y+1}
		l_corner = {x=b.x+9, y=b.y+1}
	-- bottom mid
	elseif p.y >= b.y+9 then
		r_corner = {x=b.x+9, y=b.y+9}
		l_corner = {x=b.x+1, y=b.y+9}
	-- left mid
	elseif p.x <= b.x+1 then
		r_corner = {x=b.x+1, y=b.y+9}
		l_corner = {x=b.x+1, y=b.y+1}
	-- right mid
	elseif p.x >= b.x+9 then
		r_corner = {x=b.x+9, y=b.y+1}
		l_corner = {x=b.x+9, y=b.y+9}
	else
		return
	end

	r_dir = {x=r_corner.x-p.x, y=r_corner.y-p.y}
	l_dir = {x=l_corner.x-p.x, y=l_corner.y-p.y}
	r_dist = math.sqrt(r_dir.x*r_dir.x+r_dir.y*r_dir.y)
	l_dist = math.sqrt(l_dir.x*l_dir.x+l_dir.y*l_dir.y)

	r_dir = {x=r_dir.x/r_dist, y=r_dir.y/r_dist}
	l_dir = {x=l_dir.x/l_dist, y=l_dir.y/l_dist}


	r_end = {x=p.x+r_dir.x*300, y=p.y+r_dir.y*300}
	l_end = {x=p.x+l_dir.x*300, y=p.y+l_dir.y*300}

	tri(
	r_corner.x, r_corner.y,
	l_corner.x, l_corner.y,
	r_end.x, r_end.y,
	11)

	tri(
	l_corner.x, l_corner.y,
	l_end.x, l_end.y,
	r_end.x, r_end.y,
	11)
end
