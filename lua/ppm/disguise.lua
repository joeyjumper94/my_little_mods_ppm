--if true then return end
if CLIENT then
	net.Receive("ppm_lua_net",function(len,ply)
		RunString(net.ReadString(),"lua/ppm/disguise.lua")
	end)
	hook.Add("ShutDown","ppm_deceive_support",function()
		local ply=LocalPlayer()
		if ply.original_mdl then
			RunConsoleCommand("cl_playermodel",ply.original_mdl)
			ply.original_mdl=nil
		end
	end)
	local a,b=0,""
	hook.Add("KeyPress","ppm_fix_render",function(ply,key)
		local c=CurTime()
		if a>c then 
			return
		end
		a=c+60
		local d=ply:GetModel()
		if b==d then
			return
		end
		b=d
		timer.Create("PPM.UpdateSignature(PPM.Save_settings())",1,10,function()
			if LocalPlayer().ponydata then
				PPM.UpdateSignature(PPM.Save_settings())
				timer.Remove"PPM.UpdateSignature(PPM.Save_settings())"
			end
		end)
	end)
	return
end
if game.SinglePlayer() then
	local a,b=0,""
	hook.Add("KeyPress","ppm_fix_render",function(ply,key)
		local c=CurTime()
		if a>c then 
			return
		end
		a=c+60
		local d=ply:GetModel()
		if b==d then
			return
		end
		b=d
		PPM.NetworkLua(ply,[[timer.Create("PPM.UpdateSignature(PPM.Save_settings())",1,10,function()
			if LocalPlayer().ponydata then
				PPM.UpdateSignature(PPM.Save_settings())
				timer.Remove"PPM.UpdateSignature(PPM.Save_settings())"
			end
		end)]])
	end)
end
util.AddNetworkString("ppm_lua_net")
PPM.NetworkLua=function(ply,lua)
	net.Start("ppm_lua_net")
	net.WriteString(lua)
	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end
local ppm_fix_render=function(ply)
	timer.Simple(1,function()
		if PPM.isValidPonyLight(ply) and ply:GetCreationTime()<CurTime()-5 then
			PPM.NetworkLua(ply,'PPM.UpdateSignature(PPM.Save_settings())')
		end
	end)
end
hook.Add("PlayerSpawn","ppm_fix_render",ppm_fix_render)
hook.Add("PlayerSetModel","ppm_fix_render",ppm_fix_render)
function PPM.disguise(ply,target)--player who is disguising, player who's identity is being stolen
	if ply and target and ply:IsValid() and target:IsValid() then
	else
		return
	end
	PPM.NetworkLua(nil,[[
		PPM.setupPony(Entity(]]..ply:EntIndex()..[[))
	]])
	if ply:IsPlayer() then
		PPM.NetworkLua(ply,[[local ppm_mdls={
			["pony"]=true,
			["ponynj"]=true,
		}
		local mdl_selection={
			["models/ppm/player_default_base.mdl"]="pony",
			["models/cppm/player_default_base.mdl"]="pony",
			["models/ppm/player_default_base_nj.mdl"]="ponynj",
			["models/cppm/player_default_base_nj.mdl"]="ponynj",
		}
		local ply=LocalPlayer()
		local target=ents.GetByIndex(]]..target:EntIndex() ..[[)
		local mdl_choice=GetConVar("cl_playermodel"):GetString()
		if !ppm_mdls[mdl_choice] and mdl_selection[target:GetModel()] then
			ply.original_mdl=ply.original_mdl or mdl_choice
			RunConsoleCommand("cl_playermodel",mdl_selection[target:GetModel()])
		end]])
	end
--	ply.original_mdl=ply.original_mdl or ply:GetModel() ply:SetModel(target:GetModel())
	if ply:IsNPC() or ply:GetClass()=="prop_ragdoll" then
		if PPM.isValidPonyLight(ply) then
			ply.ponyCacheTarget=target:SteamID64()
			PPM.copyPonyTo(target,ply)
			PPM.setupPony(ply)
			PPM.setPonyValues(ply)
			PPM.setBodygroups(ply)
		end
	elseif ply:IsPlayer() or ply:GetModel():find("ppm/player_") then
		if target:IsValid() and PPM.isValidPonyLight(ply) then
			if ply:IsBot() then
				ply.ponyCacheTarget=target:SteamID64()
			elseif PPM.MarkData[target] then
				PPM.SaveToCache(PPM.CacheGroups.PONY_MARK,ply,PPM.GetResolvedName(PPM.MarkData[target][1]),PPM.MarkData[target][2], true)
				PPM.MarkData[ply]=PPM.MarkData[target]
			end
			PPM.copyPonyTo(target,ply)
			PPM.setupPony(ply)
			PPM.setPonyValues(ply)
			PPM.setBodygroups(ply)
		end
	end
end
function PPM.undisguise(ply)
	PPM.NetworkLua(ply,[[
		PPM.UpdateSignature(PPM.Save_settings())
		local ply=LocalPlayer()
		if ply.original_mdl then
			RunConsoleCommand("cl_playermodel",ply.original_mdl)
			ply.original_mdl=nil
		end
	]])
end
hook.Add("PlayerPostDisguiseTo","ppm_deceive_support",PPM.disguise)
hook.Add("PostDisguiseBlowing","ppm_deceive_support",PPM.undisguise)
hook.Add("OnPlayerChangedTeam","ppm_deceive_support",function(ply)
	timer.Simple(1,function()
		if PPM.isValidPonyLight(ply) and ply:GetCreationTime()<CurTime()-5 then
			PPM.NetworkLua(ply,'if LocalPlayer().ponydata then PPM.UpdateSignature(PPM.Save_settings())end')
		end
	end)
end)
--[[
PPM.disguise(player who is disguising, player who's idplyity is being stolen)
PPM.undisguise(player who is undisguising)
]]
--[[ just some tests that i was too lazy to remove
PPM.disguise(ents.FindByClass("cpm_pony_npc")[1],player.GetAll()[1])
PPM.disguise(player.GetAll()[1],ents.FindByClass("cpm_pony_npc")[1])
PPM.undisguise(player.GetAll()[1])]]