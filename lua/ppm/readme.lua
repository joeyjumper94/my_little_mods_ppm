PPM_readme_table={'',
'serverside/superadmin stuff',
'_________________________________________________________________________________________',
'',
'ppm_use_ulx',
'default is 0, restart is required after switching',
'',
'if set to 1, ULX+ULib must be installed and the player needs to have access to ULX Rcon',
'',
'if set to 0, The player MUST be a superadmin or have a rank derived from superadmin',
'_________________________________________________________________________________________',
'',
'ppm_restrict_ragdoll',
'default is 1',
'',
'if set to 0, the spawning of pony ragdolls via toolpanel is unrestricted',
'if you have the appropriate access, you can also run "ppm_restrict_ragdoll_0"',
'',
'if set to 1, the spawning of pony ragdolls via toolpanel is restricted to admin and up',
'if you have the appropriate access, you can also run "ppm_restrict_ragdoll_1"',
'',
'if set to 2, the spawning of pony ragdolls via toolpanel is restricted to superadmin only',
'if you have the appropriate access, you can also run "ppm_restrict_ragdoll_2"',
'',
'if set to 3, the spawning of pony ragdolls via toolpanel is disabled',
'if you have the appropriate access, you can also run "ppm_restrict_ragdoll_3"',
'_________________________________________________________________________________________',
'',
'ppm_restrict_npc',
'default is 0',
'',
'if set to 0, the spawning of pony NPCs via toolpanel is unrestricted',
'if you have the appropriate access, you can also run "ppm_restrict_npc_0"',
'',
'if set to 1, the spawning of pony NPCs via toolpanel is restricted to admins and up',
'if you have the appropriate access, you can also run "ppm_restrict_npc_1"',
'',
'if set to 2, the spawning of pony NPCs via toolpanel is restricted to superadmins only',
'if you have the appropriate access, you can also run "ppm_restrict_npc_2"',
'',
'if set to 3, the spawning of pony NPCs via toolpanel is disabled',
'if you have the appropriate access, you can also run "ppm_restrict_npc_3"',
'_________________________________________________________________________________________',
'',
'clientside',
'_________________________________________________________________________________________',
'',
'ppm_readme',
'prints this readme into console, works on both the clients console and the server console',
'_________________________________________________________________________________________',
'',
'ppm_fix_render',
'fixes bleached ponies( where everypony is white)',
'_________________________________________________________________________________________',
'',
'ppm_fix_giraffe',
'fixes giraffe necks by reapplying your pony data then killing you.',
'_________________________________________________________________________________________',
'',
'PPM_limit_to_vanilla',
'default is 0',
'',
'if set to 1, it will only draw the stuff from vanilla PPM',
'you can also run "ppm_dont_draw_socks"',
'',
'if set to 0, it will try to draw all matarials.',
'you can also run "ppm_do_draw_socks"',
'_________________________________________________________________________________________',
'',
'http://steamcommunity.com/sharedfiles/filedetails/?id=945735699 is the workshop version',
'',
'https://github.com/joeyjumper94/Equestrian-Wastelanders-PPM is the githb version'























}concommand.Add('ppm_readme', function()
	if PPM_readme_table!=nil then
		for P=1,#PPM_readme_table do
			if PPM_readme_table[P]!=nil then
				print(PPM_readme_table[P]) 
			else return	end
		end 
	end
end)
--[[PPM_update_table={}
concommand.Add('ppm_update', function()
	if PPM_update_table!=nil then
		for r=1,#PPM_update_table do
			if PPM_update_table[r]!=nil then
				print(PPM_update_table[r])
			else return end
		end 
	end
end)]]