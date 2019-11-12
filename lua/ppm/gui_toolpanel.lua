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