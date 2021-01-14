PPM.Editor3_presets=PPM.Editor3_presets or {}
PPM.Editor3_presets["view_cmark"]={
    spawn=function(parent,variable)
		local CONTAINER_FAKE=vgui.Create("DPanel",parent)
		CONTAINER_FAKE:SetSize(200,200)
		CONTAINER_FAKE:Dock(TOP)
		local CONTAINER=vgui.Create("DPanel",parent:GetParent())
		CONTAINER:SetSize(200,200)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,200)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local IMAGER=vgui.Create("DImage",HEADER)
		IMAGER:SetSize(200,200)
		--IMAGER:SetColor(Color(255,255,255,255))
		IMAGER:Dock(TOP)
		IMAGER.Think=function()
			--Mat:SetTexture("$basetexture",LocalPlayer().ponydata_tex.eyeltex)
			if LocalPlayer().ponydata.custom_mark then
				IMAGER:SetMaterial(PPM.m_cmark)
			elseif PPM.m_cmarks[LocalPlayer().ponydata.cmark] then
				IMAGER:SetImage(PPM.m_cmarks[LocalPlayer().ponydata.cmark][1])
			end
		end
	end
}
--IMAGER:FixVertexLitMaterial()
PPM.Editor3_presets["view_eye"]={
	spawn=function(parent,variable)
		local CONTAINER_FAKE=vgui.Create("DPanel",parent)
		CONTAINER_FAKE:SetSize(200,200)
		CONTAINER_FAKE:Dock(TOP)
		local CONTAINER=vgui.Create("DPanel",parent:GetParent())
		CONTAINER:SetSize(200,200)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,200)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local IMAGER=vgui.Create("DImage",HEADER)
		IMAGER:SetSize(200,200)
		--IMAGER:SetColor(Color(255,255,255,255))
		IMAGER:Dock(TOP)
		local Mat=CreateMaterial("tempeyematerialtest","UnlitGeneric")
		local Entity=PPM.modelview and PPM.modelview.Entity or LocalPlayer()
		Mat:SetTexture("$basetexture",Entity.ponydata_tex.eyeltex)
		IMAGER.Paint=function()
			render.SetMaterial(Mat)
			render.DrawQuadEasy(Vector(40+80,100+80,0),Vector(0,0,-1),160,160,Color(255,255,255,255),-90)--position of the rect
		end
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
	end
}
PPM.Editor3_presets["view_eye_r"]={
	spawn=function(parent,variable)
		local CONTAINER_FAKE=vgui.Create("DPanel",parent)
		CONTAINER_FAKE:SetSize(200,200)
		CONTAINER_FAKE:Dock(TOP)
		local CONTAINER=vgui.Create("DPanel",parent:GetParent())
		CONTAINER:SetSize(200,200)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,200)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local IMAGER=vgui.Create("DImage",HEADER)
		IMAGER:SetSize(200,200)
		IMAGER:Dock(TOP)
		local Mat=CreateMaterial("tempeyematerialtest","UnlitGeneric")
		local Entity=PPM.modelview and PPM.modelview.Entity or LocalPlayer()
		Mat:SetTexture("$basetexture",Entity.ponydata_tex.eyertex)
		IMAGER.Paint=function()
			render.SetMaterial(Mat)
			render.DrawQuadEasy(Vector(40+80,100+80,0),Vector(0,0,-1),160,160,Color(255,255,255,255),-90)--position of the rect
		end
	end
}
--*/
--IMAGER:SetMaterial(PPM.m_eyel)
local WEARSLOTS={}
local item_selection_panel=nil
local function PPM_UpdateSlot(k,eqSlot)
	if eqSlot~=nil and eqSlot~=NULL then
		--MsgN(k,eqSlot.weareditem)
		eqSlot.weareditem=LocalPlayer().pi_wear[k]
		if(eqSlot.weareditem~=nil)then
			--eqSlot.btn:SetTooltip(eqSlot.weareditem.name)
			eqSlot:SetImage("gui/items/" .. eqSlot.weareditem.img .. ".png")
			eqSlot.namelabel:SetText(eqSlot.weareditem.name)
			PPM:pi_SetupItem(eqSlot.weareditem,PPM.editor_clothing,true)
			PPM:pi_SetupItem(eqSlot.weareditem,LocalPlayer())
		end
	end
end
local function PPM_UpdateSlots()
	for k,eqSlot in pairs(WEARSLOTS)do
		PPM_UpdateSlot(k,eqSlot)
	end
