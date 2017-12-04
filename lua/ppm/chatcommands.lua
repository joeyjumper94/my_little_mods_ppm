local odd_but_essential_concommands={
	["ppm_editor"]="ppm_chared3"
}
if SEVER then--[[
	hook.Add("PlayerSay","ppm_chat_commands",function(ply,text,team)
		if string.StartWith(text,"!ppm") or string.StartWith(text,"/ppm") then
			if !timer.Exists(tostring(ply:SteamID64()).." ppm_chat_command_antispam") then
				timer.Create(tostring(ply:SteamID64()).." ppm_chat_command_antispam",1.1,1,function()
					local string=table.concat(string.Split(string.Split(text,"ppm")[2]," "),'","')
					if ply and string then
						ply:SendLua('RunConsoleCommand("ppm'..string..'")')
						timer.Remove(tostring(ply:SteamID64()).." ppm_chat_command_antispam")
					end
				end)
				timer.Remove(tostring(ply:SteamID64()).." ppm_chat_command_antispam")
			end
		end
	end)]]
else
	hook.Add("OnPlayerChat","ppm_chat_commands",function(ply,text,Team,Dead)
		if string.StartWith(text,"!ppm") or string.StartWith(text,"/ppm") then
			if !timer.Exists("ppm_no_spam") then 
				timer.Adjust("ppm_no_spam",1,1,function()
					cmd="ppm"..table.concat(string.Split(string.Split(text,"ppm")[2]," "),'","')
					RunConsoleCommand(cmd)
					if string.StartWith(text,"ppm_readme") then
						RunConsoleCommand("toggleconsole")
					end
				end)
			end
		end
	end)
end