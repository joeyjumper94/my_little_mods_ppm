if SERVER then
	return
end
local _L={}
local Icon_Name="gui/mlmppme_icon.png"
if !file.Exists("materials/"..Icon_Name,"GAME") then
	Icon_Name="gui/pped_icon.png"
end
list.Set(
	"DesktopWindows",
	"PPMitor3",
	{
		title		="MLMPPM Editor",
		icon		=Icon_Name,
		width		=960,
		height		=700,
		onewindow	=true,
		init		=function(icon,window)
			window:Remove()
			PPM.Editor3Open()
		end
	}
)
PPM.EDM_FONT="TAHDS"
surface.CreateFont(PPM.EDM_FONT,{
	font="Arial",
	size=15,
	weight=2500,
	blursize=0,
	scanlines=0,
	antialias=true,
	underline=false,
	italic=false,
	strikeout=false,
	symbol=false,
	rotary=false,
	shadow=false,
	additive=false,
	outline=false
})
concommand.Add("ppm_chared3",function()
	if PPM.Editor3 and PPM.Editor3:IsValid() then return end
	PPM.Editor3Open()
end)
concommand.Add("ppm_editor",function()
	if PPM.Editor3 and PPM.Editor3:IsValid() then return end
	PPM.Editor3Open()
end)
if PPM.Editor3 and PPM.Editor3.Close then
	PPM.Editor3.Close()
	timer.Simple(0,function()
		if PPM.Editor3 and PPM.Editor3:IsValid()then
		else
			PPM.Editor3Open()
		end
	end)
end
PPM.Editor3_ponies=PPM.Editor3_ponies or {}
PPM.Editor3_nodes=PPM.Editor3_nodes or {}
PPM.Editor3_presets=PPM.Editor3_presets or {}
PPM.E3_CURRENT_NODE=nil
PPM.nodebuttons=PPM.nodebuttons or{}
local bone_offsets={
	[0]=Vector(-3.3330664634705,0.0024212002754211,28.161472320557),
	[1]=Vector(-3.3330664634705,0.0024212002754211,28.161472320557),
	[2]=Vector(2.0388174057007,0.016715928912163,28.344621658325),
	[3]=Vector(7.3947377204895,0.036377370357513,28.79695892334),
	[4]=Vector(7.3947377204895,0.036377370357513,28.79695892334),
	[5]=Vector(9.3425626754761,-0.00022458657622337,32.237895965576),
	[6]=Vector(9.0713481903076,-0.06925792992115,36.090991973877),
	[7]=Vector(11.682905197144,-0.14576078951359,38.437377929688),
	[8]=Vector(-7.0731310844421,3.8863604068756,25.773149490356),
	[9]=Vector(-6.3640880584717,4.5090179443359,17.040433883667),
	[10]=Vector(-10.183971405029,3.6159369945526,14.337207794189),
	[11]=Vector(-14.370935440063,4.2843642234802,5.4655714035034),
	[12]=Vector(-13.81724357605,4.1309480667114,1.9274878501892),
	[13]=Vector(-7.0733480453491,-3.8771884441376,25.766466140747),
	[14]=Vector(-5.4003829956055,-4.4421458244324,17.162475585938),
	[15]=Vector(-8.8391304016113,-3.6168234348297,13.970238685608),
	[16]=Vector(-13.626216888428,-4.1632342338562,5.3988590240479),
	[17]=Vector(-13.33588218689,-3.8765244483948,1.8377285003662),
	[18]=Vector(6.0389356613159,2.7768964767456,29.317590713501),
	[19]=Vector(6.3247356414795,2.6087961196899,20.867740631104),
	[20]=Vector(2.6272099018097,2.8099317550659,16.898740768433),
	[21]=Vector(3.4035353660583,3.4313035011292,10.751828193665),
	[22]=Vector(3.7144780158997,3.9734539985657,4.7342143058777),
	[23]=Vector(5.0983467102051,3.9899649620056,1.5492520332336),
	[24]=Vector(6.0388946533203,-2.7077684402466,29.298013687134),
	[25]=Vector(6.1633815765381,-2.7524275779724,20.842697143555),
	[26]=Vector(2.5053887367249,-2.656919002533,16.833312988281),
	[27]=Vector(3.2547719478607,-3.1719884872437,10.673244476318),
	[28]=Vector(3.6626029014587,-3.7564172744751,4.6653876304626),
	[29]=Vector(5.1136150360107,-3.8954613208771,1.5134706497192),
	[30]=Vector(0,0,0),
	[31]=Vector(0,0,0),
	[32]=Vector(0,0,0),
	[33]=Vector(0,0,0),
	[34]=Vector(0,0,0),
	[35]=Vector(0,0,0),
	[36]=Vector(0,0,0),
	[37]=Vector(0,0,0),
	[38]=Vector(0,0,0),
	[39]=Vector(0,0,0),
	[40]=Vector(0,0,0),
	[41]=Vector(0,0,0),
	[42]=Vector(0,0,0),
}
function PPM.Editor3Open()
	PPM.notify_editor(true)
	CUR_LEFTPLATFORM_CONTROLLS={}
	CUR_RIGHTPLATFORM_CONTROLLS={}
	WEARSLOTSL={}
	WEARSLOTSR={}
	PPM.ed3_selectedNode=nil
	LocalPlayer().pi_wear=LocalPlayer().pi_wear or {}
	local window=vgui.Create("DFrame") 
	window:ShowCloseButton(true)
	window:SetSize(ScrW(),ScrH()) 
	window:SetBGColor(255,0,0)
	window:SetVisible(true)
	window:SetDraggable(false)
	window:MakePopup()
	window:SetTitle("PPM Editor 3")
	window.Paint=function() 
		surface.SetDrawColor(0,0,0,255) 
		surface.DrawRect(0,0,window:GetWide(),window:GetTall())
	end
	PPM.Editor3=window
	window:SetKeyboardInputEnabled(true)
	local mdl=window:Add("DModelPanel")
	window.Close=function()
		PPM.notify_editor(false)
		PPM.editor3_clothing :Remove()
		PPM.editor3_pony:Remove()
		window:Remove()
		CUR_LEFTPLATFORM_CONTROLLS={}
		CUR_RIGHTPLATFORM_CONTROLLS={}
		WEARSLOTSL={}
		WEARSLOTSR={}
		PPM.Editor3=nil
		mdl.backgroundmodel_sky:Remove()
		mdl.backgroundmodel_ground:Remove()
		mdl.backgroundmodel:Remove()
	end
