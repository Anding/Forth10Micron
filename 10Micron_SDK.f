\ Code for controlling the 10Micron mount
NEED forthbase
NEED network
NEED finitefractions
NEED forthVT100
NEED windows

0 value mount.error.code       \ WinSock ior, or -1 for an already detected local failure.
0 value mount.error.timestamp  \ UTC Unix epoch seconds.

: 10u.error! ( code -- )
\ Latch nonzero transport/malformed-response failures; never recover in the driver.
    ?dup if
        -> mount.error.code utc-epoch-seconds -> mount.error.timestamp
    then
;

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
	0 -> 10Micron.socket
	10Micron.IP 0 3490 TCPConnect
	?dup 0= if 
		-> 10Micron.socket
	else
        dup 10u.error!
		s" 10Micron connection failed with WinSock error number " $-> 10u.str1 (.) $+> 10u.str1 10u.str1 cr type cr
		drop
	then
;

: 10u.checksocket ( --)
\ check for an uninitialized socket
	10Micron.socket 0 = if cr ." Uninitialized TCP/IP socket to the mount" cr
        -1 10u.error!
	then
;

: 10u.disconnect ( --)
\ Release only the transport; disconnect never changes mount motion.
    10Micron.socket ?dup if
        closesocket if WSAGetLastError 10u.error! then
        0 -> 10Micron.socket
    then
;
	
: (10u.tell) ( c-addr u -- sent?)
\ pass a command string to the mount	
	10Micron.socket 0= if 2drop 10u.checksocket 0 exit then
	dup -rot 						( u c-addr u)
	10Micron.socket writesock				( u len 0 | u error SOCKET_ERROR)
	?dup if dup 10u.error! ." Failed to write to the socket with error " . 2drop CR 0 exit then
	<> if -1 10u.error! ." Failed to write the full string to the socket" CR 0 exit then
	-1
;

: 10u.tell ( c-addr u --)
	(10u.tell) drop
;

: 10u.ask ( -- c-addr u)
\ get a response from the mount
	10Micron.socket 0= if 10u.checksocket 10Micron.buffer 0 exit then
	100 0 do
		100 ms
		10Micron.socket pollsock
		dup SOCKET_ERROR = if
            WSAGetLastError 10u.error!
			drop ." Failed to poll the socket " cr 10Micron.buffer 0 unloop exit
		then
		if
			10Micron.buffer 256 10Micron.socket readsock
			?dup if
                dup 10u.error!
				." Failed to read the socket with error " . cr drop 0
            else
                dup 0= if -1 10u.error! then
			then
			10Micron.buffer swap
			10Micron.verbose if 2dup .D> then unloop exit
		then
	loop
    -1 10u.error!
	cr ." No response from the mount" cr 10Micron.buffer 0
;
