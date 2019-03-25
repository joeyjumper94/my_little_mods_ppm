PPM.Editor3_ponies = PPM.Editor3_ponies or {}

PPM.Editor3_ponies = {
	pony = {
		node_main = "node_main",
		node_body = "pony_normal_body",
		node_face = "pony_normal_face",
		node_equipment = "pony_equipment",
		node_presets = "node_presets"
	},
	ponynj = {
		node_main = "node_main",
		node_body = "pony_normal_body",
		node_face = "pony_normal_face",
		node_equipment = "pony_equipment",
		node_presets = "node_presets"
	}
}

PPM.Editor3_nodes = PPM.Editor3_nodes or {}

PPM.Editor3_nodes.node_main = {
	name = "OMG !ROOT NODE!",
	controlls = {
		{
			name = "Type",
			type = "edit_type",
			param = "kind",
			special = "maintype",
			choises = {"Earth","Pegasus","Unicorn","Alicorn"}
		},
		--<-- age here
		{
			name = "Gender",
			type = "edit_type",
			param = "gender",
			special = "maintype",
			choises = {"Female","Male"}
		}
	}
}

PPM.Editor3_nodes.node_presets = {
	name = "OMG !ROOT NODE!",
	controlls = {
		{
			name = "Type",
			type = "menu_save_load"
		}
	}
}

PPM.Editor3_nodes.pony_equipment = {
	name = "Equipment",
	controlls = {
		{
			name = "Head",
			type = "edit_equipment_slot",
			slotid = 0
		},
		{
			name = "Eyes",
			type = "edit_equipment_slot",
			slotid = 7
		},
		{
			name = "Neck",
			type = "edit_equipment_slot",
			slotid = 1
		},
		{
			name = "Front body",
			type = "edit_equipment_slot",
			slotid = 2
		},
		{
			name = "Front legs",
			type = "edit_equipment_slot",
			slotid = 3
		},
		{
			name = "Front hooves",
			type = "edit_equipment_slot",
			slotid = 5
		},
		{
			name = "Uniform",
			type = "edit_equipment_slot",
			slotid = 50
		},
		{
			name = "Back body",
			type = "edit_equipment_slot",
			slotid = 9
		},
		{
			name = "Hind legs",
			type = "edit_equipment_slot",
			slotid = 10
		},
		{
			name = "Hind hooves",
			type = "edit_equipment_slot",
			slotid = 12
		}
	}
}

