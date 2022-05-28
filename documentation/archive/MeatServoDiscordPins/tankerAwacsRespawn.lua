local SpawnTanker1 = SPAWN
   :New( "BLUE-EW-Magic-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( magic1 )
	   magic1:CommandSetCallsign(2,1)
     end 
     )

local SpawnTanker2 = SPAWN
   :New( "Arco 1-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( arco1 )
	   arco1:CommandSetCallsign(2,1)
     end 
     )

local SpawnTanker3 = SPAWN
   :New( "Shell 1-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( shell1 )
	   shell1:CommandSetCallsign(3,1)
     end 
     )
	 
	 local SpawnTanker4 = SPAWN
   :New( "Arco 2-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( arco2 )
	   arco2:CommandSetCallsign(2,2)
     end 
     )
	 
local SpawnTanker5 = SPAWN
   :New( "Texaco 2-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( texaco2 )
	   texaco2:CommandSetCallsign(1,2)
     end 
     )
local SpawnTanker6 = SPAWN
   :New( "EW-AWACS-K-50-Group" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( awacs1 )
	   awacs1:CommandSetCallsign(3,1)
     end 
     )

local SpawnTanker7 = SPAWN
   :New( "Arco-2" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( arco3 )
	   arco3:CommandSetCallsign(2,1)
     end 
     )

local SpawnTanker8 = SPAWN
   :New( "Shell 2-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( shell4 )
	   shell4:CommandSetCallsign(3,1)
     end 
     )
	 
	 local SpawnTanker9 = SPAWN
   :New( "Shell 2" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( shell5 )
	   shell5:CommandSetCallsign(3,2)
     end 
     )
	 
local SpawnTanker10 = SPAWN
   :New( "Arco-1" )
   :InitLimit( 1, 99 )
   :InitCleanUp( 300 ) 
   :InitRepeatOnEngineShutDown()
   :InitKeepUnitNames()
   :SpawnScheduled( 15, 1 )
   :OnSpawnGroup(
     function( arco4 )
	   arco4:CommandSetCallsign(2,2)
     end 
     )
