local draw_in_editor_text=CreateConVar("ppm_draw_in_editor","1",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED,'if set to 1, "in PPM editor" will be drawn above someone\'s head when in PPM editor'):GetBool()
local draw_visibly_armed=CreateConVar("ppm_draw_visibly_armed","1",FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED,'if set to 1, "visibly armed" will be drawn above someone\'s head when they weapon'):GetBool()
if SERVER then
	util.AddNetworkString("ppm_editor_status_cl_2_sv")
	util.AddNetworkString("ppm_editor_status_sv_2_cl")
	if !draw_in_editor_text then return end
	net.Receive("ppm_editor_status_cl_2_sv",function(ply,len)
		if ply and ply:IsValid() then
			local bool=net.ReadBool()
			net.Start("ppm_editor_status_sv_2_cl",false)
			net.WriteEntity(ply)
			net.WriteBool(bool)
			net.Send()--Omit(ply)
		end
	end)
else
	PPM.notify_editor=function(bool)
		if !draw_in_editor_text then return end
		net.Start("ppm_editor_status_cl_2_sv",false)
		net.WriteBool(bool)
		net.SendToServer()
	end

	net.Receive("ppm_editor_status_sv_2_cl",function(sender,len)
		local ply=net.ReadEntity()
		local bool=net.ReadBool()
		if ply and ply:IsValid() then
			ply.in_ppm_editor=bool
		end
	end)

	hook.Add("HUDPaint","ppm_draw_in_editor",function()
		for k,ply in pairs(player.GetAll()) do
			if ply.in_ppm_editor and ply!=LocalPlayer() then
				local pos_3d = ply:EyePos() + Vector(0,0,0)
				local pos_2d = (pos_3d):ToScreen()
				draw.DrawText("In PPM Editor",PPM.EDM_FONT,pos_2d.x,pos_2d.y,Color(255,255,255,math.Clamp((pos_3d):Distance(EyePos()) * -1 + 500, 0, 500)/500*255),TEXT_ALIGN_CENTER)
			end
		end
	end)
end

if CLIENT then
	local visibly_not_armed={
		--common weapons in darkrp and sandbox
		["gmod_camera"]=true,
		["gmod_tool"]=true,
		["keys"]=true,
		["med_kit"]=true,
		["pocket"]=true,
		["weapon_keypadchecker"]=true,
		["weapon_physgun"]=true,
		["weaponchecker"]=true,

		--trouble in terrorist town weapons
		["weapon_ttt_binoculars"]=true,
		["weapon_ttt_health_station"]=true,
		["weapon_ttt_unarmed"]=true,
		["weapon_ttt_wtester"]=true,
		["weapon_zm_carry"]=true,		
	}
	print("hello")

	hook.Add("HUDPaint","ppm_draw_armed_text",function()
		for k,ply in pairs(player.GetAll()) do
			if ply:GetActiveWeapon():IsValid() and !visibly_not_armed[ply:GetActiveWeapon():GetClass()] and ply!=LocalPlayer() and !util.TraceLine({start=GetViewEntity():GetPos(),endpos=ply:GetShootPos(),filter={ply,GetViewEntity()}}).Hit then
				local pos_3d = ply:EyePos()
				local pos_2d = (pos_3d):ToScreen()
				draw.DrawText("\nVisbly Armed",PPM.EDM_FONT,pos_2d.x,pos_2d.y,Color(255,255,255,math.Clamp((pos_3d):Distance(EyePos())*-1+500,0,500)/500*255),TEXT_ALIGN_CENTER)
			end
		end
	end)
end