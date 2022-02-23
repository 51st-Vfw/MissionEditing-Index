# Mission Editing Standard Operating Procedures

This section covers a number of SOPs mission designers should employ around mission elements
such as communications, navigation, and operational support. These SOPs are built around the
airframes the 51st VFW currently supports: A-10C, AV-8B, F-14B, F-15E (soon), F-16C, F/A-18C,
and various helicopter airframes.

Missions should follow the SOPs where possible and practical to provide consistency across
51st VFW missions. That being said, mission designers may deviate from these guidelines
where necessary due to the specific mission scenario.

## TACAN Usage Guidelines

TACAN channels in the mission should be assigned according to the following diagram.

![](images/TACAN_usage.png)

Channels marked "unavailable" or "degraded" should be avoided. Default assignments for
TACAN channels are detailed below in the discussion of the communications plan and are
consistent with these assignments.

## Tanker Altitude and Airspeed Guidelines
This thread from the [ED DCS Forums](https://forums.eagle.ru/topic/260542-looking-for-actualrecommened-aerial-refueling-speeds/)
discusses tanker altitude and airspeed guidelines for AAR units based on the the KC-135
airframe. The following table summarizes the guidelines relevant to the airframes the 51st
VFW operates.

|Airframe|Speed (KIAS)|Altitude|Notes|
|---|:---:|:---:|---|
|AV-8B|275|FL150-FL200|
|A-10C|220|FL150|
|F-14B|275-285|FL300|Source has no data, assumed to match F/A-18C
|F-16C|315|FL300|
|F/A-18C|275-285|FL300|

The 51st VFW SOPs track these guidelines with some adjustments as our missions may use
airframes other than the KC-135 for AAR tasking or perfer different altitudes.

The following table lists the full set of tankers that might be found in a mission along with
the default altitude and airspeeds the 51st VFW SOPs assume. A specific mission need not
provide all of these tankers and may deviate from these speeds (though missions should attempt
to provide speeds with 10-20kt of these speeds). As the DCS Mission Editor specifies route
speeds using ground speed, not KIAS, the following table lists the ground speeds necessary in
the DCS Mission Editor to achieve the default KIAS at the default altitude in calm conditions.

|Tanker|Airframes|Altitude|Speed (KIAS)|Speed (GS, ME)|Purpose|
|---|:---:|:---:|:---:|:---:|---|
|KC-135|F-16C|FL250|300|475|Boom, High Speed
|KC-135|A-10C|FL150|220|276|Boom, Low Speed
|KC-135 MPRS|AV8-B, F-14B, F/A-18C|FL200|285|384|Probe & Drogue
|KC-135 MPRS|AV8-B, F-14B, F/A-18C|FL210|285|388|Probe & Drogue
|S-3B Tanker|AV8-B, F-14B, F/A-18C|6000 MSL|285|309|Carrier

Keep in mind that ground speed may change based on altitude or other factors and may need to be
adjusted accordingly in the mission editor based on the specific scenario.

## Default Communications Plan

For consistency, missions should follow the default comms plan wherever possible. While these
defaults can support a wide range of missions, missions may deviate based on their specific
needs. Generally, the communications plan uses uniform for cross-wing communication and victor
for communication within a flight.

The following sections focus on specific pieces of the overall comms plan.

### ATC Frequencies

ATC frequencies (tower, ground, CTAF, ATIS, etc.) are set according to the published charts
for the airports in theater. Where published charts are unavailable, a mission may fill in
any missing frequencies as it sees fit.

A mission may elect to use modules such as [DATIS](https://github.com/rkusa/DATIS) to support
ATC communications.

### Support Elements

Support elements include the tactical common frequency as well as AWACS and JTAC/AFAC units
that may be present in a mission. The following table summarizes the standard communications
plan for these elements.

|Element|Frequency|Notes|   |Element|Frequency|Notes|
|---|:---:|:---|---|---|:---:|---|
|Tactical Common|270.00|Player AWACS/GCI
|Overlord 1-1<br>*AWACS*|240.00|FL300<br>AI| |Magic 1-1<br>*Carrier AWACS*|241.00|FL280<br>AI
|Darknight 1-1<br>*JTAC*|138.00|AI| |Various<br>*JTAC/AFAC*|138.10|Player

The frequencies are selected to support both human and AI in AWACS and JTAC/AFAC roles. For
AWACS/GCI, a mission that uses a human in the role would place the AWACS/GCI on the tactical
common frequency. Placing any AI AWACS/GCI on different frequencies prevents the AI from flooding
the radio. A mission that relies on only AI AWACS/GCI would place the tactical common frequncy
on one of the AWACS/GCI frequencies.

### AAR Tankers

Given the tanker airspeed and altitude guidelines listed above, the SOPs include a basic set
of AAR tanker resources that should be sufficient for many missions. The SOPs use standard
flight names to differentiate the different taker airframes,

- *Texaco* flights support Air Force units (KC-135, boom, land-based), these flights may be
  low speed (for use by A-10C units) or high speed (for use by F-16C units)
- *Arco* flights support Navy units (KC-135 MPRS, probe & drogue, land-based)
- *Shell* flights support carrier recovery for Navy units (S-3B, probe & drogue,
  carrier-based)

Missions may support additional airframes (for example, KC-130), should follow the flight
naming conventions in the SOP. The following table summarizes the standard communications plan
for tankers supporting AAR.

|Tanker|TACAN|Frequency|Notes|   |Tanker|TACAN|Frequency|Notes|
|---|:---:|:---:|:---|---|---|:---:|:---:|---|
|Texaco 1-1<br>*Boom*|51Y|251.00|FL250<br>300KIAS|    |Texaco 2-1<br>*Boom*|52Y|252.00|15000 MSL<br>220KIAS
|Arco 1-1<br>*Probe & Drogue*|53Y|253.00|FL200<br>285KIAS|    |Arco 2-1<br>*Probe & Drogue*|54Y|254.00|FL210<br>285KIAS|
|Shell 1-1<br>*Carrier Recovery*|55Y|255.00|6000 MSL<br>285KIAS|

To eliminate some complexity, tanker TACAN channel and frequencies should be related as shown
in the table above (that is, frequency is always 200 + TACAN channel).

As missions may require additional tankers, the SOPs set aside TACAN channels 55Y through 63Y
(along with their associated frequencies 255.0, 256.0, etc.) for use by additional tankers.

### Flights & Airframes

The SOPs include a base set of airframes that includes at least one flight from all of the
currently active airframes. Based on its needs, missions may change the airframes for a
particular flight while keeping the inter-flight frequency and TACAN channels. The following
table summarizes the standard communications plan for the wing for the base set of airframes.

|Flight / Arirframe|TACAN|Frequency|   |Flight / Arirframe|TACAN|Frequency|
|---|:---:|:---:|---|---|:---:|:---:|
|Colt 1<br>*F-16C*|38Y<br>101Y|138.25|    |Uzi 1<br>*F-16C*|39Y<br>102Y|138.75|
|Enfield 1<br>*F/A-18C*|40Y<br>103Y|139.25|    |Springfield 1<br>*F/A-18C*|41Y<br>104Y|139.75|
|Dodge 1<br>*F-14B*|42Y<br>105Y|140.25|    |Dodge 2<br>*F-14B*|43Y<br>106Y|140.75|
|Hawg 1<br>*A-10C*|44Y<br>107Y|141.25|    |Pig 1<br>*A-10C*|45Y<br>108Y|141.75|
|Pontiac 1<br>*Helicopter, AV-8B*|46Y<br>109Y|142.25|    |Chevy 1<br>*Helicopter, AV-8B*|47Y<br>110Y|142.75|
|Ford 1<br>*F-15E*|48Y<br>110Y|143.25|    |Ford 2<br>*F-15E*|49Y<br>111Y|143.75|

The TACAN pairs in this table describe the A2A yardstick setup: the lead uses the lower
numbered channel of the pair while the wingmen use the higher numbered channel of the pair.

Specific missions may choose different flight names as required. When deviating from the SOP
though, please avoid changes that may create confusion. For example, an F-16C flight could use a
name such as "Venom" or "Lobo" that is not listed here; however, it should not use a name such as
"Enfield" or "Hawg" that is typically associated with a different airframe in the SOPs.

### Naval Units

Missions may include naval units for the launch and recovery of aircraft in the mission. The
following table lists the default comms plan for naval units.

|Hull|Ship|TACAN|Frequency|ICLS|
|---|---|:---:|:---:|---|
|LHA-1| USS *Tarawa*|64X|264.40|Ch. 1|
|CVN-70| USS *Carl Vinson*|70X|270.40|Ch. 10|
|CVN-71| USS *Theodore Roosevelt*|71X|271.40|Ch. 11|
|CVN-72| USS *Abraham Lincoln*|72X|272.40|Ch. 12|
|CVN-73| USS *George Washington*|73X|273.40|Ch. 13|
|CVN-74| USS *John C. Stennis*|74X|274.40|Ch. 14|
|CVN-75| USS *Harry S. Truman*|75X|275.40|Ch. 15|

### Kneeboards

Missions are encouraged to make a summary of the of the comms plan that they implemenmt
available on a kneeboard.

**TODO**: kneeboard for default comms plan?

## Default Comms Ladder

Missions should configure the presets on radios in client aircraft with the default comms ladder
this section describes.

### A-10C
TODO: No presets in ME?

### AV-8B
TODO: V/UHF #1 x26, V/UHF #2 x26, V/UHF RCS x30

### F-14B
TODO: UHF (-159) x20, V/UHF (-182) x30

### F-16C
TODO: UHF (-164) x20, VHF (-222) x20

|UHF Preset|Purpose|   |VHF Preset|Purpose|
|:---:|:---|---|:---:|:---|
|1|Tactical Common||1|Inter-flight

### F/A-18C
TODO: COMM1 (-210) x20, COMM2 (-210) x20


## Miscellaneous
### Loadout references
- [Desert Storm Era](https://www.dstorm.eu/pages/loadout/loadout.html)
### Create a pull request!
    - Don't commit to master unless you are the main owner/delegated.

## TODO
- [] Add mids and tacan overlap documentation (don't mix the freqs!)
- [] Standard comms ladder per aircraft?