end
local function OpenItemMenu(slotid,container)
	local plymodel=LocalPlayer():GetInfo("cl_playermodel")
	local avitems=PPM:GetAvailItems(plymodel,slotid)
	local posx,posy=container:LocalToScreen()
	--local paddx,paddy=container:GetParent():GetParent():GetPos()
	--MsgN(posx,posy)
	if(item_selection_panel~=nil)then
		item_selection_panel:Remove()
	end
	if avitems~=nil then
		local PanelSelect=PPM.Editor3:Add("DPanelSelect")
		item_selection_panel=PanelSelect
		local xw=math.Clamp(table.Count(avitems),1,5)* 70
		PanelSelect:SetPos(posx,posy)
		PanelSelect:SetSize(5 * 70,3 * 70)
		--PanelSelect:SetAlpha(255)
		selection_box=PanelSelect
		for name,item in SortedPairs(avitems)do
			local icon=vgui.Create("DImageButton")
			icon:SetImage("gui/items/" .. item.img .. ".png")
			icon:SetSize(64,64)
			icon:SetTooltip(item.name)
			icon.OnMousePressed=function()
				for i,slot in pairs(item.slot)do
					LocalPlayer().pi_wear[slot]=item
					--MsgN("set slot["..slot.."]="..item.name)
				end
				if(item.issuit)then
					LocalPlayer().ponydata[item.varslot]=item.wearid
				end
				net.Start("player_equip_item")
				net.WriteFloat(item.id)
				net.SendToServer()
				PanelSelect.Remove(PanelSelect)
				PPM_UpdateSlots()
			end
			PanelSelect:AddPanel(icon,{})
		end
	end
end
local scan_process_activated=false
local caching=false
local x=0
local data=""
local uppercorner_x=0
local uppercorner_y=0
local BUTTON
local CLOSEBUTTON
local coat=Vector(0,0,0)
local _cmark_raw=""
local ponydata_read=function(k)
	local ponydata1=PPM.modelview and PPM.modelview.Entity and PPM.modelview.Entity.ponydata
	if ponydata1 then
		local v=ponydata1[k]
		if v then
			return v
		end
	end
	local ponydata2=LocalPlayer().ponydata
	if ponydata2 then
		local v=ponydata2[k]
		if v then
			return v
		end
	end	
end
local ponydata_write=function(k,v)
	local ponydata1=PPM.modelview and PPM.modelview.Entity and PPM.modelview.Entity.ponydata or{}
	local ponydata2=LocalPlayer().ponydata or{}
	ponydata1[k]=v
	ponydata2[k]=v
end

local INRANGE=function(check,of)
	if of-6<=check and check<=of+6 then
		return true
	end
	return false
end
local corrections={
	[0]=3,
	[1]=6,
	[2]=8,
	[3]=10,
	[4]=12,
	[5]=13,
	[6]=14,
	[7]=15,
	[8]=16,
	[9]=17,
	[10]=18,
	[11]=19,
	[12]=20,
	[13]=21,
	[14]=22,
	[16]=23,
	[17]=24,
	[18]=25,
	[19]=26,
	[20]=27,
	[21]=28,
	[23]=29,
	[24]=30,
	[25]=31,
	[26]=32,
	[27]=33,
	[28]=34,
	[29]=35,
	[31]=36,
	[32]=37,
	[33]=38,
	[34]=39,
	[35]=40,
	[36]=41,
	[37]=42,
}
hook.Add("PostRender","PPM_image",function()
	if scan_process_activated then
		render.CapturePixels()
		local localdata=""
		for i=0,16 do
			for y=0,512,2 do
				local r,g,b=render.ReadPixel(uppercorner_x+x,uppercorner_y+y)
				local a=255
				r=corrections[r]or r
				g=corrections[g]or g
				b=corrections[b]or b
				if INRANGE(r,coat.x)and INRANGE(g,coat.y)and INRANGE(r,coat.z)then
					r,g,b,a=coat.x,coat.y,coat.z,0
				end
				--print(r,g,b)
				--bytecount=bytecount+3
				--print(r,"\t\t",g,"\t\t",b)
				localdata=localdata..string.char(r)..string.char(g)..string.char(b)
				_cmark_raw=_cmark_raw..r.."_"..g.."_"..b.."\n"
			end
			if x >=511 then
				local ponydata=PPM.modelview and PPM.modelview.Entity and PPM.modelview.Entity.ponydata
				if ponydata then
					ponydata._cmark=data
					ponydata._cmark_enabled=true
				end
				ponydata_write("_cmark_raw",_cmark_raw)
				ponydata_write("_cmark",data)
				ponydata_write("_cmark_enabled",true)
				--print(string.len(data))
				--print(data)
				PPM.cmarksys_beginsend(data)
				scan_process_activated=false
				x=0
				if BUTTON and BUTTON:IsValid()then
					BUTTON:SetText("Scan Image")
					CLOSEBUTTON:SetText("Close")
				end
				return
			end
			x=x+2
		end
		data=data..localdata
		if BUTTON and BUTTON:IsValid()then
			BUTTON:SetText("SCANNING("..math.Round(x*.1953125).."%)")
		end
		--x=x+1
	end
end)
local PANEL=NULL
local function PPM_CMarkFile(parent)
	if PANEL:IsValid()then
		if scan_process_activated then
			return
		end
		PANEL:Remove()
	end
	local R,G,B=255,0,255
	local allw=768
	uppercorner_x=ScrW()*.5-allw*.5
	uppercorner_y=ScrH()*.5-256
	PANEL=vgui.Create("DPanel",PPM.Editor3)
	PANEL:SetPos(uppercorner_x,uppercorner_y)
	PANEL:SetSize(allw,512)
	local BACKGROUND=vgui.Create("DImage",PANEL)
	BACKGROUND:SetSize(512,512)
	local material=Material("gui/pixel.png")
	BACKGROUND:SetImage("color")
	--BACKGROUND:SetColor(255,0,255,255)
	BACKGROUND.Paint=function()
		local coatcolor=PPM.modelview and PPM.modelview.Entity and PPM.modelview.Entity.ponydata and PPM.modelview.Entity.ponydata.coatcolor
		if coatcolor then
			local col=coatcolor*255
			R,G,B=col.x,col.y,col.z
		end
		render.SetMaterial(Material("color"))
		render.DrawQuadEasy(Vector(uppercorner_x+256,uppercorner_y+256,0),Vector(0,0,-1),512,512,Color(R,G,B,255),-90)--position of the rect
	end
	--direction to face in
	--size of the rect
	--color
	--rotate 90 degrees
	local IMAGE=vgui.Create("DImage",PANEL)
	IMAGE:SetSize(512,512)
	--IMAGE:SetImage("gui/items/none.png")
	local LIST=vgui.Create("DListView")
	LIST:SetParent(PANEL)
	LIST:SetSize(256,384)
	LIST:SetPos(512,0)
	LIST:SetMultiSelect(false)
	--LIST:Dock(RIGHT)
	LIST:AddColumn("Avaliable images")
	LIST:Clear()
	local files=file.Find("materials/ppm_custom/*.png","GAME")
	for k,v in pairs(files)do
		--if(!string.match(v,"*/_*",0))then
		LIST:AddLine(v)
		--end
	end
	LIST.OnClickLine=function(parent,line,isselected)
		IMAGE:SetImage("materials/ppm_custom/" .. line:GetValue(1))
	end
	BUTTON=vgui.Create("DButton",PANEL)
	CLOSEBUTTON=vgui.Create("DButton",PANEL)
	BUTTON:SetText("Select Image")
	CLOSEBUTTON:SetText("Close")
	--BUTTON:Dock(RIGHT)
	--BUTTON:Dock(RIGHT)
	BUTTON:SetPos(512,384)
	CLOSEBUTTON:SetPos(512,384+20)
	BUTTON:SetSize(256,20)
	CLOSEBUTTON:SetSize(256,20)
	BUTTON.DoClick=function()
		if !scan_process_activated then
			timer.Remove("ppm_create_texture")
			data=""
			_cmark_raw=""
			BUTTON:SetText("SCANNING...")
			CLOSEBUTTON:SetText("SCANNING...")
			x=0
			coat=ponydata_read"coatcolor"*255
			scan_process_activated=true
		end
	end
	CLOSEBUTTON.DoClick=function()
		if not scan_process_activated then
			PANEL:Remove()
			timer.Remove("ppm_create_texture")
		end
	end
