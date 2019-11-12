
PPM.bannedVars = {
	m_bodyt0=true,
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
function PPM.PonyDataToString( ponydata )
	local saveframe = {}

	for k,v in SortedPairs( ponydata ) do
		if not PPM.bannedVars[k] then
			if type(v) == "number" then
				table.insert( saveframe, "\n " .. k .. " " .. tostring(v) )
			elseif type(v) == "Vector" then
				table.insert( saveframe, "\n " .. k .. " " .. tostring(v.x).. " " .. tostring(v.y).. " " .. tostring(v.z) )
			elseif type(v) == "boolean" then
				table.insert( saveframe, "\n " .. k .. " b " .. tostring(v) )
			elseif type(v) == "string" then
				table.insert( saveframe, "\n " .. k .. " s " .. v:Replace( " " ,"\\SPACE\\" ) )
			end
		end
	end
	
	return table.concat( saveframe )
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
function PPM.StringToPonyData( str )
	local lines = string.Split( str, "\n" )
	local ponydata = {}
	for k,v in pairs( lines ) do
		local args = string.Split( string.Trim(v), " " ) 
		local name = string.Replace( args[1], "pny_", "" ) 
		if not PPM.bannedVars[name] then
			if #args == 2  then
				ponydata[name] =tonumber( args[2] )
			elseif #args == 4 then
				ponydata[name] = Vector( tonumber( args[2] ),tonumber(args[3] ),tonumber(args[4]))
				if hair[name] then
					ponydata["tailcolor"..hair[name]]=ponydata["tailcolor"..hair[name]]or ponydata[name]
					ponydata["manecolor"..hair[name]]=ponydata["manecolor"..hair[name]]or ponydata[name]
				elseif eye[name]then
					ponydata[eye[name]]=ponydata[eye[name]] or ponydata[name]
				elseif name=="coatcolor" then
					ponydata.horncolor=ponydata.horncolor or ponydata.coatcolor
					ponydata.wingcolor=ponydata.wingcolor or ponydata.coatcolor
				end
			elseif #args == 3 then
				if args[2] == "b" then
					ponydata[name] = tobool( args[3] )
				elseif args[2] == "s" then
					ponydata[name]=args[3]:Replace("\\SPACE\\"," ")
				end
			end
		end
	end
	for key,tbl in pairs(PPM.Pony_variables.default_pony) do
		if type(tbl.default)!="table" then
			ponydata[key]=ponydata[key] or tbl.default
		end
	end
	for k,v in pairs(ponydata)do--make sure all expected data types are correct
		local default=PPM.Pony_variables.default_pony[k] and PPM.Pony_variables.default_pony[k].default
		local expected,got=type(default),type(v)
		if default and expected!="table" and got!=expected then
			print("invalid ponydata detected: type of "..k.." was "..got..", expected "..expected)
			ponydata[k]=default
		end
		local max=PPM.Pony_variables.default_pony[k] and PPM.Pony_variables.default_pony[k].max
		local min=PPM.Pony_variables.default_pony[k] and PPM.Pony_variables.default_pony[k].min
		if expected=="number" or expected=="string" then
			if min and v<min then--under the min
				print("invalid ponydata detected: value of "..k.." was "..v..", min is "..min)
				ponydata[k]=min
			end
			if max and v>max then--above the max
				print("invalid ponydata detected: value of "..k.." was "..v..", max is "..max)
				ponydata[k]=max
			end
		elseif expected=="Vector" then
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
	if ponydata.custom_mark ~= nil and type( ponydata.custom_mark ) ~= "string" then
		ponydata.custom_mark = nil
	end
	
	return ponydata
end

if CLIENT then
	function PPM.Save(filename, ponydata)
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

		local saveframe = PPM.PonyDataToString( ponydata )
		
		if !string.EndsWith( filename,".txt" ) then
			filename = filename .. ".txt"
		end
		if !file.Exists( "ppm", "DATA" ) then
			file.CreateDir( "ppm" )
		end
		MsgN( "saving .... ppm/" .. filename )
		file.Write( "ppm/" .. filename, saveframe )--[[
		if !file.Exists( "ppm_cmark_cache", "DATA" ) then
			file.CreateDir( "ppm_cmark_cache" )
		end
		if ponydata._cmark and ponydata._cmark_loaded then
			file.Write( "ppm_cmark_cache/"..filename,tostring(ponydata._cmark))
		end--]]
		return PPM.SaveToCache( PPM.CacheGroups.OC_DATA, LocalPlayer(), filename, saveframe )
	end

	local bool_sending=false
	function PPM.Load(filename)
		local data = file.Read("data/ppm/"..filename,"GAME")
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
		end--[[
		local _cmark=file.Read("data/ppm_cmark_cache/"..filename,"GAME")
		if _cmark and !bool_sending then
			bool_sending=true
			local packcount=math.ceil(_cmark:len() / 32768)
			for i=1,packcount do
				timer.Simple(0.22*i,function()
					PPM.cmarksys_send(_cmark,i-1,packcount)
				end)
				if i==packcount then
					bool_sending=false
				end
			end
			ponydata._cmark=_cmark
			ponydata._cmark_loaded=true
		elseif !_cmark then
			PPM.cmarksys_clearcmark()
		end--]]
		return ponydata
	end
end


