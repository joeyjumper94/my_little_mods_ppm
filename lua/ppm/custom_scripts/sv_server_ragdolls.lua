local name="ppm_serverside_ragdolls"
local ConVar=CreateConVar(name,"0",FCVAR_ARCHIVE,"should Pony Players leave serverside ragdolls on death?",0,1)
local DMG_NORAGDOLL=0
for k,v in ipairs{--list of DMG enumatations
	DMG_DISSOLVE,--dissoving
	DMG_REMOVENORAGDOLL,--should leave no corpse behind
}do
	DMG_NORAGDOLL=bit.bor(DMG_NORAGDOLL,v)
end
hook.Add("DoPlayerDeath",name,function(Player,_,CTakeDamageInfo)
	local Entity=Player:GetNWEntity(name,NULL)--try to find their serverside ragdoll
	if Entity:IsValid()then
		Entity:Remove()
	end
	if ConVar:GetBool()then
		if 0==bit.band(DMG_NORAGDOLL,CTakeDamageInfo:GetDamageType())and PPM.isValidPonyLight(Player)then--as long as it isn't dissolve damage
			Player:SetShouldServerRagdoll(true)--mark them as a about to server ragdoll
		end
		timer.Simple(0,function()
			local Entity=Player:GetRagdollEntity()or NULL--try to find the ragdoll from the normal code
			if Entity:IsValid()then--and if we do get it
				Entity:Remove()--remove it
			end
		end)
	end
end)
--[[just some dummied out stuff from testing
local tbl={}
for k,v in pairs(_G)do
	if k:StartWith"DMG_"then
		tbl[v]=k
	end
end
for k,v in ipairs{
"100000000000000000000000000",
"10000000000000000000000",
"100000000000",
}do
	local b=math.BinToInt(v)
	print(b,tbl[b])
end
hook.Add("EntityTakeDamage",name,function(Player,CTakeDamageInfo)--player left the game
	if Player:IsPlayer()then
		local k=CTakeDamageInfo:GetDamageType()
		print(k,tbl[k])
	end
end)
print(2147483648,tbl[2147483648])
--]]
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