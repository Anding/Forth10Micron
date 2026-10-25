\ Interactive mount vocabulary over the synchronous 10Micron command layer.
\ The selected mount is session-global and equipment operations block.

need astrocalc

: mount_name ( -- caddr u)
\ return the name of the mount
	10u.MountModel 1- 0 max
;

: mount_status ( -- caddr u)
\ return the status of the mount
	10u.status 10u.>num 10u.statuses
;

: add-mount ( --)
\ Attach and select full-second replies without changing tracking or modelling policy.
	10u.connect
	10Micron.socket 0= if exit then
	s" :U1#" (10u.tell) 0= if exit then
	mount_name $-> 10u.str1 s"  " $+> 10u.str1 mount_status $+> 10u.str1 10u.str1 .>
;

: configure-mount ( --)
\ Apply the normal imaging policy explicitly after attachment and inspection.
	10u.DualAxisTrackingOn 10u.accepted? 0= if exit then
	10u.WeatherUpdatesOn 10u.accepted? 0= if exit then
	10u.TrackSiderealRate
;

synonym remove-mount 10u.disconnect ( -- )

: mount_pierside ( -- caddr u)
	10u.MountPierSide 1- 0 max
;

: mount-busy? ( -- busy? valid?)
	10u.status 10u.>num? 0= if
		drop s" Invalid mount status" .E> 0 0 exit
	then
	dup 0 12 within 0= if drop s" Invalid mount status" .E> 0 0 exit then
	dup 2 5 within over 6 = or over 8 = or swap 11 = or -1
;

: mount_busy ( -- flag)
	mount-busy? drop
;

: (wait-mount) ( -- ready? )
\ synchronous hold until the mount stops slewing
	begin
		mount-busy? 0= if drop 0 exit then
	while
		250 ms
	repeat
	-1
;

: wait-mount ( -- )
	(wait-mount) drop
;

: mount-date? ( -- YYMMDD valid?)
\ Convert the mount's MM/DD/YY UTC date to AstroCalc finite-fraction format.
	10u.utcdatetime 8 min '/' >number3~? 0= if
		drop s" Invalid mount UTC date" .E> 0 0 exit
	then
	~~~ 2000 + -rot ~
	-1
;

: mount_utcDate ( -- YYMMDD)
	mount-date? drop
;

: mount_equatorial ( -- RA_J2000 DEC_J2000)
\ return the mount RA and DEC in single integer finite fraction format
	10u.MountRA >number~~~? 0= if
		3drop s" Invalid mount RA" .E> 0 0 exit
	then ~
	10u.MountDEC >number~~~? 0= if
		3drop drop s" Invalid mount Dec" .E> 0 0 exit
	then ~
	mount-date? 0= if 3drop 0 0 exit then
	J2000
;

: (mount-equatorial-target) ( RA_J2000 DEC_J2000 -- accepted?)
\ set the mount target RA DEC are provided in single integer finite fraction format
    mount-date? 0= if drop 2drop 0 exit then
    JNOW ( RA_JNOW Dec_JNOW)
	~DEC$ 10u.SetTargetDec 10u.accepted? 0= if drop 0 exit then
	~RA$ 10u.SetTargetRA 10u.accepted?
;

: ->mount_equatorial ( RA_J2000 DEC_J2000 --)
	(mount-equatorial-target) drop
;
	
: mount_horizon ( -- ALT AZ)
\ return the mount Alt and Az in single integer finite fraction format
	10u.MountALT >number~
	10u.MountAZ >number~
;

: (mount-horizon-target) ( ALT AZ -- accepted?)
\ Set target Alt/Az; the caller owns slewing and tracking.
	~AZ$ 10u.SetTargetAz 10u.accepted? 0= if drop 0 exit then
	~ALT$ 10u.SetTargetAlt 10u.accepted?
;

: ->mount_horizon ( ALT AZ --)
	(mount-horizon-target) drop
;

: mount_location ( -- LAT LONG ELEV)
\ return the site LAT and LONG in single integer finite fraction format
\ return the ELEV as an integer
	10u.SiteLatitude >number~
	10u.SiteLongitude >number~ -1 *						\ convert to West is negative
	10u.SiteElevation 1- 0 max >float if fr>s else 0 then
;	

: mount_siderealTime ( -- T)
\ return the local sidereal time in finite fraction format
	10u.SiderealTime >number~
;

: mount_horizon-for { RA_J2000 DEC_J2000 | lat long elevation -- ALT AZ }
\ Convert one J2000 coordinate for the mount's current date, time, and site.
	mount_location to elevation to long to lat
	RA_J2000 DEC_J2000 mount_utcDate mount_siderealTime lat J2000toHZ
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

