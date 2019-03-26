-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua


--- game
game_over = true
t=0

--- bird
bird_x=24
bird_y=78
bird_vy=0.0
bird_sp=0

--- pipes
pipes = {}
left_to_pipe = 240
pipe_dist = 100
pipe_gap = 64


function TIC()
	if game_over == false then
		update()
	elseif btn(0) then
		game_over = false
		bird_y = 78
		bird_vy = 0.0
	end
	
	draw()	
	t=(t+1)%60
end

function update()
	 update_pipes()
		update_bird()
end 

function update_bird()
	if btn(0) then bird_vy = 1.6 end
	
	bird_y = bird_y - bird_vy
	
	bird_vy = bird_vy - 0.06
	
	if bird_y < 0 then 
		bird_y = 0
		bird_vy = -0.5 
	end
	
	if bird_y > 120 then
		game_over = true
	end
end

function update_pipes()
	left_to_pipe = left_to_pipe -1
	if left_to_pipe < -32 then
		left_to_pipe = left_to_pipe + pipe_dist
		table.remove(pipes, 1)
	end	
	
	while #pipes < 4 do
		table.insert(pipes, math.random(10,80))
	end
end

function draw()	
	cls(13) --- draw code here
	
	draw_bird()
	draw_pipes()
	
	if game_over == true then 
		print("GAME OVER", 68, 68)
	end
	
	
end

function draw_bird()
	if t < 15 then
		bird_sp = 2
	elseif t < 30 then
		bird_sp = 0
	elseif t < 45 then
	 bird_sp = 4
	else 
		bird_sp = 0
	end
	
	spr(bird_sp,bird_x,bird_y,0,1,0,0,2,2)
end

function draw_pipes()
	for i,pipe_height in ipairs(pipes) do
		--- bottom
		spr(6, left_to_pipe + pipe_dist * (i-1), 136 - pipe_height,0,1,0,0,2,2)
		spr(6, 16 + left_to_pipe + pipe_dist * (i-1), 136 - pipe_height,0,1,1,0,2,2)
		for h=pipe_height-16,0,-16 do 
			spr(10, left_to_pipe + pipe_dist * (i-1), 136 - h,0,1,0,0,2,2)
			spr(10, 16 + left_to_pipe + pipe_dist * (i-1), 136 - h,0,1,1,0,2,2)	
		end
		
		--- top
		spr(6, left_to_pipe + pipe_dist * (i-1), 136 - pipe_gap - pipe_height,0,1,2,0,2,2)
		spr(6, 16 + left_to_pipe + pipe_dist * (i-1), 136 - pipe_gap - pipe_height,0,1,3,0,2,2)
		for h=pipe_height+pipe_gap+16,152,16 do 
			spr(10, left_to_pipe + pipe_dist * (i-1), 136 - h,0,1,0,0,2,2)
			spr(10, 16 + left_to_pipe + pipe_dist * (i-1), 136 - h,0,1,1,0,2,2)	
		end
	end
end
