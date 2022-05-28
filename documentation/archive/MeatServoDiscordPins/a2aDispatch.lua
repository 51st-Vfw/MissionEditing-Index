
-- Define a SET_GROUP object that builds a collection of groups that define the EWR network.
DetectionSetGroup = SET_GROUP:New()

-- add the MOOSE SET_GROUP to the Skynet IADS, from now on Skynet will update active radars that the MOOSE SET_GROUP can use for EW detection.
redIADS:addMooseSetGroup(DetectionSetGroup)

-- Setup the detection and group targets to a 30km range!
Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )

-- Setup the A2A dispatcher, and initialize it.
A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )

-- Set 100km as the radius to engage any target by airborne friendlies.
A2ADispatcher:SetEngageRadius(175000) -- 100000 is the default value.

-- Set 200km as the radius to ground control intercept.
A2ADispatcher:SetGciRadius(450000) -- 200000 is the default value.

CCCPBorderZone = ZONE_POLYGON:New( "RED-BORDER", GROUP:FindByName( "RED-BORDER" ) )
A2ADispatcher:SetBorderZone( CCCPBorderZone )

A2ADispatcher:SetDefaultTakeoffFromParkingHot()
A2ADispatcher:SetDefaultLandingAtEngineShutdown()

A2ADispatcher:SetSquadron( "MiG29-1s", AIRBASE.PersianGulf.Shiraz_International_Airport, { "SQ IRN MiG-1" }, 60 )
A2ADispatcher:SetSquadron( "MiG29s", AIRBASE.PersianGulf.Kish_International_Airport, { "SQ IRN MiG-29A" }, 40 )
A2ADispatcher:SetSquadron( "MiG29-2s", AIRBASE.PersianGulf.Kish_International_Airport, { "SQ IRN MiG-2" }, 40 )
A2ADispatcher:SetSquadron( "F14s", AIRBASE.PersianGulf.Kerman_Airport, { "SQ F14A Kerman" }, 40 )
A2ADispatcher:SetSquadron( "F4s", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "SQ IRN F-4E" }, 40 )
A2ADispatcher:SetSquadron( "F4-2s", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "SQ IRN F-4E-3" }, 40 )
A2ADispatcher:SetSquadron( "MiG21s", AIRBASE.PersianGulf.Lar_Airbase, { "SQ IRN MiG-21Bis" }, 60 )

A2ADispatcher:SetSquadronGrouping( "MiG29s", 2 )
A2ADispatcher:SetSquadronGrouping( "MiG29-1s", 4 )
A2ADispatcher:SetSquadronGrouping( "MiG29-2s", 2 )
A2ADispatcher:SetSquadronGrouping( "MiG21s", 4 )
A2ADispatcher:SetSquadronGrouping( "F4s", 4 )
A2ADispatcher:SetSquadronGrouping( "F14s", 2 )

A2ADispatcher:SetSquadronGci( "MiG21s", 900, 1200 )
A2ADispatcher:SetSquadronGci( "MiG29-1s", 900, 1200 )
A2ADispatcher:SetSquadronGci( "MiG29-2s", 900, 1200 )
A2ADispatcher:SetSquadronGci( "F4-2s", 900, 1200 )

A2ADispatcher:SetSquadronOverhead( "MiG21s", 1.5 )
A2ADispatcher:SetSquadronOverhead( "MiG29-1s", 1.5 )
A2ADispatcher:SetSquadronOverhead( "MiG29-2s", 1.5 )

CAPZoneShiraz = ZONE_POLYGON:New( "CAP SHIRAZ", GROUP:FindByName( "CAP SHIRAZ" ) )
A2ADispatcher:SetSquadronCap( "MiG29s", CAPZoneShiraz, 4000, 12000, 800, 900, 800, 1400, "BARO" )
A2ADispatcher:SetSquadronCapInterval( "MiG29s", 2, 240, 600, 1 )

CAPZoneBandar = ZONE_POLYGON:New( "CAP BANDAR", GROUP:FindByName( "CAP BANDAR" ) )
A2ADispatcher:SetSquadronCap( "F4s", CAPZoneBandar, 4000, 12000, 700, 900, 800, 1400, "BARO" )
A2ADispatcher:SetSquadronCapInterval( "F4s", 1, 340, 600, 1 )

A2ADispatcher:SetTacticalDisplay(false)
A2ADispatcher:Start()
