local FCVAR_ARCHIVE_REPLICATED=FCVAR_REPLICATED
if SERVER then
	FCVAR_ARCHIVE_REPLICATED=bit.bor(FCVAR_REPLICATED,FCVAR_ARCHIVE)
end
PPM.height_min=CreateConVar("ppm_height_min","-2",FCVAR_ARCHIVE_REPLICATED,"minimum for leg and neck scaling",-4,.99):GetFloat()or -2
PPM.height_max=CreateConVar("ppm_height_max","2",FCVAR_ARCHIVE_REPLICATED,"maximum for leg and neck scaling",1.01,7):GetFloat()or 3
if SERVER then
	util.AddNetworkString"ppm_height"
	cvars.AddChangeCallback("ppm_height_max",function(v,o,n)
		n=tonumber(n)or 2
		PPM.height_max=n
		net.Start"ppm_height"
		net.WriteFloat(n)
		net.WriteBool(true)
		net.Broadcast()
	end,"ppm_height")
	cvars.AddChangeCallback("ppm_height_min",function(v,o,n)
		n=tonumber(n)or -2
		PPM.height_min=n
		net.Start"ppm_height"
		net.WriteFloat(n)
		net.WriteBool(false)
		net.Broadcast()
	end,"ppm_height")
else
	net.Receive("ppm_height",function(len,ply)
		local n=net.ReadFloat()
		local controlls=PPM.Editor3_nodes.pony_body.body.controlls
		if net.ReadBool()then
			PPM.height_max=n
			controlls[5].max=n
			controlls[6].max=n
			controlls[8].max=n
		else
			PPM.height_min=n
			controlls[5].min=n
			controlls[6].min=n
--			controlls[8].min=n
		end
	end)
end
PPM.scale_min=CreateConVar("ppm_scale_min",".4",FCVAR_ARCHIVE_REPLICATED,"minimum for model scaling",.01,.99):GetFloat()or .5
PPM.scale_max=CreateConVar("ppm_scale_max","1.6",FCVAR_ARCHIVE_REPLICATED,"maximum for model scaling",1.01,4):GetFloat()or 4
if SERVER then
	util.AddNetworkString"ppm_scale"
	cvars.AddChangeCallback("ppm_scale_min",function(v,o,n)
		n=tonumber(n)or .4
		PPM.scale_min=n
		net.Start"ppm_scale"
		net.WriteFloat(n)
		net.WriteBool(false)
		net.Broadcast()
		for k,v in ipairs(ents.GetAll())do
			if PPM.isValidPonyLight(v)then
				PPM.SetModelScale(v)
			end
		end
	end,"ppm_scale")
	cvars.AddChangeCallback("ppm_scale_max",function(v,o,n)
		n=tonumber(n)or 2.4
		PPM.scale_max=n
		net.Start"ppm_scale"
		net.WriteFloat(n)
		net.WriteBool(true)
		net.Broadcast()
		for k,v in ipairs(ents.GetAll())do
			if PPM.isValidPonyLight(v)then
				PPM.SetModelScale(v)
			end
		end
	end,"ppm_scale")
else
	net.Receive("ppm_scale",function(len,ply)
		local n=net.ReadFloat()
		local controlls=PPM.Editor3_nodes.pony_body.body.controlls
		if net.ReadBool()then
			PPM.scale_max=n
			controlls[7].max=n
		else
			PPM.scale_min=n
			controlls[7].min=n
		end
	end)
end

local ppm_force_workshop=CreateConVar("ppm_force_workshop","1",FCVAR_ARCHIVE_REPLICATED,"should clients download ppm before joining, requires restart after disabling",0,1)
if SERVER then
	cvars.AddChangeCallback("ppm_force_workshop",function(v,o,n)
		if n!="0"then
			resource.AddWorkshop"945735699"
		else
			PrintMessage(HUD_PRINTTALK,"ppm_force_workshop has been set to 0, a restart is required to have an effect")
			print"ppm_force_workshop has been set to 0, a restart is required to have an effect"
		end
	end,"ppm_force_workshop")
	timer.Simple(1,function()
		if ppm_force_workshop:GetBool()then
			resource.AddWorkshop"945735699"--make clients download the addon
		end
	end)
end