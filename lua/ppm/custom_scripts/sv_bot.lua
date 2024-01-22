do return end--incase i accidentally put this into a production addon
local name="sv_ppm_bot"
local i=0
local fn=function()
	i=i+1
	local k="Dummy"..i
	local v=_G[k]or NULL
	if!v:IsValid()then
		v=player.CreateNextBot(k)or NULL
	end
	if v:IsValid()then
		v:Spawn()
		v:setRPName(k)
		_G[k]=v
		v:SetPos(Vector(i*50,0,0))
		v:SetAngles(Angle(0,0,0))
		v:SetHealth(1)
	else
		timer.Remove("Dummy"..name)
	end
end
timer.Create("Dummy"..name,1,0,fn)
fn()