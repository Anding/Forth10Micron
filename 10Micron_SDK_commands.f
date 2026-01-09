\ Alignment commands
s" :GTRK#" MAKE-COMMAND 		10u.TrackingMode
s" :AL#" MAKE-QUIET-COMMAND 	10u.StopTracking
s" :AP#" MAKE-QUIET-COMMAND 	10u.StartTracking

\ GPS commands
s" :gtg#" MAKE-COMMAND			10u.GPSclockMode
s" :gps#" MAKE-COMMAND			10.NMEAstring

\ Sync control and model building
s" :getalst#" MAKE-COMMAND		10u.AlignmentStarCount
s" :getain#" MAKE-COMMAND		10u.ModelAlignmentInfo
\ "ZZZ.ZZZZ,+AA.AAAA,EE.EEEE,PPP.PP,+OO.OOOO,+aa.aa,+bb.bb,NN,RRRRR.R#"
\ "000.3469,+22.3778,00.3310,284.32,-00.0403,+00.28,+00.04,08,00004.7#"
\ "000.4126,+22.3674,00.3882,280.64,E,+00.34,+00.03,E,E#"
\ "000.4126,+22.3674,00.3882,280.64,E       ,+00.34,+00.03,E ,E#"
\ ZZZ.ZZZZ and +AA.AAAA are the azimuth and altitude of the direction pointed at by the right ascension axis
\ EE.EEEE is the polar align error in degrees and decimals
\ PPP.PP is the position angle of the right ascension axis with respect to the celestial pole in degrees and decimals, 
\ +OO.OOOO is the orthogonality error between the optical axis of the telescope and the declination axis in degrees and decimals, 
\ +aa.aa is the number of turns of the azimuth adjustment knobs (positive if the polar axis must be moved to the left), 
\ +bb.bb is the number of turns of the altitude adjustment knob (positive if the polar axis must be moved downwards), 
\ N is the number of terms used in the modeling, RRRRR.R is the expected RMS error in arcseconds.

\ Get position information
s" :GA#" MAKE-COMMAND			10u.MountAlt
s" :Ga#" MAKE-COMMAND			10u.TargetAlt
s" :GZ#"  MAKE-COMMAND			10u.MountAz
s" :Gz#"  MAKE-COMMAND			10u.TargetAz
s" :GR#"  MAKE-COMMAND 			10u.MountRA
s" :Gr#"  MAKE-COMMAND 			10u.TargetRA
s" :GD#" MAKE-COMMAND			10u.MountDec
s" :Gd#" MAKE-COMMAND			10u.TargetDec
s" :Gev#" MAKE-COMMAND			10u.SiteElevation
s" :GG#"	MAKE-COMMAND			10u.LocalOffsetToUTC ( add to local time)
s" :Gg#"	MAKE-COMMAND			10u.SiteLongitude
s" :Gt#"	MAKE-COMMAND			10u.SiteLatitude
s" :Gmte#" MAKE-COMMAND			10u.TimeToTrackingEnd

\ Get date time information
s" :GC#" MAKE-COMMAND			10u.LocalDate
s" :GL#"	MAKE-COMMAND			10u.LocalTime
s" :GLDT#"	MAKE-COMMAND		10u.LocalDateTime
s" :GUDT#"	MAKE-COMMAND		10u.UTCDateTime
s" :GS#"	MAKE-COMMAND			10u.SiderealTime

\ Get operating information
s" :Gstat#" MAKE-COMMAND 		10u.Status
	BEGIN-ENUMS 					10u.Statuses
(  0)	+" Tracking"
		+" Stopped by command"
		+" Slewing to park"
		+" Unparking"
		+" Slewing to home"
(  5)	+" Parked"
		+" Slewing"
		+" Stopped with tracking off"
		+" Low temperature"
		+" Stopped outside tracking limits"
( 10)	+" Satellite trajectory"
		+" Needs user OK"
( 98	unknown)
( 99  error	)	
	END-ENUMS
	
