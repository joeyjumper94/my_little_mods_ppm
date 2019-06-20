if CLIENT then
	return
end
util.AddNetworkString("player_equip_item")
util.AddNetworkString("player_pony_cm_send")

net.Receive("player_equip_item",function(len,ply)
	local id=net.ReadFloat()
	local item=PPM:pi_GetItemById(id)
	if item then
		PPM.setupPony(ply,false)
		PPM:pi_SetupItem(item,ply)
		if ply.ponydata.clothes1 and ply.ponydata.clothes1:IsValid() then
			ply.ponydata.bdata = ply.ponydata.bdata or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,}
			for i,v in pairs(ply.ponydata.bdata) do
				ply.ponydata.bdata[i]=ply.ponydata.clothes1:GetBodygroup(i)
			end
		else
			timer.Simple(10,function()
				if ply and ply.ponydata and ply.ponydata.clothes1 and ply.ponydata.clothes1:IsValid() then
					ply.ponydata.bdata = ply.ponydata.bdata or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,}
					for i,v in pairs(ply.ponydata.bdata) do
						ply.ponydata.bdata[i]=ply.ponydata.clothes1:GetBodygroup(i)
					end
				end				
			end)
		end
	end
end)

local PlayerSwitchWeapon=function(ply,old,new)
	if PPM.pony_models[ply:GetModel()] and new:IsValid() then
		if PPM.hide_weapon then
			new.PPMColor=new.PPMColor or new:GetColor()
			new:SetColor(Color(0,0,0,0))
			new.PPMMaterial=new.PPMMaterial or new:GetMaterial()
			new:SetMaterial"Models/effects/vol_light001"
		else
			new:SetColor(new.PPMColor or Color(255,255,255,255))
			new.PPMColor=nil
			new:SetMaterial(new.PPMMaterial or "")
			new.PPMMaterial=nil
		end
	else
		if new.PPMColor then
			new:SetColor(new.PPMColor)
			new.PPMColor=nil
		end
		if new.PPMMaterial then
			new:SetMaterial(new.PPMMaterial)
			new.PPMMaterial=nil
		end
	end
end
hook.Add("PlayerSwitchWeapon","pony_weapons_autohide",PlayerSwitchWeapon)
local PlayerSetModel=function(ply)
	timer.Simple(0.1,function()
		if ply and ply:IsValid() then
			PlayerSwitchWeapon(ply,NULL,ply:GetActiveWeapon()or NULL)
			local newmodel=ply:GetModel()
			if PPM.pony_models[newmodel] then--became a pony
				if !ply.ponydata then
					PPM.setupPony(ply)
				end
				PPM.setPonyValues(ply)
				PPM.setBodygroups(ply)
				if PPM.camoffcetenabled then 
					ply:SetViewOffset(Vector(0,0,42))
					ply:SetViewOffsetDucked(Vector(0,0,35))
				end
				timer.Simple(0.1,function()
					if ply:IsValid() and ply.ponydata.bdata then
						ply.ponydata.clothes1=ply.ponydata.clothes1:IsValid() and ply.ponydata.clothes1 or ents.Create("prop_dynamic")
						ply.ponydata.clothes1:SetModel("models/ppm/player_default_clothes1.mdl")
						ply.ponydata.clothes1:SetParent(ply)
						ply.ponydata.clothes1:AddEffects(EF_BONEMERGE)
						ply.ponydata.clothes1:SetRenderMode(RENDERMODE_TRANSALPHA)
						--ply.ponydata.clothes1:SetNoDraw(true)	
						ply:SetNWEntity("pny_clothing",ply.ponydata.clothes1)
						for i=0,14 do
							ply.ponydata.clothes1:SetBodygroup(i,ply.ponydata.bdata[i] or 0)
						end
					end
				end)
			elseif PPM.pony_models[ply.pi_prevplmodel] then--no longer a pony
				ply:SetViewOffset(Vector(0,0,64))
				ply:SetViewOffsetDucked(Vector(0,0,28))
				local clothes1=ply.ponydata and ply.ponydata.clothes1 or NULL
				if clothes1:IsValid() then
					ply.ponydata.bdata = ply.ponydata.bdata or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,}
					for i=0,14 do
						ply.ponydata.bdata[i]=ply.ponydata.clothes1:GetBodygroup(i)
					end
					clothes1:Remove()
				end
			end
			ply.pi_prevplmodel=newmodel
		end
	end)
end
hook.Add("PlayerSetModel","items_Flush",PlayerSetModel)
hook.Add("playerSpawn","items_Flush",PlayerSetModel)
hook.Add("OnPlayerChangedTeam","items_Flush",PlayerSetModel)
PPM.hide_weapon=CreateConVar("ppm_hide_weapon","1",FCVAR_REPLICATED,FCVAR_ARCHIVE,"hide weapons held by ponies"):GetBool()
cvars.AddChangeCallback("ppm_hide_weapon",function(v,o,n)
	PPM.hide_weapon=n!="0"
end,"ppm_hide_weapon")
hook.Add("PlayerLeaveVehicle","pony_fixclothes",function(ply)
	if PPM.pony_models[ply:GetModel()] then
		if ply.ponydata!=nil and IsValid(ply.ponydata.clothes1) then
			ply.ponydata.bdata = ply.ponydata.bdata or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,}
			for i=0,14 do
				ply.ponydata.bdata[i]=ply.ponydata.clothes1:GetBodygroup(i)
				ply.ponydata.clothes1:SetBodygroup(i,0)
			end
			timer.Simple(0.2,function()
				for i=0,14 do
					ply.ponydata.clothes1:SetBodygroup(i,ply.ponydata.bdata[i])
				end
			end)
		end
	end
end)
PPM.camoffcetenabled=CreateConVar("ppm_enable_camerashift","1",FCVAR_REPLICATED,FCVAR_ARCHIVE,"Enables ViewOffset Setup"):GetBool()
cvars.AddChangeCallback("ppm_enable_camerashift",function(v,o,n)PPM.camoffcetenabled=n!="0"end,"ppm_enable_camerashift")
hook.Add("PreCleanupMap","ppm_clothes_map_clean",function()
	for k,ply in ipairs(player.GetAll())do
		if ply.ponydata and ply.ponydata.clothes1 and PPM.pony_models[ply:GetModel()] then
			ply.ponydata.bdata = ply.ponydata.bdata or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,}
			if ply.ponydata.clothes1:IsValid() then
				for i=0,14 do
					ply.ponydata.bdata[i]=ply.ponydata.clothes1:GetBodygroup(i)
				end
			end
			timer.Simple(k*0.1,function()
				if ply:IsValid() and ply.ponydata.bdata then
					ply.ponydata.clothes1=ply.ponydata.clothes1:IsValid() and ply.ponydata.clothes1 or ents.Create("prop_dynamic")
					ply.ponydata.clothes1:SetModel("models/ppm/player_default_clothes1.mdl")
					ply.ponydata.clothes1:SetParent(ply)
					ply.ponydata.clothes1:AddEffects(EF_BONEMERGE)
					ply.ponydata.clothes1:SetRenderMode(RENDERMODE_TRANSALPHA)
					ply:SetNWEntity("pny_clothing",ply.ponydata.clothes1)
					for i=0,14 do
						ply.ponydata.clothes1:SetBodygroup(i,ply.ponydata.bdata[i] or 0)
					end
				end
			end)
		end
	end
end)
