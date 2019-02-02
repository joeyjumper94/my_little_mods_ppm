if CLIENT then
	function PPM:RescaleRIGPART(ent,part,scale)
		for k,v in pairs(part) do
			ent:ManipulateBoneScale(v,scale)
		end
	end

	function PPM:RescaleMRIGPART(ent,part,scale)
		for k,v in pairs(part) do
			--ent:ManipulateBoneScale(v,scale ) 
			ent:ManipulateBonePosition(v,scale)
		end
	end

	function PPM:RescaleOFFCETRIGPART(ent,part,scale)
		for k,v in pairs(part) do
			--ent:ManipulateBoneScale(v,scale ) 
			local thispos=PPM.skeletons.pony_default[v+1].localpos
			ent:ManipulateBonePosition(v,thispos*(scale-Vector(1,1,1)))
		end
	end

	function PPM.PrePonyDraw(ent,localvals)
		if not PPM.isValidPonyLight(ent) then return end
		--if true then return end 
		local pony=PPM.getPonyValues(ent,localvals)
		--				MsgN("Pony at "..tostring(ent)..tostring(ent:GetClass()))
		--local gdimf=pony.gender;
		--[[
		if(PPM.TextureIsOutdated(ent,"bodytex",PPM.GetBodyHash(pony))) then
			if(!PPM.isValidPony(ent)) then PPM.setupPony(ent) end
			--MsgN("Outdated texture at "..tostring(ent).." IsLocal: "..tostring(localvals))
			 
			PPM.CreateBodyTexture(ent,pony) 
		end
		]]
		--render.DrawScreenQuad()
		--fafaf=true  
		--TESTTEXTRUE=TEST_CreateBodyTexture()
		--Pony at Entity [40][class C_HL2MPRagdoll]class C_HL2MPRagdoll IsLocal: true
		--Pony at Player [1][Celestia]player IsLocal: false
		--MsgN("Pony at "..tostring(ent)..tostring(ent:GetClass()).." IsLocal: "..tostring(localvals))
		--MsgN("pony begin")
		if (table.Count(pony)==0) then return end

--		for k,v in SortedPairs(pony) do
			--MsgN(k,"\t\t\t",pony[k] )
