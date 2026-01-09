\ write the mount properties to the FITS map
NEED forth-map

: add-mountFITS ( map --)
\ add key value pairs for FITS observation parameters
	>R
	s"   "                          R@ =>" #MOUNT"			\ a header to indicate the source of these FITS values
	mount_equatorial swap
	~FITS$                          R@ =>" OBJCTRA"
	~FITS$                          R@ =>" OBJCTDEC"
	mount_equatorial swap
	~fp 15e0 f* 4 (f.)              R@ =>" RA"
	~fp 4 (f.)                      R@ =>" Dec"	
	mount_horizon swap
	~FITS$                          R@ =>" OBJCTALT"
	~FITS$                          R@ =>" OBJCTAZ"	
	mount_horizon swap
	~fp 4 (f.)                      R@ =>" CENTALT"
	~fp 4 (f.)                      R@ =>" CENTAZ"	
	mount_hourAngle ~FITS$          R@ =>" OBJCTHA"
	mount_siderealTime ~FITS$       R@ =>" SIDEREAL"
	10u.LocalTime 	
	>number~ ~FITS$                 R@ =>" MNTLOCT"		
	mount_location
	rot ~FITS$                      R@ =>" SITELAT"
	swap ~FITS$                     R@ =>" SITELONG"
	(.)                             R@ =>" SITEELEV"
	mount_pierside                  R@ =>" PIERSIDE"	
	target_pierside                 R@ =>" TGTPSIDE"	
	10u.DualAxisTrackingMode 
	10u.OnOff?                      R@ =>" DUALAXIS"	
	10u.TrackingMode	
	10u.OnOff?                      R@ =>" TRACKING"
	10u.RefractionCorrectionMode
	10u.OnOff?                      R@ =>" REFRACTN"
	10u.SpeedCorrectionMode
	10u.OnOff?                      R@ =>" SPDCORCT"
	10u.UnattendedFlipMode
	10u.OnOff?                      R@ =>" UNATFLIP"
	mount_timeToTrackingEnd
	~FITS$                          R@ =>" TRACKEND"
	10u.MeridianTrackingLimit
	10u.>num (.)                    R@ =>" TRKLIMIT"
	10u.MeridianSlewLimit
	10u.>num (.)                    R@ =>" SLWLIMIT"
	10u.AlignmentStarCount 1-       R@ =>" ALGNSTRS"	
	10u.ModelAlignmentInfo drop 18 + 7 >float
	IF	fp~ ~FITS$                  R@ =>" POLARERR" THEN	
	mount_status                    R@ =>" STATUS"
	mount_SN                        R@ =>" MOUNTSN"
	R> drop
;
