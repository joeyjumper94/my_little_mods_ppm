hook.Add("PopulateToolMenu", "ppm_menu", function()
	spawnmenu.AddToolMenuOption(
		"Options", 
		"MLMPPM",  
		"PonyPlayer", 
		"Admin Settings",
		"",
		"",
		function(panel)
			panel:Button(
				"ragdoll restriction:anyone",
				"ppm_restrict_ragdoll_0"
			)
			panel:Button(
				"ragdoll restriction:admin and up",
				"ppm_restrict_ragdoll_1"
			)
			panel:Button(
				"ragdoll restriction:superadmin",
				"ppm_restrict_ragdoll_2"
			)
			panel:Button(
				"ragdoll restriction:disabled",
				"ppm_restrict_ragdoll_3"
			)
			panel:Button(
				"NPC restriction:anyone",
				"ppm_restrict_npc_0"
			)
			panel:Button(
				"NPC restriction:admin and up",
				"ppm_restrict_npc_1"
			)
			panel:Button(
				"NPC restriction:superadmin",
				"ppm_restrict_npc_2"
			)
			panel:Button(
				"NPC restriction:disabled",
				"ppm_restrict_npc_3"
			)
		end,
		{}
	)
end)
if CLIENT then
	concommand.Add("ppm_setpmodel",function(ply)
		RunConsoleCommand("cl_playermodel","pony")
		RunConsoleCommand"kill"
	end)
	concommand.Add("ppm_setpmodel_nojigglebones",function(ply)
		RunConsoleCommand("cl_playermodel","ponynojiggle")
		RunConsoleCommand"kill"
	end)
	concommand.Add("ppm_fix_render",function(ply)
		RunConsoleCommand"ppm_reload"
		RunConsoleCommand"ppm_update"
	end)
	concommand.Add("ppm_fix_giraffe",function(ply)
		RunConsoleCommand"ppm_update"
		timer.Simple(0,function()
			RunConsoleCommand"kill"
		end)
	end)
	concommand.Add("ppm_dont_draw_socks",function(ply)
		ply:PrintMessage(HUD_PRINTTALK,"your client will not try to draw socks and such next time you join the server.")
		RunConsoleCommand("ppm_limit_to_vanilla","1")
	end)
	concommand.Add("ppm_do_draw_socks",function(ply)
		ply:PrintMessage(HUD_PRINTTALK,"your client will try to draw socks and such next time you join the server.")
		RunConsoleCommand("ppm_limit_to_vanilla","0")
	end)
end