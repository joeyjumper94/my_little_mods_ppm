if!file.Exists("autorun/injector.lua","LUA")then return end
local cppm_usehands=CreateConVar("cppm_usehands","1",FCVAR_REPLICATED,"Activate|Disactivate pony hands.(Only C_ models!)")
local cppm_active=CreateConVar("cppm_active","1",FCVAR_REPLICATED,"Activate|Disactivate CPPM")

local copy=function(t,f)--helper function to copy specific ponydata more cheaply than PPM.copyLocalPonyTo(FROM,TO) which copies all
	for k,v in pairs{
		bodydetail1=true,
		bodydetail1_c=true,
		bodydetail2=true,
		bodydetail2_c=true,
		bodydetail3=true,
		bodydetail3_c=true,
		bodydetail4=true,
		bodydetail4_c=true,
		bodydetail5=true,
		bodydetail5_c=true,
		bodydetail6=true,
		bodydetail6_c=true,
		bodydetail7=true,
		bodydetail7_c=true,
		bodydetail8=true,
		bodydetail8_c=true,
		bodydetail9=true,
		bodydetail9_c=true,
		bodydetail10=true,
		bodydetail10_c=true,
		bodydetail11=true,
		bodydetail11_c=true,
		bodydetail12=true,
		bodydetail12_c=true,
		bodyweight=true,
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
