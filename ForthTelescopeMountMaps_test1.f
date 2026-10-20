\ Hardware-free checks of the actual mount metadata writer.
NEED ForthBase
NEED ordered-maps
NEED simple-tester

: ~FITS$ ( n -- caddr u ) (.) ;
: ~fp ( n -- ) ( F: -- r ) s>f ;
: >number~ ( caddr u -- n ) 2drop 0 ;
: mount_horizon ( -- alt az ) 0 0 ;
: mount_location ( -- lat long elevation ) 0 0 0 ;
: mount_siderealTime ( -- n ) 0 ;
: mount_hourAngle ( -- n ) 0 ;
: mount_equatorial ( -- ra dec ) 0 0 ;
: mount_pierside ( -- caddr u ) s" East" ;
: mount_timeToTrackingEnd ( -- n ) 0 ;
: mount_status ( -- caddr u ) s" Tracking" ;
: mount_SN ( -- caddr u ) s" test" ;
: mount_alignment ( -- ) ;
: 10u.LocalTime ( -- caddr u ) s" 0" ;
: 10u.DualAxisTrackingMode ( -- caddr u ) s" 0" ;
: 10u.TrackingMode ( -- caddr u ) s" 1" ;
: 10u.RefractionCorrectionMode ( -- caddr u ) s" 0" ;
: 10u.SpeedCorrectionMode ( -- caddr u ) s" 0" ;
: 10u.UnattendedFlipMode ( -- caddr u ) s" 0" ;
: 10u.MeridianTrackingLimit ( -- caddr u ) s" 0" ;
: 10u.MeridianSlewLimit ( -- caddr u ) s" 0" ;
: 10u.OnOff? ( caddr u -- caddr u ) ;
: 10u.>num ( caddr u -- n ) 2drop 0 ;
: 10u.PolarError ( -- caddr u ) s" 0" ;
: 10u.OrthoError ( -- caddr u ) s" 0" ;
0 value test.reply-length
: 10u.AlignmentStarCount ( -- caddr u )
    s" 9#" drop test.reply-length
;

include "%idir%\ForthTelescopeMountMaps.f"
allocate-map constant test.mount-map

Tstart
T{ 1234 test.mount-map add-mountFITS }T 1234 ==
T{ s" ALGNSTRS" test.mount-map map@ }T 0 0 ==
2 -> test.reply-length
T{ 1234 test.mount-map add-mountFITS }T 1234 ==
T{ s" ALGNSTRS" test.mount-map map@ hashS }T s" 9" hashS ==
T{ test.mount-map map-count }T 29 ==
T{ test.mount-map reset-map }T ==
T{ test.mount-map map-count }T 29 ==
T{ s" ALGNSTRS" test.mount-map map@ }T 0 0 ==
T{ test.mount-map add-mountFITS }T ==
T{ s" ALGNSTRS" test.mount-map map@ hashS }T s" 9" hashS ==
T{ test.mount-map erase-map test.mount-map map-count }T 0 ==
test.mount-map free-map
Tend
