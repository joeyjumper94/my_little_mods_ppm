if SERVER then
	return
end
--[[
lua_run_cl for k,v in SortedPairs(PPM)do if type(v)=="IMaterial" and v.SetFloat then v:SetFloat("$phongexponent",255)v:SetFloat("$phongboost",10)end end
lua_run for k,v in ipairs(PPM.m_bodydetails)do v[1]:SetFloat("$phongexponent",255)v[1]:SetFloat("$phongboost",10)end
lua_run_cl for k,v in SortedPairs(PPM)do if type(v)=="IMaterial" and v.SetFloat then v:SetFloat("$$alpha",.1)end end
$alpha
lua_run_cl for k,v in SortedPairs(PPM.m_wings:GetKeyValues())do if type(v)=="number"then print(k.."="..v)elseif type(v)=="Vector"then print(k.."=Vector("..v.x..","..v.y..","..v.z..")")end end

$alpha=1
$alphatestreference=0
$ambientonly=0
$basemapalphaphongmask=1
$blendtintbybasealpha=0
$blendtintcoloroverbase=0
$bumpframe=0
$cloakcolortint=Vector(1,1,1)
$cloakfactor=0
$cloakpassenabled=0
$depthblend=0
$depthblendscale=0
$detailblendfactor=1
$detailblendmode=0
$detailframe=0
$detailscale=4
$detailtint=Vector(1,1,1)
$emissiveblendenabled=0
$emissiveblendscrollvector=Vector(0,0,0)
$emissiveblendstrength=0
$emissiveblendtint=Vector(1,1,1)
$envmapcontrast=0
$envmapframe=0
$envmapfresnel=0
$envmapmaskframe=0
$envmapsaturation=0
$envmaptint=Vector(1,1,1)
$flags=2048
$flags2=262210
$flags_defined=2048
$flags_defined2=0
$flashlightnolambert=0
$flashlighttextureframe=0
$fleshbordernoisescale=0
$fleshbordersoftness=0
$fleshbordertint=Vector(1,1,1)
$fleshborderwidth=0
$fleshdebugforcefleshon=0
$flesheffectcenterradius1=Vector(0,0,0)
$flesheffectcenterradius2=Vector(0,0,0)
$flesheffectcenterradius3=Vector(0,0,0)
$flesheffectcenterradius4=Vector(0,0,0)
$fleshglobalopacity=0
$fleshglossbrightness=0
$fleshinteriorenabled=0
$fleshscrollspeed=0
$fleshsubsurfacetint=Vector(1,1,1)
$frame=0
$invertphongmask=0
$linearwrite=0
$phong=1
$phongalbedotint=1
$phongfresnelranges=Vector(0.21951973438263,1,1)
$phongtint=Vector(1,1,1)
$refractamount=0
$rimlight=1
$rimlightboost=1
$rimlightexponent=2
$rimmask=0
$selfillum_envmapmask_alpha=0
$selfillumfresnel=0
$selfillumfresnelminmaxexp=Vector(0,1,1)
$selfillumtint=Vector(1,1,1)
$separatedetailuvs=0
$srgbtint=Vector(1,1,1)
$time=0
--]]

if CreateConVar("ppm_limit_to_vanilla", "0", {FCVAR_ARCHIVE}, "if the client sets it to 1, socks and other custom textures will not be drawn by said client"):GetBool() then
	PPM_Render_Cap = 13
else
	PPM_Render_Cap = 1000000000000000
end
cvars.AddChangeCallback("ppm_limit_to_vanilla",function(var,old,new)
	if new!="0" then
		PPM_Render_Cap=13
	else
		PPM_Render_Cap=10000000000000000000
	end
end,"ppm_limit_to_vanilla")
function PPM.TextureIsOutdated(ent, name, newhash)
	if not PPM.isValidPony(ent) then return true end
	if ent.ponydata_tex==nil then return true end
	if ent.ponydata_tex[name]==nil then return true end
	if ent.ponydata_tex[name.."_hash"]==nil then return true end
	if ent.ponydata_tex[name.."_hash"] ~=newhash then return true end

	return false
end
function PPM.GetBodyHash(ponydata)
	return tostring(ponydata.bodyt0)..tostring(ponydata.bodyt1)..tostring(ponydata.coatcolor)..tostring(ponydata.bodyt1_color)
