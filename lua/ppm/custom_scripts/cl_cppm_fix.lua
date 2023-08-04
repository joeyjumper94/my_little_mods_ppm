if!file.Exists("autorun/injector.lua","LUA")then return end
local cppm_usehands=CreateConVar("cppm_usehands","1",FCVAR_REPLICATED,"Activate|Disactivate pony hands.(Only C_ models!)")
local cppm_active=CreateConVar("cppm_active","1",FCVAR_REPLICATED,"Activate|Disactivate CPPM")

local copy=function(t,f)--helper function to copy specific ponydata more cheaply than PPM.copyLocalPonyTo(FROM,TO) which copies all
	for k,v in pairs{
		coatcolor=true,
		coatphongboost=true,
		coatphongexponent=true,
	}do
		f.ponydata[k]=t.ponydata[k]
	end
end
hook.Add("PreDrawPlayerHands","CPPM_handfix",function(hand,vm,ply,wpn)
	if!CPPM then return end
	if!cppm_usehands:GetBool()or!cppm_active:GetBool()then return end
	ply=ply or LocalPlayer()
	wpn=wpn or NULL
	if wpn:IsValid()and wpn:GetWeaponViewModel():StartWith"models/weapons/c_"then
		if!hand:IsValid()then return end
		if!PPM.isValidPony(ply)then return end
		if!hand.ponydata then
			PPM.setupPony(hand)
			hand.isEditorPony = true
		elseif CPPM:IsPonyModel(hand:GetModel()) then
			--PPM.copyLocalPonyTo(ply,hand)
			copy(ply,hand)
			PPM.PrePonyDraw(hand,true)
		end
	else
		return true
	end
end)
timer.Create("CPPM_handfix",1,0,function()--execute every second
	hook.Remove("PreDrawPlayerHands","CPPMHook#4")--never let CPPM's normal hook exist
end)