--[[
	local top=vgui.Create("DPanel",window)
	top:SetSize(20,20) 
	top:Dock(TOP)
	top.Paint=function() -- Paint function 
		surface.SetDrawColor(50,50,50,255) 
		surface.DrawRect(0,0,top:GetWide(),top:GetTall())
	end
	]]
	PPM.faceviewmode=false
	--smenupanel:SetSize(w,h) 
	--smenupanel:SetPos(x+w,y)
	--smenupanel:SizeTo(fw,fh,0.4,0,1) 
	--smenupanel:MoveTo(fx,fy,0.4,0,1) 
	--PPM.smenupanel.Paint=function() -- Paint function 
		--surface.SetDrawColor(0,0,0,255) 
		--surface.DrawRect(0,0,PPM.smenupanel:GetWide(),PPM.smenupanel:GetTall())
	--end
	----------------------------------------------------------/
	PPM.modelview=mdl
	mdl:Dock(FILL)
	mdl:SetFOV(70)
	mdl:SetModel("models/ppm/player_default_base.mdl")
	mdl.camang=Angle(0,70,0)
	mdl.camangadd=Angle(0,0,0)
	local time=0
	function mdl:LayoutEntity()
		PPM.copyLocalPonyTo(LocalPlayer(),self.Entity) 
		PPM.editor3_pony=self.Entity
		PPM.editor3_pony.ponyCacheTarget=LocalPlayer():SteamID64()
		self.Entity.isEditorPony=true 
		if mdl.model2==nil then
			mdl.model2=ClientsideModel("models/ppm/player_default_clothes1.mdl",RENDER_GROUP_OPAQUE_ENTITY) 
			mdl.model2:SetNoDraw(true)
			mdl.model2:SetParent(self.Entity)
			mdl.model2:AddEffects(EF_BONEMERGE) 
			PPM.editor3_clothing=mdl.model2
		end
		if LocalPlayer().pi_wear[50]!=nil then
			self.Entity.ponydata.bodyt0=LocalPlayer().pi_wear[50].wearid or 1
		end
		PPM.editor3_pony:SetPoseParameter("move_x",0)
		if(LocalPlayer().pi_wear!=nil) then 
			for i,item in pairs(LocalPlayer().pi_wear) do
				PPM.setBodygroupSafe(PPM.editor3_pony,item.bid,item.bval) 
				PPM.setBodygroupSafe(mdl.model2,item.bid,item.bval) 
			end
		end
		self.OnMousePressed=function()
			self.ismousepressed=true
			self.mdx,self.mdy=self:CursorPos(); 
			self:SetCursor("sizeall");
		end
		self.OnMouseReleased=function()
			self.ismousepressed=false
			self.camang=self.camang+self.camangadd
			self.camangadd=Angle(0,0,0)
			self:SetCursor("none");
		end
		--self:RunAnimation()
		self:SetAnimSpeed(0.5)
		self:SetAnimated(false)
		if PPM.faceviewmode then 
			local attachmentID=self.Entity:LookupAttachment("eyes");
			local attachpos=self.Entity:GetAttachment(attachmentID).Pos+Vector(-10,0,7)
			self.vLookatPos=self.vLookatPos + (attachpos-self.vLookatPos)*.05
			mdl.fFOV=mdl.fFOV+(40-mdl.fFOV)*.02
		else
			self.vLookatPos=self.vLookatPos+ (Vector(0,0,25)-self.vLookatPos)*.05
			mdl.fFOV=mdl.fFOV+(70-mdl.fFOV)*.02
		end
		if self.ismousepressed then 
			local x,y=self:CursorPos();
			self.camangadd=Angle(math.Clamp(self.camang.p-y+self.mdy,-89,13)-self.camang.p,-x+self.mdx,0)
		end
		local camvec=(Vector(1,0,0)*120)
		camvec:Rotate(self.camang+self.camangadd) 
		self:SetCamPos(self.vLookatPos+camvec)--Vector(90,0,60))
		self.camvec=camvec
		time=time+0.02
		PPM.setBodygroups(PPM.editor3_pony,true)
		PPM.SetModelScale(PPM.editor3_pony,true)
	end
	mdl.t=0
	mdl.backgroundmodel_sky=ClientsideModel("models/ppm/decoration/skydome.mdl")
	mdl.backgroundmodel_sky:SetModelScale(25,0)
	mdl.backgroundmodel_sky:SetAngles(Angle(0,30,0))
	mdl.backgroundmodel_ground=ClientsideModel("models/ppm/decoration/ground.mdl")
	mdl.backgroundmodel_ground:SetModelScale(25,0)
	mdl.backgroundmodel=ClientsideModel("models/ppm/decoration/building.mdl")
	mdl.backgroundmodel:SetModelScale(25,0)
	--mdl.backgroundmodel:SetScale(0.5)--Vector(0.5,0.5,1))
	mdl.backgroundmodel:SetPos(Vector(0,0,-15))
	mdl.backgroundmodel_ground:SetPos(Vector(0,0,-15))
	mdl.Paint=function()------------------------------------
		if (!IsValid(mdl.Entity)) then return end
		local x,y=mdl:LocalToScreen(0,0)
		mdl:LayoutEntity(mdl.Entity)
		PPM.PrePonyDraw(mdl.Entity,true)
		local ang=mdl.aLookAngle
		if (!ang) then
			ang=(mdl.vLookatPos-mdl.vCamPos):Angle()
		end
		local w,h=mdl:GetSize()
		cam.Start3D(mdl.vCamPos,ang,mdl.fFOV,x,y,w,h,5,4096)
		cam.IgnoreZ(false)
		PPM.PrePonyDraw(PPM.modelview.Entity,PPM.modelview.Entity.ponydata)
		surface.SetMaterial(Material("gui/editor/group_circle.png"))
		surface.SetDrawColor(0,0,0,255) 
		surface.DrawRect(-30,-30,30,30)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(mdl.Entity:GetPos())
		render.ResetModelLighting(mdl.colAmbientLight.r*.003921568627451,mdl.colAmbientLight.g*.003921568627451,mdl.colAmbientLight.b*.003921568627451)
		render.SetColorModulation(mdl.colColor.r*.003921568627451,mdl.colColor.g*.003921568627451,mdl.colColor.b*.003921568627451)
		render.SetBlend(mdl.colColor.a*.003921568627451)
		render.FogMode(MATERIAL_FOG_LINEAR)
		render.FogStart(0)
		render.FogEnd(3000)
		render.FogMaxDensity(0.5)
		render.FogColor(219,242,255)
		for i=0,6 do
			local col=mdl.DirectionalLight[ i ]
			if (col) then
				render.SetModelLighting(i,col.r*.003921568627451,col.g*.003921568627451,col.b*.003921568627451)
			end
		end
		render.SetMaterial(Material("gui/editor/group_circle.png"))
		for k=0,10 do
			local div=(10-k)
			local dim=25+10-k
			--render.SetBlend(k/10)
			--render.SetColorModulation(k/10,k/10,k/10)
			render.DrawQuad(Vector(-dim,-dim,-div),Vector(-dim,dim,-div),Vector(dim,dim,-div),Vector(dim,-dim,-div))
		end
		--local dim=50 
		--render.DrawQuad(Vector(-dim,-dim,-10),Vector(-dim,dim,-10),Vector(dim,dim,-10),Vector(dim,-dim,-10))
		--local dim=25 
		--render.DrawQuad(Vector(-dim,-dim,0),Vector(-dim,dim,0),Vector(dim,dim,0),Vector(dim,-dim,0))
		mdl.backgroundmodel_sky:DrawModel()
		mdl.backgroundmodel_ground:DrawModel()
		mdl.backgroundmodel:DrawModel()
		mdl.Entity:DrawModel()
		mdl.model2:DrawModel()
		render.SuppressEngineLighting(false)
		--cam.IgnoreZ(false)
		cam.End3D()
		--[[
			local attachmentID=mdl.Entity:LookupAttachment("eyes");
			local attachpos=mdl.Entity:GetAttachment(attachmentID).Pos
			mdl.t=mdl.t+0.01
			local x,y,viz=	_L.VectorToLPCameraScreen(((mdl.Entity:GetPos()+ attachpos)- mdl.camvec-mdl.vLookatPos):GetNormal(),w,h,ang,math.rad(mdl.fFOV))
			--local ww,hh=PPM.selector_circle[1]:GetSize()
				if viz then
					--PPM.selector_circle[1]:SetPos(x-ww*.5,y-hh*.5)
					local tt=4 
					surface.SetDrawColor(255,0,0,255) 
					surface.DrawRect(x,y,tt,tt)
				else
					--PPM.selector_circle[1]:SetPos(-ww,-hh)
				end
				--PPM.selector_circle[1]:Draw()
				]]
		if PPM.E3_CURRENT_NODE and!PPM.E3_CURRENT_NODE.name then
			for k,v in pairs(PPM.E3_CURRENT_NODE) do
				local button=PPM.nodebuttons[k]
				local offset,bone=vector_origin,v.bone
				if bone and!tonumber(bone)then
					bone=mdl.Entity:LookupBone(bone)
				end
				if bone then
					offset=mdl.Entity:GetBonePosition(bone)-bone_offsets[bone]
				end
				local x,y,viz=_L.VectorToLPCameraScreen(((mdl.Entity:GetPos()+offset+v.pos)- mdl.camvec-mdl.vLookatPos):GetNormal(),w,h,ang,math.rad(mdl.fFOV))
				local tt=50
				local shift=25
				local RADIUS=20
				local RADIED=25
				x=x+shift
				y=y+shift
				local dist=1/math.max(1,Vector(x,y):Distance(Vector(input.GetCursorPos()))*.03)
				surface.SetDrawColor(255,255,255,255) 
				if(v==PPM.ed3_selectedNode) then
					local xcwidth=200
					local direction=(Vector(x-tt*.5,y-tt*.5) - Vector(40+xcwidth+tt*.25,20+tt*.25)):GetNormalized()
					surface.DrawLine(x-tt*.5-direction.x*RADIUS+22,y-tt*.5-direction.y*RADIUS+7,40+xcwidth+tt*.25,20+tt*.25) 
					surface.SetDrawColor(155,255,255,255)
					surface.SetMaterial(Material("gui/editor/lid_str.png"))
					surface.DrawTexturedRectRotated(40+xcwidth,20,tt,tt,180)
					surface.SetMaterial(Material("gui/editor/lid_mid.png"))
					surface.DrawTexturedRectRotated(40+xcwidth*.5,20,xcwidth,tt,180)
					surface.SetMaterial(Material("gui/editor/lid_end.png"))
					surface.DrawTexturedRectRotated(40,20,tt,tt,180)
					local CK=v.name:upper()
					surface.SetFont(PPM.EDM_FONT)
					surface.SetTextPos(60-tt*.5,20)
					surface.SetTextColor(0,0,0,255)
					surface.DrawText(CK)
					surface.SetTextPos(60-tt*.5-2,20-2)
					surface.SetTextColor(255,204,204,255)
					surface.DrawText(CK)
					surface.SetDrawColor(0,255,0,255)
					surface.SetMaterial(Material("gui/editor/lid_ind.png"))
					surface.DrawTexturedRectRotated(x-RADIED+22,y-RADIED+7,RADIED*2,RADIED*2,0)
				else
					surface.SetFont(PPM.EDM_FONT)
					surface.SetTextPos(x-tt+15,y-tt*.5)
					surface.SetTextColor(51,51*dist,51*dist,255)
					surface.DrawText(v.name)
					surface.SetTextPos(x-tt-2+15,y-tt*.5-2)
					surface.SetTextColor(255,255*dist,255*dist,255)
					surface.DrawText(v.name)
				end
				if button then
					button.alpha=255*dist-127
					--local ww,hh=button:GetSize()
					--button:SetAlpha(155*dist)
					button:SetPos(x-tt*.5-12,y-tt*.5+25)
					--MsgN(button)
				end
			end
		end
		mdl.LastPaint=RealTime()
	end
	--APPLY BUTTON
	local APPLY=vgui.Create("DImageButton",PPM.Editor3) 
	APPLY:SetPos(ScrW()*.5-64,ScrH()-64) 
	APPLY:SetSize(128,64) 
	APPLY:SetImage("gui/editor/gui_button_apply.png") 
	APPLY:SetColor(Color(255,255,255,255)) 
	APPLY.DoClick=function() 
		local cm=LocalPlayer():GetInfo("cl_playermodel")
		if(cm!="pony" and cm!="ponynj") then
			RunConsoleCommand("cl_playermodel","ponynj")
		end
		--PPM.SendCharToServer(LocalPlayer())
		local sig=PPM.Save_settings()
		PPM.UpdateSignature(sig)
		PPM.colorFlash(APPLY,0.1,Color(0,200,0),Color(255,255,255)) 
	end
	_L.spawnTabs()
	_L.setupCurPone()
