PPM.Pony_variables=PPM.Pony_variables or {}

PPM.Pony_variables.default_pony={
	--main
	kind={default=4,min=1,max=4},
	age={default=2,min=2,max=2},
	gender={default=1,min=1,max=2},
	body_type={default=1,min=1,max=1},
	
	--body
	_cmark={default=nil},
	_cmark_loaded={default=false},
	mane={default=1,min=1,max=16},
	manel={default=1,min=1,max=13},
	tail={default=1,min=1,max=15},
	tailsize={default=1,min=.65,max=1.5},
	manesize={default=1,min=.65,max=1.5},
	hairsize={default=1,min=.65,max=1.5},

	cmark_enabled={default=2,min=1,max=2},
	cmark={default=1,min=1,max=nil},
	custom_mark={default=nil},
	bodyweight={default=1,min=0.8,max=1.2},
	
	clothes={default="1_3_5_59_61_7_63_65_47"},--clothes data here

	--coat and horn
	coatcolor={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	coatphongexponent={default=.5,min=0,max=255},
	coatphongboost={default=.6,min=0,max=255},
	horncolor={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	hornphongexponent={default=.1,min=0,max=255},
	hornphongboost={default=.1,min=0,max=255},
	wingcolor={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	wingphongexponent={default=6,min=0,max=255},
	wingphongboost={default=.05,min=0,max=255},

	--upper mane
	haircolor1={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor2={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor3={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor4={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor5={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor6={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	hairphongexponent={default=6,min=0,max=255},
	hairphongboost={default=1,min=0,max=255},

	--lower mane
	manecolor1={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor2={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor3={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor4={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor5={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor6={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manephongexponent={default=6,min=0,max=255},
	manephongboost={default=1,min=0,max=255},

	--tail
	tailcolor1={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor2={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor3={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor4={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor5={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor6={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailphongexponent={default=6,min=0,max=255},
	tailphongboost={default=.5,min=0,max=255},

	--bodydetails
	bodydetail1={default=1,min=1},
	bodydetail2={default=1,min=1},
	bodydetail3={default=1,min=1},
	bodydetail4={default=1,min=1},
	bodydetail5={default=1,min=1},
	bodydetail6={default=1,min=1},
	bodydetail7={default=1,min=1},
	bodydetail8={default=1,min=1},
	
	bodydetail1_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail2_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail3_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail4_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail5_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail6_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail7_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	bodydetail8_c={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},

	eyelash={default=1,min=1,max=6},--eyelash bodygroup
	--left eye
	eyehaslines={default=1},
	eyeirissize={default=0.7,min=0.2,max=2},
	eyeholesize={default=0.7,min=0.3,max=1},
	eyejholerssize={default=1,min=0.2,max=1},
	eyecolor_bg={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_iris={default=Vector(1,1,1)/3,min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_grad={default=Vector(.5,.5,.5),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_line1={default=Vector(.8,.8,.8),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_line2={default=Vector(.9,.9,.9),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_hole={default=Vector(0,0,0),min=Vector(0,0,0),max=Vector(1,1,1)},

	eye_type={default=1,min=1,max=2},
	eye_reflect_type={default=1,min=1,max=4},
	eye_reflect_color={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	eye_reflect_alpha={default=1,min=0,max=1},
	eye_effect_color={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	eye_effect_alpha={default=1,min=0,max=1},

	--right eye
	eyehaslines_r={default=1},
	eyeirissize_r={default=0.7,min=0.2,max=2},
	eyeholesize_r={default=0.7,min=0.3,max=1},
	eyejholerssize_r={default=1,min=0.2,max=1},
	eyecolor_bg_r={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_iris_r={default=Vector(1,1,1)/3,min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_grad_r={default=Vector(.5,.5,.5),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_line1_r={default=Vector(.8,.8,.8),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_line2_r={default=Vector(.9,.9,.9),min=Vector(0,0,0),max=Vector(1,1,1)},
	eyecolor_hole_r={default=Vector(0,0,0),min=Vector(0,0,0),max=Vector(1,1,1)},

	eye_type_r={default=1,min=1,max=2},
	eye_reflect_type_r={default=1,min=1,max=4},
	eye_reflect_color_r={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	eye_reflect_alpha_r={default=1,min=0,max=1},
	eye_effect_color_r={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	eye_effect_alpha_r={default=1,min=0,max=1},
	--body clothing
	bodyt0={default=1,min=1},
	--bodyt1={default=1},
	--bodyt2={default=1},
}
