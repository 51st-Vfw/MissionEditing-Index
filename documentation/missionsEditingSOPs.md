# Mission Editing Standard Operating Procedures

## TACAN Usage

TACAN frequencies in the mission should be assigned according to the following diagram.

![](https://github.com/51st-Vfw/MissionEditing-Index/documentation/images/TACAN_usage.png)

Channels marked "unavailable" or "degraded" should be avoided. Default assignments for
TACAN channels are detailed below and are consistent with these assignments.

## Default Comms Plan

For consistency, missions should follow the default comms plan to the extent possible. These
defaults are intended to support a wide range of missions. The comms plan is broken up into
two parts: air units and naval units. Note that ATC frequencies (tower, ground, ATIS, etc.)
are set according to the published charts for the airports in theater and are not shown here
as they depend on the specific configuration of the mission.

The following table lists the default comms plan for support and squadron aircraft.

|Usage|TACAN|Frequency|Notes|   |Usage|TACAN|Frequency|Notes|
|---|:---:|:---:|:---|---|---|:---:|:---:|---|
|Tactical Common|N/A|270.00|
|AWACS|N/A|240.00|
|**Tankers**|
|Texaco 1-1<br>*Boom*|51Y|251.00|FL250|    |Texaco 2-1<br>*Boom*|52Y|252.00|FL150
|Arco 1-1<br>*Probe & Drogue*|53Y|253.00|FL200|    |Arco 2-1<br>*Probe & Drogue*|54Y|254.00|FL210|
|**Squadrons / Flights**|
|Colt 1<br>*F-16C*|38Y<br>101Y|138.25||    |Uzi 1<br>*F-16C*|39Y<br>102Y|138.75||
|Enfield 1<br>*F/A-18C*|40Y<br>103Y|139.25||    |Springfield 1<br>*F/A-18C*|41Y<br>104Y|139.75||
|Dodge 1<br>*F-14B*|42Y<br>105Y|140.25||    |Dodge 2<br>*F-14B*|43Y<br>106Y|140.75||
|Hawg 1<br>*A-10C*|44Y<br>107Y|141.25||    |Pig 1<br>*A-10C*|45Y<br>108Y|141.75||
|Pontiac 1<br>*Helicopter, AV-8B*|46Y<br>109Y|142.25||    |Chevy 1<br>*Helicopter, AV-8B*|47Y<br>110Y|142.75||
|Ford 1<br>*F-15E*|48Y<br>110Y|143.25||    |Ford 2<br>*F-15E*|49Y<br>111Y|143.75||

The TACAN pairs in the squadrons indicate the A2A yardstick setup: the lead uses the lower channel
of the pair while the wingmen use the higher channel of the pair.

The following table lists the default comms plan for naval units.

|Hull|Ship|TACAN|Frequency|ICLS|
|---|---|:---:|:---:|---|
|LHA-1| USS *Tarawa*|64X|264.40|Ch. 1|
|CVN-70| USS *Carl Vinson*|70X|270.40|Ch. 10|
|CVN-71| USS *Theodore Roosevelt*|71X|271.40|Ch. 11|
|CVN-72| USS *Abraham Lincoln*|72X|272.40|Ch. 12|
|CVN-73| USS *George Washington*|73X|273.40|Ch. 13|
|CVN-74| USS *John C. Stennis*|74X|274.40|Ch. 14|
|CVN-75| USS *Harry S. Truman*|75X|275.40|Ch. 15|

Missions should make a summary of the of the comms plan that they implemenmt available on the
kneeboard.

**TODO**: kneeboard for default comms plan?

## Default Comms Ladder

Missions should configure the presets on radios in client aircraft with the default comms ladder
this section describes.

### A-10
TODO: No presets in ME?

### AV-8B
TODO: V/UHF #1 x26, V/UHF #2 x26, V/UHF RCS x30

### F-14
TODO: UHF (-159) x20, V/UHF (-182) x30

### F-16
TODO: UHF (-164) x20, VHF (-222) x20

|UHF Preset|Purpose|   |VHF Preset|Purpose|
|:---:|:---|---|:---:|:---|
|1|Tactical Common||1|Inter-flight

### F/A-18
TODO: COMM1 (-210) x20, COMM2 (-210) x20


## Misc
### Loadout references
- [Desert Storm Era](https://www.dstorm.eu/pages/loadout/loadout.html)
### Create a pull request!
    - Don't commit to master unless you are the main owner/delegated.

## Todo
- [] Add mids and tacan overlap documentation (don't mix the freqs!)
- [] Standard comms ladder per aircraft?