s" :GVP#" MAKE-COMMAND			10u.MountModel
s" :GIP#" MAKE-COMMAND			10u.IPaddress
s" :GMAC#" MAKE-COMMAND			10u.MACaddress
s" :GVN#" MAKE-COMMAND			10u.FirmwareVersion
s" :GETID#" MAKE-COMMAND		10u.SerialNumber
s" :GREF#"	MAKE-COMMAND		10u.RefractionCorrectionMode
s" :GSC#"	MAKE-COMMAND		10u.SpeedCorrectionMode
s" :Gdat#" MAKE-COMMAND			10u.DualAxisTrackingMode
s" :pS#"  MAKE-COMMAND			10u.MountPierSide
\ East#, telescope is on the east of the pier looking west
\ West#, telescope is on the west of the pier looking east
s" :GTsid#" MAKE-COMMAND		10u.TargetPierSide
\ 0 no target defined, or the target object is located in a position where it is not possible to go
\ 2 the target is located in a position where the mount would slew the telescope to the west side so that after the slew the ":pS#" command would return "West#".
\ 3 the target is located in a position where the mount would slew the telescope to the east side so that after the slew the ":pS#" command would return "East#".
s" :Guaf#" MAKE-COMMAND			10u.UnattendedFlipMode
s" :Glmt#" MAKE-COMMAND			10u.MeridianTrackingLimit
s" :Glms#" MAKE-COMMAND			10u.MeridianSlewLimit

\ Movement commands
s" :STOP#" MAKE-QUIET-COMMAND   10u.Stop
s" :KA#" MAKE-QUIET-COMMAND 	10u.Park
s" :PO#" MAKE-QUIET-COMMAND 	10u.Unpark
\ Park position is set with handbox or virtual keypad software
s" :Sd" MAKE-DATA-COMMAND 		10u.SetTargetDec
s" :Sr" MAKE-DATA-COMMAND		10u.SetTargetRA
s" :MS#"  MAKE-COMMAND			10u.SlewToEquatorialTarget \ starts tracking
s" :Sa" MAKE-DATA-COMMAND 		10u.SetTargetAlt
s" :Sz" MAKE-DATA-COMMAND		10u.SetTargetAz
s" :MA#"  MAKE-COMMAND			10u.SlewToHorizonTarget \ no tracking
s" :RT0#" MAKE-QUIET-COMMAND 	10u.TrackLunarRate
s" :RT1#" MAKE-QUIET-COMMAND 	10u.TrackSolarRate
s" :RT2#" MAKE-QUIET-COMMAND 	10u.TrackSiderealRate
s" :Slmt#" MAKE-DATA-COMMAND	10u.SetMeridianLimitTracking
s" :Slms#" MAKE-DATA-COMMAND	10u.SetMeridianLimitSlews
s" :FLIP#" MAKE-COMMAND			10u.FlipPierSide
s" :newalign#" MAKE-COMMAND     10u.StartNewAlignment
s" :newapt" MAKE-DATA-COMMAND   10u.AddAlignmentPoint
s" :endalign#" MAKE-COMMAND     10u.EndAlignment

\ Operating commands
s" :U1#" MAKE-QUIET-COMMAND 			10u.HighPrecisionOn
s" :SWOL0#" MAKE-QUIET-COMMAND 		10u.WakeOnLANoff
s" :SWOL1#" MAKE-QUIET-COMMAND 		10u.WakeOnLANon
s" :Sdat0#" MAKE-COMMAND 		10u.DualAxisTrackingOff
s" :Sdat1#" MAKE-COMMAND 		10u.DualAxisTrackingOn
s" :WSS0#" MAKE-COMMAND			10u.WeatherUpdatesOff
s" :WSS2#" MAKE-COMMAND 		10u.WeatherUpdatesOn
s" :Suaf0#" MAKE-QUIET-COMMAND		10u.UnattendedFlipOff
s" :Suaf1#" MAKE-QUIET-COMMAND		10u.UnattendedFlipOn
s" :SREF0#" MAKE-COMMAND 10u.RefractionCorrectionOff
s" :SREF1#" MAKE-COMMAND 10u.RefractionCorrectionOn
s" :USEROK#" MAKE-QUIET-COMMAND 		10u.UserOK
s" :shutdown#" MAKE-QUIET-COMMAND 	10u.shutdown