end
local function PPM_CMarkURL(parent)
	if PANEL:IsValid()then
		if scan_process_activated then
			return
		end
		PANEL:Remove()
	end
	local R,G,B=255,0,255
	local allw=768
	uppercorner_x=ScrW()*.5-allw*.5
	uppercorner_y=ScrH()*.5-256
	PANEL=vgui.Create("DPanel",PPM.Editor3)
	PANEL:SetPos(uppercorner_x,uppercorner_y)
	PANEL:SetSize(allw,512)
	local BACKGROUND=vgui.Create("DImage",PANEL)
	BACKGROUND:SetSize(512,512)
	BACKGROUND:SetImage("color")
	--BACKGROUND:SetColor(255,0,255,255)
	local coatcolor=ponydata_read"coatcolor"
	BACKGROUND.Paint=function()
		if coatcolor then
			local col=coatcolor*255
			R,G,B=col.x,col.y,col.z
		end
		render.SetMaterial(Material("color"))
		render.DrawQuadEasy(Vector(uppercorner_x+256,uppercorner_y+256,0),Vector(0,0,-1),512,512,Color(R,G,B,255),-90)--position of the rect
	end
	--direction to face in
	--size of the rect
	--color
	--rotate 90 degrees
	local DHTML=vgui.Create("DHTML",PANEL)
	DHTML.Setup=function(self,data)
		self.URL=data.URL or self.URL or""
		self.margin=data.margin or self.margin or 0
		DHTML:SetHTML([[
			<html><head><style type="text/css">
				html
				{
					overflow:hidden;
					margin: ]]..self.margin..[[px ]]..self.margin..[[px;
				}
				body {
					background-image: url(]]..self.URL..[[);
					background-size: contain;
					background-position: center;
					background-repeat: no-repeat;
					height: 100%;
					width: 100%;
				}
			</style></head><body></body></html>
		]])
	end
	DHTML:SetSize(512,512)
	--DHTML:SetImage("gui/items/none.png")
	local DTextEntry=vgui.Create("DTextEntry",PANEL)
	DTextEntry:SetSize(256,49)
	DTextEntry:SetPos(512,0)
	local format=""
	DTextEntry.OnChange=function(self)
		local URL=self:GetText()
		local tbl,code,find=URL:Split"/","",find
		if URL:find"imgur.com/"then
			code=tbl[#tbl]
			code=code:Split".png"[1]
			format="https://i.imgur.com/%s.png"
		end
		local new=string.format(format,code)
		if new!=URL then
			URL=new
			self:SetText(URL)
			ponydata_write("cmark_url",URL)
			timer.Create("PPM_DHTML",1,1,function()
				if DHTML:IsValid()then
					DHTML:Setup{URL=URL}
				end
			end)
		end
	end
	DTextEntry.OnEnter=function(self,URL)
		ponydata_write("cmark_url",URL)
		DHTML:Setup{URL=URL}
	end
	local DNumSlider = vgui.Create( "DNumSlider", PANEL )
	DNumSlider:SetPos(512,40)	-- Set the position
	DNumSlider:SetSize(256,40)	-- Set the size
	DNumSlider:SetText"margin"	-- Set the text above the slider
	DNumSlider:SetMin(-256)		-- Set the minimum number you can slide to
	DNumSlider:SetMax(255)		-- Set the maximum number you can slide to
	DNumSlider:SetDecimals(0)	-- Decimal places - zero for whole number
	-- If not using convars, you can use this hook + Panel.SetValue()
	DNumSlider.OnValueChanged=function(self,margin)
		ponydata_write("cmark_url_margin",margin)
		DHTML:Setup{margin=margin}
	end
	local cmark_url=ponydata_read"cmark_url"
	local cmark_url_margin=ponydata_read"cmark_url_margin"
	if type(cmark_url_margin)=="number"then
		cmark_url_margin=math.min(cmark_url_margin,255)
		DNumSlider:SetValue(cmark_url_margin)
		DHTML.margin=cmark_url_margin
	else
		local scale=ponydata_read"cmark_scale"
		if type(scale)=="number"then
			cmark_url_margin=-math.Remap(scale,0,2,-255,256)
			cmark_url_margin=math.min(cmark_url_margin,255)
			DNumSlider:SetValue(cmark_url_margin)
			DHTML.margin=cmark_url_margin
			ponydata_write("cmark_url_margin",cmark_url_margin)
		end
	end
	if type(cmark_url)=="string"then
		DTextEntry:SetText(cmark_url)
		DHTML:Setup{URL=cmark_url}
	end
	BUTTON=vgui.Create("DButton",PANEL)
	CLOSEBUTTON=vgui.Create("DButton",PANEL)
	BUTTON:SetText("Select Image")
	CLOSEBUTTON:SetText("Close")
	--BUTTON:Dock(RIGHT)
	--BUTTON:Dock(RIGHT)
	BUTTON:SetPos(512,80)
	CLOSEBUTTON:SetPos(512,120)
	BUTTON:SetSize(256,40)
	CLOSEBUTTON:SetSize(256,40)
	BUTTON.DoClick=function()
		if !scan_process_activated then
			data=""
			_cmark_raw=""
			BUTTON:SetText("SCANNING...")
			CLOSEBUTTON:SetText("SCANNING...")
			x=0
			coat=ponydata_read"coatcolor"*255
			scan_process_activated=true
		end
	end
	CLOSEBUTTON.DoClick=function()
		if not scan_process_activated then
			PANEL:Remove()
		end
	end
end

function PPM.rgbtoHex(r,g,b)
	return string.char(r).. string.char(g).. string.char(b)
end
PPM.Editor3_presets["edit_equipment_slot"]={
	spawn=function(parent,variable)
		local SLOTID=variable.slotid
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(70,70)
		CONTAINER:Dock(TOP)
		local DISPLAY=vgui.Create("DImageButton",CONTAINER)
		DISPLAY:SetPos(3,3)
		DISPLAY:SetSize(64,64)
		DISPLAY:SetColor(Color(255,255,255,255))
		DISPLAY:SetImage("gui/items/none.png")
		WEARSLOTS[SLOTID]=DISPLAY
		local DISPLAY_CASE=vgui.Create("DImageButton",CONTAINER)
		DISPLAY_CASE:SetPos(0,0)
		DISPLAY_CASE:SetSize(70,70)
		DISPLAY_CASE:SetColor(Color(255,255,255,255))
		local plymodel=LocalPlayer():GetInfo("cl_playermodel")
		local avitems=PPM:GetAvailItems(plymodel,SLOTID)
		if(avitems~=nil and table.Count(avitems)> 0)then
			DISPLAY_CASE:SetImage("gui/item.png")
			DISPLAY_CASE.DoClick=function()
				OpenItemMenu(SLOTID,CONTAINER)
			end
		else
			DISPLAY_CASE:SetImage("gui/editor/gui_cross.png")
		end
		--DISPLAY:Dock(TOP)
		local HEADERLABEL=vgui.Create("DLabel",CONTAINER)
		HEADERLABEL:SetPos(80,10)
		HEADERLABEL:SetColor(Color(20,20,20,255))
		HEADERLABEL:SetText(variable.name)
		HEADERLABEL:SetFont(PPM.EDM_FONT)
		HEADERLABEL:SetSize(100,20)
		local NAMELABEL=vgui.Create("DLabel",CONTAINER)
		NAMELABEL:SetPos(80,30)
		NAMELABEL:SetColor(Color(20,20,20,255))
		NAMELABEL:SetText(variable.name)
		--NAMELABEL:SetFont(PPM.EDM_FONT)
		NAMELABEL:SetSize(100,20)
		DISPLAY.namelabel=NAMELABEL
		PPM_UpdateSlot(SLOTID,DISPLAY)
	end
}
PPM.Editor3_presets["select_custom_cmark"]={
	spawn=function(parent,variable)
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(200,85)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,20)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local HEADERLABEL=vgui.Create("DLabel",HEADER)
		--HEADERLABEL:Dock(TOP)
		HEADERLABEL:SetPos(80,0)
		HEADERLABEL:SetText(variable.name)
		local BUTTON_FILE=vgui.Create("DButton",CONTAINER)
		BUTTON_FILE:SetText("Select from file")
		BUTTON_FILE:Dock(TOP)
		BUTTON_FILE.DoClick=function()
			PPM_CMarkFile(parent)
		end
		local BUTTON_URL=vgui.Create("DButton",CONTAINER)
		BUTTON_URL:SetText("Select from url")
		BUTTON_URL:Dock(TOP)
		BUTTON_URL.DoClick=function()
			PPM_CMarkURL(parent)
		end
		local CLEARBUTTON=vgui.Create("DButton",CONTAINER)
		CLEARBUTTON:SetText("Clean custom cmark")
		CLEARBUTTON:Dock(TOP)
		CLEARBUTTON.DoClick=function()
			if PANEL:IsValid()then
				if scan_process_activated then
					return
				end
				PANEL:Remove()
			end
			PPM.cmarksys_clearcmark()
		end
	end
}
PPM.Editor3_presets["edit_bool"]={
	spawn=function(parent,variable)
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(200,40)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,20)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local HEADERLABEL=vgui.Create("DLabel",HEADER)
		--HEADERLABEL:Dock(TOP)
		HEADERLABEL:SetPos(80,0)
		HEADERLABEL:SetText(variable.name)
		local SELECTOR=vgui.Create("DCheckBoxLabel",CONTAINER)
		--SELECTOR:SetText("Value")
		--SELECTOR:SetSize(100,100)
		SELECTOR:SetPos(20,20)
		SELECTOR:Dock(FILL)
		SELECTOR:SetValue(LocalPlayer().ponydata[variable.param]==variable.onvalue)
		SELECTOR.OnChange=function(pSelf,fValue)
			if(fValue)then
				LocalPlayer().ponydata[variable.param]=variable.onvalue
			else
				LocalPlayer().ponydata[variable.param]=variable.offvalue
			end
		end
	end
}
PPM.Editor3_presets["edit_number"]={
	spawn=function(parent,variable)
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(200,40)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,20)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local HEADERLABEL=vgui.Create("DLabel",HEADER)
		--HEADERLABEL:Dock(TOP)
		HEADERLABEL:SetPos(80,0)
		HEADERLABEL:SetText(variable.name)
		local SELECTOR=vgui.Create("DNumSlider",CONTAINER)
		--SELECTOR:SetText("Value")
		SELECTOR:SetMin(variable.min)
		SELECTOR:SetMax(variable.max)
		--SELECTOR:SetSize(100,100)
		SELECTOR:SetPos(20,20)
		SELECTOR:Dock(FILL)
		SELECTOR:SetValue(LocalPlayer().ponydata[variable.param])
		SELECTOR.OnValueChanged=function()
			--local value=variable.min+SELECTOR:GetValue()*(variable.max-variable.min)
			LocalPlayer().ponydata[variable.param]=SELECTOR:GetValue()
		end
	end
}
PPM.Editor3_presets["edit_color"]={
	spawn=function(parent,variable)
		local VALUE=LocalPlayer().ponydata[variable.param] or Vector(1,1,1)
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(200,220)
		CONTAINER:Dock(TOP)
		--local CONTAINER=vgui.Create("DCollapsibleCategory",parent)
		--CONTAINER:SetPos(25,50)
		--CONTAINER:SetSize(200,200)--Keep the second number at 50
		--CONTAINER:SetExpanded(200)--Expanded when popped up
		--CONTAINER:SetLabel(variable.name)
		--CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,20)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local HEADERLABEL=vgui.Create("DLabel",HEADER)
		--HEADERLABEL:Dock(TOP)
		HEADERLABEL:SetPos(80,0)
		HEADERLABEL:SetText(variable.name)
		local INDICATOR=vgui.Create("DImageButton",CONTAINER)
		INDICATOR:Dock(LEFT)
		INDICATOR:SetSize(20,20)
		INDICATOR:SetImage("gui/editor/pictorect.png")
		local SELECTOR=vgui.Create("DColorMixer",CONTAINER)
		SELECTOR:SetSize(100,100)
		SELECTOR:SetPos(20,20)
		SELECTOR:SetAlphaBar(false)
		--[[
	local bCANCEL=vgui.Create("DButton",sR)
	bCANCEL:SetSize(20,130)
	bCANCEL:Dock(BOTTOM)
	bCANCEL:SetPos(0,0)
	bCANCEL:SetText("C")
	bCANCEL.DoClick=function(button)
		PanelSelect:SetColor(Color(color.x*255,color.y*255,color.z*255,255))
		PanelSelect.ValueChanged()
	end
	]]
		SELECTOR:SetColor(Color(VALUE.x * 255,VALUE.y * 255,VALUE.z * 255,255))
		INDICATOR:SetColor(Color(VALUE.x * 255,VALUE.y * 255,VALUE.z * 255,255))
		SELECTOR:Dock(FILL)
		SELECTOR.ValueChanged=function()
			local v2=SELECTOR:GetVector()
			LocalPlayer().ponydata[variable.param]=v2
			INDICATOR:SetColor(Color(v2.x * 255,v2.y * 255,v2.z * 255,255))
		end
	end
}
PPM.Editor3_presets["edit_type"]={
	spawn=function(parent,variable)
		local VALUE=LocalPlayer().ponydata[variable.param] or 0
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(200,220)
		CONTAINER:Dock(TOP)
		local HEADER=vgui.Create("DImageButton",CONTAINER)
		HEADER:SetSize(200,20)
		HEADER:SetColor(Color(0,0,0,255))
		HEADER:SetImage("gui/editor/pictorect.png")
		HEADER:Dock(TOP)
		local HEADERLABEL=vgui.Create("DLabel",HEADER)
		--HEADERLABEL:Dock(TOP)
		HEADERLABEL:SetPos(80,0)
		HEADERLABEL:SetText(variable.name)
		--[[
	local INDICATOR=vgui.Create("DImageButton",CONTAINER)
	INDICATOR:Dock(LEFT)
	INDICATOR:SetSize(20,20)
	INDICATOR:SetImage("gui/editor/pictorect.png")
	]]
		--choises
		--[[
	local SELECTOR=vgui.Create("DComboBox",CONTAINER)
	SELECTOR:SetPos(10,35)
	SELECTOR:SetSize(100,185)
	//SELECTOR:SetMultiple(false)
	SELECTOR:Dock(TOP)
	if variable.choises !=nill then
		for k ,v in pairs(variable.choises)do
			SELECTOR:AddChoice(v)
		end
		SELECTOR:ChooseOptionID(LocalPlayer().ponydata[variable.param] or 1)
		SELECTOR.OnSelect=function(panel,index,value,data)
			LocalPlayer().ponydata[variable.param]=index
		end
	end
	]]
		local SELECTOR=vgui.Create("DPanel",CONTAINER)
		SELECTOR:SetPos(10,35)
		SELECTOR:SetSize(100,185)
		SELECTOR:Dock(TOP)
		--[[
	SCROLL=vgui.Create("DVScrollBar",SELECTOR)
	SCROLL:SetSize(20,ScrH()-100)
	SCROLL:SetUp(1000,2000)
	SCROLL:SetEnabled(true)
	SCROLL:Dock(RIGHT)
	]]
		local SELECTOR_INNER=vgui.Create("DPanel",SELECTOR)
		SELECTOR_INNER:SetPos(0,0)
		SELECTOR_INNER:SetSize(200,2000)
		SELECTOR.PerformLayout=function()end
		--SELECTOR_INNER:SetSize(200,2000)
		--PPM.CDVScrollBar:SetUp(1000,PPM.smenupanel_inner:GetTall())
		--SELECTOR_INNER:SetPos(0,SCROLL:GetOffset())
		local VARIABLE=LocalPlayer().ponydata[variable.param] or 1
		SELECTOR.buttons={}
		if variable.choises~=nill then
			CONTAINER:SetSize(100,table.Count(variable.choises)* 20+20)
			SELECTOR:SetSize(100,table.Count(variable.choises)* 20)
			for k,v in pairs(variable.choises)do
				local ITEM_CONTAINER=vgui.Create("DPanel",SELECTOR_INNER)
				ITEM_CONTAINER:SetSize(100,20)
				ITEM_CONTAINER:Dock(TOP)
				local ITEM_INDICATOR=vgui.Create("DImageButton",ITEM_CONTAINER)
				ITEM_INDICATOR:SetImage("gui/editor/pictorect.png")
				ITEM_INDICATOR:SetSize(20,20)
				ITEM_INDICATOR:Dock(LEFT)
				SELECTOR.buttons[k]=ITEM_INDICATOR
				if(k==VARIABLE)then
					ITEM_INDICATOR:SetColor(Color(200,255,200))--PPM.colorcircles(k))
				else
					ITEM_INDICATOR:SetColor(Color(100,100,100))
				end
				local ITEM=vgui.Create("DButton",ITEM_CONTAINER)
				ITEM:SetSize(200,20)
				ITEM:SetBGColor(PPM.colorcircles(k))
				--ITEM:SetImage("gui/editor/pictorect.png")
				ITEM:Dock(FILL)
				ITEM:SetText(v)
				ITEM.OnCursorEntered=function()
					LocalPlayer().ponydata[variable.param]=k
				end
				ITEM.OnCursorExited=function()
					LocalPlayer().ponydata[variable.param]=VARIABLE
				end
				ITEM.DoClick=function()
					VARIABLE=k
					LocalPlayer().ponydata[variable.param]=VARIABLE
					for k2,v2 in pairs(variable.choises)do
						if(k2==VARIABLE)then
							SELECTOR.buttons[k2]:SetColor(Color(200,255,200))
						else
							SELECTOR.buttons[k2]:SetColor(Color(100,100,100))
						end
					end
				end
			end
		end
	end
}
local INDICATOR_ONE=nil
local INDICATOR_TWO=nil
function PPM.colorFlash(controll,time,color,defcolor)
	controll:SetColor(color)
	timer.Simple(time,function()
		controll:SetColor(defcolor)
	end)
