AddCSLuaFile()
print("Loading Equestrian Wastelanders PPM")
player_manager.AddValidModel("pony","models/ppm/player_default_base.mdl")
player_manager.AddValidModel("ponynj","models/ppm/player_default_base_nj.mdl")   
local FastDL=CreateConVar("ppm_Fastdl","1",FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,"should we automatically add this to the list of stuff people download while joining?"):GetBool()
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
	if FastDL then
		resource.AddWorkshop("945735699")
	end
	add_files("ppm/")
else
	list.Set("PlayerOptionsModel","pony","models/ppm/player_default_base.mdl") 
	list.Set("PlayerOptionsModel","ponynj","models/ppm/player_default_base_nj.mdl") 
end

include("ppm/init.lua")
