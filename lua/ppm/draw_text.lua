local flags=bit.bor(FCVAR_REPLICATED)
local ppm_draw_in_editor=CreateConVar("ppm_draw_in_editor","1",Flags,'if set to 1, "in PPM editor" will be drawn above someone\'s head when in PPM editor'):GetBool()
local ppm_draw_visibly_armed=CreateConVar("ppm_draw_visibly_armed","1",Flags,'if set to 1, "visibly armed" will be drawn above someone\'s head when they weapon'):GetBool()
timer.Create("ppm/draw_text_cvars",10,0,function()
	ppm_draw_in_editor=GetConVar"ppm_draw_in_editor":GetBool()
	ppm_draw_visibly_armed=GetConVar"ppm_draw_visibly_armed":GetBool()
end)
if SERVER then
	util.AddNetworkString("ppm_editor_status")
	net.Receive("ppm_editor_status",function(len,ply)
		if ppm_draw_in_editor and ply and ply:IsValid() then
			local bool=net.ReadBool() or false
			ply:SetNWBool("ppm_editor_status",bool)
		end
	end)
	return
end
PPM.notify_editor=function(bool)
	if ppm_draw_in_editor and CLIENT then
		net.Start"ppm_editor_status"
		net.WriteBool(bool)
		net.SendToServer()
	end
end
local nodraw={
	[TEAM_CONNECTING]=true,
	[TEAM_UNASSIGNED]=false,
	[TEAM_SPECTATOR]=true,
}
local visibly_not_armed={
	--common weapons in darkrp and sandbox
	itemstore_pickup=true,--inventory pickup
	gmod_camera=true,--camera
	gmod_tool=true,--toolgun
	pocket=true,--darkrp pocket
	keys=true,--darkrp keys
	med_kit=true,--darkrp medkit
	revenants_blowtorch=true,--blowtorch i made as a raiding tool
	weapon_medkit=true,--sandbox medkit
	weapon_keypadchecker=true,--keypad checker used by admins to check keypads and fading doors
	weapon_physcannon=true,--gravity gun
	weapon_physgun=true,--physgun
	weaponchecker=true,--checks a player's weapons
	none=true,--hands
	unarrest_stick=true,--unarrest baton
	--trouble in terrorist town weapons
	weapon_ttt_binoculars=true,--detective binoculars
	weapon_ttt_health_station=true,--allows detectives to place a health station
	weapon_ttt_unarmed=true,--the "holstered" swep
	weapon_ttt_wtester=true,--dna tester for detectives
	weapon_zm_carry=true,--magneto stick
}
hook.Add("HUDPaint","ppm_draw_text",function()
	local ViewEntity=GetViewEntity()
	for k,ply in pairs(player.GetAll()) do
		if ply==ViewEntity then continue end--no need to draw text on the client
		if !ply:Alive() then continue end--no need to draw stuff for dead players
	--	if nodraw[ply:Team()] then continue end
		if ppm_draw_in_editor and ply:GetNWBool("ppm_editor_status",false) then
			local pos_3d = ply:EyePos() + Vector(0,0,0)
			local pos_2d = (pos_3d):ToScreen()
			draw.DrawText("In PPM Editor",PPM.EDM_FONT,pos_2d.x,pos_2d.y,Color(255,255,255,math.Clamp(250000-(pos_3d):DistToSqr(EyePos()),0,250000)*0.51),TEXT_ALIGN_CENTER)
		end
		if ppm_draw_visibly_armed
		and PPM.pony_models[ply:GetModel()]
		and ply:GetActiveWeapon():IsValid() 
		and !visibly_not_armed[ply:GetActiveWeapon():GetClass()] --do they have a dangerous weapon?
		and !util.TraceLine({
			start=ViewEntity:GetPos(),--start a trace from where their camera is
			endpos=ply:GetShootPos(),--end the trace where the target is
			filter={ply,ViewEntity}--don't need to hit the target or what the client is looking through
		}).Hit then
			local pos_3d = ply:EyePos()
			local pos_2d = (pos_3d):ToScreen()
			draw.DrawText("\nVisbly Armed",PPM.EDM_FONT,pos_2d.x,pos_2d.y,Color(255,255,255,math.Clamp(250000-(pos_3d):DistToSqr(EyePos()),0,250000)*0.51),TEXT_ALIGN_CENTER)
		end
	end
end)