end
local taboffcet=0
local tabcount=0
local tabs={}
local selected_tab=nil
function _L.spawnTabs()
	taboffcet=5*-32
	local ponymodel=LocalPlayer():GetInfo("cl_playermodel")
	if(PPM.Editor3_ponies[ponymodel]!=nil) then
		_L.spawnTab("node_main")
		_L.spawnTab("node_body","b")
		_L.spawnTab("node_face","h")
		_L.spawnTab("node_equipment","o")
		_L.spawnTab("node_presets")
	end
end
function _L.spawnTab(nodename,pfx)
	pfx=pfx or "e"
	local TABBUTTON=vgui.Create("DImageButton",PPM.Editor3)
	TABBUTTON.node=nodename
	TABBUTTON:SetSize(64,128)
	TABBUTTON.eyemode=(pfx=="h")
	TABBUTTON:SetPos(ScrW()*.5+taboffcet,-64)
	TABBUTTON:SetImage("gui/editor/gui_tab_"..pfx..".png")
	TABBUTTON.OnCursorEntered=function()
		if(selected_tab!=TABBUTTON) then
			local px,py=TABBUTTON:GetPos()
			TABBUTTON:SetPos(px,-50) 
		end
	end
	TABBUTTON.OnCursorExited=function()
		if(selected_tab !=TABBUTTON) then
			local px,py=TABBUTTON:GetPos()
			TABBUTTON:SetPos(px,-64)
		end
	end
	TABBUTTON.DoClick=function()
		if(selected_tab !=TABBUTTON) then
			if(IsValid(selected_tab)) then
				local px,py=selected_tab:GetPos()
				selected_tab:SetPos(px,-64)
			end
			local px,py=TABBUTTON:GetPos()
			TABBUTTON:SetPos(px,-40)
			selected_tab=TABBUTTON
			PPM.faceviewmode=TABBUTTON.eyemode
			PPM.ed3_selectedNode=nil
			PPM.E3_CURRENT_NODE=nil
			_L.cleanValueEditors()
			_L.cleanButtons()
			local ponymodel=LocalPlayer():GetInfo("cl_playermodel")
			if PPM.Editor3_ponies[ponymodel]and PPM.Editor3_nodes[PPM.Editor3_ponies[ponymodel][TABBUTTON.node]] then
				PPM.E3_CURRENT_NODE=PPM.Editor3_nodes[PPM.Editor3_ponies[ponymodel][TABBUTTON.node]]
				if PPM.E3_CURRENT_NODE.name then
					PPM.ed3_selectedNode=PPM.E3_CURRENT_NODE
					_L.spawnEditPanel()
					_L.spawnValueEditor()
				else
					_L.spawnButtons()
				end
			end
		end
	end
	taboffcet=taboffcet + 64
	tabcount=tabcount + 1
	tabs[tabcount]=TABBUTTON
	return TABBUTTON
