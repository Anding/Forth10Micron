include %idir%\..\ForthBase\libraries\libraries.f
NEED Forth10Micron
NEED simple-tester

CR
Tstart

T{ s" +48ß52:52#" >number~ ~ALT$ hashS }T s" +48*52:52" HashS ==
T{ s" 356ß12:30#" >number~ ~AZ$ hashS }T s" 356*12:30" HashS ==
T{ s" 06:39:18#" >number~ ~RA$ hashS }T s" 06:39:18" HashS ==
T{ s" +10ß31:54#" >number~ ~DEC$ hashS }T s" +10*31:54" HashS ==
T{ s" +070ß51#" >number~ ~FITS$ hashS }T s" 70 51 00" HashS ==
T{ s" -30ß32#" >number~ ~FITS$ hashS }T s" -30 32 00" HashS ==
T{ s" 180.2742,+30.3470,00.2967,232.88,-00.0295,+00.57,-00.29,22,00009.5#"
	drop 18 + 7 >float drop fp~ ~FITS$ hashS }T s" 00 17 42" HashS ==
T{ s" +1736.6" >float drop fr>s }T 1737 ==
CR
Tend