--		end

		--{--rigscalething
		local SCALEVAL0=pony.bodyweight or 1--(1+math.sin(time)/4)  
		local SCALEVAL1=pony.gender-1
		--local SCALEVAL2=PPM.test_buffness;
		PPM:RescaleRIGPART(ent,PPM.rig.leg_FL,Vector(1,1,1)*SCALEVAL0)
		PPM:RescaleRIGPART(ent,PPM.rig.leg_FR,Vector(1,1,1)*SCALEVAL0)
		PPM:RescaleRIGPART(ent,PPM.rig.leg_BL,Vector(1,1,1)*SCALEVAL0)
		PPM:RescaleRIGPART(ent,PPM.rig.leg_BR,Vector(1,1,1)*SCALEVAL0)
		PPM:RescaleRIGPART(ent,PPM.rig.rear,Vector(1,1,1)*(SCALEVAL0-(SCALEVAL1)*0.2))
		--PPM:RescaleRIGPART(self.Entity,{1},Vector(0,1,1 )*(SCALEVAL0+SCALEVAL1*0.2)+Vector(1,0,0 ))
		--PPM:RescaleRIGPART(self.Entity,{2},Vector(0,1,1 )*(SCALEVAL0+SCALEVAL1*0.4)+Vector(1,0,0 ))
		--PPM:RescaleRIGPART(self.Entity,{3},Vector(0,1,1 )*(SCALEVAL0+SCALEVAL1*0.8)+Vector(1,0,0 ))
		PPM:RescaleRIGPART(ent,PPM.rig.neck,Vector(1,1,1)*SCALEVAL0)
		PPM:RescaleRIGPART(ent,{3},Vector(1,1,0)*((SCALEVAL0-1)+SCALEVAL1*0.1+0.9)+Vector(0,0,1))
		PPM:RescaleMRIGPART(ent,{18},Vector(0,0,SCALEVAL1/2))
		PPM:RescaleMRIGPART(ent,{24},Vector(0,0,-SCALEVAL1/2))
		--tailscale
		local SCALEVAL_tail=pony.tailsize or 1
		local svts=(SCALEVAL_tail-1)*2+1
		local svtc=(SCALEVAL_tail-1)/2+1
		PPM:RescaleOFFCETRIGPART(ent,{38},Vector(svtc,svtc,svtc))
		PPM:RescaleRIGPART(ent,{38},Vector(svts,svts,svts))
		PPM:RescaleOFFCETRIGPART(ent,{39,40},Vector(SCALEVAL_tail,SCALEVAL_tail,SCALEVAL_tail))
		PPM:RescaleRIGPART(ent,{39,40},Vector(svts,svts,svts))
		--}
		if PPM.m_hair1==nil then return end
		PPM.m_hair1:SetVector("$color2",pony.haircolor1)
		PPM.m_hair2:SetVector("$color2",pony.haircolor2)
		PPM.m_wings:SetVector("$color2",pony.coatcolor)
		PPM.m_horn:SetVector("$color2",pony.coatcolor)
		PPM.m_eyel:SetFloat("$ParallaxStrength",0.2)
		PPM.m_eyer:SetFloat("$ParallaxStrength",0.1)
		--PPM.m_eyel:SetTexture("$Iris",PPM.t_eyes[pony.eye][1]:GetTexture("$basetexture"))
		--PPM.m_eyer:SetTexture("$Iris",PPM.t_eyes[pony.eye][1]:GetTexture("$detail")) 
		--MATE:SetTexture("$basetexture",PPM.t_eyes[pony.eye][1])
		--MATE:SetFloat("$ignorez",0)
		--MATE:SetFloat("$additive",0) 
		if ent.ponydata_tex!=nil then
			for k,v in pairs(PPM.rendertargettasks) do
				if ent.ponydata_tex[k]!=nil and ent.ponydata_tex[k]!=NULL and ent.ponydata_tex[k .. "_draw"] and type(ent.ponydata_tex[k])=="ITexture" and not ent.ponydata_tex[k]:IsError() then
					v.renderTrue(ent,pony)
				else
					v.renderFalse(ent,pony)
				end
			end
		end
		--[[
		if ent.ponydata_tex!=nil and ent.ponydata_tex.bodytex!=nil and ent.ponydata_tex.bodytex!=NULL and 
			type(ent.ponydata_tex.bodytex)=="ITexture" and !ent.ponydata_tex.bodytex:IsError() then 
			PPM.m_body:SetVector("$color2",Vector(1,1,1) ) 
			PPM.m_body:SetTexture("$basetexture",ent.ponydata_tex.bodytex)--PPM.m_bodyf:GetTexture("$basetexture"))
		else	 
			PPM.m_body:SetVector("$color2",pony.coatcolor ) 
			if(pony.gender==1)then 			
				PPM.m_body:SetTexture("$basetexture",PPM.m_bodyf:GetTexture("$basetexture")) 
			else		
				PPM.m_body:SetTexture("$basetexture",PPM.m_bodym:GetTexture("$basetexture"))
			end--45345345
		end
		]]
	end

