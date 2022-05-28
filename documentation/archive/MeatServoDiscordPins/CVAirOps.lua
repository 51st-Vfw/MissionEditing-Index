--[[
This is a script by near_blind and the name of this script is Carrier Air Ops

Goals:
#1 Simulate turning into the wind during launch/recovery operations, and then return to base course once complete
#2 At the commencement of launch and recovery operations, launch a tanker and a helicopter to simulate recovery tanker and plane guard helo respectively

]]
do
  local DEBUG = false
  local createMenus
  
  function calculateWaypoint(group)
    group.currentWaypoint = group.currentWaypoint + 1
    return group.currentWaypoint
  end
  
  --stealing this shit from MOOSE because their debugger broke my breaking their shit.
  local function tacanToFreq(TACANChannel, TACANMode)
  
    if type(TACANChannel) ~= "number" then
        if TACANMode ~= "X" and TACANMode ~= "Y" then
          return nil -- error in arguments
        end
    end
    
  -- This code is largely based on ED's code, in DCS World\Scripts\World\Radio\BeaconTypes.lua, line 137.
  -- I have no idea what it does but it seems to work
    local A = 1151 -- 'X', channel >= 64
    local B = 64   -- channel >= 64
    
    if TACANChannel < 64 then
      B = 1
    end
    
    if TACANMode == 'Y' then
      A = 1025
      if TACANChannel < 64 then
        A = 1088
      end
    else -- 'X'
      if TACANChannel < 64 then
        A = 962
      end
    end
    
    return (A + TACANChannel - B) * 1000000
  end
  
  Carrier = {
    name = nil,
    missionRoute = nil,
    currentWaypoint = 0,
    tankerType = nil,
    heloType = nil,
    tankerOnRecover = true,
    heloOnRecover = true,
    carrierBRC = nil,
    carrierTACAN = nil,
    carrierICLS = nil,
    activeRecoveryTanker = nil,
    activeRecoveryHelo = nil,
    activeRecoveryCycle = false,
  }
  
  function Carrier:New(s)
    s = s or {}
    setmetatable(s, self)
    self.__index = self
    return s
  end
  
  local function setTACAN(TACAN, unit)
    local tacNum = TACAN.number
    local letter = TACAN.letter
    local callsign = "CV"
    local cvUnitId = unit:GetDCSObject():getID()
    
    
    if(TACAN.callsign ~= nil) then
      callsign = TACAN.callsign
    end
    local freq = tacanToFreq(tacNum,letter)
    local activateBeacon = { 
      id = 'ActivateBeacon', 
      params = { 
        type = 4,
        AA = false,
        unitId = cvUnitId,
        callsign = callsign,
        modeChannel = letter,
        name = nil,
        channel = tacNum,
        system = 3, 
        bearing = true,
        frequency = freq,
      } 
    }
    
    return activateBeacon
  end
  
  local function setICLS(ILCS, unit)
    local ILCSNum = ILCS
    local cvUnitId = unit:GetDCSObject():getID()
    local activateBeacon = { 
      id = 'ActivateICLS', 
      params = { 
        unitId = cvUnitId,
        type = 131584,
        name = nil,
        channel = ILCSNum,
      } 
    }
    
    return activateBeacon
  end
  
  local function magVarDeterminator()
    local magVar = 0
    if(AIRBASE.Caucasus.Gelendzhik ~= nil) then
      --is Georgia
      magVar = -6
    elseif(AIRBASE.Nevada.Creech_AFB ~= nil) then
      --is Nevada
      magVar = -12
    elseif(AIRBASE.Normandy.Tangmere ~= nil) then
      --is Normandy
      magVar = 2
    else
      --is Persian Gulf
      magVar = -2
    end
    
    return magVar
  end
  
  function Carrier:Setup(unitName, tankerType, heloType, tankerOnRecover, TACANNum, TACANLetter, TACANName, ICLS)
    self.name = unitName
    local carrier = UNIT:FindByName(unitName)
    local carrierGroup = carrier:GetGroup()
    carrierGroup.currentWaypoint = 1
    if(tankerType ~= nil)then
      self.tankerType = tankerType
    end
    if(heloType ~= nil) then
      self.heloType = heloType
    end
    
    if(tankerOnRecover ~= nil) then
      self.tankerOnRecover = tankerOnRecover
    end
    
    if(TACANNum ~= nil and TACANLetter ~= nil) then
      self.carrierTACAN = {number = TACANNum, letter = TACANLetter}
      if(TACANName ~= nil) then
        self.carrierTACAN.callsign = TACANName
      end
      carrierGroup:SetCommand(setTACAN(self.carrierTACAN, carrier))
    end
    
    if(ICLS ~= nil) then
      self.carrierICLS = ICLS
      carrierGroup:SetCommand(setICLS(self.carrierICLS, carrier))
    end
    
    local cvRoute = carrierGroup:CopyRoute()
    for x = 1, #cvRoute, 1 do
      local taskFunction = carrierGroup:TaskFunction( "calculateWaypoint")
      carrierGroup:SetTaskWaypoint(cvRoute[x], taskFunction)
    end
    self.missionRoute = cvRoute
    carrierGroup:Route(cvRoute)
    
    --make radio menus and shit, fuck it, I'm tired
    self:CreateMenus()
    
    return self
  end
  
  function Carrier:SetAutomaticTanker(enabled)
    self.tankerOnRecover = enabled
  end
  
  function Carrier:SetAutomaticHelo(enabled)
    self.heloOnRecover = enabled
  end
  
  --Turns carrier into the wind, assumes proper speed, and if desired launches tanker and planeguard
  function Carrier:BeginFlightOps()
    local carrier = UNIT:FindByName(self.name)
    local carrierGroup = carrier:GetGroup()
    local carrierPos = carrier:GetCoordinate()
    MESSAGE:New((carrier:Name() .. " is assuming flight operations"),60):ToCoalition(carrierGroup:GetCoalition())
    local heading, windSpeed = carrierPos:GetWind(UTILS.FeetToMeters(40))
    heading = heading + 9 --to account for angle of landing deck and movement of the ship **was 7
    if heading > 360 then
      heading = heading - 360
    end
    self.carrierBRC = heading
    windSpeed = UTILS.MpsToKnots(windSpeed)
    local speed = UTILS.KnotsToKmph(27 - windSpeed)
    if(speed <= 0) then
      speed = UTILS.KnotsToKmph(5)
    end
    local destination = carrierPos:Translate((speed * 1500), heading)
    carrierGroup:RouteGroundTo(destination, speed, nil, 1)
    if(self.carrierTACAN ~= nil) then
      carrierGroup:SetCommand(setTACAN(self.carrierTACAN, carrier))
    end
    
    if(self.carrierICLS ~= nil) then
      carrierGroup:SetCommand(setICLS(self.carrierICLS, carrier))
    end
        
    if(DEBUG) then
      destination:MarkToAll("Destination Point" .. heading .. ", " .. windSpeed .. ", " .. (27 - windSpeed))
    end
    
    if(self.tankerOnRecover == true and self.activeRecoveryTanker == nil) then
      self:LaunchTanker()
    end
    if(self.heloOnRecover == true and self.activeRecoveryHelo == nil) then
      --self:LaunchPlaneGuard()
    end
    self.activeRecoveryCycle = true
    local carrierLogic = self
    
    self.scheduler2, self.schedulerID2 = SCHEDULER:New( nil,
      function(foo)
        local notify = false
        local heading, windSpeed = carrierPos:GetWind(UTILS.FeetToMeters(40))
        heading = heading + 9 --to account for angle of landing deck and movement of the ship **was 7
        if heading > 360 then
          heading = heading - 360
        end
        if(heading ~= foo.carrierBRC) then 
          notify = true
        end
        
        foo:UpdateBRC(notify)
      end,
    {carrierLogic}, (((math.abs(carrierGroup:GetHeading() - heading) / 90) * 3.33) *60), 900)

    self.scheduler, self.schedulerID = SCHEDULER:New( nil,
      function(foo)
        foo:ResumeRoute()
        createMenus(carrierLogic)
      end,
    {carrierLogic}, ((((math.abs(carrierGroup:GetHeading() - heading) / 90) * 3.33) *60) +3600))
  end
  
  --make carrier turn back into wind, we'll see if this is needed
  function Carrier:UpdateBRC(announce)
    if(self.activeRecoveryCycle == false) then return false end
    local carrier = UNIT:FindByName(self.name)
    local carrierGroup = carrier:GetGroup()
    local carrierPos = carrier:GetCoordinate()
    local heading, windSpeed = carrierPos:GetWind(UTILS.FeetToMeters(40))
    heading = heading + 8 --to account for angle of landing deck and movement of the ship **was 7
    if heading > 360 then
      heading = heading - 360
    end
    self.carrierBRC = heading
    if(announce ~= nil and announce ~= false) then
      MESSAGE:New((carrier:Name() .. string.format( " is shifting BRC to: %3d (Deck is %3d)", (heading + magVarDeterminator()), ((heading + magVarDeterminator()) - 9))),30):ToCoalition(carrierGroup:GetCoalition())
    end
    windSpeed = UTILS.MpsToKnots(windSpeed)
    local speed = UTILS.KnotsToKmph(27 - windSpeed)
    local destination = carrierPos:Translate((speed * 1500), heading)
    if(DEBUG) then
      destination:MarkToAll("Destination Point" .. heading .. ", " .. windSpeed .. ", " .. (27 - windSpeed))
    end
    carrierGroup:RouteGroundTo(destination, speed, nil, 1)
    if(self.carrierTACAN ~= nil) then
      carrierGroup:SetCommand(setTACAN(self.carrierTACAN, carrier))
    end
    
    if(self.carrierICLS ~= nil) then
      carrierGroup:SetCommand(setICLS(self.carrierICLS, carrier))
    end
  end
  
  
  --Returns to the pre-created mission editor route while respecting elapsed waypoints
  function Carrier:ResumeRoute()
    if(self.scheduler ~= nil) then
      self.scheduler:Clear()
    end
    if(self.scheduler2 ~= nil) then
      self.scheduler2:Clear()
    end  
    local carrier = UNIT:FindByName(self.name)
    local carrierGroup = carrier:GetGroup()
    local waypoint = carrierGroup.currentWaypoint
    local cvRoute = carrierGroup:CopyRoute(waypoint,0)
    for x = 1, #cvRoute, 1 do
      local taskFunction = carrierGroup:TaskFunction( "calculateWaypoint")
      carrierGroup:SetTaskWaypoint(cvRoute[x], taskFunction)
    end
    self.activeRecoveryCycle = false
    carrierGroup:Route(cvRoute)
    if(self.carrierTACAN ~= nil) then
      carrierGroup:SetCommand(setTACAN(self.carrierTACAN, carrier))
    end
    if(self.carrierICLS ~= nil) then
      carrierGroup:SetCommand(setICLS(self.carrierICLS, carrier))
    end
    
    MESSAGE:New((carrier:Name() .. " is resuming pre-planned route"),60):ToCoalition(carrierGroup:GetCoalition())
    self.carrierBRC = nil
  end
  
  --request BRC and Pressure
  function Carrier:RequestBRC()
    local carrier = UNIT:FindByName(self.name)
    local carrierGroup = carrier:GetGroup()
    local heading = self.carrierBRC
    
    
    local pressure_hPa = carrier:GetCoordinate():GetPressure(0)
    local pressure_inHg = pressure_hPa * 0.0295299830714
    MESSAGE:New((carrier:Name() .. string.format( " BRC is: %3d (Deck is %3d),  QNH is:  %4.2f inHg", (heading + magVarDeterminator()), ((heading + magVarDeterminator()) - 9), pressure_inHg )),30):ToCoalition(carrierGroup:GetCoalition())
    if(self.carrierTACAN ~= nil) then
      local TACAN = self.carrierTACAN
      MESSAGE:New("TACAN is: " .. TACAN.number .. TACAN.letter,30):ToCoalition(carrierGroup:GetCoalition())
    end
    if(self.carrierICLS ~= nil) then
      local ICLS = self.carrierICLS
      MESSAGE:New("ICLS is: " .. ICLS,30):ToCoalition(carrierGroup:GetCoalition())
    end   
   
        --MESSAGE:New((carrier:Name() .. " BRC is " .. heading .. " QNH is " .. pressure_inHg),30):ToCoalition(carrierGroup:GetCoalition())
   
    
  end
  
  
  --launches recovery tanker
  function Carrier:LaunchTanker()
    if(self.tankerType == nil) then
      return false
    end
    local spawner = SPAWN:NewWithAlias(self.tankerType, (self.name .. " Recovery Tanker"))
    local tankerGroup = spawner:SpawnAtAirbase(AIRBASE:FindByName(self.name), SPAWN.Takeoff.Hot, nil)
    local route = {}
    local carrierGroup = UNIT:FindByName(self.name):GetGroup()
    local heading = UNIT:FindByName(self.name):GetHeading()
    local orbitPoint = tankerGroup:GetCoordinate()
    local orbitEndPoint = orbitPoint:Translate(UTILS.NMToMeters(5),heading)
    if(DEBUG) then
      orbitPoint:MarkToAll("Orbit Point 1: " .. timer.getTime())
      orbitEndPoint:MarkToAll("Orbit Point 2: " .. timer.getTime())
    end
    local orbit = { 
     id = 'Orbit', 
     params = { 
       pattern = AI.Task.OrbitPattern.RACE_TRACK,
       point = orbitPoint:GetVec2(),
       point2 = orbitEndPoint:GetVec2(),
       speed = UTILS.KnotsToMps(300),
       altitude = 2000
     } 
    }

    tankerGroup:SetTask( orbit, 10 )
    --tankerGroup:SetTaskWaypoint(route[#route], orbit)
    tankerGroup:PushTask( tankerGroup:EnRouteTaskTanker(), 11 )
    

    local tanker_ref , schedule_id = SCHEDULER:New (
      nil, 
      function (foo1, foo2)
        local heading = foo2:GetUnit(1):GetHeading()
        local orbitPoint = foo2:GetCoordinate()
        local orbitEndPoint= foo2:GetCoordinate():Translate(UTILS.NMToMeters(5),heading)
        
        if(DEBUG) then
          orbitPoint:MarkToAll("Orbit Point 1: " .. timer.getTime())
          orbitEndPoint:MarkToAll("Orbit Point 2: " .. timer.getTime())
        end
        local orbit2 = { 
          id = 'Orbit', 
          params = { 
            pattern = AI.Task.OrbitPattern.RACE_TRACK,
            point = orbitPoint:GetVec2(),
            point2 = orbitEndPoint:GetVec2(),
            speed = UTILS.KnotsToMps(300),
            altitude = 2000
          }
        }
        foo1:SetTask( orbit2, 10 )
        foo1:PushTask( tankerGroup:EnRouteTaskTanker(), 11 )
      end, 
      {tankerGroup, carrierGroup}, 
      600, 
      600
    )
    self.activeRecoveryTanker = tankerGroup
  end
  
  --orders tanker to RTB
  function Carrier:RecoverTanker()
    local group = self.activeRecoveryTanker
    --group:RouteRTB(AIRBASE:FindByName(self.name),nil)
    group:RouteRTB()
    self.activeRecoveryTanker = nil
  end
  
  function Carrier:LaunchPlaneGuard()
    if(self.heloType == nil) then
      return false
    end
    local spawner = SPAWN:NewWithAlias(self.heloType, (self.name .. " Plane Guard"))
    local guardGroup = spawner:SpawnAtAirbase(AIRBASE:FindByName(self.name), SPAWN.Takeoff.Hot, nil)
    local offset = POINT_VEC3:New(0,150,500)
    guardGroup:TaskFollow(UNIT:FindByName(self.name), offset, 1)
    self.activeRecoveryHelo = guardGroup
  end
  
  function Carrier:RecoverPlaneGuard()
    local group = self.activeRecoveryHelo
    group:RouteRTB()
    self.activeRecoveryHelo = nil
  end


  
  
  local function beginFlightOps(carrierLogic)
    carrierLogic:BeginFlightOps()
    createMenus(carrierLogic)
  end
  
  local function resumeRoute(carrierLogic)
    carrierLogic:ResumeRoute()
    createMenus(carrierLogic)
  end
  
  local function launchTanker(carrierLogic)
    carrierLogic:LaunchTanker()
  end
  
  local function recoverTanker(carrierLogic)
    carrierLogic:RecoverTanker()
  end
  
  local function requestBRC(carrierLogic)
    carrierLogic:RequestBRC()
  end
  -- MENU SHIT
  
  function createMenus(carrierLogic)
    if(carrierLogic.MenuManage ~= nil) then
      carrierLogic.MenuManage:Remove()
    end
  
    local carrier = UNIT:FindByName(carrierLogic.name)
    local carrierGroup = carrier:GetGroup()
    if carrierGroup and carrierGroup:IsAlive() then
      local coalition = carrierGroup:GetCoalition()
      carrierLogic.MenuManage = MENU_COALITION:New( coalition, "Manage " .. carrierGroup.GroupName)
      if(carrierLogic.activeRecoveryCycle == false) then
        local windMenu = MENU_COALITION_COMMAND:New( coalition, "Order Turn Into Wind", carrierLogic.MenuManage, beginFlightOps, carrierLogic)
      else
        MENU_COALITION_COMMAND:New( coalition, "Order Return to Route", carrierLogic.MenuManage, resumeRoute, carrierLogic)
        MENU_COALITION_COMMAND:New( coalition, "Request BRC", carrierLogic.MenuManage, requestBRC, carrierLogic)
        if(carrierLogic.activeRecoveryTanker == nil and carrierLogic.tankerType ~= nil) then
          MENU_COALITION_COMMAND:New( coalition, "Launch Recovery Tanker", carrierLogic.MenuManage, launchTanker, carrierLogic)
        end
      end
      if(carrierLogic.activeRecoveryTanker ~= nil) then
        MENU_COALITION_COMMAND:New( coalition, "Order Tanker RTB", carrierLogic.MenuManage, recoverTanker, carrierLogic)
      end
    end
  end  
  
  --[[function Carrier:CreateMenus()
    local carrier = self
    SCHEDULER:New( nil,
      function(foo)
        createMenus(foo)
     end, {carrier}, 0, 300 )
    end]]
  function createMenus(carrierLogic)
    if(carrierLogic.MenuManage ~= nil) then
      carrierLogic.MenuManage:Remove()
    end
  
    local carrier = UNIT:FindByName(carrierLogic.name)
    local carrierGroup = carrier:GetGroup()
    if carrierGroup and carrierGroup:IsAlive() then
      local coalition = carrierGroup:GetCoalition()
      carrierLogic.MenuManage = MENU_COALITION:New( coalition, "Manage " .. carrierGroup.GroupName)
      if(carrierLogic.activeRecoveryCycle == false) then
        local windMenu = MENU_COALITION_COMMAND:New( coalition, "Order Turn Into Wind", carrierLogic.MenuManage, beginFlightOps, carrierLogic)
      else
        MENU_COALITION_COMMAND:New( coalition, "Order Return to Route", carrierLogic.MenuManage, resumeRoute, carrierLogic)
        MENU_COALITION_COMMAND:New( coalition, "Request BRC", carrierLogic.MenuManage, requestBRC, carrierLogic)
        if(carrierLogic.activeRecoveryTanker == nil and carrierLogic.tankerType ~= nil) then
          MENU_COALITION_COMMAND:New( coalition, "Launch Recovery Tanker", carrierLogic.MenuManage, launchTanker, carrierLogic)
        end
      end
      if(carrierLogic.activeRecoveryTanker ~= nil) then
        MENU_COALITION_COMMAND:New( coalition, "Order Tanker RTB", carrierLogic.MenuManage, recoverTanker, carrierLogic)
      end
    end
  end  
  
  function Carrier:CreateMenus()
    local carrier = self
    SCHEDULER:New( nil,
      function(foo)
        createMenus(foo)
     end, {carrier}, 0, 300 )
  
  end

end




