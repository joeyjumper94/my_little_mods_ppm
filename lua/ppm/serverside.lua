if SERVER then
	util.AddNetworkString("player_equip_item")
	util.AddNetworkString("player_pony_cm_send")
	local ponyarray_temp={
		["pony"]=true,
		["ponynj"]=true,
		["models/ppm/player_mature_base.mdl"]=true,
		["models/ppm/player_default_base.mdl"]=true,
		["models/cppm/player_default_base.mdl"]=true,
		["models/ppm/player_default_base_nj.mdl"]=true,
		["models/cppm/player_default_base_nj.mdl"]=true,
		["models/ppm/player_default_base_new.mdl"]=true,
		["models/ppm_veh/player_default_base.mdl"]=true,
		["models/ppm_veh/player_default_base_nj.mdl"]=true,
		["models/ppm/player_default_base_new_nj.mdl"]=true,
		["models/ppm/player_default_base_ragdoll.mdl"]=true,
		["models/cppm/player_default_base_ragdoll.mdl"]=true,
	}

	net.Receive("player_equip_item",function(len,ply)
		local id=net.ReadFloat()
		local item=PPM:pi_GetItemById(id)
		if item then
			PPM.setupPony(ply,false)
			PPM:pi_SetupItem(item,ply)
		end
	end)

	local PlayerSetModel=function(ply)
		timer.Simple(0.1,function()
			if ply and ply:IsValid() then
				local newmodel=ply:GetModel()--ply:GetInfo("cl_playermodel")
				if newmodel!=ply.pi_prevplmodel then
					PPM:pi_UnequipAll(ply)
					if ponyarray_temp[newmodel] then
						if !ply.ponydata then
							PPM.setupPony(ply)
						end
						PPM.setPonyValues(ply)
						PPM.setBodygroups(ply)
						if PPM.camoffcetenabled then 
							ply:SetViewOffset(Vector(0,0,42))
							ply:SetViewOffsetDucked(Vector(0,0,35))
						end
					else
						ply:SetViewOffset(Vector(0,0,64))
						ply:SetViewOffsetDucked(Vector(0,0,28))
					end
					ply.pi_prevplmodel=newmodel
				end
			end
		end)
	end
	hook.Add("PlayerSetModel","items_Flush",PlayerSetModel)
	hook.Add("playerSpawn","items_Flush",PlayerSetModel)
	hook.Add("PlayerSwitchWeapon","pony_weapons_autohide",function(ply,oldwep,newwep)
		if ponyarray_temp[ply:GetModel()]then--ply:GetInfo("cl_playermodel")] then
			newwep:SetMaterial"Models/effects/vol_light001"
		end
	end)
	hook.Add("PlayerLeaveVehicle","pony_fixclothes",function(ply,ent)
		if ponyarray_temp[ply:GetInfo("cl_playermodel")]then
			if ply.ponydata!=nil and IsValid(ply.ponydata.clothes1) then
				local bdata = {}
				for i=0,14 do
					bdata[i]=ply.ponydata.clothes1:GetBodygroup(i)
					ply.ponydata.clothes1:SetBodygroup(i,0)
				end
				timer.Simple(0.2,function()
                    for i=0,14 do
                        ply.ponydata.clothes1:SetBodygroup(i,bdata[i])
                    end
                end)
			end
		end
	end)
	PPM.camoffcetenabled=CreateConVar("ppm_enable_camerashift","1",FCVAR_REPLICATED,FCVAR_ARCHIVE,"Enables ViewOffset Setup"):GetBool()
	cvars.AddChangeCallback("ppm_enable_camerashift",function(v,o,n)PPM.camoffcetenabled=n!="0"end,"ppm_enable_camerashift")
end
--]]