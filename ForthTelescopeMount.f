need astrocalc

s" " $value 10u.ModelAlignmentInfoString
\ 000.4126,+22.3672,00.3882,280.64,E,+00.34,+00.03,E,E# 
\ need to split on the commas!
: 10u.RAaxisAz      10u.ModelAlignmentInfoString drop 8 ;
: 10u.RAaxisAlt     10u.ModelAlignmentInfoString drop 9 + 8 ;
: 10u.PolarError    10u.ModelAlignmentInfoString drop 18 + 7 ;
: 10u.RAaxisPA      10u.ModelAlignmentInfoString drop 26 + 7 ;
: 10u.OrthoError    10u.ModelAlignmentInfoString drop 34 + 8 ;
: 10u.TurnAzLeft    10u.ModelAlignmentInfoString drop 43 + 6 ;
: 10u.TurnAltDown   10u.ModelAlignmentInfoString drop 50 + 6 ;
: 10u.NumOfTerms    10u.ModelAlignmentInfoString drop 57 + 2 ;
: 10u.RMSerror      10u.ModelAlignmentInfoString drop 60 + 7 ;

: mount_name ( -- caddr u)
\ return the name of the mount
	10u.MountModel 1-
;

: mount_status ( -- caddr u)
\ return the status of the mount
	10u.status 10u.>num 10u.statuses
;

: add-mount ( --)
	flushkeys
	10u.connect
	10u.HighPrecisionOn
	10u.DualAxisTrackingOn 2drop
	10u.WeatherUpdatesOn 2drop
	10u.TrackSiderealRate
	cr mount_name $-> 10u.str1 s"  " $+> 10u.str1 mount_status $+> 10u.str1 10u.str1 .> cr
;

: remove-mount ( --)
	10u.disconnect
;

: mount_pierside ( -- caddr u)
	10u.MountPierSide 1-
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

: mount_equatorial ( -- RA_J2000 DEC_J2000)
\ return the mount RA and DEC in single integer finite fraction format
	10u.MountRA >number~
	10u.MountDEC >number~
	10u.utcdatetime >number~~~  ( dd mm yy) 2000 + ( yyyy mm dd) -rot swap ( dd mm yyyy) ~ ( RA_JNOW Dec_JNOW YYMMDD)
	J2000
;

: ->mount_equatorial ( RA_J2000 DEC_J2000 --)
\ set the mount target RA DEC are provided in single integer finite fraction format
    10u.utcdatetime >number~~~  ( yy mm dd) 2000 + ( yyyy mm dd) -rot swap ( dd mm yyyy) ~ ( RA_J2000 Dec_J2000 YYMMDD)
    JNOW ( RA_JNOW Dec_JNOW)
	~DEC$ 10u.SetTargetDec 10u.?abort
	~RA$ 10u.SetTargetRA 10u.?abort
;
	
: mount_horizon ( -- ALT AZ)
\ return the mount Alt and Az in single integer finite fraction format
	10u.MountALT >number~
	10u.MountAZ >number~
;

: ->mount_horizon ( ALT AZ --)
\ slew to ALT AZ provied in single integer finite fraction format and start tracking
	~AZ$ 10u.SetTargetAz 10u.?abort
	~ALT$ 10u.SetTargetAlt 10u.?abort
;

: mount_location ( -- LAT LONG ELEV)
\ return the site LAT and LONG in single integer finite fraction format
\ return the ELEV as an integer
	10u.SiteLatitude >number~
	10u.SiteLongitude >number~ -1 *						\ convert to West is negative
	10u.SiteElevation 1- >float if fr>s else 0 then
;	

: mount_siderealTime ( -- T)
\ return the local sidereal time in finite fraction format
	10u.SiderealTime >number~
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

: stop-mount ( --)
	10u.Stop
;

: mount_SN ( -- caddr u)
\ return the S/N of the mount as a string
	10u.SerialNumber 1-
;

: mount_alignment ( --)
    10u.ModelAlignmentInfo $-> 10u.ModelAlignmentInfoString
;

\ convenience functions

: check-mount ( --)
\ report the current mount to the user
\ WheelID Name SerialNo Slots
	CR 
	." Mount Name = " mount_name type
	." ; Status = " mount_status type
;

\ user lexicon

: unpark ( --)
	10u.unpark
	10u.StartTracking
	cr mount_status .> cr
;

