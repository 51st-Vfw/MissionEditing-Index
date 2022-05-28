do

redIADS = SkynetIADS:create('IRAN')

--local iadsDebug = redIADS:getDebugSettings()
--iadsDebug.IADSStatus = true
--iadsDebug.samWentDark = true
--iadsDebug.contacts = true
--iadsDebug.radarWentLive = true
--iadsDebug.noWorkingCommmandCenter = true
--iadsDebug.ewRadarNoConnection = true
--iadsDebug.samNoConnection = true
--iadsDebug.jammerProbability = true
--iadsDebug.addedEWRadar = true
--iadsDebug.hasNoPower = true
--iadsDebug.harmDefence = true

redIADS:addEarlyWarningRadarsByPrefix('IEWR')


redIADS:addSAMSitesByPrefix('SAM')

--- Configuración basica de los SAM de IRAN por ZONA
redIADS:getSAMSitesByPrefix('SAM SA10'):setActAsEW(true)
-- ZONA BANDAR ABAS
-- Punto defensivo TOR Bandar Abas
local sa15ban = redIADS:getSAMSiteByGroupName('SAM-TOR-PD-BAN'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(100):setHARMDetectionChance(90)
-- SA2 Zona Bandar Abas
redIADS:getSAMSiteByGroupName('SAM SA2 1'):addPointDefence(sa15ban):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70):setIgnoreHARMSWhilePointDefencesHaveAmmo(true)
-- Hawk zona Bandar Abas
redIADS:getSAMSiteByGroupName('SAM HAWK 1'):addPointDefence(sa15ban):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70):setIgnoreHARMSWhilePointDefencesHaveAmmo(true)
redIADS:getSAMSiteByGroupName('SAM SA10'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(70):setHARMDetectionChance(90)
redIADS:getSAMSiteByGroupName('SAM SA10-1'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(70):setHARMDetectionChance(90)
redIADS:getSAMSiteByGroupName('SAM SA10-2'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(70):setHARMDetectionChance(90)
redIADS:getSAMSiteByGroupName('SAM SA10-3'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(70):setHARMDetectionChance(90)
-- Hawk zona Havadarya
redIADS:getSAMSiteByGroupName('SAM HAWK 2'):addPointDefence(sa15ban):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

-- ZONA LAVAN
-- Punto defensivo TOR LAVAN
local sa15lavan = redIADS:getSAMSiteByGroupName('SAM-TOR-PD-LAV'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(100):setHARMDetectionChance(90)

-- SA2 Zona LAVAN
redIADS:getSAMSiteByGroupName('SAM SA2 4'):addPointDefence(sa15lavan):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70):setIgnoreHARMSWhilePointDefencesHaveAmmo(true)
-- Hawk zona LAVAN
redIADS:getSAMSiteByGroupName('SAM HAWK 3'):addPointDefence(sa15lavan):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70):setIgnoreHARMSWhilePointDefencesHaveAmmo(true)

-- ZONA ABU MUSA

redIADS:getSAMSiteByGroupName('SAM HAWK 4'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(30):setHARMDetectionChance(70)

-- ZONA SHIRAZ
-- SA2 Zona SHIRAZ
redIADS:getSAMSiteByGroupName('SAM SA2 5'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)
-- Hawk zona SHIRAZ
redIADS:getSAMSiteByGroupName('SAM HAWK 10'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

redIADS:setupSAMSitesAndThenActivate()

blueIADS = SkynetIADS:create('UAE')
blueIADS:addSAMSitesByPrefix('PATRIOT')
blueIADS:addEarlyWarningRadarsByPrefix('BLUE-EW')

---we add a AWACs, manually. This could just as well be automated by adding an 'EW' prefix to the unit name:
blueIADS:addEarlyWarningRadar('CARRIER Mother 297.400, VOICE en-US-Wavenet-F')

---we add a AWACs, manually. This could just as well be automated by adding an 'EW' prefix to the unit name:
blueIADS:addEarlyWarningRadar('Tarawa')

-- ZONA AL DHAFRA

blueIADS:getSAMSiteByGroupName('PATRIOT-4'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

blueIADS:getSAMSiteByGroupName('PATRIOT-5'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

-- ZONA AL NAKHEEL
blueIADS:getSAMSiteByGroupName('PATRIOT-3'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

-- ZONA AL AINL
blueIADS:getSAMSiteByGroupName('PATRIOT-6'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

-- ZONA AL SHAMKA

blueIADS:getSAMSiteByGroupName('PATRIOT-2'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)
-- ZONA AL MINHAD
blueIADS:getSAMSiteByGroupName('PATRIOT-1'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE):setGoLiveRangeInPercent(85):setHARMDetectionChance(70)

--local iadsDebug = blueIADS:getDebugSettings()
--iadsDebug.IADSStatus = true
--iadsDebug.contacts = true
blueIADS:activate()

end


