local name="ppm_pony_hull"
local ConVar=CreateConVar(name,"1",bit.bor(FCVAR_ARCHIVE,FCVAR_REPLICATED),"enable modified hull sizes for ponies",0,1)
PPM.SetHull=function(Player,localvals)
	timer.Simple(0,function()
		if Player:IsValid()then
			if Player:IsPlayer()and PPM.isValidPonyLight(Player)and ConVar:GetBool()then
				Player[name]=true
				local ponydata=PPM.getPonyValues(Player,localvals)
				local bodyheight=math.Clamp(ponydata.bodyheight,PPM.height_min,PPM.height_max)*.05
				local neckheight=math.Clamp(ponydata.neckheight,PPM.height_min,PPM.height_max)*.05
				local scale=0.9+bodyheight+neckheight
				Player:SetHull(Vector(-16,-16,0),Vector(16,16,55*scale))
			elseif Player[name]then
				Player:ResetHull()
				Player[name]=nil
			end
		end
	end)
end
hook.Add("PlayerLoadout",name,PPM.SetHull)
hook.Add("PlayerSetModel",name,PPM.SetHull)
hook.Add("PlayerSpawn",name,PPM.SetHull)
hook.Add("OnPlayerChangedTeam",name,PPM.SetHull)
cvars.AddChangeCallback(name,function(v,o,n)
	for k,Player in ipairs(player.GetAll())do
		PPM.SetHull(Player)
	end
end,name)