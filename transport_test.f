\ Offline transport return contracts: no real socket is opened or written.
include "%idir%\..\ForthBase\libraries\libraries.f"
NEED ForthBase
NEED network
NEED simple-tester

0 value test.socket-ior
0 value test.short-write
1 value test.poll
0 value test.closes
: TCPConnect ( ip flags port -- socket ior )
\ Return a simulated connection and native error.
    3drop 42 test.socket-ior ;
: closesocket ( socket -- ior )
\ Count transport release without operating on a real handle.
    drop test.closes 1+ -> test.closes 0 ;
: WSAGetLastError ( -- ior )
\ Supply a real WinSock connection-reset error for failed polling.
    10054 ;
: writesock { addr count socket -- len ior }
\ Preserve VFX's actual len/ior contract, including partial writes.
    test.socket-ior if -1 test.socket-ior else count test.short-write - 0 then ;
: readsock { addr count socket -- len ior }
\ Simulate a single-byte response or native read failure.
    '1' addr c! test.socket-ior if -1 test.socket-ior else 1 0 then ;
: pollsock ( socket -- bytes )
\ Control readiness and polling errors without network I/O.
    drop test.poll ;
: ms ( milliseconds -- )
\ Eliminate the real reply timeout delay.
    drop ;

include "%idir%\10Micron_SDK.f"
include "%idir%\10Micron_SDK_extend.f"

Tstart
T{ 123 10u.connect 10Micron.socket }T 123 42 ==
T{ s" :U1#" (10u.tell) mount.error.code }T -1 0 ==
10054 -> test.socket-ior
T{ s" :U1#" (10u.tell) mount.error.code }T 0 10054 ==
T{ mount.error.timestamp utc-epoch-seconds swap - 0 2 within }T -1 ==
0 -> test.socket-ior
T{ s" :U1#" (10u.tell) mount.error.code }T -1 10054 ==
1 -> test.short-write
T{ s" :U1#" (10u.tell) mount.error.code }T 0 -1 ==
0 -> test.short-write 0 -> mount.error.code
T{ 10u.ask nip mount.error.code }T 1 0 ==
10054 -> test.socket-ior
T{ 10u.ask nip mount.error.code }T 0 10054 ==
0 -> test.socket-ior -1 -> test.poll
T{ 10u.ask nip mount.error.code }T 0 10054 ==
0 -> test.poll 0 -> mount.error.code
T{ 10u.ask nip mount.error.code }T 0 -1 ==
0 -> mount.error.code
T{ s" malformed#" 10u.>num mount.error.code }T 0 -1 ==
T{ 123 10u.disconnect test.closes 10Micron.socket }T 123 1 0 ==
Tend
