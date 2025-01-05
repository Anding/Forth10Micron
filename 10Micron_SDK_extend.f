: MAKE-COMMAND
\ defining word for a 10Micron command
\ s" raw-command-string" MAKE-COMMAND <name>
	CREATE	( caddr u --)
		$,					\ compile the caddr u string to the parameter field as a counted string
	DOES>	( -- caddr u)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		CR 10u.tell 
		10u.ask
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
		CR 2swap compose-command 10u.tell 
		10u.ask
;

: MAKE-QUIET-COMMAND
\ defining word for a 10Micron command which has no return signal
\ s" raw-command-string" MAKE-QUIET-COMMAND <name>
	CREATE	( caddr u --)
		$,
	DOES>	( --)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		CR 10u.tell 
;

\ Prepare string formats for 10u mount commands

: ~DEC$ ( deg-min-sec -- caddr u)
\ obtain a declination string in the format sDD*MM:SS from single integer finite fraction format
	'*' ':' -1 ~custom$
;

: ~RA$ ( hr-min-sec -- caddr u)
\ obtain a right ascension string in the format HH:MM:SS	from single integer finite fraction format
   ':' ':' 0 ~custom$
;

: ~ALT$ ( deg-min-sec -- caddr u)
\ obtain an altitude string in the format sDD*MM:SS from single integer finite fraction format
   '*' ':' -1 ~custom$
;

: ~AZ$ ( deg-min-sec -- caddr u)
\ obtain an azimuth string in the format DDD*MM:SS from single integer finite fraction format	
   '*' ':' 0 ~custom$
;

\ Prepare string formats for FITS

: ~FITS$ ( x-y-z -- caddr u)
\ obtain an  string in the format XX YY ZZ from single integer finite fraction format	
   BL BL 0 ~custom$
 ;

: 10u.?abort ( caddr u --)
\ do-or-die error handler	
	flushKeys	
	drop c@						\ the first character in the buffer
	'1' = IF EXIT THEN		\ '1' is the valid return condition
	." Mount responds invalid"
	abort 
;

\ Convenience functions

:	10u.>num ( caddr u -- n)
\ take a 10u return string and convert to an integer or otherwise return 0
	1- isInteger? ( d 2 | n 1 | 0)
	case
		0 of 0 endcase
		1 of ( n) endcase
		2 of 2drop 0 endcase
	endcase
;

BEGIN-ENUMS 10u.modes
	+" Off"
	+" On"
END-ENUMS

: 10u.OnOff? ( caddr u -- caddr u)
	10u.>num 10u.modes
;
	
	

	
	

		
	
	
	
	
	
