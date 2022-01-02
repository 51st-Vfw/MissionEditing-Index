# 51st VFW MapSOP Script
## Overview
**MapSOP** is a MOOSE-based Lua script to assist with creation of [51st VFW SOP](https://github.com/51st-Vfw/MissionEditing-Index/blob/master/documentation/missionsEditingSOPs.md)-compliant missions.

**MapSOP** does the following:
* Deploys Tanker and AWACs flights that set radio frequencies, TACANs, altitude, and speed in accordance with 51st VFW SOPs. Orbit endpoints are defined by creating named trigger zones in the DCS Mission Editor. When the on-station Tanker/AWACS flights get low on fuel, a relief flight is automatically launched from the designated support airbase. When the relief flight arrives on-station, the original flight checks-out and RTBs.
* Sets the radio frequency and TACANS/ICLS for Aircraft Carriers, automatically loops the Carrier group's waypoints, and adds a radio F10 menu option to turn the carrier into the wind for launch and recovery operations.
* Automatically launches and maintains a Recovery Tanker, E-2 AWACS, and a Rescue Helicopter that position themselves relative to the Carrier Group. Tanker/AWACs use SOP Radio/TACAN/Altitude/Speed.
* Restarts Tanker/Carrier TACAN/ICLS beacons every 5 minutes to ensure they keep working. Also provides an F10 menu option to reset all TACANs on demand.

  ![Reset TACAN](images/ResetTACAN.png)
* Sets up the MOOSE [MANTIS](https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Functional.Mantis.html) (similar to Skynet) IADS for Red. Engaugement area can be limited by creating a trigger zone.

## Setup
*(Note: All Zone/Unit names are case-sensitive.)*
1. In the DCS Mission Editor Triggers menu, load the MOOSE include the _Moose.lua script with DO SCRIPT FILE on MISSION START: ![Load Moose Script with MISSION START Trigger](images/MOOSE-load.png)
2. Use the ONCE trigger with Time More condition to load the 51stMapSOP.lua after 5 seconds: ![Load 51stMapSOP.lua with ONCE Trigger](images/MapSOP-load.png)
3. **(OPTIONAL)** designate the home airbase for Tanker and AWACS flights be creating a Trigger Zone called `Support Airbase` over an airbase:

    ![Optionally create a trigger zone called 'Support Airbase'](images/SupportAirbase.png)

    If no 'Support Airbase' Trigger Zone is designated, a default will be used based on the map:
    | **Map**          | **Default Support Airbase** |
    | ---------------- | --------------------------- |
    | Caucasus         | Batumi                      |
    | Mariana Islands  | Andersen                    |
    | Nevada           | Nellis                      |
    | Syria            | Incirlik                    |
    | Persian Gulf     | Al Dhafra                   |
4. Enable Tanker and AWACS flights by creating two Trigger Zones for each desired flight to mark the racetrack endpoints. The Trigger Zones should start with the callsign of the flight, and end with -P1 and -P2, for example **Texaco1-P1** and **Texaco2-P2** -- see the following table for the list of supported flights:
    | **Flight**       | **Type**                    | **Point 1**  | **Point 2**  |
    | ---------------- | --------------------------- | ------------ | ------------ |
    | Texaco1          | Boom Tanker for F-16s       | Texaco1-P1   | Texaco1-P2   |
    | Texaco2          | Boom Tanker for A-10s       | Texaco1-P1   | Texaco1-P2   |
    | Arco1            | Probe & Drogue Tanker       | Arco1-P1     | Arco1-P2     |
    | Arco2            | Probe & Drogue Tanker       | Arco2-P1     | Arco2-P2     |
    | Overlord1        | AWACS                       | Overlord1-P1 | Overlord1-P2 |

    ![Create Trigger Zones to designate Tanker/AWACs Orbits](images/OrbitPoints.png)
5. To add Aircraft Carrier support, name the carrier **unit** with the hull number of the carrier, for example `CVN-75`.  The Tarawa `LHA-1` is supported for TACAN only.  This will set up Radio, TACAN, and ICLS for the carrier, loop the waypoints of the carrier group, and launch recovery tanker, AWACS, and rescue helicopter flights around the carrier group.  This will also enable an Radio F10 menu option to turn the carrier into the wind for takeoff and recovery.
 
    ![Name the carrier unit with the carrier hull number](images/CarrierUnit.png)
    ![Carrier wind turn menu](images/WindTurn.png)

6. MANTIS IADS:
    1. **(OPTIONAL)** Create a Trigger Zone called `Red IADS` to designate a Zone that limit where the IADS network will consider targets for engaugement.

        ![Optionally create a 'Red IADS' zone](images/RedIADS.png)

    2. Name Red early warning radar groups with a name starting with `Red EWR`:

        ![Give Red EWR groups names starting with 'Red EWR'](images/RedEWR.png)

    3. Name Red SAM groups a name starting with `Red SAM`, and include the name of the SAM system (on SAM system type per group). Valid SAM system names are as follows *(case sensitive)*:
        * Avenger
        * Chaparrel
        * Hawk
        * Linebacker
        * NASAMS
        * Patriot
        * Rapier
        * Roland
        * SA-2, SA-3, SA-5, SA-6, SA-7, SA-8, SA-9, SA-10, SA-11, SA-13, SA-15, SA-19
    
        Short-range systems like the SA-15 or SA-19 will automatically work as SHORAD point defense if positoned near other SAM groups.

        ![Give Red SAM groups names starting with 'Red SAM' and include the SAM system name](images/RedSAMSA-10.png)