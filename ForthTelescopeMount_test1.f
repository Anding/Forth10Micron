\ Hardware-free attachment and UTC calendar-date checks.
NEED Forth10Micron
NEED simple-tester

0 value test.high-precision

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

: 10u.SetTargetAz ( caddr u -- caddr u ) 2drop s" E#" ;
: 10u.SetTargetAlt ( caddr u -- caddr u ) 2drop s" 1" ;
: 10u.SlewToHorizonTarget ( -- caddr u ) s" E#" ;

include "%idir%\ForthTelescopeMount.f"

Tstart
T{ add-mount test.high-precision }T -1 ==
T{ mount_utcDate }T 2026 10 24 ~ ==
T{ 123 10 20 gotoAltAz }T 123 ==
Tend
