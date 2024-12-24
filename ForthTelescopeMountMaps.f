\ write the mount properties to the FITS map
NEED forth-map

: add-mountFITS ( map --)
\ add key value pairs for FITS observation parameters
	>R
	s"   "							R@ =>" #MOUNT"			\ a header to indicate the source of these FITS values
	mount_equatorial 
	swap ~FITS$						R@ =>" OBJCTRA"
	~FITS$							R@ =>" OBJCTDEC"
	mount_horizon swap
	swap ~FITS$						R@ =>" OBJCTALT"
	~FITS$							R@ =>" OBJCTAZ"	
	s"  "								R@ =>" OBJCTHA"
	mount_location
	rot ~FITS$						R@ =>" SITELAT"
	swap ~FITS$						R@ =>" SITELONG"	
	(.)								R@ =>" SITEELEV"
	10u.MountModel  1-			R@ =>" MOUNT"
	10u.SerialNumber 1-			R@ =>" MOUNTSN"
	10u.MountPierSide 1-			R@ =>" PIERSIDE"	
	10u.ModelAlignmentInfo drop 18 + 7 >float
	IF	fp~ ~FITS$ 					R@ =>" POLARERR" THEN
	R> drop
;

\ OBJCTALT – nominal altitude of center of image            
\ OBJCTAZ – nominal azimuth of center of image
\ OBJCTDEC – Declination of object being imaged, string format DD MM SS, if available. Note: this is an approximate field center value only.
\ OBJCTHA – nominal hour angle of center of image
\ OBJCTRA – Right Ascension of object being imaged, string format HH MM SS, if available. Note: this is an approximate field center value only.
\ SITELAT – latitude of the imaging site in degrees, if available. Uses the same format as OBJECTDEC.
\ SITELONG – longitude of the imaging site in degrees, if available. Uses the same format as OBJECTDEC.
\ PIERSIDE – indicates side-of-pier status when connected to a German Equatorial mount.

\ FITS keywords defined here for the ASI camera
\ =============================================
\ MOUNT		- mount name and model
\ MOUNTSN	- mount serial number
\ PALARERR	- polar alignment error as deg mm ss