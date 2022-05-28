  local carrier={
    Name="CARRIER Mother 297.400, VOICE en-US-Wavenet-F",
    tacan={
        channel=75,
        mode="X",
        morseCode="HST"
    },
    icls={
        channel=11,
        morseCode="RDR"--i think morse code doesn't apply here
    }
  }

local rescueHelo={
	Base="BlueMASH #9",
	GroupName="Rescue Helo"
}

local tankerDetails={
  GroupName="Texaco-1",
  radio=270,
  tacan={
    channel=51,
    mode="Y",--forced to Y for tanker/awacs
    morseCode="TEX"
  },
  debug=false --marks pattern on f10
 
}

local awacsDetails={
  GroupName="Wizard-1",
  radio=299.15,
  tacan={
    channel=52,
    mode="Y",--forced to y for tanker/awcs
    morseCode="WIZ"
  }
}

-- S-3B Recovery Tanker spawning in air.
local tanker=RECOVERYTANKER:New(carrier.Name, tankerDetails.GroupName)
--tanker:SetTakeoffAir()
tanker:SetRadio(tankerDetails.radio)
tanker:SetRacetrackDistances(5, 2.5)
tanker:SetModex(511)
tanker:SetTACAN(tankerDetails.tacan.channel, tankerDetails.tacan.morseCode)

tanker:__Start(1800)

-- E-2D AWACS spawning on Stennis.
local awacs=RECOVERYTANKER:New(carrier.Name, awacsDetails.GroupName)
awacs:SetAWACS()
--awacs:SetTakeoffAir()
awacs:SetRadio(299.15)
awacs:SetAltitude(20000)
awacs:SetCallsign(CALLSIGN.AWACS.Wizard)
awacs:SetRacetrackDistances(30, 15)
awacs:SetModex(611)
awacs:SetTACAN(awacsDetails.tacan.channel, awacsDetails.tacan.morseCode)
awacs:__Start(1)

awacs:__Start(1800)

-- Rescue Helo with home base rescueHeloBase. Has to be a global object!
rescuehelo=RESCUEHELO:New(carrier.Name, rescueHelo.GroupName)
rescuehelo:SetHomeBase(AIRBASE:FindByName(rescueHelo.Base))
rescuehelo:SetModex(42)
rescuehelo:__Start(1)

---------------------------
--- Generate AI Traffic ---
---------------------------

-- Spawn some AI flights as additional traffic.
--local F181=SPAWN:New("FA-18C Group 1"):InitModex(111) -- Coming in from NW after ~ 6 min
--local F182=SPAWN:New("FA-18C Group 2"):InitModex(112) -- Coming in from NW after ~20 min
--local F183=SPAWN:New("FA-18C Group 3"):InitModex(113) -- Coming in from W  after ~18 min
--local F14=SPAWN:New("F-14B 2ship"):InitModex(211)     -- Coming in from SW after ~ 4 min
--local E2D=SPAWN:New("E-2D Group"):InitModex(311)      -- Coming in from NE after ~10 min
--local S3B=SPAWN:New("S-3B Group"):InitModex(411)      -- Coming in from S  after ~16 min
  
-- Spawn always 9 min before the recovery window opens.
--local spawntimes={"06:51", "8:51", "10:51", "14:51", "16:51", "20:51"}
--for _,spawntime in pairs(spawntimes) do
--  local _time=UTILS.ClockToSeconds(spawntime)-timer.getAbsTime()
--  if _time>0 then
--    SCHEDULER:New(nil, F181.Spawn, {F181}, _time)
--    SCHEDULER:New(nil, F182.Spawn, {F182}, _time)
--    SCHEDULER:New(nil, F183.Spawn, {F183}, _time)
--    SCHEDULER:New(nil, F14.Spawn,  {F14},  _time)
--    SCHEDULER:New(nil, E2D.Spawn,  {E2D},  _time)
--    SCHEDULER:New(nil, S3B.Spawn,  {S3B},  _time)
--  end
--end