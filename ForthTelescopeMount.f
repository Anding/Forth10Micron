
: mount_name ( -- caddr u)
\ return the name of the mount
	10u.MountModel 1-
;

: mount_SN ( -- caddr u)
\ return the S/N of the mount as a string
	10u.SerialNumber 1-
;

: mount_slewing ( -- flag)
;

: wait-mount ( -- flag)
\ synchronous hold until the mount stops slewing
	begin
		mount_moving
	while
		." . " 250 ms
	repeat
;
	
: mount-stop ( --)
	10u.Stop
;

: add-mount ( --)
	10u.connect
;

: remove-mount ( --)
;

\ convenience functions

: what-mount? ( --)
\ report the current mount to the user
\ WheelID Name SerialNo Slots
	CR ." Name" 	mount_name tab tab type
	CR ." S/N"		mount_SN tab tab type
	CR CR
;