end
function _L.setupCurPone()
	local ponymodel=LocalPlayer():GetInfo("cl_playermodel")
	if(PPM.Editor3_ponies[ponymodel]!=nil) then
		PPM.E3_CURRENT_NODE=PPM.Editor3_nodes[PPM.Editor3_ponies[ponymodel].node_body]
		_L.cleanButtons()
		_L.spawnButtons()
	else
		PPM.E3_CURRENT_NODE=nil
	end
end
function _L.cleanButtons()
	for k,v in pairs(PPM.nodebuttons) do
		if(IsValid(v))then
			v:Remove()
		end
	end
	PPM.nodebuttons={}
end
function _L.spawnButtons()
	if(PPM.E3_CURRENT_NODE!=nil)then
		for k,v in pairs(PPM.E3_CURRENT_NODE) do
			local button=vgui.Create("DButton",PPM.Editor3) 
			button:SetSize(80,20)
	--		button:SetImage("gui/editor/pictorect.png")
	--		button:SetAlpha(0)
			--button:SetColor(v.col or Vector(1,1,1))
			button.DoClick=function()
				PPM.ed3_selectedNode=v
				--if(v.onclick!=nil)then v.onclick() end
				_L.cleanValueEditors()
				_L.spawnEditPanel()
				_L.spawnValueEditor()
			end
			button.Paint=function(self,w,h)
				local a=self.alpha or 127
				if a>0 then
					surface.SetDrawColor(255,255,255,a+63)
					surface.DrawOutlinedRect(0,0,w,h)
					surface.DrawOutlinedRect(1,1,w-2,h-2)
				end
				return true
			end
			PPM.nodebuttons[k]=button
			--MsgN(PPM.nodebuttons[k])
		end
	end