PPM.Editor3_nodes.pony_normal_face = {
	eyelashes = {
		name = "Eyelashes",
		pos = Vector(15,8,45),
		controlls = {
			{
				name = "Type",
				type = "edit_type",
				param = "eyelash",
				choises = {"Default","Double","Coy","Full","Mess","None"}
			}
		}
	},
	eyes = {
		name = "Left Eye",
		pos = Vector(15,5,40),
		controlls = {
/*			{
				name = "View",
				type = "view_eye" 
			},*/
			{
				name = "Back color",
				type = "edit_color",
				param = "eyecolor_bg"
			},
			{
				name = "Iris size",
				type = "edit_number",
				param = "eyeirissize",
				min = 0.2,
				max = 2
			},
			{
				name = "Iris color",
				type = "edit_color",
				param = "eyecolor_iris"
			},
			{
				name = "Iris color 2",
				type = "edit_color",
				param = "eyecolor_grad"
			},
			{
				name = "No lines",
				type = "edit_bool",
				param = "eyehaslines",
				onvalue = 2,
				offvalue = 1
			},
			{
				name = "Line 1 color",
				type = "edit_color",
				param = "eyecolor_line1"
			},
			{
				name = "Line 2 color",
				type = "edit_color",
				param = "eyecolor_line2"
			},
			{
				name = "Pupil size",
				type = "edit_number",
				param = "eyeholesize",
				min = 0.3,
				max = 1
			},
			{
				name = "Pupil width",
				type = "edit_number",
				param = "eyejholerssize",
				min = 0.2,
				max = 1
			},
			{
				name = "Pupil color",
				type = "edit_color",
				param = "eyecolor_hole"
			}
		}
	},
	right_eye = {
		name = "Right Eye",
		pos = Vector(15,-5,40),
		controlls = {
/*			{
				name = "View",
				type = "view_eye_r" 
			},*/
			{
				name = "Back color",
				type = "edit_color",
				param = "eyecolor_bg_r"
			},
			{
				name = "Iris size",
				type = "edit_number",
				param = "eyeirissize_r",
				min = 0.2,
				max = 2
			},
			{
				name = "Iris color",
				type = "edit_color",
				param = "eyecolor_iris_r"
			},
			{
				name = "Iris color 2",
				type = "edit_color",
				param = "eyecolor_grad_r"
			},
			{
				name = "No lines",
				type = "edit_bool",
				param = "eyehaslines_r",
				onvalue = 2,
				offvalue = 1
			},
			{
				name = "Line 1 color",
				type = "edit_color",
				param = "eyecolor_line1_r"
			},
			{
				name = "Line 2 color",
				type = "edit_color",
				param = "eyecolor_line2_r"
			},
			{
				name = "Pupil size",
				type = "edit_number",
				param = "eyeholesize_r",
				min = 0.3,
				max = 1
			},
			{
				name = "Pupil width",
				type = "edit_number",
				param = "eyejholerssize_r",
				min = 0.2,
				max = 1
			},
			{
				name = "Pupil color",
				type = "edit_color",
				param = "eyecolor_hole_r"
			}
		}
	},
}
PPM.Editor3_nodes.pony_normal_body = {
	horn = {
		name = "Horn",
		pos = Vector(22,0,60),
		controlls = {
			{
				name = "horn color",
				type = "edit_color",
				param = "horncolor"
			}
		}
	},
	wings={
		name = "Wings",
		pos = Vector(0,0,30),
		controlls = {
			{
				name = "wing color",
				type = "edit_color",
				param = "wingcolor"
			}
		}
	},
	body = {
		name = "Body",
		pos = Vector(10,0,20),
		controlls = {
			{
				name = "Weight",
				type = "edit_number",
				param = "bodyweight",
				min = 0.8,
				max = 1.2
			},
			{
				name = "Coat color",
				type = "edit_color",
				param = "coatcolor"
			}
		}
	},
	ponymark = {
		name = "Ponymark",
		pos = Vector(-8,6,27),
		controlls = {
			{
				name = "View",
				type = "view_cmark"
			},
			{
				name = "No ponymark",
				type = "edit_bool",
				param = "cmark_enabled",
				onvalue = 2,
				offvalue = 1
			},
			{
				name = "Ponymark",
				type = "edit_cmark"
			},
			{
				name = "Select custom ponymark",
				type = "select_custom_cmark"
			},
			{
				name = "Ponymark",
				type = "edit_type",
				param = "cmark",
				choises = {
					"8ball","dice","magichat",
					"magichat02","record","microphone",
					"bits","checkered","lumps",
					"mirror","camera","magnifier",
					"padlock","binaryfile","floppydisk",
					"cube","bulb","battery",
					"deskfan","flames","alarm",
					"myon","beer","berryglass",
					"roadsign","greentree","seasons",
					"palette","palette02","palette03",
					"lightningstone","partiallycloudy","thunderstorm",
					"storm","stoppedwatch","twistedclock",
					"surfboard","surfboard02","star",
					"ussr","vault","anarchy",
					"suit","deathscythe","shoop",
					"smiley","dawsome","weegee"
				}
			}
		}
	},
	tail = {
		name = "Tail",
		pos = Vector(-22,0,34),
		controlls =
		{
			{
				name = "Tail",
				type = "edit_type",
				param = "tail",
				choises = {
					"MAILCALL","FLOOFEH","ADVENTUROUS","SHOWBOAT","ASSERTIVE",
					"BOLD","STUMPY","SPEEDSTER","EDGY","RADICAL",
					"BOOKWORM","BUMPKIN","POOFEH","CURLY","NONE"
				}
			},
			{
				name = "Tail size",
				type = "edit_number",
				param = "tailsize",
				min = 0.8,
				max = 1.1
			},
			{
				name = "Color 1",
				type = "edit_color",
				param = "tailcolor1"
			},
			{
				name = "Color 2",
				type = "edit_color",
				param = "tailcolor2"
			},
			{
				name = "Color 3",
				type = "edit_color",
				param = "tailcolor3"
			},
			{
				name = "Color 4",
				type = "edit_color",
				param = "tailcolor4"
			},
			{
				name = "Color 5",
				type = "edit_color",
				param = "tailcolor5"
			},
			{
				name = "Color 6",
				type = "edit_color",
				param = "tailcolor6"
			}
		}
	},
	uppermane = {
		name = "Uppermane",
		pos = Vector(18,0,55),
		controlls = {
			{
				name = "Mane Upper",
				type = "edit_type",
				param = "mane",
				choises = {
					"MAILCALL","FLOOFEH","ADVENTUROUS","SHOWBOAT","ASSERTIVE",
					"BOLD","STUMPY","SPEEDSTER","RADICAL","SPIKED",
					"BOOKWORM","BUMPKIN","POOFEH","CURLY","INSTRUCTOR","NONE"
				}
			},
			{
				name = "Color 1",
				type = "edit_color",
				param = "haircolor1"
			},
			{
				name = "Color 2",
				type = "edit_color",
				param = "haircolor2"
			},
			{
				name = "Color 3",
				type = "edit_color",
				param = "haircolor3"
			},
			{
				name = "Color 4",
				type = "edit_color",
				param = "haircolor4"
			},
			{
				name = "Color 5",
				type = "edit_color",
				param = "haircolor5"
			},
			{
				name = "Color 6",
				type = "edit_color",
				param = "haircolor6"
			}
		}
	},
	lowermane =	{
		name = "Lowermane",
		pos = Vector(5,0,40),
		controlls = {
			{
				name = "Lower mane",
				type = "edit_type",
				param = "manel",
				choises = {
					"MAILCALL","FLOOFEH","ADVENTUROUS","SHOWBOAT","ASSERTIVE",
					"BOLD","STUMPY","HIPPIE","SPEEDSTER","BOOKWORM",
					"BUMPKIN","CURLY","NONE"
				}
			},
			{
				name = "Color 1",
				type = "edit_color",
				param = "manecolor1"
			},
			{
				name = "Color 2",
				type = "edit_color",
				param = "manecolor2"
			},
			{
				name = "Color 3",
				type = "edit_color",
				param = "manecolor3"
			},
			{
				name = "Color 4",
				type = "edit_color",
				param = "manecolor4"
			},
			{
				name = "Color 5",
				type = "edit_color",
				param = "manecolor5"
			},
			{
				name = "Color 6",
				type = "edit_color",
				param = "manecolor6"
			}
		}
	},

/*
	PPM.Editor3_nodes["face"] = {
		pos = Vector(20,0,43)
	} 
*/
}

timer.Simple(0,function()
	local choises={"NONE",}
	for k,v in ipairs(PPM.m_bodydetails)do
		choises[k+1]=tostring(v[2])
	end
	for i=1,8 do
		local div=math.rad(i*45)
		PPM.Editor3_nodes.pony_normal_body["bdetail"..i]={
			name="B"..i,
			pos=Vector(math.cos(div)*25,math.sin(div)*25,-5),
			controlls={
				{
					name="Detail type",
					type="edit_type",
					param="bodydetail"..i,
					choises=choises,
				},
				{
					name="Color",
					type="edit_color",
					param="bodydetail"..i.."_c",
				}
			}
		}
	end
end)
