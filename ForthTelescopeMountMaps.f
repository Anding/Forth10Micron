\ write the mount properties to the FITS map
NEED forth-map

: add-mount-positionFITS { RA Dec map -- }
\ Write one captured J2000 coordinate pair together with the remaining live
\ mount state.  Callers which also classify the sky can reuse the same pair.
	s"   "                          map =>" #MOUNT"			\ a header to indicate the source of these FITS values
	RA ~FITS$                       map =>" OBJCTRA"
	Dec ~FITS$                      map =>" OBJCTDEC"
	RA ~fp 15e0 f* 4 (f.)           map =>" RA"
	Dec ~fp 4 (f.)                  map =>" Dec"
	mount_horizon swap
	~FITS$                          map =>" OBJCTALT"
	~FITS$                          map =>" OBJCTAZ"
	mount_horizon swap
	~fp 4 (f.)                      map =>" CENTALT"
	~fp 4 (f.)                      map =>" CENTAZ"
	mount_siderealTime ~FITS$       map =>" SIDEREAL"
	mount_hourAngle ~FITS$          map =>" OBJCTHA"
	10u.LocalTime 	
	>number~ ~FITS$                 map =>" MNTLOCT"
	mount_location
	rot ~FITS$                      map =>" SITELAT"
	swap ~FITS$                     map =>" SITELONG"
	(.)                             map =>" SITEELEV"
	mount_pierside                  map =>" PIERSIDE"
	10u.DualAxisTrackingMode 
	10u.OnOff?                      map =>" DUALAXIS"
	10u.TrackingMode	
	10u.OnOff?                      map =>" TRACKING"
	10u.RefractionCorrectionMode
	10u.OnOff?                      map =>" REFRACTN"
	10u.SpeedCorrectionMode
	10u.OnOff?                      map =>" SPDCORCT"
	10u.UnattendedFlipMode
	10u.OnOff?                      map =>" UNATFLIP"
	mount_timeToTrackingEnd
	~FITS$                          map =>" TRACKEND"
	10u.MeridianTrackingLimit
	10u.>num (.)                    map =>" TRKLIMIT"
	10u.MeridianSlewLimit
	10u.>num (.)                    map =>" SLWLIMIT"
	10u.AlignmentStarCount 1-       map =>" ALGNSTRS"
	mount_alignment	
	10u.PolarError                  map =>" POLARERR"
	10u.OrthoError                  map =>" ORTHOERR"
	mount_status                    map =>" STATUS"
	mount_SN                        map =>" MOUNTSN"
;

: add-mountFITS { map | RA Dec -- }
\ Compatibility entry point for callers which do not already have a position.
	mount_equatorial to Dec to RA
	RA Dec map add-mount-positionFITS
;