end
function _L.spawnEditPanel()
	_L.cleanValueEditors()
	local smpanel=vgui.Create("DPanel",PPM.Editor3)
	local smpanel_inner=vgui.Create("DPanel",smpanel)
	local scrollb=vgui.Create("DVScrollBar",smpanel)
	smpanel.PerformLayout=function()
		--if(IsValid(PPM.smenupanel_inner) and IsValid(PPM.CDVScrollBar)) then
			smpanel_inner:SetSize(200,2000)
			scrollb:SetUp(1000,smpanel_inner:GetTall())
			smpanel_inner:SetPos(0,scrollb:GetOffset())
		--end
	end
	smpanel:SetSize(220,ScrH()-120)
	smpanel:SetPos(20,80)
	smpanel:SetAlpha(255) 
	--PPM.smenupanel_inner:Dock(LEFT)
	smpanel_inner:SetSize(200,2000)
	smpanel_inner:SetAlpha(255)
	scrollb:SetSize(20,ScrH()-100)
	--scrollb:SetPos(PPM.smenupanel:GetWide()-20,23)
	scrollb:SetUp(1000,2000)
	scrollb:SetEnabled(true)
	scrollb:Dock(RIGHT)
	PPM.smenupanel=smpanel
	--PPM.smenupanel_scroll=scroll
	PPM.smenupanel_inner=smpanel_inner
