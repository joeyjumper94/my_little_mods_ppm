local name="ppm_serverside_ragdolls"
local ConVar=CreateConVar(name,"0",FCVAR_ARCHIVE,"should Pony Players leave serverside ragdolls on death?",0,1)
hook.Add("DoPlayerDeath",name,function(Player,_,CTakeDamageInfo)
	local Entity=Player:GetNWEntity(name,NULL)--try to find their serverside ragdoll
	if Entity:IsValid()then
		Entity:Remove()
	end
	if ConVar:GetBool()then
		if!CTakeDamageInfo:IsDamageType(DMG_DISSOLVE)and PPM.isValidPonyLight(Player)then--as long as it isn't dissolve damage
			Player:SetShouldServerRagdoll(true)--mark them as a about to server ragdoll
		end
		timer.Simple(0,function()
			local Entity=Player:GetRagdollEntity()or NULL
			if Entity:IsValid()then
				Entity:Remove()
			end
		end)
	end
end)
hook.Add("PlayerDisconnected",name,function(Player)--player left the game
	local Entity=Player:GetNWEntity(name,NULL)--try to find their serverside ragdoll
	if Entity:IsValid()then--if we find it
		Entity:Remove()--remove it
	end	
end)
hook.Add("CreateEntityRagdoll",name,function(Player,Entity)
	if PPM.isValidPonyLight(Player)then--if it was a pony player who died
		Player:SetNWEntity(name,Entity)--so we can track their death ragdoll later.
		Entity:SetNWEntity(name,Player)--and link the ragdoll back to their owner.
		PPM.setupPony(Entity)--setup the pony for the dragoll
		timer.Simple(1,function()--delay by 1 second
			if Player:IsValid()and Entity:IsValid()then--make sure both the player and ragdoll entities are valid
				Entity.ponyCacheTarget=Player:SteamID64()--some code copied from the tool
				PPM.copyPonyTo(Player,Entity)
				PPM.setupPony(Entity)
				PPM.setPonyValues(Entity)
				PPM.setBodygroups(Entity)
			end
		end)
		if CPPI then--if using a prop protection that uses CPPI
			Entity:CPPISetOwner(Player)--set the player as the owner of the ragdoll
		end
		Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)--make ragdolls not collide with players/vehicles
	end
end)
hook.Add("PlayerSpawn",name,function(Player)--when a player respawns
	local Entity=Player:GetNWEntity(name,NULL)--find their ragdoll entity if possible
	if Entity:IsValid()then--if we do find it,
		Entity:Remove()--remove it
	end
end)