--	function PonyPropDraw(ent) end
	PPM.Ents={}
	timer.Create("PPM_ENT_CACHE",2.5,0,function()
		PPM.Ents={}
		for i,ent in ipairs(ents.GetAll()) do
			if PPM.isValidPonyLight(ent) or ent.isEditorPony then
				table.insert(PPM.Ents,ent)
			end
		end
	end)
	hook.Add("PostDrawOpaqueRenderables","test_Redraw",function()
		--PPM.bones_testDraw("pony_mature") 	
		--			MsgN("Ponies:")
		--------------------STRARTUPHOOK
		--if true then return end
		if (not PPM.isLoaded) then
			PPM.LOAD()
		end

		--if true then return end
		--------------------RENDER
		for name,ent in ipairs(PPM.Ents) do
			if IsValid(ent) then
				if not ent:IsPlayer() then
					if PPM.isValidPonyLight(ent) then
						if (ent:IsNPC()) then
							ent:SetNoDraw(true)
							PPM.PrePonyDraw(ent,false)
							ent:DrawModel()
							--ent.Draw=function()
							--	MsgN("loald")
							--end
							--	if(ent.ponyoverlay==nil) then
							--		local e=ents.Create("pony_npc" )
							--		e:SetFrame(ent)
							--	end
							--PPM.randomizePony(ent)
							--ent:SetupBones()
						elseif PPM.VALIDPONY_CLASSES[ent:GetClass()] then
							if (not ent.isEditorPony) then
								if (not PPM.isValidPony(ent)) then end
								ent:SetNoDraw(true)

								if (ent.ponydata!=nil and ent.ponydata.useLocalData) then
									PPM.PrePonyDraw(ent,true)
								else
									PPM.PrePonyDraw(ent,false)
								end

								ent:DrawModel()
							end
						end
					end
					------------/PONY IS PLAYER
					--MsgN(I,ent.ponydata.clothes1:GetBodygroup(I ))
					--if plyrag.cloth1!=nil then
					--	plyrag.cloth1:DrawModel()  
					--end
					----
					--if ent.ponydata.clothes1==NULL  then 
					--	PPM.setupPony(ent) 
					--end
					--[[
						if  ent.ponydata.clothes1_sv!=NULL and ent.ponydata.clothes1!=NULL then
							for I=0,14 do 
								PPM.setBodygroupSafe(ent.ponydata.clothes1,I,
								ent.ponydata.clothes1_sv:GetBodygroup(I ) )
								--Msg(ent.ponydata.clothes1_sv:GetBodygroup(I ))
							end
						end
						--]]
				else
					local plyrag=ent:GetRagdollEntity()
					if plyrag!=nil then
						if PPM.isValidPonyLight(plyrag) then
							if !PPM.isValidPony(plyrag) then
								PPM.setupPony(plyrag)
								PPM.copyPonyTo(ent,plyrag)
								PPM.copyLocalTextureDataTo(ent,plyrag)
								plyrag.ponydata.useLocalData=true
								PPM.setBodygroups(plyrag,true)
								plyrag:SetNoDraw(true)
								if ent.ponydata!=nil then
									if plyrag.clothes1==nil then
										plyrag.clothes1=ClientsideModel("models/ppm/player_default_clothes1.mdl",RENDERGROUP_TRANSLUCENT)
										plyrag.clothes1:SetParent(plyrag)
										plyrag.clothes1:AddEffects(EF_BONEMERGE)
										if IsValid(ent.ponydata.clothes1) then
											for I=1,14 do
												PPM.setBodygroupSafe(plyrag.clothes1,I,ent.ponydata.clothes1:GetBodygroup(I))
											end
										end
										plyrag:CallOnRemove("clothing del",function()
											plyrag.clothes1:Remove()
										end)
									end
								end
							else
								PPM.PrePonyDraw(plyrag,true)
								plyrag:DrawModel()
							end
						end
					else
						if ent.ponydata==nil then PPM.setupPony(ent) end
						if ent.ponydata.clothes1==nil or ent.ponydata.clothes1==NULL then
							ent.ponydata.clothes1=ent:GetNWEntity("pny_clothing")
						end
					end
				end
			end
		end
	end)
	hook.Add("PrePlayerDraw","pony_draw",function(PLY)
		--PLY:SetRenderMode(RENDERMODE_NORMAL ) 
		--if !PPM.isValidPonyLight(PLY) then 
		--local cne=PLY.ponydata.clothes1:GetNWEntity("pny_clothing")
		--if(IsValid(cne)) then
		--	PLY.ponydata.clothes1=cne
		--MsgN("OK")
		--else
		--PPM.SendCharToServer(PLY)
		--MsgN("RESET")
		--end
		if PLY.ponydata!=nil then
			if PLY.ponydata.clothes1!=nil then
				if IsValid(PLY.ponydata.clothes1) then
					PLY.ponydata.clothes1:SetNoDraw(not PLY:Alive())
				end
			end
		end

		PPM.PrePonyDraw(PLY,false)
		--end
		if not PLY:Alive()then
			return false
		end
	end)
	
	hook.Add("PostPlayerDraw","pony_postdraw",function(PLY)
		if PLY==nil then return end
		if not IsValid(PLY) then return end

		--local clothes=PLY:GetNWEntity("pny_clothing")
		--MsgN(clothes)
		if (PPM.isLoaded) then
			if not PPM.isValidPonyLight(PLY) then return end
			if PPM.m_hair1==nil then return end
			PPM.m_hair1:SetVector("$color2",Vector(0,0,0))
			PPM.m_hair2:SetVector("$color2",Vector(0,0,0))
			PPM.m_body:SetVector("$color2",Vector(1,1,1))
			PPM.m_wings:SetVector("$color2",Vector(1,1,1))
			PPM.m_horn:SetVector("$color2",Vector(1,1,1))
			PPM.m_eyel:SetFloat("$ParallaxStrength",0.1)
			PPM.m_eyer:SetFloat("$ParallaxStrength",0.1)
			PPM.m_eyel:SetTexture("$Iris",PPM.t_eyes[1][1]:GetTexture("$basetexture"))
			PPM.m_eyer:SetTexture("$Iris",PPM.t_eyes[1][1]:GetTexture("$detail"))
			--PPM.m_eyer:SetTexture("$Iris",PPM.t_eyes[1][2])
			PPM.m_cmark:SetTexture("$basetexture",PPM.m_cmarks[1][2]:GetTexture("$basetexture"))
			PPM.m_body:SetTexture("$basetexture",PPM.m_bodyf:GetTexture("$basetexture"))
		end
	end)
	hook.Add("OnReloaded","pony_reload",function() 
	end)
	CreateClientConVar("ppm_oldeyes","0",true,false)
end