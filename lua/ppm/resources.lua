function PPM.loadResources()
	hook.Run("PPM.PreLoadResources")
	PPM.m_body = Material"models/ppm/base/body"
	PPM.m_bodyf = Material"models/ppm/base/bodyf"
	PPM.m_bodym = Material"models/ppm/base/bodym"
	PPM.m_wings = Material"models/ppm/base/wings"
	PPM.m_horn = Material"models/ppm/base/horn"
	PPM.m_cmark = Material"models/ppm/base/cmark"
	PPM.m_hair1 = Material"models/ppm/base/hair_color_1"
	PPM.m_hair2 = Material"models/ppm/base/hair_color_2"
	PPM.m_tail1 = Material"models/ppm/base/tail_color_1"
	PPM.m_tail2 = Material"models/ppm/base/tail_color_2"
	PPM.m_eyel = Material"models/ppm/base/eye_l"
	PPM.m_eyer = Material"models/ppm/base/eye_r"
	PPM.t_eyes = {
		{Material"models/ppm/base/face/tc00","Gray","models/ppm/base/face/tc00" },
		{Material"models/ppm/base/face/tc01","Turquoise","models/ppm/base/face/tc01" },
		{Material"models/ppm/base/face/tc02","Yellow","models/ppm/base/face/tc02" },
		{Material"models/ppm/base/face/tc03","Red","models/ppm/base/face/tc03" },
		{Material"models/ppm/base/face/tc04","Blue","models/ppm/base/face/tc04" },
		{Material"models/ppm/base/face/tc05","Purple","models/ppm/base/face/tc05" },
		{Material"models/ppm/base/face/tc06","Slate Blue","models/ppm/base/face/tc06" },
		{Material"models/ppm/base/face/tc07","Green","models/ppm/base/face/tc07" },
		{Material"models/ppm/base/face/tc08","Gold","models/ppm/base/face/tc08" },
		{Material"models/ppm/base/face/tc09","Orange","models/ppm/base/face/tc09" }
	}
	PPM.m_cmarks = { 
		{"models/ppm/cmarks/8ball.vtf"},
		{"models/ppm/cmarks/dice.vtf"},
		{"models/ppm/cmarks/magichat.vtf"},
		{"models/ppm/cmarks/magichat02.vtf"},
		{"models/ppm/cmarks/record.vtf"},
		{"models/ppm/cmarks/microphone.vtf"},
		{"models/ppm/cmarks/bits.vtf"},
		{"models/ppm/cmarks/checkered.vtf"},
		{"models/ppm/cmarks/lumps.vtf"},
		{"models/ppm/cmarks/mirror.vtf"},
		{"models/ppm/cmarks/camera.vtf"},
		{"models/ppm/cmarks/magnifier.vtf"},
		{"models/ppm/cmarks/padlock.vtf"},
		{"models/ppm/cmarks/binaryfile.vtf"},
		{"models/ppm/cmarks/floppydisk.vtf"},
		{"models/ppm/cmarks/cube.vtf"},
		{"models/ppm/cmarks/bulb.vtf"},
		{"models/ppm/cmarks/battery.vtf"},
		{"models/ppm/cmarks/deskfan.vtf"},
		{"models/ppm/cmarks/flames.vtf"},
		{"models/ppm/cmarks/alarm.vtf"},
		{"models/ppm/cmarks/myon.vtf"},
		{"models/ppm/cmarks/beer.vtf"},
		{"models/ppm/cmarks/berryglass.vtf"},
		{"models/ppm/cmarks/roadsign.vtf"},
		{"models/ppm/cmarks/greentree.vtf"},
		{"models/ppm/cmarks/seasons.vtf"},
		{"models/ppm/cmarks/palette.vtf"},
		{"models/ppm/cmarks/palette02.vtf"},
		{"models/ppm/cmarks/palette03.vtf"},
		{"models/ppm/cmarks/lightningstone.vtf"},
		{"models/ppm/cmarks/partiallycloudy.vtf"},
		{"models/ppm/cmarks/thunderstorm.vtf"},
		{"models/ppm/cmarks/storm.vtf"},
		{"models/ppm/cmarks/stoppedwatch.vtf"},
		{"models/ppm/cmarks/twistedclock.vtf"},
		{"models/ppm/cmarks/surfboard.vtf"},
		{"models/ppm/cmarks/surfboard02.vtf"},
		{"models/ppm/cmarks/star.vtf"},
		{"models/ppm/cmarks/ussr.vtf"},
		{"models/ppm/cmarks/vault.vtf"},
		{"models/ppm/cmarks/anarchy.vtf"},
		{"models/ppm/cmarks/suit.vtf"},
		{"models/ppm/cmarks/deathscythe.vtf"},
		{"models/ppm/cmarks/shoop.vtf"},
		{"models/ppm/cmarks/smiley.vtf"},
		{"models/ppm/cmarks/dawsome.vtf"},
		{"models/ppm/cmarks/weegee.vtf"},
	}
	-- Procedurally generate the material objects from their paths
	for i,t in ipairs(PPM.m_cmarks) do
		PPM.m_cmarks[i][2] = Material(t[1])
	end
	PPM.m_bodyt0 = {
		Material"models/ppm/texclothes/clothes_wbs_light.png",
		Material"models/ppm/texclothes/clothes_wbs_full.png",
		Material"models/ppm/texclothes/clothes_sbs_full.png",
		Material"models/ppm/texclothes/clothes_sbs_light.png",
		Material"models/ppm/texclothes/clothes_royalguard.png",
	}
	PPM.m_bodyt0[6] = PPM.m_bodyt0[5] -- Done to prevent bizarre memory bug in GMOD itself...
	PPM.m_eyes={
		Material"models/ppm/partrender/eye_oval.png",
		Material"models/ppm/partrender/eye_oval_aperture.png",
	}
	PPM.m_eye_grads={
		Material"models/ppm/partrender/eye_grad.png",
		Material"models/ppm/partrender/eye_grad_aperture.png",
	}
	PPM.m_eye_reflections={
		Material"models/ppm/partrender/eye_reflection.png",
		Material"models/ppm/partrender/eye_reflection_crystal_unisex.png",
		Material"models/ppm/partrender/eye_reflection_foal.png",
		Material"models/ppm/partrender/eye_reflection_male.png",
	}
	PPM.m_bodydetails = {
		{Material"models/ppm/partrender/body_leggrad1.png","Leg grad"},
		{Material"models/ppm/partrender/body_lines1.png","Lines"},
		{Material"models/ppm/partrender/body_stripes1.png","Stripes"},
		{Material"models/ppm/partrender/body_headstripes1.png","Head stripes"},
		{Material"models/ppm/partrender/body_freckles.png","Freckles"},
		{Material"models/ppm/partrender/body_hooves1.png","Hooves big"},
		{Material"models/ppm/partrender/body_hooves2.png","Hooves small"}, 
		{Material"models/ppm/partrender/body_headmask1.png","Head layer"},
		{Material"models/ppm/partrender/body_hooves1_crit.png","Hooves big rnd"},
		{Material"models/ppm/partrender/body_hooves2_crit.png","Hooves small rnd"},
		{Material"models/ppm/partrender/body_spots1.png","Spots 1"},
		{Material"models/ppm/partrender/body_headmask2.png","Head gradient1"},
		{Material"models/ppm/partrender/body_headmask3.png","Head gradient2"},
		{Material"models/ppm/partrender/pony_socks1.png","Socks 1"},
		{Material"models/ppm/partrender/pony_socks1b.png","Socks 1 Back"},
		{Material"models/ppm/partrender/pony_socks1bl.png","Socks 1 Back Left"},
		{Material"models/ppm/partrender/pony_socks1br.png","Socks 1 Back Right"},
		{Material"models/ppm/partrender/pony_socks1f.png","Socks 1 Front"},
		{Material"models/ppm/partrender/pony_socks1b.png","Socks 1 Front Left"},
		{Material"models/ppm/partrender/pony_socks1b.png","Socks 1 Front Right"},
		{Material"models/ppm/partrender/pony_socks2.png","Socks 2"},
		{Material"models/ppm/partrender/pony_socks2b.png","Socks 2 Back"},
		{Material"models/ppm/partrender/pony_socks2bl.png","Socks 2 Back Left"},
		{Material"models/ppm/partrender/pony_socks2br.png","Socks 2 Back Right"},
		{Material"models/ppm/partrender/pony_socks2f.png","Socks 2 Front"},
		{Material"models/ppm/partrender/pony_socks2fl.png","Socks 2 Front Left"},
		{Material"models/ppm/partrender/pony_socks2fr.png","Socks 2 Front Right"},
		{Material"models/ppm/partrender/pony_sockss.png","Socks Solid"},
		{Material"models/ppm/partrender/pony_sockssb.png","Socks Solid Back"},
		{Material"models/ppm/partrender/pony_sockssbl.png","Socks Solid Back Left"},
		{Material"models/ppm/partrender/pony_sockssbr.png","Socks Solid Back Right"},
		{Material"models/ppm/partrender/pony_sockssf.png","Socks Solid Front"},
		{Material"models/ppm/partrender/pony_sockssfl.png","Socks Solid Front Left"},
		{Material"models/ppm/partrender/pony_sockssfr.png","Socks Solid Front Right"},
		{Material"models/ppm/partrender/fs_reye1.png","right_eye_scar_1"},
		{Material"models/ppm/partrender/fs_reye2.png","right_eye_scar_2"},
		{Material"models/ppm/partrender/fs_reye3.png","right_eye_scar_3"},
		{Material"models/ppm/partrender/fs_leye1.png","left_eye_scar_1"},
		{Material"models/ppm/partrender/fs_leye2.png","left_eye_scar_2"},
		{Material"models/ppm/partrender/fs_leye3.png","left_eye_scar_3"},
		{Material"models/ppm/partrender/dash-e.png","dash-e"},
		{Material"models/ppm/partrender/body_scar.png","body_scar"},
		{Material"models/ppm/partrender/body_robotic.png","robotic"},
		{Material"models/ppm/partrender/suit_full_base.png","suit full base"},
		{Material"models/ppm/partrender/suit_full_mask.png","suit full mask"},
		{Material"models/ppm/partrender/suit_full_sb_pattern.png","suit full sb pattern"},
		{Material"models/ppm/partrender/suit_full_mask.png","suit full trim"},
		{Material"models/ppm/partrender/suit_light_base.png","suit light base"},
		{Material"models/ppm/partrender/suit_light_sb_pattern.png","suit light sb pattern"},
		{Material"models/ppm/partrender/suit_light_trim.png","suit light trim"},
		{Material"models/ppm/partrender/suit_thunder_1.png","suit thunder 1"},
		{Material"models/ppm/partrender/suit_thunder_2.png","suit thunder 2"},
		{Material"models/ppm/partrender/suit_thunder_3.png","suit thunder 3"},
		{Material"models/ppm/partrender/suit_thunder_4.png","suit thunder 4"},
		{Material"models/ppm/partrender/suit_thunder_5.png","suit thunder 5"},
		{Material"models/ppm/partrender/suit_thunder_6.png","suit thunder 6"},
		{Material"models/ppm/partrender/xperiment.png","Experiment1"},
		{Material"models/ppm/partrender/xperiment.png","Experiment2"},
		{Material"models/ppm/partrender/xperiment.png","Experiment3"},
		{Material"models/ppm/partrender/xperiment.png","Experiment4"},
	}
	hook.Run("PPM.PreValidateResources")
	for key,bool in SortedPairs{
		m_eye_grads=true,
		m_eye_reflections=true,
		m_eyes=true,
	}do
		hook.Run("PPM.PreValidateResource",key)
		for k,v in ipairs(PPM[key])do
			if type(v)!="IMaterial"then
				timer.Simple(0,function()
					table.remove(PPM[key],k)
				end)
			elseif v:IsError() then
				PPM[key][k]=PPM[key][1]
			end
		end
		hook.Run("PPM.PostValidateResource",key)
	end
	hook.Run("PPM.PreValidateResource","m_bodydetails")
	for k,v in ipairs(PPM.m_bodydetails)do
		if type(v[1])!="IMaterial"then
			timer.Simple(0,function()
				table.remove(PPM.m_bodydetails,k)
			end)
		elseif v[1]:IsError() then
			PPM.m_bodydetails[k][1]=nil
		end
	end
	hook.Run("PPM.PostValidateResource","m_bodydetails")

	hook.Run("PPM.PostValidateResources")
	PPM.Pony_variables.default_pony.cmark.max=#PPM.m_cmarks
	PPM.Pony_variables.default_pony.eye_reflect_type_r.max=#PPM.m_eyes
	PPM.Pony_variables.default_pony.eye_reflect_type.max=#PPM.m_eyes
	PPM.Pony_variables.default_pony.eye_reflect_type_r.max=#PPM.m_eye_reflections
	PPM.Pony_variables.default_pony.eye_reflect_type.max=#PPM.m_eye_reflections
	hook.Run("PPM.PostLoadResources")
end
if SERVER then
	PPM.loadResources()
end
