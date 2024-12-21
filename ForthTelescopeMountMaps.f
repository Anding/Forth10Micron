\ write the mount properties to the FITS map

: add-mountFITS ( map --)
\ add key value pairs for FITS observation parameters
	>R
	s"  " 							R@ =>" #MOUNT"			\ a header to indicate the source of these FITS values
	R> drop
;