: park
	10u.park
	wait-mount
	cr mount_status .> cr
;

: goto ( RA Dec --)
\ slew the mount to an equatorial coordinate
    ->mount_equatorial ( RA DEC --)
	10u.UnPark
	10u.SlewToEquatorialTarget ( caddr u)
	over c@ '0' <> IF CR 2 - swap 1+ swap .>E CR abort THEN
	2drop cr
	begin
	    mount_busy       ( flag)
	    500 ms
	    mount_equatorial ( flag RA DEC) swap	
	    s" RA " $-> 10u.str1 <.RA> $+> 10u.str1 s"  Dec " $+> 10u.str1 <.Dec> $+> 10u.str1 
        10u.str1 .>	
    0= until
	cr mount_status .> cr	
;

: gotoAltAz ( Alt Az --)
\ slew the mount to a horizon coordinate, then continue tracking
	->mount_horizon ( RA DEC --)
	10u.UnPark
	10u.SlewToEquatorialTarget ( caddr u)
	over c@ '0' <> IF CR 2 - swap 1+ swap .>E CR abort THEN
	2drop cr
	begin
	    mount_busy    ( flag)
	    500 ms
	    mount_horizon ( flag Alt Az) swap	
	    s" Alt " $-> 10u.str1 <.RA> $+> 10u.str1 s"  Az " $+> 10u.str1 <.RA> $+> 10u.str1 
        10u.str1 .>	
	0= until
	cr mount_status .> cr
;

: need-flip? ( -- flag)
\ return true if the mount should make a meridian flip to continue tracking
    mount_pierside drop c@ 'W' = 
    mount_hourAngle 0 >=
    and if -1 else 0 then
;

: meridian-flip ( --)
    10u.FlipPierSide ( caddr u)
    drop c@ '0' = if 
        s" No meridian flip required" .> cr
    else
        s" Meridian flip in progress..." .> cr
	    begin
	        mount_busy    ( flag)
	        500 ms
	    0= until
	then
	mount_status .> cr  
;

: delete-alignment-model
    10u.DeleteAlignment
    2drop
;

: save-alignment-model ( caddr u --)
    10u.SaveAlignment
    2drop
;

: load-alignment-model ( caddr u --)
    10u.LoadAlignment
    2drop
;

: add-alignment-point ( caddr u --)
    2dup 10u.AddAlignmentPoint
    drop c@ 'E' = if 
        s" Invalid point  " $-> 10u.str1 $+> 10u.str1 10u.str1 .>E cr
     else 2drop
     then
;

: new-alignment-model ( caddr u -- ior)
\ create a new alignment model
\ caddr u is a forth file with formatted add-alignment-point commands
    2dup FileExists? 
    0= if s" No such file" .>E cr -1 exit then
    10u.StartNewAlignment 2drop
    ( addr u ) included
    10u.EndAlignment
    drop c@ 'E' = if s" Mount failed to compute a model" .>E cr -1 exit then
    mount_alignment
    s" New alignment model computed" .> cr 0
;

: .alignment ( --)
    cr 
    s" Align stars  " $-> 10u.str1 10u.AlignmentStarCount 1- $+> 10u.str1 10u.str1 .> cr
    mount_alignment
    s" RA Axis Az   " $-> 10u.str1 10u.RAaxisAz      $+> 10u.str1 10u.str1 .> cr
    s" RA Axis Alt  " $-> 10u.str1 10u.RAaxisAlt     $+> 10u.str1 10u.str1 .> cr
    s" Polar Error  " $-> 10u.str1 10u.PolarError    $+> 10u.str1 10u.str1 .> cr
    s" RA Axis PA   " $-> 10u.str1 10u.RAaxisPA      $+> 10u.str1 10u.str1 .> cr
    s" Ortho Error  " $-> 10u.str1 10u.OrthoError    $+> 10u.str1 10u.str1 .> cr
    s" Az go left   " $-> 10u.str1 10u.TurnAzLeft    $+> 10u.str1 10u.str1 .> cr
    s" Alt go down  " $-> 10u.str1 10u.TurnAltDown   $+> 10u.str1 10u.str1 .> cr
    s" No. terms    " $-> 10u.str1 10u.NumOfTerms    $+> 10u.str1 10u.str1 .> cr
    s" RMS Error    " $-> 10u.str1 10u.RMSerror      $+> 10u.str1 10u.str1 .> cr 
;     
    

