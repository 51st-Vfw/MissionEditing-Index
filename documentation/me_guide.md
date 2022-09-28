# Mission Editing

This section provides general information on mission editing, such as helpful documentation or
frameworks, for mission designers.

## ED Documentation

ED API documentation can be found in your DCS installation at

```
API/DCS_ControlAPI.html
```

For example,

```
file:///C:/Program Files/Eagle Dynamics/DCS World OpenBeta/API/DCS_ControlAPI.html
```
## Hoggit ED Reference

The [Hoggit Wiki](https://wiki.hoggitworld.com/view/Hoggit_DCS_World_Wiki#Mission_Making) is a
good source of general information on mission making and scripting.

## Workflow

Several 51st VFW templates and missions adopt a workflow intended to help smooth over the rough
edges of the DCS Mission Editor when it comes to scripting. A description of the workflow is
available
[here](https://github.com/51st-Vfw/template-missions/blob/master/NTTR%20Base%20Scripting/workflow.md).

# Frameworks

There are several frameworks that are useful for mission designers.

## MOOSE

One of the most widely used frameworks in DCS is MOOSE, available on Github
[here](https://github.com/FlightControl-Master/MOOSE/). MOOSE provides an object-oriented
wrapper around base DCS scripting engine functionality and implements a great deal of additional
functionality. Documentation for the framework is available
[here](https://flightcontrol-master.github.io/MOOSE_DOCS/).

To use MOOSE, reference the starter guide, but typically it's just download MOOSE and include.
A [starter's guide](https://flightcontrol-master.github.io/MOOSE_DOCS/Moose_Starters_Guide.html)
is available from the developers as well.

Generally, the MOOSE Lua needs to be included in the `.miz`, so client usage should not require
an install. Many of the 51st VFW
[template missions](https://github.com/51st-Vfw/template-missions) are setup for MOOSE.

## MIST

TODO

# Scripts

## Skynet

[IADS](https://github.com/walder/Skynet-IADS)

