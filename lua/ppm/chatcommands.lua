if CLIENT then
	hook.Add("OnPlayerChat","ppm_chat_commands",function(ply,text,Team,Dead)
		if ply!=LocalPlayer() then return end--this will make it so that only the player who said something will have a command run
		text=string.lower(text)
		if string.StartWith(text,"!ppm") or string.StartWith(text,"/ppm") then
			cmd=string.Split(string.Split(text,"ppm")[2]," ")
			if cmd and cmd[1] then
				RunConsoleCommand("ppm"..cmd[1],cmd[2],cmd[3])
				if cmd[1]=="ppm_readme" then
					LocalPlayer():PrintMessage(HUD_PRINTTALK,"look in console")
				end
			end
		end
	end)
end
