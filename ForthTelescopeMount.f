: add-mount ( --)
	flushkeys
	10u.connect
	10u.HighPrecisionOn
	10u.DualAxisTrackingOn 2drop
	10u.WeatherUpdatesOn 2drop
\ 	10u.UnattendedFlipOn
	10u.TrackSiderealRate
;

: remove-mount ( --)
	10u.disconnect
;

: mount_status ( -- caddr u)
	10u.status 10u.>num 10u.statuses
;

: mount_pierside ( -- caddr u)
	10u.MountPierSide 1-
;

: target_pierside ( -- caddr u)
	10u.TargetPierSide 10u.>num
	CASE
		2 OF s" West" ENDOF
		3 OF s" East" ENDOF
		s" n/a" rot
	ENDCASE		
;

: mount_busy ( -- flag)
	10u.status 10u.>num
	CASE
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
		250 ms
	repeat
;

: mount_equatorial ( -- RA DEC)
\ return the mount RA and DEC in single integer finite fraction format
	10u.MountRA >number~
	10u.MountDEC >number~
;

: ->mount_equatorial ( RA DEC --)
\ slew to RA DEC provied in single integer finite fraction format and start tracking
	~DEC$ 10u.SetTargetDec 10u.?abort
	~RA$ 10u.SetTargetRA 10u.?abort
	10u.UnPark
	10u.SlewToEquatorialTarget ( caddr u)
	over c@ '0' = IF 2drop wait-mount EXIT THEN		\ '0' is the no-error condition
	type CR abort
;
	
: mount_horizon ( -- ALT AZ)
\ return the mount Alt and Az in single integer finite fraction format
	10u.MountALT >number~
	10u.MountAZ >number~
;

: ->mount_horizon ( ALT AZ --)
\ slew to ALT AZ provied in single integer finite fraction format with no tracking
	~AZ$ 10u.SetTargetAz 10u.?abort
	~ALT$ 10u.SetTargetAlt 10u.?abort
	10u.UnPark
	10u.SlewToHorizonTarget ( caddr u)
	over c@ '0' = IF 2drop wait-mount EXIT THEN		\ '0' is the no-error condition
	type CR abort
;

: mount_location ( -- LAT LONG ELEV)
\ return the site LAT and LONG in single integer finite fraction format
\ return the ELEV as an integer
	10u.SiteLatitude >number~
	10u.SiteLongitude >number~ -1 *						\ convert to West is negative
	10u.SiteElevation 1- >float if fr>s else 0 then
;	

: mount_hourAngle ( -- HA)
\ return the Hour Angle of the mount in the range -11 59 59 to 12 00 00 in single interger finite fraction format
\ negative means the mount is pointing is A.M., positive P.M.
	10u.SiderealTime >number~
	10u.MountRA >number~					( LST RA)
	- 											( HA)
	dup  43200 >= IF 86400 ( 24 hours in seconds) - THEN
	dup -43200 <  IF 86400 + THEN	
	\ place in range -12 00 00 - 11 59 59
;

: mount_siderealTime ( --T)
\ return the sidereal time
	10u.SiderealTime >number~
;

: mount_timeToTrackingEnd ( -- T)
\ return the estimated time to tracking end due to horizon / flip limits in single integer f.f. format
	10u.TimeToTrackingEnd 10u.>num 60 *
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

: check-mount ( --)
\ report the current mount to the user
\ WheelID Name SerialNo Slots
		CR 
	." Mount IP = "	10u.IPaddress drop 15 type  	
	." ; Name = " mount_name type

;