PPM.bannedVars={
	m_bodyt0=true,
	_cmark_raw=true,
	_cmark=true,
	_cmark_loaded=true,
	bodydetail1_b=true,
	bodydetail7=true,
	bodydetail7_c=true,
	bodydetail8=true,
	bodydetail8_c=true,
	bodydetail9=true,
	bodydetail9_c=true,
	bodydetail10=true,
	bodydetail10_c=true,
	bodydetail12=true,
--	bodyt0=true,
	bodyt1=true,
	haircolor7=true,
	haircolor8=true,
	haircolor9=true,
	haircolor10=true,
	tailcolor7=true,
	tailcolor8=true,
	tailcolor9=true,
	tailcolor10=true,
	manecolor7=true,
	manecolor8=true,
	manecolor9=true,
	manecolor10=true,
--	wingscolor=true,
	eyelash_r=true,
	eyelholerssize=true,
	eyelholerssize_r=true,
	bodyt1_color=true,
	cmarkscale=true,
}
-- NOTABLE LIMITATION: WILL REMOVE SPACES FROM STRINGS TYPE ITEMS BEFORE SAVING AND WILL REFUSE TO LOAD THEM PROPERLY
-- (THIS IS A LIMITATION OF THE ORIGINAL FORMAT FROM A PRIOR AUTHOR AND MAY BE FIXED LATER WITH A WORKAROUND IF IT EVER BECOMES NEEDED)
local fns={
	number=function(saveframe,k,v)
		table.insert(saveframe,"\n "..k.." "..tostring(v))
	end,
	Vector=function(saveframe,k,v)
		table.insert(saveframe,"\n "..k.." "..tostring(v.x).." "..tostring(v.y).." "..tostring(v.z))
	end,
	boolean=function(saveframe,k,v)
		table.insert(saveframe,"\n "..k.." b "..tostring(v))
	end,
	string=function(saveframe,k,v)
		table.insert(saveframe,"\n "..k.." s "..v:Replace(" ","\\SPACE\\"))
	end,
}
function PPM.PonyDataToString(ponydata)
	local saveframe={}
	for k,v in SortedPairs(ponydata) do
		if not PPM.bannedVars[k]then
			local fn=fns[type(v)]
			if fn then
				fn(saveframe,k,v)
			end
		end
	end
	return table.concat(saveframe)
end
local hair={
	haircolor1=1,
	haircolor2=2,
	haircolor3=3,
	haircolor4=4,
	haircolor5=5,
	haircolor6=6,
}
local eye={
	eyecolor_bg="eyecolor_bg_r",
	eyecolor_grad="eyecolor_grad_r",
	eyecolor_hole="eyecolor_hole_r",
	eyecolor_iris="eyecolor_iris_r",
	eyecolor_line1="eyecolor_line1_r",
	eyecolor_line2="eyecolor_line2_r",
	eyehaslines="eyehaslines_r",
	eyeholesize="eyeholesize_r",
	eyeirissize="eyeirissize_r",
	eyejholerssize="eyejholerssize_r",
	eyelholerssize="eyelholerssize_r",
}
function PPM.StringToPonyData(str)
	local lines=string.Split(str,"\n")
	local ponydata={}
	for k,v in pairs(lines)do
		local args=string.Split(string.Trim(v)," ") 
		local name=string.Replace(args[1],"pny_","") 
		if not PPM.bannedVars[name]then
			if#args==2 then
				ponydata[name]=tonumber( args[2])
			elseif#args==4 then
				ponydata[name]=Vector(tonumber(args[2]),tonumber(args[3]),tonumber(args[4]))
				if hair[name]then
					ponydata["tailcolor"..hair[name]]=ponydata["tailcolor"..hair[name]]or ponydata[name]
					ponydata["manecolor"..hair[name]]=ponydata["manecolor"..hair[name]]or ponydata[name]
				elseif eye[name]then
					ponydata[eye[name]]=ponydata[eye[name]]or ponydata[name]
				elseif name=="coatcolor"then
					ponydata.horncolor=ponydata.horncolor or ponydata.coatcolor
					ponydata.wingcolor=ponydata.wingcolor or ponydata.coatcolor
				end
			elseif#args==3 then
				if args[2]=="b"then
					ponydata[name]=tobool(args[3])
				elseif args[2]=="s"then
					ponydata[name]=args[3]:Replace("\\SPACE\\"," ")
				end
			end
		end
	end
	for key,tbl in pairs(PPM.Pony_variables.default_pony) do
		if type(tbl.default)!="table"then
			ponydata[key]=ponydata[key]or tbl.default
		end
	end
	for k,v in pairs(ponydata)do--make sure all expected data types are correct
		local default=PPM.Pony_variables.default_pony[k]and PPM.Pony_variables.default_pony[k].default
		local expected,got=type(default),type(v)
		if default and expected!="table"and got!=expected then
			print("invalid ponydata detected: type of "..k.." was "..got..", expected "..expected)
			ponydata[k]=default
		end
		local max=PPM.Pony_variables.default_pony[k]and PPM.Pony_variables.default_pony[k].max
		local min=PPM.Pony_variables.default_pony[k]and PPM.Pony_variables.default_pony[k].min
		if expected=="number"or expected=="string"then
			if min and v<min then--under the min
				print("invalid ponydata detected: value of "..k.." was "..v..", min is "..min)
				ponydata[k]=min
			end
			if max and v>max then--above the max
				print("invalid ponydata detected: value of "..k.." was "..v..", max is "..max)
				ponydata[k]=max
			end
		elseif expected=="Vector"then
			local cur=ponydata[k]
			for key,val in SortedPairs{x=cur.x,y=cur.y,z=cur.z}do
				local min,max=min and min[key],max and max[key]
				if min and val<min then--under the min
					ponydata[k][key]=min
					print("invalid ponydata detected: value of "..key.." of Vector "..k.." was "..val..", min is "..min)
				end
				if max and val>max then--above the max
					print("invalid ponydata detected: value of "..key.." of Vector "..k.." was "..val..", max is "..max)
					ponydata[k][key]=max
				end
			end
		end
	end
	-- Perform simple data validation (May add more here later if players start finding ways to mess up their pony files)
	if ponydata.custom_mark!=nil and type( ponydata.custom_mark )!="string"then
		ponydata.custom_mark=nil
	end
	return ponydata
