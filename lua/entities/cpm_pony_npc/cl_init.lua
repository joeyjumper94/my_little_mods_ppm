
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

/*---------------------------------------------------------
	Name: Draw
	Desc: Draw it!
---------------------------------------------------------*/
function ENT.Draw(ent)
	if !PPM.rendertargettasks then
		return
	end
	local pony=PPM.getPonyValues(ent, false)

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
	PPM.PrePonyDraw(ent,false)
	ent:DrawModel()
end

/*---------------------------------------------------------
	Name: DrawTranslucent
	Desc: Draw translucent
---------------------------------------------------------*/
function ENT.DrawTranslucent(ent)
	if !PPM.rendertargettasks then
		return
	end
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
	PPM.PrePonyDraw(ent,true)
	ent:Draw()
end

/*---------------------------------------------------------
   Name: BuildBonePositions
   Desc: 
---------------------------------------------------------*/
function ENT:BuildBonePositions( NumBones, NumPhysBones )

end



/*---------------------------------------------------------
   Name: SetRagdollBones
   Desc: 
---------------------------------------------------------*/
function ENT:SetRagdollBones( bIn )


	self.m_bRagdollSetup = bIn

end


/*---------------------------------------------------------
   Name: DoRagdollBone
   Desc: 
---------------------------------------------------------*/
function ENT:DoRagdollBone( PhysBoneNum, BoneNum )

	// self:SetBonePosition( BoneNum, Pos, Angle )

end