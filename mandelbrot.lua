sx=0
sy=0
z=1

function draw()
	cls(0)
	for y=0,135,1 do
		for x=0,239,1 do
			cx=(x-120+sx)/(70*z)
			cy=(y-68+sy)/(70*z)
			re=0
			im=0
			for i=0,200,1 do
				n_re=re*re-im*im+cx
				im=2*re*im+cy
				re=n_re
				if re*re+im*im>=2 then
					pix(x,y,2)
					break
				end
			end
		end
	end
end
function TIC()
	if btn(0) then sy=sy-10 draw() end
	if btn(1) then sy=sy+10 draw() end
	if btn(2) then sx=sx-10 draw() end
	if btn(3) then sx=sx+10 draw() end
	if btn(4) then z=z*0.9 draw() end
	if btn(5) then z=z*1.1 draw() end
end
