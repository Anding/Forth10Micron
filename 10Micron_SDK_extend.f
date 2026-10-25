\ Defining words for the 10Micron text protocol. Static command strings live
\ in the dictionary; data commands compose into the one synchronous I/O buffer.

: MAKE-COMMAND
\ defining word for a 10Micron command
\ s" raw-command-string" MAKE-COMMAND <name>
	CREATE	( caddr u --)
		$,					\ compile the caddr u string to the parameter field as a counted string
	DOES>	( -- caddr u)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		(10u.tell) if 10u.ask else 10Micron.buffer 0 then
;

: compose-command {: caddr1 u1 caddr2 u2 -- MNTBUF u3 :}	\ use VFX locals
\ compose a mount command in the format PrefixData#
\ caddr1 u1 contains the prefix
\ caddr2 u2 contains the data, which will be appended to caddr1 u1
\ # is appended by the word
\ u3 = u1 + u2 + 1
	caddr1 10Micron.buffer u1			( from to len) 
	cmove
	caddr2 10Micron.buffer u1 + u2	( from to len)
	cmove
	'#' 10Micron.buffer u1 + u2 +		( '#' caddr)
	c!
	10Micron.buffer	u1 u2 + 1+			( caddr3 u3)
;

: MAKE-DATA-COMMAND
\ defining word for a 10Micron command which takes a data string
\ s" raw-command-prefix" MAKE-DATA-COMMAND <name>
	CREATE	( caddr u --)
		$,
	DOES>	( caddr u -- caddr u)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		2swap
		dup 0< over 0= or if 2drop 2drop cr ." Empty mount command data" cr 10Micron.buffer 0 exit then
		2over nip over + 255 > if
			2drop 2drop cr ." Mount command is too long" cr 10Micron.buffer 0 exit
		then
		compose-command (10u.tell) if 10u.ask else 10Micron.buffer 0 then
;

: MAKE-QUIET-COMMAND
\ defining word for a 10Micron command which has no return signal
\ s" raw-command-string" MAKE-QUIET-COMMAND <name>
	CREATE	( caddr u --)
		$,
	DOES>	( --)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		10u.tell 
;

\ Prepare string formats for 10u mount commands

: ~DEC$ ( deg-min-sec -- caddr u)
\ obtain a declination string in the format sDD*MM:SS from single integer finite fraction format
	'*' ':' -1 ~custom$
;

synonym ~RA$ <.RA> ( hr-min-sec -- caddr u )

synonym ~ALT$ ~DEC$ ( deg-min-sec -- caddr u )

: ~AZ$ ( deg-min-sec -- caddr u)
\ obtain an azimuth string in the format DDD*MM:SS from single integer finite fraction format	
   '*' ':' 0 ~custom$
;

: 10u.accepted? ( caddr u -- flag)
\ A missing or rejected target must not be followed by a slew.
	dup if over c@ '1' = if 2drop -1 exit then then
	cr ." Mount responds invalid: " type cr 0
;

: 10u.?abort ( caddr u --)
\ Report only; the compatibility name no longer aborts.
	10u.accepted? drop
;

\ Convenience functions

:	10u.>num? ( caddr u -- n valid?)
\ Take a numeric protocol reply without conflating a missing reply with zero.
	dup 0= if 2drop 0 0 exit then
	2dup + 1- c@ '#' = IF 1- THEN		\ # some but not all returns terminate in #
	isInteger? ( d 2 | n 1 | 0)
	case
		0 of 0 0 endof
		1 of -1 endof
		2 of 2drop 0 0 endof
	endcase
;

: 10u.>num ( caddr u -- n)
	10u.>num? 0= if cr ." Invalid numeric mount response" cr then
;

BEGIN-ENUMS 10u.modes
	+" Off"
	+" On"
END-ENUMS

: 10u.OnOff? ( caddr u -- caddr u)
	10u.>num 10u.modes
;
	
	

	
	

		
	
	
	
	
	
