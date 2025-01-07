\ Testing code with the 10Micron mount
NEED Forth10Micron

	192 168 1 107 toIPv4 -> 10Micron.IP		\ DSC
\ 	192 168 1  14 toIPv4 -> 10Micron.IP		\ DB

CR ." Connecting to mount"
add-mount

CR ." Set high precision mode"
10u.HighPrecisionOn

map CONSTANT FITSmap
FITSmap add-mountFITS 
CR FITSmap .map CR

map CONSTANT DASHmap
DASHmap add-mountDASH 
CR DASHmap .map CR

