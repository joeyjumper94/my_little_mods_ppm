AddCSLuaFile()
print("Loading My Little Mods PPM")
player_manager.AddValidModel("pony","models/ppm/player_default_base.mdl")
player_manager.AddValidModel("ponynj","models/ppm/player_default_base_nj.mdl")   
if SERVER then
	local function add_files(dir)
		local files,folders = file.Find(dir.."*", "LUA")

		for key,file_name in pairs(files) do
			AddCSLuaFile(dir..file_name)
		end

		for key,folder_name in pairs(folders) do
			add_files(dir..folder_name.."/")
		end
	end
	timer.Simple(1,function()
		resource.AddWorkshop"945735699"--make clients download the addon
	end)
	add_files("ppm/")
else
	list.Set("PlayerOptionsModel","pony","models/ppm/player_default_base.mdl") 
	list.Set("PlayerOptionsModel","ponynj","models/ppm/player_default_base_nj.mdl") 
end

include("ppm/init.lua")
