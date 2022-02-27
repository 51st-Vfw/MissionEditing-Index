# 51st VFW MapSOP Script
## Overview
**51st MapSOP** is a MOOSE-based Lua script to assist with creation of [51st VFW SOP](https://github.com/51st-Vfw/MissionEditing-Index/blob/master/documentation/missionsEditingSOPs.md)-compliant missions.

**MapSOP** does the following:
* Deploys Tanker and AWACs flights that set radio frequencies, TACANs, altitude, and speed in accordance with 51st VFW SOPs. Orbit endpoints are defined by creating named trigger zones in the DCS Mission Editor. When the on-station Tanker/AWACS flights get low on fuel, a relief flight is automatically launched from the designated support airbase. When the relief flight arrives on-station, the original flight checks-out and RTBs.
* Sets the radio frequency and TACANS/ICLS for Aircraft Carriers, automatically loops the Carrier group's waypoints, and adds a radio F10 menu option to turn the carrier into the wind for launch and recovery operations.
* Automatically launches and maintains a Recovery Tanker, E-2 AWACS, and a Rescue Helicopter that position themselves relative to the Carrier Group. Tanker/AWACs use SOP Radio/TACAN/Altitude/Speed.
* Restarts Tanker/Carrier TACAN/ICLS beacons every 5 minutes to ensure they keep working. Also provides an F10 menu option to reset all TACANs on demand.

  ![Reset TACAN](images/ResetTACAN.png)
* Sets up the [MOOSE MANTIS](https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Functional.Mantis.html) or [Skynet](https://github.com/walder/Skynet-IADS) IADS networks for Red. With MANTIS, engaugement areas can be defined by creating appropriately named trigger zones.

## Setup
***(Note: All Zone/Unit names are case-sensitive.)***
1. In the DCS Mission Editor Triggers menu, load the MOOSE include the _Moose.lua script with DO SCRIPT FILE on MISSION START: ![Load Moose Script with MISSION START Trigger](images/MOOSE-load.png)
2. **(OPTIONAL)** If you wish to use **Skynet** instead of MOOSE's **MANTIS** for IADS, load the MIST and *Skynet* scripts from the [Skynet Github Repo](https://github.com/walder/Skynet-IADS) under *'demo-missions'* as shown: 

    ![Load MIST/Skynet Scripts with MISSION START Trigger](images/SKYNET-load.png)

3. Use the ONCE trigger with Time More condition to load the 51stMapSOP.lua after 5 seconds: ![Load 51stMapSOP.lua with ONCE Trigger](images/MapSOP-load.png)
4. **(OPTIONAL)** designate the home airbase for Tanker and AWACS flights be creating a Trigger Zone called `Support Airbase` over an airbase:

    ![Optionally create a trigger zone called 'Support Airbase'](images/SupportAirbase.png)

    If no 'Support Airbase' Trigger Zone is designated, a default will be used based on the map:
    | **Map**          | **Default Support Airbase** |
    | ---------------- | --------------------------- |
    | Caucasus         | Batumi                      |
    | Mariana Islands  | Andersen                    |
    | Nevada           | Nellis                      |
    | Syria            | Incirlik                    |
    | Persian Gulf     | Al Dhafra                   |
5. Enable Tanker and AWACS flights by creating two Trigger Zones for each desired flight to mark the racetrack endpoints. The Trigger Zones should start with the callsign of the flight, and end with -P1 and -P2, for example **Texaco1-P1** and **Texaco2-P2** -- see the following table for the list of supported flights:
    | **Flight**       | **Type**                    | **Point 1**  | **Point 2**  |
    | ---------------- | --------------------------- | ------------ | ------------ |
    | Texaco1          | Boom Tanker for F-16s       | Texaco1-P1   | Texaco1-P2   |
    | Texaco2          | Boom Tanker for A-10s       | Texaco1-P1   | Texaco1-P2   |
    | Arco1            | Probe & Drogue Tanker       | Arco1-P1     | Arco1-P2     |
    | Arco2            | Probe & Drogue Tanker       | Arco2-P1     | Arco2-P2     |
    | Overlord1        | AWACS                       | Overlord1-P1 | Overlord1-P2 |

    ![Create Trigger Zones to designate Tanker/AWACs Orbits](images/OrbitPoints.png)
6. **(OPTIONAL)** SOP flight parameters can be overridden by adding them to to the -P1 Trigger zone for a callsign, for example, a Trigger Zone named `Texaco1-FL230-P1` in conjunction with a `Texaco-P2` Trigger Zone will create a Texaco1 tanker flight according to the SOP, **except** that the altitude will be overridden to 23k feet.

    The speed and altitude allow for a special additional syntax that allows adding lowercase  **p** (plus/addition) or **m** (minus/subtraction) immediately after **FL** or **SP** to add or subtract from the SOP values.  For example, a trigger zone named `Texaco1-FLp30-SPm50-P1` would override the speed and altitude SOP values for Texaco1 by adding (**p**) 3k feet to the SOP altitude, and subtracting (**m**) 50 knots from its orbit speed.

    Consult the table below for the complete list of SOP override paramters:
    | **Parameter**           | **Notation** | **Example**               | **Effect**                                           |
    |-------------------------|--------------|---------------------------|------------------------------------------------------|
    | Flight SOP base template|T***n***      |Texaco2-T***1***-P1        |Override all SOP values to those of Texaco***1***     |
    | Orbit Altitude          |FL***n***     |Texaco1-FL***230***-P1     |Override Texaco1 orbit altitude to 23k feet           |
    | Increase Orbit Altitude |FLp***n***    |Texaco1-FLp***30***-P1     |Increase Texaco1 orbit altitude by 3k feet from SOP   |
    | Decrease Orbit Altitude |FLm***n***    |Texaco1-FLm***30***-P1     |Decrease Texaco1 orbit altitude by 3k feet from SOP   |
    | Orbit Speed             |SP***n***     |Texaco1-SP***400***-P1     |Override Texaco1 orbit speed to 300 knots             |    
    | Increase Orbit Speed    |SPp***n***    |Texaco1-SPp***50***-P1     |Increase Texaco1 orbit altitude by 50 knots           |
    | Decrease Orbit Speed    |SPm***n***    |Texaco1-SPm***50***-P1     |Decrease Texaco1 orbit altitude by 50 knots           |
    | Set Radio Frequency     |FR***nnn.nn***|Texaco1-FR***FR256.00***-P1|Override Texaco1 radio setting to 256.00 MHz AM       |
    | Set TACAN Freq/Band     |TC***nnY***   |Texaco1-TC***56Y***-P1     |Override Texaco1 TACAN to 56Y                         |
    | Make invisible to AI    |INV           |Texaco1-INV-P1             |Makes Texaco1 invisible to the AI                     |
    | Limit available flights |QTY***n***    |Texaco1-QTY***4***         |Limits Texaco1 to ***4*** spawns during the mission   |

7.  **(OPTIONAL)** Additional flights beyond those specified in the SOP can be created by specifying additional -P1 and -P2 trigger with a name cooresponding to the callsign of the new flight. All values will default to the SOP settings of the **1** callsign with the same name (Texaco1/Acro1/Shell1/Overlord1/Magic1).  

    ***NOTE:** Additional Shell/Magic callsigns will operate from the land airbase using -P1 and -P2 endpoints instead of following the carrier.*

    The -T***N***- SOP parameter can be used to default to the SOP values from another flight, see the table above.

    To avoid collisions with SOP values, parameter overrides should be used to override relevant SOP settings. For example, a Texaco3 flight might be created using the following -P1 Trigger Zone (and an accompanying **Texaco3-P2** Trigger Zone):
        Texaco3-T2-FLp10-SP375-FR256.0-TC56Y-P1

    This creates a 'Texaco3' tanker flight starting with the Texaco2 SOP values, but lowers orbit altitude by 1000 feet, sets orbit speed to 375 knots, sets the radio to 256.0 MHz, and sets TACAN to 56Y.

8. To add Aircraft Carrier support, name the carrier **unit** with the hull number of the carrier, for example `CVN-75`.  The Tarawa `LHA-1` is supported for TACAN only.  This will set up Radio, TACAN, and ICLS for the carrier, loop the waypoints of the carrier group, and launch recovery tanker, AWACS, and rescue helicopter flights around the carrier group.  This will also enable an Radio F10 menu option to turn the carrier into the wind for takeoff and recovery.
 
    ![Name the carrier unit with the carrier hull number](images/CarrierUnit.png)
    ![Carrier wind turn menu](images/WindTurn.png)

9. IADS:

    1. Name Red SAM groups a name starting with `Red SAM`, and if using *MANTIS* (Skynet not loaded) include the name of the SAM system (one SAM system type per group). Valid SAM system names for *MANTIS* are as follows *(case sensitive)*:
        * Avenger
        * Chaparrel
        * Hawk
        * Linebacker
        * NASAMS
        * Patriot
        * Rapier
        * Roland
        * SA-2, SA-3, SA-5, SA-6, SA-7, SA-8, SA-9, SA-10, SA-11, SA-13, SA-15, SA-19
    
        With *MANTIS*, short-range systems like the SA-15 will automatically work as SHORAD point defense if positoned near other SAM groups.

        ![Give Red SAM groups names starting with 'Red SAM' and include the SAM system name](images/RedSAMSA-10.png)

        ***NOTE:*** If no groups includes the name `Red SAM`, no IADS system will be initialized to save server resources. 

    2. Name Red early warning radar groups with a name starting with `Red EWR`:

        ![Give Red EWR groups names starting with 'Red EWR'](images/RedEWR.png)

    3.  **(OPTIONAL)** If using *Skynet*, you can configure point defense units by adding a `DO SCRIPT` (or `LOAD SCRIPT FILE`) action after loading `51stMapSOP.lua` that assigns a point defense group to a SAM or EWR -- the *Skynet* object is called `RedIADS`:
        ```lua
        --first get the SAM site you want to use as point defence from the IADS:
        local sa15 = RedIADS:getSAMSiteByGroupName('RED SAM SA-15-1')
        --then add it to the SAM site it should protect:
        RedIADS:getSAMSiteByGroupName('RED SAM SA-10-1'):addPointDefence(sa15)
        ```
        ![DO SCRIPT to load Skynet PD setup code](images/Skynet-PD.png)
    
    4. **(OPTIONAL)** If using *MANTIS* (*Skynet* has not not loaded), you may create Trigger Zones starting with `Red IADS Accept`, `Red IADS Reject`, or `Red IADS Conflict` to designate *MANTIS* Accept, Reject, or Conflict Zones that limit where the IADS network will consider targets for engaugement. Reference the [MANTIS](https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Functional.Mantis.html##(MANTIS).AddZones) documentation for details.

    5. **(OPTIONAL)** If you want a Red AWACS unit to act as a EWR, name the AWACS group `Red EWR AWACS`.

---

## Version History

*Version 20220101.1*
* Blackdog initial version

*Version 20220115.1*
* Fix: Tanker speeds adjusted to be close KIAS from SOP + better starting altitudes.

*Version 20220123.1*
* Fix: Unit orbit endpoints longer offset from orbit endpoint zone locations.
* Fix: Carriers/LHA now set their assigned radio frequencies.
* Fix: Tankers/AWACs relief launched at 25-35% fuel instead of testing value of 80-90%.
* Allow 'extra' Tankers/AWACS flights not in SOP to be spawned via Trigger Zones.
* Allow limiting the number of Tankers/AWACS spawns per flight via -P1 Zone name parameters.
* Allow override of SOP parameters via -P1 Zone name parameters.
* Allow relative adjustment of SOP FL/Airspeed via -P1 Zone name parameters.
* Allow setting Tanker/AWACS invisible via -P1 Zone name parameter.
* IADS completely disabled if no group names with 'Red SAM'.

*Version 20220213.1*
* No carrier F10 menu without a carrier.

*Version 20220221.1*
* Package MOOSE devel from 2022-02-21 for DCS NTTR Airport name changes.

*Version 20220227.1*
* Add Carrier STC/TACAN/ICLS info to comms/F10 carrier menu.

### Known issues:
* Tankers/AWACs airspawn at 0 velocity; to compensate units spawn at 15k feet above target altitude to prevent terrain collisions.
* Extra Non-SOP Shell/Magic units act like land-based Tankers/AWACS.
