
PPM.bannedVars = {
	m_bodyt0=true,
	_cmark=true,
	_cmark_loaded=true,
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
				table.insert( saveframe, "\n " .. k .. " " .. tostring(v) )
			elseif type(v) == "boolean" then
				table.insert( saveframe, "\n " .. k .. " b " .. tostring(v) )
			elseif type(v) == "string" then
				table.insert( saveframe, "\n " .. k .. " s " .. string.Replace( v, " " ,"\\SPACE\\" ) )
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
			if( table.Count(args) == 2 ) then
				ponydata[name] =tonumber( args[2] )
			elseif( table.Count(args) == 4 ) then
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
			elseif( table.Count(args) == 3 ) then
				if args[2] == "b" then
					ponydata[name] = tobool( args[3] )
				elseif args[2] == "s" then
					ponydata[name]=args[3]:Replace("\\SPACE\\"," ")
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
		local saveframe = PPM.PonyDataToString( ponydata )
		
		if !string.EndsWith( filename,".txt" ) then
			filename = filename .. ".txt"
		end
		if !file.Exists( "ppm", "DATA" ) then
			file.CreateDir( "ppm" )
		end
		MsgN( "saving .... " .. "ppm/" .. filename )
		file.Write( "ppm/" .. filename, saveframe )
		return PPM.SaveToCache( PPM.CacheGroups.OC_DATA, LocalPlayer(), filename, saveframe )
	end

	function PPM.Load(filename)
		local data = file.Read("data/ppm/"..filename,"GAME")
		return PPM.StringToPonyData( data )
	end

end