: mount_timeToTrackingEnd ( -- T)
\ return the estimated time to tracking end due to horizon / flip limits in single integer f.f. format
	10u.TimeToTrackingEnd 10u.>num 60 *
;

synonym stop-mount 10u.Stop ( -- )

: mount_SN ( -- caddr u)
\ return the S/N of the mount as a string
	10u.SerialNumber 1- 0 max
;

s" " $value 10u.RAaxisAz  
s" " $value 10u.RAaxisAlt 
s" " $value 10u.PolarError
s" " $value 10u.RAaxisPA  
s" " $value 10u.OrthoError
s" " $value 10u.TurnAzLeft
s" " $value 10u.TurnAltDown
s" " $value 10u.NumOfTerms
s" " $value 10u.RMSerror  

: mount_alignment ( --)
    10u.ModelAlignmentInfo
    dup 0= if 2drop s" No mount alignment response" .E> exit then
              ',' csplit $-> 10u.RAaxisAz
    1 /string ',' csplit $-> 10u.RAaxisAlt  
    1 /string ',' csplit $-> 10u.PolarError 
    1 /string ',' csplit $-> 10u.RAaxisPA   
    1 /string ',' csplit $-> 10u.OrthoError 
    1 /string ',' csplit $-> 10u.TurnAzLeft 
    1 /string ',' csplit $-> 10u.TurnAltDown
    1 /string ',' csplit $-> 10u.NumOfTerms 
    1 /string 1- 0 max   $-> 10u.RMSerror       
;

\ convenience functions

: check-mount ( --)
\ report the current mount to the user
	s" Mount" panel{
	s" Name" mount_name .field
	s" Status" mount_status .field
	s" Pier side" mount_pierside .field
	}panel
;

\ user lexicon

: unpark ( --)
	s" :PO#" (10u.tell) 0= if exit then
	10u.StartTracking
	mount_status .>
;

: park
	10u.park
	wait-mount
	mount_status .>
;

: goto ( RA Dec --)
\ slew the mount to an equatorial coordinate
    (mount-equatorial-target) 0= if exit then
	s" :PO#" (10u.tell) 0= if exit then
	10u.SlewToEquatorialTarget ( caddr u)
	dup 0= if 2drop s" No slew response" .E> exit then
	over c@ '0' <> IF .E> exit THEN
	2drop
	(wait-mount) 0= if exit then
	mount_status .>
;

: gotoAltAz ( Alt Az --)
\ slew the mount to a horizon coordinate, then continue tracking
	(mount-horizon-target) 0= if exit then
	s" :PO#" (10u.tell) 0= if exit then
	10u.SlewToHorizonTarget ( caddr u)
	dup 0= if 2drop s" No slew response" .E> exit then
	over c@ '0' <> IF .E> exit THEN
	2drop 
	(wait-mount) 0= if exit then
	10u.StartTracking
	mount_status .>
;

: need-flip? ( -- flag)
\ return true if the mount should make a meridian flip to continue tracking
    mount_pierside dup 0= if 2drop 0 exit then drop c@ 'W' =
    mount_hourAngle 0 >=
    and if -1 else 0 then
;

: meridian-flip ( --)
    10u.FlipPierSide ( caddr u)
    dup 0= if 2drop s" No meridian flip response" .E> exit then
    drop c@ '0' = if 
        s" No meridian flip required" .>
    else
        s" Meridian flip in progress..." ...>
	    (wait-mount) 0= if -... exit then
	    -...
	then
	mount_status .>
;

: delete-alignment-model
    10u.DeleteAlignment
    .D>
;

: save-alignment-model ( caddr u --)
    10u.SaveAlignment
    .D>
;

: load-alignment-model ( caddr u --)
    10u.LoadAlignment
    .D>
;

: add-alignment-point ( caddr u --)
    10u.AddAlignmentPoint
    dup 0= if 2drop s" No alignment point response" .E> exit then
    over c@ 'E' = if .E> else .D> then
;

: .alignment ( --)
    mount_alignment
    s" Alignment model" panel{
    s" Alignment stars" 10u.AlignmentStarCount 1- 0 max .field
    s" RA axis azimuth" 10u.RAaxisAz .field
    s" RA axis altitude" 10u.RAaxisAlt .field
    s" Polar error" 10u.PolarError .field
    s" RA axis PA" 10u.RAaxisPA .field
    s" Orthogonality error" 10u.OrthoError .field
    s" Az RHS turn clockw." 10u.TurnAzLeft .field
    s" Altitude go down" 10u.TurnAltDown .field
    s" Model terms" 10u.NumOfTerms .field
    s" RMS error" 10u.RMSerror .field
    }panel
;     
    
