# Forth10Micron
Forth language control of the 10Micron robotic telescope mounts (German equatorial mount manufactured by 10Micron Technology of Italy).  

The mount is responsible for pointing the telescope and then tracking the target during long exposure astrophotography.  The model installed is the GM2000

Https://www.10micron.com/en/product/gm2000-hps-ii-combi-en/

The mount is connected by a fixed IP, wired Ethernet connection.  The 10Micron use a simple text-based command protocol over TCP/IP.  The command protocol is documented in a PDF file which may be downloaded from the mount itself over the web interface.

An empty alignment-count reply records an empty `ALGNSTRS` value rather than
passing a negative string length to the metadata map.
`ForthTelescopeMountMaps_test1.f` checks this without hardware.

Ordinary transport and protocol errors report and return normally.
`10u.?abort` is a compatibility name for reporting only. Empty replies have
length zero. Rejected target coordinates, invalid UTC dates and failed
unpark writes prevent dependent slew commands; invalid status replies stop
slew monitoring without starting tracking. Callers can retry on a later
iteration. `ForthTelescopeMount_test1.f` checks attachment, UTC dates and a
rejected target using mocks, without contacting hardware.

Slews use the common readiness wait and report their final status rather
than constructing continuous progress strings.
 
