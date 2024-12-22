: add-mount ( --)
	10u.connect
	10u.HighPrecisionOn
	10u.DualAxisTrackingOn
	10u.WeatherUpdatesOn
	10u.UnattendedFlipOn
	10u.TrackSiderealRate
;

: remove-mount ( --)
	10u.Park
;

: mount_busy ( -- flag)
	10u.Status	( caddr u)
	>number CASE
	 0 OF 0 ENDOF
	 1 OF 0 ENDOF
	 2 OF -1 ENDOF
	 3 OF -1 ENDOF
	 4 OF -1 ENDOF
	 5 OF 0 ENDOF
	 6 OF -1 ENDOF
	 7 OF 0 ENDOF
	 8 OF -1 ENDOF
	 9 OF 0 ENDOF
   10 OF 0 ENDOF
   11 OF -1 ENDOF
   -1 SWAP ENDCASE	
;

: wait-mount ( -- flag)
\ synchronous hold until the mount stops slewing
	begin
		mount_busy
	while
		." . " 250 ms
	repeat
;

: mount_equatorial ( -- RA DEC)
\ return the mount RA and DEC in single integer finite fraction format
	10u.MountRA >number~
	10u.MountDEC >number~
;

: ->mount_equatorial ( RA DEC --)
\ slew to RA DEC provied in single integer finite fraction format and start tracking
	~DEC$ 10u.SetTargetDec 10um.?abort
	~RA$ 10u.SetTargetRA 10um.?abort
	10u.UnPark
	10u.SlewToEquatorialTarget ( caddr u)
	over c@ '0' == IF 2drop wait-mount EXIT THEN		\ '0' is the no-error condition
	type CR abort
;
	
: mount_horizon ( -- ALT AZ)
\ return the mount Alt and Az in single integer finite fraction format
	10u.MountALT >number~
	10u.MountAZ >number~
;

: ->mount_horizon ( ALT AZ --)
\ slew to ALT AZ provied in single integer finite fraction format with no tracking
	~AZ$ 10u.SetTargetAz 10um.?abort
	~ALT$ 10u.SetTargetAlt 10um.?abort
	10u.UnPark
	10u.SlewToHorizonTarget ( caddr u)
	over c@ '0' == IF 2drop wait-mount EXIT THEN		\ '0' is the no-error condition
	type CR abort
;

: mount_location ( -- LOG LAT ELEV)
\ return the site LAT and LONG in single integer finite fraction format
\ return the ELEV as an integer
	10u.SiteLongitude >number~
	10u.SiteLatitude >number~
	10u.SiteElevation >number \ an integer 
;	

: stop-mount ( --)
	10u.Stop
;

: mount_name ( -- caddr u)
\ return the name of the mount
	10u.MountModel 1-
;

: mount_SN ( -- caddr u)
\ return the S/N of the mount as a string
	10u.SerialNumber 1-
;

\ convenience functions

: what-mount? ( --)
\ report the current mount to the user
\ WheelID Name SerialNo Slots
	CR ." Name" 	mount_name tab tab type
	CR ." S/N"		mount_SN tab tab type
	CR CR
;