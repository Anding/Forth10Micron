\ Hardware-free attachment and UTC calendar-date checks.
NEED Forth10Micron
NEED simple-tester

0 value test.high-precision
0 value test.target-accepted \ Select a rejected or accepted horizon target.
0 value test.slews \ Count accepted simulated slew commands.
0 value test.tracking \ Count explicit tracking starts after horizon slews.

: 10u.connect ( -- )
\ Replace the transport connection; no equipment is contacted.
    1 -> 10Micron.socket
;

: (10u.tell) ( caddr u -- sent? )
\ Record selection of the reply format during attachment.
    2drop -1 -> test.high-precision -1
;

: 10u.MountModel ( -- caddr u )
\ Supply a terminated model reply for the attachment announcement.
    s" Test#"
;

: 10u.status ( -- caddr u )
\ Supply the tracking status for the attachment announcement.
    s" 0#"
;

: 10u.utcdatetime ( -- caddr u )
\ Supply a date whose day exceeds 12 to expose month/day transposition.
    s" 10/24/26,12:27:23#"
;

: 10u.SetTargetAz ( caddr u -- caddr u )
\ Select target rejection or acceptance without contacting equipment.
    2drop test.target-accepted if s" 1" else s" E#" then ;
: 10u.SetTargetAlt ( caddr u -- caddr u ) 2drop s" 1" ;
: 10u.SetTargetRA ( caddr u -- caddr u ) 2drop s" 1" ;
: 10u.SetTargetDec ( caddr u -- caddr u ) 2drop s" 1" ;
: 10u.SlewToHorizonTarget ( -- caddr u )
\ Simulate an accepted slew so reporting and wait cleanup can run offline.
    test.slews 1+ -> test.slews s" 0" ;
: 10u.SlewToEquatorialTarget ( -- caddr u )
\ Use the same simulated response for equatorial motion.
    10u.SlewToHorizonTarget ;
: 10u.StartTracking ( -- )
\ Record tracking policy without issuing a transport command.
    test.tracking 1+ -> test.tracking ;

include "%idir%\ForthTelescopeMount.f"

Tstart
T{ add-mount test.high-precision }T -1 ==
T{ mount_utcDate }T 2026 10 24 ~ ==
T{ 123 10 20 gotoAltAz }T 123 ==
T{ test.slews test.tracking }T 0 0 ==
-1 -> test.target-accepted
T{ 123 45 00 00 Alt 180 00 00 Az gotoAltAz }T 123 ==
T{ test.slews test.tracking vt.status-active }T 1 1 0 ==
T{ 123 22 30 00 RA 00 00 00 Dec goto }T 123 ==
T{ test.slews test.tracking vt.status-active }T 2 1 0 ==
Tend