end
if CLIENT then
	function PPM.Save(filename,ponydata)
		ponydata.clothes=""
		local clothes=LocalPlayer().pi_wear or PPM:GetEquippedItems(LocalPlayer(),"pony")
		local i=table.Count(clothes)
		for k,v in pairs(clothes) do
			ponydata.clothes=ponydata.clothes..v.id
			i=i-1
			if i!=0 then
				ponydata.clothes=ponydata.clothes.."_"
			end
		end
		local saveframe=PPM.PonyDataToString(ponydata)
		if!string.EndsWith(filename,".txt")then
			filename=filename..".txt"
		end
		if!file.Exists("ppm/cmark_cache","DATA") then
			file.CreateDir("ppm/cmark_cache")
		end
		MsgN("saving .... ppm/"..filename)
		file.Write("ppm/"..filename,saveframe)
		if ponydata._cmark_raw and ponydata._cmark_raw:len()>0 then
			file.Write("ppm/cmark_cache/"..filename,ponydata._cmark_raw)
		else
			file.Delete("ppm/cmark_cache/"..filename)
		end
		return PPM.SaveToCache( PPM.CacheGroups.OC_DATA,LocalPlayer(),filename,saveframe )
	end
	local bool_sending=false
	function PPM.Load(filename)
		local data=file.Read("data/ppm/"..filename,"GAME")
		local ponydata=PPM.StringToPonyData( data )
		if ponydata.clothes then
			local clothes=ponydata.clothes:Split("_")
			for time,id in ipairs(clothes)do
				local itemid=tonumber(id)
				timer.Simple(.1*time,function()
					if itemid and PPM:pi_GetItemById(itemid)then
						net.Start"player_equip_item"
						net.WriteFloat(itemid)
						net.SendToServer()
						PPM:pi_SetupItem(PPM:pi_GetItemById(itemid),LocalPlayer())
					else
						timer.Simple(30,function()
							if itemid and PPM:pi_GetItemById(itemid)then
								net.Start"player_equip_item"
								net.WriteFloat(itemid)
								net.SendToServer()
								PPM:pi_SetupItem(PPM:pi_GetItemById(itemid),LocalPlayer())
							end
						end)
					end
				end)
			end
		end
		local _cmark_raw=file.Read("data/ppm/cmark_cache/"..filename,"GAME")
		if _cmark_raw then
			ponydata._cmark_raw=_cmark_raw
			local c=ponydata.coatcolor*255
			local R,G,B=math.Round(c.x),math.Round(c.y),math.Round(c.z)
			local _cmark=""
			for a,line in ipairs(_cmark_raw:Split"\n")do
				line=line:Split"_"
				local r,g,b=tonumber(line[1]),tonumber(line[2]),tonumber(line[3])
				if a==1 then
					if r==R and g==G and b==B then
					elseif g==R and b==G and r==B then
						_cmark="\0"
					elseif b==R and r==G and g==B then
						_cmark="\0\0"
					end
				end
				for b,RGB in ipairs(line)do
					local char=tonumber(RGB)
					if char then
						_cmark=_cmark..string.char(char)
					end
				end
			end
			ponydata._cmark=_cmark
			ponydata._cmark_loaded=true
			PPM.cmarksys_beginsend(_cmark)
		end	
		return ponydata
	end
end
