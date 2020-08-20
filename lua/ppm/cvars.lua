local FCVAR_ARCHIVE_REPLICATED=FCVAR_REPLICATED
if SERVER then
	FCVAR_ARCHIVE_REPLICATED=bit.bor(FCVAR_REPLICATED,FCVAR_ARCHIVE)
end
CreateConVar("ppm_height_min","-1",FCVAR_ARCHIVE_REPLICATED,"minimum for leg and neck scaling",-4,0)
CreateConVar("ppm_height_max","3",FCVAR_ARCHIVE_REPLICATED,"maximum for leg and neck scaling",0,7)