end
function _L.spawnValueEditor()
	if PPM.ed3_selectedNode!=nil and PPM.ed3_selectedNode.controlls!=nil then
		_L.spawnEditPanel()
		for k,v in ipairs(PPM.ed3_selectedNode.controlls) do
		--MsgN("preset ",v.type," ",v.name)
			if(PPM.Editor3_presets[v.type]!=nil) then
				--MsgN("has ",v.type)
				PPM.Editor3_presets[v.type].spawn(PPM.smenupanel_inner,v)
			end
		end
	end
end
function _L.cleanValueEditors()
	if IsValid(PPM.smenupanel)then 
		PPM.smenupanel:SetSize(20,20)
		PPM.smenupanel:Remove()
		--PPM.smenupanel=nil
	end
end
function PPM.vectorcircles(id)
	return Vector(math.sin(id-30),math.sin(id),math.sin(id+30))
end
function PPM.colorcircles(id)
	return Color(math.sin(id-30)*255,math.sin(id)*255,math.sin(id+30)*255)
end
function PPM.Save_settings() 
	local sig=PPM.Save("_current.txt",LocalPlayer().ponydata) 
	return sig
end
function PPM.Load_settings() 
	if (file.Exists("ppm/_current.txt","DATA")) then
		PPM.mergePonyData(LocalPlayer().ponydata,PPM.Load("_current.txt"))
		--PPM.SendCharToServer(LocalPlayer()) 
	else 
		PPM.randomizePony(LocalPlayer())
		--PPM.SendCharToServer(LocalPlayer()) 
	end
	local sig=PPM.Save_settings()
	PPM.UpdateSignature(sig)
