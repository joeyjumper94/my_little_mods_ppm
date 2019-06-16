local PPM_readme_table={'',
'serverside/superadmin stuff',
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
'ppm_antispam_time',
'default is 4',
'',
'if set to 0, the antispam timer is disabled',
'',
'if set to anything more than 0, a timer will be created after spawning pony ragdoll/NPC',
'this timer will stop further pony NPC/ragdoll spawns by that player untill the timer runs out',
'',
'_________________________________________________________________________________________',
'',
'ppm_draw_in_editor',
'default is 1',
'',
'if set to 1, "in PPM editor" will be drawn above someone\'s head when in PPM editor',
'_________________________________________________________________________________________',
'',
"ppm_draw_visibly_armed",
'default is 1',
'',
'if set to 1, "visibly armed" will be drawn above someone\'s head when they weapon',
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
'https://github.com/joeyjumper94/Equestrian-Wastelanders-PPM is the githb version'}
concommand.Add('ppm_readme',function(ply,cmd,args)
	for k,v in ipairs(PPM_readme_table) do
		print(v)
	end
end)