end
function FixVertexLitMaterial(Mat)
	local strImage=Mat:GetName()

	if (string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable")) then
		local t=Mat:GetString("$basetexture")

		if (t) then
			local params={}
			params["$basetexture"]=t
			params["$vertexcolor"]=1
			params["$vertexalpha"]=1
			Mat=CreateMaterial(strImage.."_DImage", "UnlitGeneric", params)
		end
	end

	return Mat
end
function PPM.CreateTexture(tname, data)
	local w, h=ScrW(), ScrH()
	local rttex=nil
	local size=data.size or 512
	rttex=GetRenderTarget(tname, size, size, false)

	if data.predrawfunc ~=nil then
		data.predrawfunc()
	end

	local OldRT=render.GetRenderTarget()
	render.SetRenderTarget(rttex)
	render.SuppressEngineLighting(true)
	cam.IgnoreZ(true)
	render.SetBlend(1)
	render.SetViewPort(0, 0, size, size)
	render.Clear(0, 0, 0, 255, true)
	cam.Start2D()
	render.SetColorModulation(1, 1, 1)

	if data.drawfunc ~=nil then
		data.drawfunc()
	end

	cam.End2D()
	render.SetRenderTarget(OldRT)
	render.SetViewPort(0, 0, w, h)
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	render.SuppressEngineLighting(false)

	return rttex
end
function PPM.CreateBodyTexture(ent, pony)
	if not PPM.isValidPony(ent) then return end
	local w, h=ScrW(), ScrH()

	local function tW(val)
		return val
	end --val/512*w end

	local function tH(val)
		return val
	end --val/512*h end

	local rttex=nil
	ent.ponydata_tex=ent.ponydata_tex or {}

	if (ent.ponydata_tex.bodytex ~=nil) then
		rttex=ent.ponydata_tex.bodytex
	else
		rttex=GetRenderTarget(string.Replace(tostring(ent),".","//point//").."body", tW(512), tH(512), false)
	end

	local OldRT=render.GetRenderTarget()
	render.SetRenderTarget(rttex)
	render.SuppressEngineLighting(true)
	cam.IgnoreZ(true)
	render.SetLightingOrigin(Vector(0, 0, 0))
	render.ResetModelLighting(1, 1, 1)
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	render.SetModelLighting(BOX_TOP, 1, 1, 1)
	render.SetViewPort(0, 0, tW(512), tH(512))
	render.Clear(0, 255, 255, 255, true)
	cam.Start2D()
	render.SetColorModulation(1, 1, 1)

	if (pony.gender==1) then
		render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodyf")))
	else
		render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodym")))
	end

	render.DrawQuadEasy(Vector(tW(256), tH(256), 0), Vector(0, 0, -1), tW(512), tH(512), Color(pony.coatcolor.x * 255, pony.coatcolor.y * 255, pony.coatcolor.z * 255, 255), -90) --position of the rect

	--direction to face in
	--size of the rect
	--color
	--rotate 90 degrees
	if (pony.bodyt1 > 1) then
		render.SetMaterial(FixVertexLitMaterial(PPM.m_bodydetails[pony.bodyt1 - 1][1]))
		render.SetBlend(1)
		local colorbl=pony.bodyt1_color or Vector(1, 1, 1)
		render.DrawQuadEasy(Vector(tW(256), tH(256), 0), Vector(0, 0, -1), tW(512), tH(512), Color(colorbl.x * 255, colorbl.y * 255, colorbl.z * 255, 255), -90) --position of the rect
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
	end

	if (pony.bodyt0 > 1) then
		render.SetMaterial(FixVertexLitMaterial(PPM.m_bodyt0[pony.bodyt0 - 1][1]))
		render.SetBlend(1)
		render.DrawQuadEasy(Vector(tW(256), tH(256), 0), Vector(0, 0, -1), tW(512), tH(512), Color(255, 255, 255, 255), -90) --position of the rect
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
	end

	cam.End2D()
	render.SetRenderTarget(OldRT) -- Resets the RenderTarget to our screen
	render.SetViewPort(0, 0, w, h)
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	render.SuppressEngineLighting(false)
	--	cam.IgnoreZ(false)
	ent.ponydata_tex.bodytex=rttex
	--MsgN("HASHOLD: "..tostring(ent.ponydata_tex.bodytex_hash)) 
	ent.ponydata_tex.bodytex_hash=PPM.GetBodyHash(pony)
	--MsgN("HASHNEW: "..tostring(ent.ponydata_tex.bodytex_hash)) 
	--MsgN("HASHTAR: "..tostring(PPM.GetBodyHash(outpony))) 

	return rttex
end
PPM.VALIDPONY_CLASSES={
	"player",
	"prop_ragdoll",
	"prop_physics",
	"cpm_pony_npc",
	player=true,
	prop_physics=true,
	prop_ragdoll=true,
	cpm_pony_npc=true,
	["class C_HL2MPRagdoll"]=true,
}
hook.Add("HUDPaint","pony_render_textures",function()
	for index, ent in pairs(PPM.Ents) do
		if !ent:IsValid() then continue end
		if PPM.VALIDPONY_CLASSES[ent:GetClass()] then
			if (PPM.isValidPonyLight(ent)) then
				local pony=PPM.getPonyValues(ent, false)

				if (not PPM.isValidPony(ent)) then
					PPM.setupPony(ent)
				end

				local texturespreframe=1

				for k, v in pairs(PPM.rendertargettasks) do
					if texturespreframe > 0 and PPM.TextureIsOutdated(ent, k, v.hash(pony)) then
						ent.ponydata_tex=ent.ponydata_tex or {}
						PPM.currt_ent=ent
						PPM.currt_ponydata=pony
						PPM.currt_success=false
						ent.ponydata_tex[k]=PPM.CreateTexture(string.Replace(tostring(ent),".","//point//")..k, v)
						ent.ponydata_tex[k.."_hash"]=v.hash(pony)
						ent.ponydata_tex[k.."_draw"]=PPM.currt_success
						texturespreframe=texturespreframe - 1
					end
				end
			end
			--MsgN("Outdated texture at "..string.Replace(tostring(ent),".","//point//")..tostring(ent:GetClass()))
		elseif ent.isEditorPony then
			local pony=PPM.getPonyValues(ent, true)

			if !pony then
				PPM.setupPony(ent)
				return
			end

			for k, v in pairs(PPM.rendertargettasks) do
				if (PPM.TextureIsOutdated(ent, k, v.hash(pony))) then
					ent.ponydata_tex=ent.ponydata_tex or {}
					PPM.currt_ent=ent
					PPM.currt_ponydata=pony
					PPM.currt_success=false
					ent.ponydata_tex[k]=PPM.CreateTexture(string.Replace(tostring(ent),".","//point//")..k, v)
					ent.ponydata_tex[k.."_hash"]=v.hash(pony)
					ent.ponydata_tex[k.."_draw"]=PPM.currt_success
				end
			end
		end
	end
end)
PPM.loadrt=function()
	PPM.currt_success=false
	PPM.currt_ent=nil
	PPM.currt_ponydata=nil
	PPM.rendertargettasks={}
	PPM.rendertargettasks["bodytex"]={
		renderTrue=function(ENT, PONY)
			PPM.m_body:SetVector("$color2", Vector(1, 1, 1))
			PPM.m_body:SetTexture("$basetexture", ENT.ponydata_tex.bodytex)
		end,
		renderFalse=function(ENT, PONY)
			PPM.m_body:SetVector("$color2", PONY.coatcolor)--[ [
			PPM.m_body:SetFloat("$phongexponent",PONY.coatphongexponent)
			PPM.m_body:SetFloat("$phongboost",PONY.coatphongboost)--]]
			if (PONY.gender==1) then
				PPM.m_body:SetTexture("$basetexture", PPM.m_bodyf:GetTexture("$basetexture"))
			else
				PPM.m_body:SetTexture("$basetexture", PPM.m_bodym:GetTexture("$basetexture"))
			end
		end,
		drawfunc=function()
			local pony=PPM.currt_ponydata

			if (pony.gender==1) then
				render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodyf")))
			else
				render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodym")))
			end

			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(pony.coatcolor.x * 255, pony.coatcolor.y * 255, pony.coatcolor.z * 255, 255), -90) --position of the rect

			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			--MsgN("render.body.prep")
			for C=1, 8 do
				local detailvalue=pony["bodydetail"..C] or 1
				local detailcolor=pony["bodydetail"..C.."_c"] or Vector(0, 0, 0)

				if detailvalue<PPM_Render_Cap and detailvalue>1 and PPM.m_bodydetails[detailvalue-1] and PPM.m_bodydetails[detailvalue-1][1] then
					--MsgN("rendering tex id: ",detailvalue," col: ",detailcolor)
					local mat=PPM.m_bodydetails[detailvalue - 1][1]
					--PPM.m_body:SetFloat("$phong",1)
					--PPM.m_body:SetFloat("$basemapalphaphongmask",1)
					render.SetMaterial(mat) --Material("models/ppm/base/render/clothes_sbs_full")) 
					--surface.SetTexture(surface.GetTextureID("models/ppm/base/render/horn"))
					render.SetBlend(1)
					render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(detailcolor.x * 255, detailcolor.y * 255, detailcolor.z * 255, 255), -90) --position of the rect
					--direction to face in
					--size of the rect
					--color
					--rotate 90 degrees
				end
			end

			local pbt=pony.bodyt0 or 1

			if (pbt > 1) then
				local mmm=PPM.m_bodyt0[pbt - 1]

				if (mmm ~=nil) then
					render.SetMaterial(FixVertexLitMaterial(mmm)) --Material("models/ppm/base/render/clothes_sbs_full")) 
					--surface.SetTexture(surface.GetTextureID("models/ppm/base/render/horn"))
					render.SetBlend(1)
					render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(255, 255, 255, 255), -90) --position of the rect
					--direction to face in
					--size of the rect
					--color
					--rotate 90 degrees
				end
			end

			PPM.currt_success=true
		end,
		hash=function(ponydata)
			local hash=ponydata.coatphongexponent..ponydata.coatphongboost..tostring(ponydata.bodyt0)..tostring(ponydata.coatcolor)..tostring(ponydata.gender)

			for C=1, 8 do
				local detailvalue=ponydata["bodydetail"..C] or 1
				local detailcolor=ponydata["bodydetail"..C.."_c"] or Vector(0, 0, 0)
				hash=hash..tostring(detailvalue)..tostring(detailcolor)
			end

			return hash
		end
	}
	PPM.rendertargettasks["hairtex1"]={--upper mane
		renderTrue=function(ENT, PONY)
			PPM.m_hair1:SetVector("$color2", Vector(1, 1, 1))
			--PPM.m_hair2:SetVector("$color2", Vector(1,1,1)) 
			PPM.m_hair1:SetTexture("$basetexture", ENT.ponydata_tex.hairtex1)
		end,
		renderFalse=function(ENT, PONY)
			PPM.m_hair1:SetVector("$color2", PONY.haircolor1)
			PPM.m_hair1:SetFloat("$phongexponent",PONY.hairphongexponent)
			PPM.m_hair1:SetFloat("$phongboost",PONY.hairphongboost)
 			--PPM.m_hair2:SetVector("$color2", PONY.haircolor2) 
			PPM.m_hair1:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
		end,
		--PPM.m_hair2:SetTexture("$basetexture",Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture")) 
		drawfunc=function()
			local pony=PPM.currt_ponydata
			render.Clear(pony.haircolor1.x * 255, pony.haircolor1.y * 255, pony.haircolor1.z * 255, 255, true)
			PPM.tex_drawhairfunc(pony, "up", false)
		end,
		hash=function(ponydata)return ponydata.hairphongexponent..ponydata.hairphongboost..tostring(ponydata.haircolor1)..tostring(ponydata.haircolor2)..tostring(ponydata.haircolor3)..tostring(ponydata.haircolor4)..tostring(ponydata.haircolor5)..tostring(ponydata.haircolor6)..tostring(ponydata.mane)end
	}
	PPM.rendertargettasks["hairtex2"]={--lower mane
		renderTrue=function(ENT, PONY)
			--PPM.m_hair1:SetVector("$color2", Vector(1,1,1))
			PPM.m_hair2:SetVector("$color2", Vector(1, 1, 1))
			PPM.m_hair2:SetTexture("$basetexture", ENT.ponydata_tex.hairtex2)
		end,
		renderFalse=function(ENT, PONY)
			--PPM.m_hair1:SetVector("$color2", PONY.haircolor1) 
			PPM.m_hair2:SetVector("$color2", PONY.haircolor2)
			PPM.m_hair2:SetFloat("$phongexponent",PONY.manephongexponent)
			PPM.m_hair2:SetFloat("$phongboost",PONY.manephongboost)
			--PPM.m_hair1:SetTexture("$basetexture",Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture")) 
			PPM.m_hair2:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
		end,
		drawfunc=function()
			local pony=PPM.currt_ponydata
			PPM.tex_drawhairfunc(pony, "dn", false)
		end,
		hash=function(ponydata) return ponydata.manephongexponent..ponydata.manephongboost..tostring(ponydata.manecolor1)..tostring(ponydata.manecolor2)..tostring(ponydata.manecolor3)..tostring(ponydata.manecolor4)..tostring(ponydata.manecolor5)..tostring(ponydata.manecolor6)..tostring(ponydata.manel) end
	}
	PPM.rendertargettasks["tailtex"]={--the tail
		renderTrue=function(ENT, PONY)
			PPM.m_tail1:SetVector("$color2", Vector(1, 1, 1))
			PPM.m_tail2:SetVector("$color2", Vector(1, 1, 1))
			PPM.m_tail1:SetTexture("$basetexture", ENT.ponydata_tex.tailtex)
		end,
		renderFalse=function(ENT, PONY)
			PPM.m_tail1:SetVector("$color2", PONY.tailcolor1)
			PPM.m_tail2:SetVector("$color2", PONY.tailcolor2)
			PPM.m_tail1:SetFloat("$phongexponent",PONY.tailphongexponent)
			PPM.m_tail1:SetFloat("$phongboost",PONY.tailphongboost)
			PPM.m_tail1:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
			PPM.m_tail2:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
		end,
		drawfunc=function()
			local pony=PPM.currt_ponydata
			PPM.tex_drawhairfunc(pony, "up", true)
		end,
		hash=function(ponydata) return ponydata.tailphongexponent..ponydata.tailphongboost..tostring(ponydata.tailcolor1)..tostring(ponydata.tailcolor2)..tostring(ponydata.tailcolor3)..tostring(ponydata.tailcolor4)..tostring(ponydata.tailcolor5)..tostring(ponydata.tailcolor6)..tostring(ponydata.tail) end
	}
	PPM.rendertargettasks["eyeltex"]={--left eye
		renderTrue=function(ENT, PONY)
			PPM.m_eyel:SetTexture("$Iris", ENT.ponydata_tex.eyeltex)
		end,
		renderFalse=function(ENT, PONY)
			PPM.m_eyel:SetTexture("$Iris", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
		end,
		drawfunc=function()
			local pony=PPM.currt_ponydata
			PPM.tex_draweyefunc(pony, false)
		end,
		hash=function(ponydata) 
			local ret=""
			..tostring(ponydata.eye_effect_alpha)
			..tostring(ponydata.eye_effect_color)
			..tostring(ponydata.eye_reflect_alpha)
			..tostring(ponydata.eye_reflect_color)
			..tostring(ponydata.eye_reflect_type)
			..tostring(ponydata.eye_type)
			..tostring(ponydata.eyecolor_bg)
			..tostring(ponydata.eyecolor_grad)
			..tostring(ponydata.eyecolor_hole)
			..tostring(ponydata.eyecolor_iris)
			..tostring(ponydata.eyecolor_line1)
			..tostring(ponydata.eyecolor_line2)
			..tostring(ponydata.eyehaslines)
			..tostring(ponydata.eyeholesize)
			..tostring(ponydata.eyeirissize)
			..tostring(ponydata.eyejholerssize)
			return ret
		end
	}
	PPM.rendertargettasks["eyertex"]={--right eye
		renderTrue=function(ENT, PONY)
			PPM.m_eyer:SetTexture("$Iris", ENT.ponydata_tex.eyertex)
		end,
		renderFalse=function(ENT, PONY)
			PPM.m_eyer:SetTexture("$Iris", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
		end,
		drawfunc=function()
			local pony=PPM.currt_ponydata
			PPM.tex_draweyefunc(pony, true)
		end,
		hash=function(ponydata) 
			local ret=""
			..tostring(ponydata.eye_effect_alpha_r)
			..tostring(ponydata.eye_effect_color_r)
			..tostring(ponydata.eye_reflect_alpha_r)
			..tostring(ponydata.eye_reflect_color_r)
			..tostring(ponydata.eye_reflect_type_r)
			..tostring(ponydata.eye_type_r)
			..tostring(ponydata.eyecolor_bg_r)
			..tostring(ponydata.eyecolor_grad_r)
			..tostring(ponydata.eyecolor_hole_r)
			..tostring(ponydata.eyecolor_iris_r)
			..tostring(ponydata.eyecolor_line1_r)
			..tostring(ponydata.eyecolor_line2_r)
			..tostring(ponydata.eyehaslines_r)
			..tostring(ponydata.eyeholesize_r)
			..tostring(ponydata.eyeirissize_r)
			..tostring(ponydata.eyejholerssize_r)
			return ret
		end
	}
	PPM.tex_drawhairfunc=function(pony, UPDN, TAIL)
		local hairnum=pony.mane
		local PREFIX="hair"

		if UPDN=="dn" then
			hairnum=pony.manel
			PREFIX="mane"
		elseif TAIL then
			hairnum=pony.tail
			PREFIX="tail"
		end

		PPM.hairrenderOp(UPDN, TAIL, hairnum)
		local colorcount=PPM.manerender[UPDN..hairnum]

		if TAIL then
			colorcount=PPM.manerender["tl"..hairnum]
		end

		if colorcount ~=nil then
			local coloroffcet=colorcount[1]

			if UPDN=="up" then--hair on top
				coloroffcet=0
			end

			local prephrase=UPDN.."mane_"

			if TAIL then--drawing the tail
				prephrase="tail_"
			end

			colorcount=colorcount[2]
			local backcolor=pony[PREFIX.."color"..(coloroffcet + 1)] or PPM.defaultHairColors[coloroffcet + 1]
			render.Clear(backcolor.x * 255, backcolor.y * 255, backcolor.z * 255, 255, true)

			for I=0, colorcount - 1 do
				local color=pony[PREFIX.."color"..(I + 2 + coloroffcet)] or PPM.defaultHairColors[I + 2 + coloroffcet] or Vector(1, 1, 1)
				local material=Material("models/ppm/partrender/"..prephrase..hairnum.."_mask"..I..".png")
				render.SetMaterial(material)
				render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(color.x * 255, color.y * 255, color.z * 255, 255), -90) --position of the rect
				--direction to face in
				--size of the rect
				--color
				--rotate 90 degrees
			end
		else
			if TAIL then end

			if UPDN=="dn" then
				render.Clear(pony.haircolor2.x * 255, pony.haircolor2.y * 255, pony.haircolor2.z * 255, 255, true)
			else
				render.Clear(pony.haircolor1.x * 255, pony.haircolor1.y * 255, pony.haircolor1.z * 255, 255, true)
			end
		end
	end
	PPM.tex_draweyefunc=function(pony, isR)
		local prefix="l"
		local SUFFIX=""

		if isR then
			SUFFIX="_r"
		else
			prefix="r"
		end

		local backcolor=pony["eyecolor_bg"..SUFFIX] or Vector(1, 1, 1)
		local color=1.3 * pony["eyecolor_iris"..SUFFIX] or Vector(0.5, 0.5, 0.5)
		local colorg=1.3 * pony["eyecolor_grad"..SUFFIX] or Vector(1, 0.5, 0.5)
		local colorl1=1.3 * pony["eyecolor_line1"..SUFFIX] or Vector(0.6, 0.6, 0.6)
		local colorl2=1.3 * pony["eyecolor_line2"..SUFFIX] or Vector(0.7, 0.7, 0.7)
		local holecol=1.3 * pony["eyecolor_hole"..SUFFIX] or Vector(0, 0, 0)

		render.Clear(backcolor.x * 255, backcolor.y * 255, backcolor.z * 255, 255, true)
		local material=PPM.m_eyes[1]
		if isR then
			material=PPM.m_eyes[pony.eye_type_r] or material
		else
			material=PPM.m_eyes[pony.eye_type] or material
		end
		render.SetMaterial(material)
		local drawlines=false
		if isR and pony.eye_type_r==1 then
			drawlines=pony.eyehaslines_r==1
		end
		if !isR and pony.eye_type==1 then
			drawlines=pony.eyehaslines==1
		end
		local holewidth=pony.eyejholerssize or 1
		local irissize=pony["eyeirissize"..SUFFIX] or 0.6
		local holesize=(pony["eyeirissize"..SUFFIX] or 0.6) * (pony["eyeholesize"..SUFFIX] or 0.7)
		render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(color.x * 255, color.y * 255, color.z * 255, 255), -90) --position of the rect
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
		--grad 
		local material=PPM.m_eye_grads[1]
		if isR then
			material=PPM.m_eye_grads[pony.eye_type_r] or material
		else
			material=PPM.m_eye_grads[pony.eye_type] or material
		end
		render.SetMaterial(material)
		render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(colorg.x * 255, colorg.y * 255, colorg.z * 255, 255), -90) --position of the rect

		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
		if drawlines then
			--eye_line_l1
			local material=Material("models/ppm/partrender/eye_line_"..prefix.."2.png")
			render.SetMaterial(material)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(colorl2.x * 255, colorl2.y * 255, colorl2.z * 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			local material=Material("models/ppm/partrender/eye_line_"..prefix.."1.png")
			render.SetMaterial(material)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(colorl1.x * 255, colorl1.y * 255, colorl1.z * 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
		end

		--hole
		local material=Material("models/ppm/partrender/eye_oval.png")
		render.SetMaterial(material)
		render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * holesize * holewidth, 512 * holesize, Color(holecol.x * 255, holecol.y * 255, holecol.z * 255, 255), -90) --position of the rect
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
		local material=Material("models/ppm/partrender/eye_effect.png")
		if isR then
			material:SetVector("$color2",pony.eye_effect_color_r or Vector(1,1,1))
			material:SetFloat("$alpha",pony.eye_effect_alpha_r)
		else
			material:SetVector("$color2",pony.effect_color or Vector(1,1,1))
			material:SetFloat("$alpha",pony.eye_effect_alpha)
		end
		render.SetMaterial(material)
		render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(255, 255, 255, 255), -90) --position of the rect
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
		local material=PPM.m_eye_reflections[1]
		if isR then
			material=PPM.m_eye_reflections[pony.eye_reflect_type_r] or material
			material:SetVector("$color2",pony.eye_reflect_color_r)
			material:SetFloat("$alpha",pony.eye_reflect_alpha_r)
		else
			material=PPM.m_eye_reflections[pony.eye_reflect_type] or material
			material:SetVector("$color2",pony.eye_reflect_color)
			material:SetFloat("$alpha",pony.eye_reflect_alpha)
		end
		render.SetMaterial(material)
		render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(255, 255, 255, 255 * 0.5), -90) --position of the rect
		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
		PPM.currt_success=true
	end
	PPM.hairrenderOp=function(UPDN, TAIL, hairnum)
		if TAIL then
			if PPM.manerender["tl"..hairnum] ~=nil then
				PPM.currt_success=true
			end
		else
			if PPM.manerender[UPDN..hairnum] ~=nil then
				PPM.currt_success=true
			end
		end
	end
	--/PPM.currt_success=true
	--MsgN(UPDN,TAIL,hairnum,"=",PPM.currt_success)
	PPM.manerender={}
	PPM.manerender.up5={0, 1}
	PPM.manerender.up6={0, 1}
	PPM.manerender.up8={0, 2}
	PPM.manerender.up9={0, 3}
	PPM.manerender.up10={0, 1}
	PPM.manerender.up11={0, 3}
	PPM.manerender.up12={0, 1}
	PPM.manerender.up13={0, 1}
	PPM.manerender.up14={0, 1}
	PPM.manerender.up15={0, 1}
	PPM.manerender.dn5={0, 1}
	PPM.manerender.dn8={3, 2}
	PPM.manerender.dn9={3, 2}
	PPM.manerender.dn10={0, 3}
	PPM.manerender.dn11={0, 2}
	PPM.manerender.dn12={0, 1}
	PPM.manerender.tl5={0, 1}
	PPM.manerender.tl8={0, 5}
	PPM.manerender.tl10={0, 1}
	PPM.manerender.tl11={0, 3}
	PPM.manerender.tl12={0, 2}
	PPM.manerender.tl13={0, 1}
	PPM.manerender.tl14={0, 1}
	PPM.manecolorcounts={}
	PPM.manecolorcounts[1]=1
	PPM.manecolorcounts[2]=1
	PPM.manecolorcounts[3]=1
	PPM.manecolorcounts[4]=1
	PPM.manecolorcounts[5]=1
	PPM.manecolorcounts[6]=1
	PPM.defaultHairColors={Vector(252,92,82)*0.00390625,Vector(254,134,60)*0.00390625,Vector(254,241,160)*0.00390625,Vector(98,188,80)*0.00390625,Vector(38,165,245)*0.00390625,Vector(124,80, 160)*0.00390625}
	PPM.rendertargettasks["ccmarktex"]={
		renderTrue=function(ENT,PONY)
			PPM.m_cmark:SetTexture("$basetexture",ENT.ponydata_tex.ccmarktex)
		end,
		renderFalse=function(ENT,PONY)
			--PPM.m_cmark:SetTexture("$basetexture",Material("models/mlp/partrender/clean.png"):GetTexture("$basetexture")) 
			if (PONY==nil) then print("1") return end
			if (PONY.cmark==nil) then  print("2") return end
			if (PPM.m_cmarks[PONY.cmark]==nil) then print("3") return end
			if (PPM.m_cmarks[PONY.cmark][2]==nil) then print("4") return end
			if (PPM.m_cmarks[PONY.cmark][2]:GetTexture("$basetexture")==nil) then print("5") return end
			if (PPM.m_cmarks[PONY.cmark][2]:GetTexture("$basetexture")==NULL) then print("6") return end
			PPM.m_cmark:SetTexture("$basetexture",PPM.m_cmarks[PONY.cmark][2]:GetTexture("$basetexture"))
		end,
		drawfunc=function()
			local pony=PPM.currt_ponydata

			--print("LOAD STATUS CHANGED!")
			if (pony._cmark_loaded and pony._cmark~=nil) then
				render.Clear(255,255,255,255)
				print("DATA HAS BEEN LOADED...RENDERING!")
				local material=Material("gui/pixel.png")
				--render.SetMaterial(material) 
				render.SetColorMaterialIgnoreZ()
				render.SetBlend(1)
				local data=pony._cmark

				for x=0,256 do
					--local xsub=string.sub(data,x*256*3,x*256*3+256*3)
					for y=0,256 do
						local postition=(x * 257 + y) * 3
						--local ysub=string.sub(xsub,y*3,y*3+3)
						local r=string.byte(string.sub(pony._cmark,postition,postition)) or 1
						local g=string.byte(string.sub(pony._cmark,postition+1,postition+1)) or 1
						local b=string.byte(string.sub(pony._cmark,postition+2,postition+2)) or 0

						--print(r)
						if (r > 250 and g==0 and b > 250) or (x < 45 or x > 250) or (y < 5 or y > 250) then
							--[[
						render.DrawQuadEasy(Vector(x*2+1,y*2+1,0),	--position of the rect
							Vector(0,0,-1),		--direction to face in
							2,2,			  --size of the rect
							Color(0,0,0,0),--color
							-90					 --rotate 90 degrees
							)  
						]]
							render.SetScissorRect(x * 2,y * 2,x * 2 + 2,y * 2 + 2,true)
							render.Clear(0,0,0,0)
							--position of the rect
							--direction to face in
							--size of the rect
							--color
							--rotate 90 degrees
						else
							render.SetScissorRect(x * 2,y * 2,x * 2 + 2,y * 2 + 2,false)
							render.DrawQuadEasy(Vector(x * 2 + 1,y * 2 + 1,0),Vector(0,0,-1),2,2,Color(r,g,b,255),-90)
						end
					end
				end

				PPM.currt_success=true
				print("cleaned_Surface_")
			else
				render.Clear(0,0,0,0)
				PPM.currt_success=false
			end
		end,
		hash=function(ponydata) return tostring(ponydata._cmark_loaded) end
	}
end