end
function _L.VectorToLPCameraScreen(vDir,iScreenW,iScreenH,angCamRot,fFoV)
	--Same as we did above,we found distance the camera to a rectangular slice of the camera's frustrum,whose width equals the "4:3" width corresponding to the given screen height.
	local d=4 * iScreenH / (6 * math.tan(0.5 * fFoV));
	local fdp=angCamRot:Forward():Dot(vDir);
	--fdp must be nonzero (in other words,vDir must not be perpendicular to angCamRot:Forward())
	--or we will get a divide by zero error when calculating vProj below.
	if fdp==0 then
		return 0,0,-1
	end
	--Using linear projection,project this vector onto the plane of the slice
	local vProj=(d / fdp) * vDir;
	--Dotting the projected vector onto the right and up vectors gives us screen positions relative to the center of the screen.
	--We add half-widths / half-heights to these coordinates to give us screen positions relative to the upper-left corner of the screen.
	--We have to subtract from the "up" instead of adding,since screen coordinates decrease as they go upwards.
	local x=0.5 * iScreenW + angCamRot:Right():Dot(vProj);
	local y=0.5 * iScreenH - angCamRot:Up():Dot(vProj);
	--Lastly we have to ensure these screen positions are actually on the screen.
	local iVisibility
	if fdp < 0 then			--Simple check to see if the object is in front of the camera
		iVisibility=-1;
	elseif x < 0 || x > iScreenW || y < 0 || y > iScreenH then	--We've already determined the object is in front of us,but it may be lurking just outside our field of vision.
		iVisibility=0;
	else
		iVisibility=1;
	end
	return x,y,iVisibility;
end