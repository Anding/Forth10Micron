\ Code for controlling the 10Micron mount
NEED forthbase
NEED network
NEED finitefractions
NEED forthVT100

s" " $value 10u.str1

0 value 10Micron.verbose
\ 10u.ask will report results to the terminal

0 value 10Micron.socket
\ value type holding the socket number of the 10Micron mount

192 168 0 15 toIPv4 value 10Micron.IP
\ change for the local rig

256 buffer: 10Micron.buffer
\ buffer to hold strings communicated with the 10Micron mount

: 10u.connect ( -- )
\ try to connect to the 10 Micron mount
	10Micron.IP 0 3490 TCPConnect
	?dup 0= if 
		-> 10Micron.socket
	else
		s" 10Micron connection failed with WinSock error number " $-> 10u.str1 (.) $+> 10u.str1 10u.str1 .>E abort
	then
;

: 10u.checksocket ( --)
\ check for an uninitialized socket
	10Micron.socket 0 = if CR s" Uninitialized TCP/IP socket to the mount" .>E abort
	then
;

: 10u.disconnect ( --)
\ VFX does not provide a function to close a socket
;
	
: 10u.tell ( c-addr u --)
\ pass a command string to the mount	
	10u.checksocket
	dup -rot 						( u c-addr u)
	10Micron.socket writesock				( u len 0 | u error SOCKET_ERROR)
	SOCKET_ERROR = if ." Failed to write to the socket with error " . CR exit then
	<> if ." Failed to write the full string to the socket" CR exit then
;

: 10u.ask ( -- c-addr u)
\ get a response from the mount
	10u.checksocket
	0 >R 5													( tries R:bytes)
	begin
		1- dup 0 >=
	while
		200 ms
		10Micron.socket pollsock									( tries len | tries SOCKET_ERROR)
		dup SOCKET_ERROR = if 
			drop ." Failed to poll the socket " CR
		else
			0= if
				." 0 bytes available at the socket" CR
			else
				10Micron.buffer 256 10Micron.socket readsock 			( tries len 0 | tries error SOCKET_ERROR)
				SOCKET_ERROR = if							( tries ior)
					." Failed to read the socket with error " . CR
				else											( tries len)
					R> drop >R drop 0						( 0 R:bytes)
				then											( tries R:bytes)
			then
		then
	repeat
	drop 10Micron.buffer R>						  ( caddr bytes)
	dup if 
		10Micron.verbose if 2dup .>D then ( caddr u)
	then
;
