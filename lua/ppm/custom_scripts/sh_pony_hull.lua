local name="ppm_pony_hull"
local FCVAR_ARCHIVE_REPLICATED=FCVAR_REPLICATED
if SERVER then
	FCVAR_ARCHIVE_REPLICATED=bit.bor(FCVAR_ARCHIVE,FCVAR_REPLICATED)
end
local ConVar=CreateConVar(name,"1",FCVAR_ARCHIVE_REPLICATED,"enable modified hull sizes for ponies",0,1)
local SetHull=function(Player,scale1,scale2)
	timer.Simple(0,function()
		if Player:IsValid()then
			if scale1!=0 and scale2!=0 then
				Player:SetHull(Vector(-16,-16,0),Vector(16,16,50*scale1))
				Player:SetHullDuck(Vector(-16,-16,0),Vector(16,16,40*scale2))
			else
				Player:ResetHull()
			end
		end
	end)
end
if SERVER then
	util.AddNetworkString(name)
	PPM.SetHull=function(Player,localvals)
		if Player:IsPlayer()and ConVar:GetBool()and PPM.isValidPonyLight(Player)then
			local ponydata=PPM.getPonyValues(Player,localvals)
			local min,max=PPM.height_min-1,PPM.height_max-1
			local bodyheight=math.Clamp(ponydata.bodyheight-1,min,max)
			local neckheight=math.Clamp(ponydata.neckheight-1,min,max)*.05
			local scale1=1+bodyheight*.065+neckheight
			local scale2=1+bodyheight*.07+neckheight
			Player[name]={
				scale1=scale1,
				scale2=scale2,
			}
			SetHull(Player,scale1,scale2)
			net.Start(name)
			net.WriteUInt(1,8)
			net.WritePlayer(Player)
			net.WriteFloat(scale1)
			net.WriteFloat(scale2)
			net.Broadcast()
		elseif Player[name]then
			SetHull(Player,0,0)
			Player[name]=nil
			net.Start(name)
			net.WriteUInt(1,8)
			net.WritePlayer(Player)
			net.WriteFloat(0)
			net.WriteFloat(0)
			net.Broadcast()
		end
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
	for k,Player in ipairs(player.GetAll())do
		PPM.SetHull(Player)
	end

	--bit of a hack but i need some way to network pony hulls from server to client as hulls are not networked from server to client
	local sent={}
	net.Receive(name,function(len,ply)
		if!sent[ply]and ConVar:GetBool()then
			sent[ply]=true
			local i=0
			for _,Player in ipairs(player.GetAll())do
				if Player[name]and Player!=ply then
					i=i+1
				end
			end
			if i==0 then return end
			net.Start(name)
			net.WriteUInt(i,8)
			for _,Player in ipairs(player.GetAll())do
				if Player[name]and Player!=ply then
					net.WritePlayer(Player)
					net.WriteFloat(Player[name].scale1 or 1)
					net.WriteFloat(Player[name].scale2 or 1)
				end
			end
			net.Send(ply)
		end
	end)
else
	hook.Add("KeyPress",name,function()
		hook.Remove("KeyPress",name)
		net.Start(name)
		net.SendToServer()
	end)
	net.Receive(name,function(len,ply)
		local max=net.ReadUInt(8)
		for i=1,max do
			local Player=net.ReadPlayer()
			if Player:IsValid()then
				local scale1=net.ReadFloat()
				local scale2=net.ReadFloat()
				SetHull(Player,scale1,scale2)
			end
		end
	end)
end
