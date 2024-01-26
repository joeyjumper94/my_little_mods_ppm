local name="ragdoll_transfer_decals"
if SERVER then
	util.AddNetworkString(name)
	hook.Add("CreateEntityRagdoll",name,function(Player,Entity)
		timer.Simple(1,function()
			if Player:IsValid()and Entity:IsValid()and PPM.isValidPonyLight(Player)then
				net.Start(name)
				net.WriteEntity(Player)
				net.WriteEntity(Entity)
				net.Broadcast()
			end
		end)
	end)
	return
end
net.Receive(name,function(len)
	local Player=net.ReadEntity()
	local Entity=net.ReadEntity()
	if Entity:IsValid()and Player:IsValid()then
		Entity:SnatchModelInstance(Player)
	end
end)
hook.Add("CreateClientsideRagdoll",name,function(Player,Entity)
	if PPM.isValidPonyLight(Player)then
		Entity:SnatchModelInstance(Player)
	end
end)