end
local function LoadFileList(dPresetList)
	dPresetList:Clear()
	local files=file.Find("data/ppm/*.txt","GAME")
	for k,v in pairs(files)do
		if(not string.match(v,"*/_*",0))then
			dPresetList:AddLine(v)
		end
	end
end
PPM.Editor3_presets["menu_save_load"]={
	spawn=function(parent,variable)
		local VALUE=LocalPlayer().ponydata[variable.param] or Vector(1,1,1)
		local CONTAINER=vgui.Create("DPanel",parent)
		CONTAINER:SetSize(200,1000)
		CONTAINER:Dock(TOP)
		local INDICATOR=vgui.Create("DImageButton",CONTAINER)
		INDICATOR:Dock(LEFT)
		INDICATOR:SetSize(20,1000)
		INDICATOR:SetImage("gui/editor/pictorect.png")
		local INDICATOR2=vgui.Create("DImageButton",CONTAINER)
		INDICATOR2:Dock(RIGHT)
		INDICATOR2:SetSize(20,1000)
		INDICATOR2:SetImage("gui/editor/pictorect.png")
		--it begins~_~
		INDICATOR_ONE=INDICATOR
		INDICATOR_TWO=INDICATOR2
		local dPresetList=vgui.Create("DListView")
		dPresetList:SetParent(CONTAINER)
		dPresetList:SetPos(0,0)
		dPresetList:SetSize(ScrW()/ 8,ScrH()* 1 *.5)
		dPresetList:SetMultiSelect(false)
		dPresetList:Dock(TOP)
		dPresetList:AddColumn"Preset list"
		PPM.dPresetList=dPresetList
		local bAddPony=vgui.Create("DButton",CONTAINER)
		bAddPony:SetSize(180,30)
		bAddPony:Dock(TOP)
		bAddPony:SetText("New Pony")
		bAddPony.DoClick=function(self)
			if curmenupanel then
				if curmenupanel:IsValid()then
					curmenupanel:Remove()
				end
				curmenupanel=nil
			end
			local smenupanel=vgui.Create("DPanel",bAddPony:GetParent())
			local x,y=0,0--bAddPony:GetParent():GetPos()
			local px,py=0,0--bAddPony:GetPos()
			local w,h=bAddPony:GetSize()
			smenupanel:SetSize(w,h * 3)
			smenupanel:SetPos(bAddPony:GetPos())
			smenupanel:SetKeyboardInputEnabled(true)
			curmenupanel=smenupanel
			local nfNInput=vgui.Create("DTextEntry",smenupanel)
			nfNInput:SetText("NewFileName")
			nfNInput:SetSize(20,h)
			nfNInput:Dock(TOP)
			nfNInput:SetKeyboardInputEnabled(true)
			local bPSave=vgui.Create("DButton",smenupanel)
			bPSave:SetSize(20,h)
			bPSave:Dock(BOTTOM)
			bPSave:SetPos(0,0)
			bPSave:SetText("SAVE")
			bPSave.DoClick=function(button)
				local selected_fname=nfNInput:GetValue()
				if(selected_fname==nil or selected_fname:Trim()=="")then
					--PPM.colorFlash(bPSave,0.1,Color(200,0,0),Color(255,255,255))
					--PPM.colorFlash(PPM.button_save,0.1,Color(200,0,0),Color(255,255,255))
					return
				end
				if(table.HasValue(PPM.reservedPresetNames,selected_fname))then
					--PPM.colorFlash(bPSave,0.1,Color(200,0,0),Color(255,255,255))
					--PPM.colorFlash(PPM.button_save,0.1,Color(200,0,0),Color(255,255,255))
					return
				end
				PPM.Save(selected_fname,LocalPlayer().ponydata)
				--PPM.colorFlash(PPM.button_save,0.1,Color(0,200,0),Color(255,255,255))
				LoadFileList(PPM.dPresetList)
				smenupanel:Remove()
				curmenupanel=nil
			end
			local bExit=vgui.Create("DButton",smenupanel)
			bExit:SetSize(20,h)
			bExit:Dock(BOTTOM)
			bExit:SetPos(0,0)
			bExit:SetText("CANCEL")
			bExit.DoClick=function(button)
				smenupanel:Remove()
				curmenupanel=nil
			end
		end
		local bDelPreset=vgui.Create("DButton",CONTAINER)
		local SPACE=vgui.Create("DImageButton",CONTAINER)
		local button_save=vgui.Create("DButton",CONTAINER)
		bDelPreset.goDef=function()
			if bDelPreset.bdel then
				if bDelPreset:IsValid()then
					bDelPreset.bdel:Remove()
				end
				bDelPreset.bdel=nil
			end
			bDelPreset:SetSize(180,30)
			bDelPreset:Dock(TOP)
			bDelPreset:SetText("Delete")
			bDelPreset.sure=false
			button_save:SetSize(180,30)
		end
		bDelPreset.goDef()
		bDelPreset.DoClick=function(button)
			local selline=dPresetList:GetSelectedLine()
			if(selline==nil)then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(0,0,0))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(0,0,0))
				bDelPreset.goDef()
				return
			end
			local selected_fname=dPresetList:GetLine(selline):GetColumnText(1)
			if(selected_fname==nil)then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(0,0,0))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(0,0,0))
				bDelPreset.goDef()
				return
			end
			if(table.HasValue(PPM.reservedPresetNames,selected_fname))then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(255,255,255))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(255,255,255))
				return
			end
			if not bDelPreset.sure then
				bDelPreset:SetText("NO!")
				bDelPreset:SetSize(180,15)
				bDelPreset.sure=true
				button_save:SetSize(180,15)
				bDelPreset.bdel=vgui.Create("DButton",button_save)
				bDelPreset.bdel:SetSize(180,15)
				bDelPreset.bdel:Dock(BOTTOM)
				bDelPreset.bdel:SetText("YES,DELETE!")
				bDelPreset.bdel.DoClick=function(button)
					file.Delete("ppm/" .. selected_fname)
					LoadFileList(PPM.dPresetList)
					bDelPreset.goDef()
				end
			else
				bDelPreset.goDef()
			end
		end
		SPACE:Dock(TOP)
		SPACE:SetSize(180,30)
		--INDICATOR:SetImage("gui/editor/pictorect.png")
		--/ part 2
		button_save:SetSize(180,30)
		--button_save:SetImage("gui/editor/group_circle.png")
		button_save:SetText("SAVE")
		button_save:Dock(TOP)
		PPM.button_save=button_save
		button_save.DoClick=function(button)
			local selline=dPresetList:GetSelectedLine()
			if(selline==nil)then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(255,255,255))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(255,255,255))
				return
			end
			local selected_fname=dPresetList:GetLine(selline):GetColumnText(1)
			if(selected_fname==nil)then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(255,255,255))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(255,255,255))
				return
			end
			if(table.HasValue(PPM.reservedPresetNames,selected_fname))then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(255,255,255))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(255,255,255))
				return
			end
			PPM.Save(selected_fname,LocalPlayer().ponydata)
			PPM.colorFlash(INDICATOR_ONE,0.1,Color(0,200,0),Color(255,255,255))
			PPM.colorFlash(INDICATOR_TWO,0.1,Color(0,200,0),Color(255,255,255))
			LoadFileList(PPM.dPresetList)
		end
		local button_load=vgui.Create("DButton",CONTAINER)
		button_load:SetSize(180,30)
		--button_load:SetImage("gui/editor/group_circle.png")
		button_load:Dock(TOP)
		button_load:SetText("LOAD")
		button_load.DoClick=function(button)
			local selline=dPresetList:GetSelectedLine()
			if(selline==nil)then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(255,255,255))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(255,255,255))
				return
			end
			local selected_fname=dPresetList:GetLine(selline):GetColumnText(1)
			if(selected_fname==nil)then
				PPM.colorFlash(INDICATOR_ONE,0.1,Color(200,0,0),Color(255,255,255))
				PPM.colorFlash(INDICATOR_TWO,0.1,Color(200,0,0),Color(255,255,255))
				return
			end
			--if(PPM.selected_filename==nil)then return end
			--if(PPM.selected_filename=="@NEWFILE@")then return end
			--PPM.ReadFile(PPM.selected_filename)
			PPM.cleanPony(LocalPlayer())
			PPM.mergePonyData(LocalPlayer().ponydata,PPM.Load(selected_fname))
			--PPM.SendCharToServer(LocalPlayer())
			PPM.colorFlash(INDICATOR_ONE,0.1,Color(0,200,0),Color(255,255,255))
			PPM.colorFlash(INDICATOR_TWO,0.1,Color(0,200,0),Color(255,255,255))
			--PPM.colorFlash(PPM.selector_circle[3],0.2,Color(0,200,0),Color(255,255,255))
			local sig=PPM.Save_settings()
			PPM.UpdateSignature(sig)
		end
		local SPACE2=vgui.Create("DImageButton",CONTAINER)
		SPACE2:Dock(TOP)
		SPACE2:SetSize(180,30)
		--part 3
		local button_reset=vgui.Create("DButton",CONTAINER)
		button_reset:SetSize(180,30)
		button_reset:SetText("Clear")
		button_reset:Dock(TOP)
		button_reset.DoClick=function(button)
			PPM.cleanPony(LocalPlayer())
			PPM.colorFlash(INDICATOR_ONE,0.1,Color(0,200,0),Color(255,255,255))
			PPM.colorFlash(INDICATOR_TWO,0.1,Color(0,200,0),Color(255,255,255))
		end
		local button_rnd=vgui.Create("DButton",CONTAINER)
		button_rnd:SetSize(180,30)
		button_rnd:SetText("Randomize")
		button_rnd:Dock(TOP)
		button_rnd.DoClick=function(button)
			PPM.randomizePony(LocalPlayer())
			PPM.colorFlash(INDICATOR_ONE,0.1,Color(0,200,0),Color(255,255,255))
			PPM.colorFlash(INDICATOR_TWO,0.1,Color(0,200,0),Color(255,255,255))
		end
		LoadFileList(dPresetList)
	end
}