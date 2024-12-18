s" :GR#"  MAKE-COMMAND 		10u.RA? ( --)
\ get the 10Micron telescope right ascension in the raw format
s" :GD#"  MAKE-COMMAND		10u.DEC? ( --)
\ get the 10Micron telescope declination in the raw format
s" :GA#"  MAKE-COMMAND		10u.ALT? ( --)
\ get the 10Micron telescope altitude in the raw format
s" :GZ#"  MAKE-COMMAND		10u.AZ? ( --)
\ get the 10Micron telescope altitude in the raw format
s" :GS#"  MAKE-COMMAND		10u.ST?
\ get the siderial time at the mount in raw format
s" :Gstat#" MAKE-COMMAND 	10u.status?
\ get the status of the mount
s" :pS#"  MAKE-COMMAND		10u.pierSide?
\ get the 10Micron pier side
\ East#, telescope is on the east of the pier looking west
\ West#, telescope is on the west of the pier looking east
s" :D#"  MAKE-COMMAND		10u.tracking?
\ test the tracking status of the mount
s" :MS#"  MAKE-COMMAND		10u.slew
\ slew to target RA Dec coordinates and start tracking

s" :Sd" MAKE-DATA-COMMAND 	10u.DEC
\ set the 10Micron target to a declension in the format sDDD:MM:SS
s" :Sr" MAKE-DATA-COMMAND	10u.RA ( caddr u --)
\ set the 10Micron target to a right ascension in the format HH:MM:SS

s" :U2#" MAKE-QUIET-COMMAND 10u.highPrecision
\ set the mount in high precision mode
s" :KA#" MAKE-QUIET-COMMAND 10u.park
\ park the mount
s" :PO#" MAKE-QUIET-COMMAND 10u.unpark
\ unpark the mount
s" :Q#"  MAKE-QUIET-COMMAND 10u.halt
\ halt all mount movement	