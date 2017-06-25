CreateConVar("ppm_use_ulx", "0", {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE}, "decides whether or not to use ULX for tha admin panel")

if (GetConVarNumber( "ppm_use_ulx" )==1) then
	ppm_admin_mod="ulx"
else
	ppm_admin_mod=nil
end

if ppm_admin_mod==nil then
	if SERVER then
		concommand.Add("ppm_restrict_npc_0",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_ragdoll","0")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony ragdolls is now unrestricted")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_npc_1",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_ragdoll","1")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony ragdolls is now restricted to admin and up")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_npc_2",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_ragdoll","2")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony ragdolls is now restricted to superadmins only")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_npc_3",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_ragdoll","3")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony ragdolls is now disabled")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_ragdoll_0",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_npc","0")
				ply:PrintMessage( HUD_PRINTTALK, "Convar Switched the spawning of pony ragdolls is now unrestricted")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_ragdoll_1",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_npc","1")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony npcs is now restricted to admin and up")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_ragdoll_2",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_npc","2")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony npcs is now restricted to superadmins only")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
		concommand.Add("ppm_restrict_ragdoll_3",function(ply)
			if ply:IsSuperAdmin() then
				RunConsoleCommand("ppm_restrict_npc","3")
				ply:PrintMessage( HUD_PRINTTALK, "The spawning of pony npcs is now disabled")
			else
				ply:PrintMessage( HUD_PRINTTALK, "Only Superadmins and ranks derived from superadmin can change this" )
			end
		end)
	end
else
	concommand.Add("ppm_restrict_npc_0",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_npc","0") 
	end)
	concommand.Add("ppm_restrict_npc_1",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_npc","1") 
	end)
	concommand.Add("ppm_restrict_npc_2",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_npc","2") 
	end)
	concommand.Add("ppm_restrict_npc_3",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_npc","3") 
	end)
	concommand.Add("ppm_restrict_ragdoll_0",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_ragdoll","0") 
	end)
	concommand.Add("ppm_restrict_ragdoll_1",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_ragdoll","1") 
	end)
	concommand.Add("ppm_restrict_ragdoll_2",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_ragdoll","2") 
	end)
	concommand.Add("ppm_restrict_ragdoll_3",function()
		RunConsoleCommand( ppm_admin_mod,"rcon","ppm_restrict_ragdoll","3") 
	end)
end