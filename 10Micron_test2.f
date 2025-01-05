\ Testing code with the 10Micron mount

include %idir%\..\..\ForthBase\libraries\libraries.f
NEED Forth10Micron
NEED forth-map

	192 168 1 107 toIPv4 -> 10Micron.IP		\ DSC
\ 	192 168 1  14 toIPv4 -> 10Micron.IP		\ DB

add-mount

CR ." Set high precision mode"
10u.HighPrecisionOn

-1 -> 10Micron.verbose

.( 10u.TrackingMode ) 10u.TrackingMode
.( 10u.GPSclockMode ) 10u.GPSclockMode
.( 10u.AlignmentStarCount ) 10u.AlignmentStarCount		
.( 10u.ModelAlignmentInfo ) 10u.ModelAlignmentInfo
.( 10u.MountAlt ) 10u.MountAlt
.( 10u.TargetAlt ) 10u.TargetAlt
.( 10u.MountAz ) 10u.MountAz
.( 10u.TargetAz ) 10u.TargetAz
.( 10u.MountRA ) 10u.MountRA
.( 10u.TargetRA ) 10u.TargetRA
.( 10u.MountDec ) 10u.MountDec
.( 10u.TargetDec ) 10u.TargetDec
.( 10u.SiteElevation ) 10u.SiteElevation
.( 10u.SiteLongitude ) 10u.SiteLongitude
.( 10u.SiteLatitude ) 10u.SiteLatitude
.( 10u.TimeToTrackingEnd ) 10u.TimeToTrackingEnd
.( 10u.LocalDate ) 10u.LocalDate
.( 10u.LocalTime ) 10u.LocalTime
.( 10u.LocalDateTime ) 10u.LocalDateTime 
.( 10u.UTCDateTime ) 10u.UTCDateTime
.( 10u.SiderealTime ) 10u.SiderealTime
.( 10u.Status ) 10u.Status
.( 10u.MountModel ) 10u.MountModel
.( 10u.IPaddress ) 10u.IPaddress
.( 10u.MACaddress ) 10u.MACaddress
.( 10u.FirmwareVersion ) 10u.FirmwareVersion
.( 10u.SerialNumber ) 10u.SerialNumber
.( 10u.RefractionCorrectionMode ) 10u.RefractionCorrectionMode
.( 10u.SpeedCorrectionMode ) 10u.SpeedCorrectionMode
.( 10u.DualAxisTrackingMode ) 10u.DualAxisTrackingMode
.( 10u.MountPierSide ) 10u.MountPierSide
.( 10u.TargetPierSide ) 10u.TargetPierSide
.( 10u.UnattendedFlipSetting ) 10u.UnattendedFlipSetting
.( 10u.MeridianTrackingLimit) 10u.MeridianTrackingLimit
.( 10u.MeridianSlewLimit) 10u.MeridianSlewLimit


