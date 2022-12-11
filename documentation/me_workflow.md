# Mission Editing and Packaging Workflow

_Version: 2.0.1 of 24-Sep-22_

> The workflow builds on the [VEAF](https://github.com/VEAF) mission creation and conversion
> tools, using some of the VEAF scripts along with techniques borrowed from VEAF and previous
> 51st VFW workflows.

This document describes a directory structure and workflows for mission editing that supports
packaging missions and associated materials. As of DCS 2.7, the handling of assets such as
external Lua scripts or kneeboards in the DCS Mission Editor (DCS ME) is clumsy, at best;
and hostile, at worst. This workflow attempts to help make that less painful.

The workflow is based on a set of Windows `cmd.exe` scripts. Internally, these scripts may
invoke Lua scripts to perform some operations though this is transparent to the user.
Generally, when using the workflow, you will need to have a `cmd.exe` shell running.

> Using all capabilities of the workflow requires some basic familiarity with programming
> and scripting concepts.

A mission template set up for the workflow is available through the 51st VFW `git` repository
at
[51st VFW Mission Templates](https://github.com/51st-Vfw/MissionEditing-Templates).
For those not familiar with `git`, a `.zip` file with the template is available at
[TODO](TODO).
The templates support all of the maps currently active in the wing.

# Quick Start Guide

To use the workflow,

- Install `7-zip`, `Lua`, and (optional) `ImageMagick` tools, see
  [Before Using the Workflow](#Before-Using-the-Workflow)
  for further details.
- Copy the entire `VFW51_Core_Mission` directory to where you store your missions and rename it
  to match the name of your mission. The path to this directory, the "mission directory", should
  contain only alphanumeric, "-", and "_" characters.
- Start `cmd.exe` and change directories to the mission directory you created in the previous
  step.
- If you are creating a new mission, run "`scripts\setup.cmd --map <map>`" where `<map>` is
  either "CAU" (Caucuses), "MAR" (Marianas), "NTTR" (NTTR), "PG" (Persian Gulf), or "SYR"
  (Syria) depending on the map your mission uses, see
  [Creating a Mission That Uses the Workflow](#Creating-a-Mission-That-Uses-the-Workflow).
- Run `scripts\build.cmd` to rebuild the mission and synchronize the mission directory with the
  `.miz` package, see
  [Basic Concepts and Operation](#Basic-Concepts-and-Operation).
  Generally, you should do this every time you make changes to the mission.

It is worth reading on, the wokflow can do a lot more than you can describe in a paragraph or
two...

# Workflow Capabilities

The workflow supports mission designers by providing better management of external mission
resources, such as scripts or kneeboards, by providing automation to setup of properties like
radio presets or waypoints across multiple units, and providing better integration with
source control systems to allow more efficient collaboartion.

The workflow assmebles a `.miz` file for the mission from the associated source files. In
addition, it supports the automatic generation of mission variants that differ from the base
mission in DCS mission options (such as dot labels or F10 map setup), weather, or time of day.

During assembly, the workflow can make edits to internal mission state on a unit or group
basis. This allows for easier setup of radio presets or mission steerpoints without requiring
the mission designer to make the same edits to numerous units or groups in the mission. In
addition, the workflow supports dynamic generate of kneeboards, such as comms cards, that
reflect mission setup and can automatically change as the setup changes.

During mission development, the workflow allows a mission to be built in a "dynamic"
configuration that allows mission scripts to be edited in an IDE outside of the mission
editor without requiring a rebuild of the mission package. This can streamline development by
eliminating the need to repackage the `.miz` every time a script changes.

Finally, the workflow represents missions in a format that works efficiently with source
control systems such as GitHub. This enables better collaboration between mission designers
while preventing the need to place the raw `.miz` files under source control.

# Before Using the Workflow

The 51st VFW workflow require several tools to support its operation. The tools, their
locations on the web, and their purpose are,

- [7-zip](https://www.7-zip.org/download.html)
  packs and unpacks a DCS `.miz` file. The workflow has been tested with 7-zip 21.07.
- [Lua](https://sourceforge.net/projects/luabinaries/files/5.4.2/Tools%20Executables/)
  runs some of the internal scripts the workflow uses to process missions. The workflow
  has been tested with Lua 5.4.2.
- [ImageMagick](https://imagemagick.org/script/index.php)
  processes image files for use in dynamic kneeboard construction. ImageMagick is only needed
  if you are generating kneeboards dynamically based on mission content. The workflow has been
  tested with ImageMagick 7.1.0-46 Q16-HDRI x64.

Each of these tools must appear in the system or user `PATH` environment variable for the
workflow to operate correctly (see below). In addition to these tools that the workflow
directly uses, you may also want to install,

- [Visual Studio Code](https://code.visualstudio.com/) is an IDE that supports Lua
  development. You should also install the Lua plug-in from VSC to get syntax checking
  and other nice things.
- [GitHub](https://desktop.github.com/) is a desktop `git` client to allow access to
  the 51st VFW repositories and enable collaboration between multiple designers on a
  shared mission.

While specific versions are called out here, installing more recent versions should be fine.

The 7-zip and Lua programs linked above are not packaged with Windows installers and must be
installed manually. Typically, you can extract the downloaded files to a directory such as
`C:\Program Files\<tool>` or equivalent. You will need to manually add the install paths to
the `PATH` environment variable (Google can get you instructions based on the version of
Windows you are running). ImageMagick is packaged with a Windows installer that will handle
`PATH` setup for you. Make sure to check the "Add to PATH" option during install to add the
appropriate directory to your `PATH`.

# Mission Directories

The workflow operates in a _Mission Directory_ that contains all of the files related to the
mission, including source, scripts, internal `.miz` files, etc. A mission directory has the
same name as the base mission. For example, the mission directory for a mission
`Breaking_Bad.miz` would be `C:\Users\Raven\DCS_miz\Breaking_Bad`. Due to scripting
limitations, the full path to a mission directory should only contain alphanumeric,
"-", and "_" characters. For example, `C:\Users\Raven\DCS Missions\Reactor #5 Strike` is not
a valid mission directory name.

> Just keep paths to alphanumeric, "-", and "_" characters, and we'll all be happy.

The top level of a mission directory contains the following directories,

- `backup\` holds backups of the previous version of the `.miz` files generated by a mission
  build.
- `docs\` holds optional mission-related support documentation such as briefing material.
- `build\` holds temporary build products and files during mission construction.
- `scripts\` holds the Windows `.cmd` and Lua `.lua` scripts that support the workflow.
- `src\` holds the source files that make up the mission. This includes user-generated files
  (e.g., Lua scripts, kneeboards) along with `.miz` internal DCS ME files.

In addition to these directories, the top level of the mission directory typically contains a
`README` file and a number of packaged `.miz` files that provide different variants of the
base mission.

Mission files are named `<mission_name>[-<variant>].miz` where the "base" mission does not
include `[-<variant>]`. In the mission name, `[-<variant>]` is the name of an optional
automatically-generated "variant" of the base mission that differs from the base mission in
weather, time of mission, or mission options.

# Creating a Mission That Uses the Workflow

There are two ways to set up a mission that uses with the 51st VFW workflow: create the
mission from a 51st VFW mission template or transition an existing mission to use the
workflow.

## Initial Setup

In either approach, you will start by making a copy of the `VFW51_Core_Mission` directory. You
can find this directory in the
[51st VFW Mission Templates](https://github.com/51st-Vfw/MissionEditing-Templates)
repository on GitHub or as a separate
[`.zip` package](TODO_LINK).

> If you are working from GitHub, you will want to make a copy of `VFW51_Core_Mission` outside
> of the repository, since you don't want to change the template in the repository.

The copy of the `VFW51_Core_Mission` directory should be moved to where ever you want to store
your missions and renamed to the mission name. The path to this directory should include only
alphanumeric, "-" and "_" characters as discussed earlier. For example, assuming the new
mission is to be called `Breaking_Bad` and the directory where you store missions is
`C:\Users\Raven\DCS_Missions\` you would do something like this,

```
C:\Users\Raven\DCS_Missions\> move VFW51_Core_Mission Breaking_Bad
```

The next step depends on whether you are starting from a template or an existing mission.

## Creating a Mission From a Mission Template

The `VFW51_Core_Mission` directory includes basic mission templates for all of the main maps
the wing supports. These can be found at the top level of the template mission directory in the
files named `Tmplt_<map>_core.miz` where `<map>` is the abbreviated map name. The supported
maps include Caucuses (CAU), Marianas (MAR), NTTR (NTTR), Persian Gulf (PG), and Syria (SYR).

> The template `.miz` files in the directory are not completly set up as they appear in the
> `VFW51_Core_Mission` directory. The workflow will complete their setup.

To complete setup from a template, run the `setup.cmd` script from the root of the mission
directory. For example, to set up the `Breaking_Bad` mission from the NTTR map,

```
C:\Users\Raven\DCS_Missions\Breaking_Bad\> scripts\setup.cmd --map NTTR
```

This will create a `Breaking_Bad.miz` file from the template and synchronize it with the
contents of the mission directory. Setup will also remove any uneeded files such as the
templates for the other maps.

At this point, the mission directory is setup and ready for use.

## Updating an Existing Mission to Use the Workflow

> When updating an existing mission, you may need to make changes to be consistent with
> workflow expectations. For further details see,
> [Applying the Workflow to an Existing Mission](#Applying-the-Workflow-to-an-Existing-Mission)
> below.

The `setup.cmd` script can also start from an existing `.miz` file, though the process is
slightly more complicated.

```
C:\Users\Raven\DCS_Missions\Breaking_Bad\> scripts\setup.cmd --miz C:\Stuff\Mission.miz
```

In this case, the script will copy `Mission.miz` to `Breaking_Bad.miz` in the mission
directory and perform some additional setup.

> The path to the existing `.miz` file must conform to the requirements on mission
> directory paths: it should only contain alphanumeric, "-", and "_" characters.

Once this script completes, the mission directory is only partially built. After the first
run is complete, the `src\miz_core\` subdirectory will contain the files extracted from the
`.miz` package. Files such as scripts, kneeboards, or briefing panels will need to be
manually moved into their correct locations in the mission directory. Once this manual step
is complete, you run `setup.cmd` again with `--finalize` to complete the setup.

```
C:\Users\Raven\DCS_Missions\Breaking_Bad\> scripts\setup.cmd --finalize
```

At this point, the mission directory is setup and ready for use. You may need to make
further adjustments to the scripting and triggers in the mission.

# Using the Workflow

Once the mission directory is set up, you can use the workflow to build and manage the
mission and its resources.

## Basic Concepts and Operation

The `src\` subdirectory of a mission directory contains all the collateral necessary to build
a DCS `.miz` package for the mission. Within this directory,

- `miz_core\` contains files from the `.miz` mission package that are created, owned, and
  edited primarily by the DCS ME. The workflow may also modify these files.
- The remaining subdirectories in `src\` contain files that the workflow owns and incorporates
  into the `.miz` mission package that the DCS ME does not modify.

The `scripts\` subdirectory of a mission directory contains the scripts that support the
workflow. All scripts are run from the root of the mission directory using a shell such as
`cmd.exe` in Windows. Scripts will also support a `--help` command line argument to output
some usage infomration.

The workflow relies on two main scripts: `sync.cmd` and `build.cmd`. Generally speaking,
`sync.cmd` moves data from the `.miz` package to the mission directory while `build.cmd`
moves data from the mission directory to the `.miz` package.

### _Synchronizing the Mission Directory with `sync.cmd`_

After saving the `.miz` from the DCS ME, use the `sync.cmd` script to update files in the
mission directory (primarily in `src\miz_core\`),

```
C:\Users\Raven\DCS_Missions\Breaking_Bad> scripts\sync.cmd
```

The `sync.cmd` script has several command line arguments. The main arguments include,

- `--help` lists help information, including some arguments not listed here for brevity.
- `--dirty` disables clean up of redundnat files in the `src\miz_core\` subdirectory allowing
  you to examine what was pulled from the `.miz` package. The `cleanmission.cmd` script will
  clean up this subdirectory.
- `--dynamic` configures the mission directory files for dynamic script handling (see below).
- `--verbose` turns on logging information.

You need not run the `sync.cmd` script after every save in the DCS ME; the `build.cmd`
script discussed next will run `sync.cmd` by default.

### _Building Mission Packages with `build.cmd`_

After making changes to the files outside of `src\miz_core\`, use the `build.cmd` script to
rebuild the `.miz` package(s) from the mission directory,

```
C:\Users\Raven\DCS_Missions\Breaking_Bad> scripts\build.cmd
```

By default, the `build.cmd` script will first run `sync.cmd` prior to building the `.miz`
package(s).

The `build.cmd` script has several command line arguments. The main arguments include,

- `--help` lists help information, including some arguments not listed here for brevity.
- `--dirty` disables deletion of the mission package build directory, `build\miz_image\`, after
  the build is complete allowing you to examine what was built in to the `.miz` packages.
- `--dynamic` builds `.miz` mission packages to use dynamic script handling. By default, the
  workflow will build packages for static script handling.
- `--nosync` prevents `build.cmd` from running `sync.cmd` prior to bulding the `.miz` packages.
- `--base` builds the base mission variant only and does not build any other variants the
  mission directory specifies, see
  [Mission Variants](#Mission-Variants) for further details.
- `--verbose` turns on logging information.

The `build.cmd` script may build one or more `.miz` packages depending on the configuration
the mission directory specifies. These packages are named according to the convention outlined
earlier in
[Mission Directories](#Mission-Directories).
See 
[Mission Variants](#Mission-Variants)
for further details.

Note that you need not build if you are only editing Lua scripts and the mission directory
is currently set up for dynamic mission scripting handling. Any time you build, you should
make sure to reload the `.miz` in the DCS ME. Generally, it is safest to exit out of the DCS
ME before running `build.cmd`.

## Mission Resources

The workflow allows you to edit and inject different types of information into the mission
package. Each type of information has its own subdirectory in the `src\` subdirectory of the
mission directory. Generally, you will put relevant files into the appropriate subdirectory
and edit a settings file to make changes. The build scripts will use the settings and
relevant files to assemble the `.miz` packages at build time via the `build.cmd` script.

> The workflow uses Lua tables to specify settings. Though often it should be clear how
> to change the settings file, an basic understanding of Lua tables may be helpfu. See this
> [tutorial on Lua tables](https://www.tutorialspoint.com/lua/lua_tables.htm).

The following sections describe each type of information in further detail.

### _Audio Files_

The `src\audio\` subdirectory of a mission direcctory contains audio files that are included
in the final mission. These files should be in `.ogg` or `.wav` format. To add audio files,
update the `vfw51_audio_settings.lua` file in the `src\audio\` subdirectory.

The settings file contains a single Lua table, `AudioSettings` that specifies the audio files
to include in the mission. The file names the table specifies are relative to the `src\audio\`
subdirectory. For example, the settings to add the audio files `ao_check_in.ogg` and
`jtac_xmit.ogg`, from `src\audio\` to the mission is,

```
AudioSettings = {
    [1] = "ao_check_in.ogg",
    [2] = "jtac_xmit.ogg"
}
```

This makes the audio files available to the mission. Playing the audio files requires the use
of scripting or triggers as usual.

When building the mission, the workflow copies the audio files into the `.miz` package as well
as updating a workflow-managed trigger that ensures the mission references all audio files
(this is necessary to keep the DCS ME from deleting files that do not appear in DCS ME
triggers, see
[DCS ME Resource References](#DCS-ME-Resource-References)
below for further details).

### _Briefing Panels_

The `src\briefing\` subdirectory of a mission directory contains images to present on the
briefing panel that DCS shows at mission start. These files must be in `.jpg` or `.png` format.
To change the briefing panels in the mission, update the `vfw51_briefing_settings.lua` file in
the `src\briefing\` subdirectory.

The settings file contains a single Lua table, `BriefingSettings` that specifies the briefing
panels to use for each coalition. The file names the table specifies are relative to the
`src\briefing\` subdirectory. For example, the settings to add the image file
`51st_VFW_Logo.png` in `src\briefing` as a blue coalition briefing is,

```
BriefingSettings = {
    ["blue"] = {
        [1] = "51st_VFW_Logo.png"
    },
    ["red"] = { },
    ["neutral"] = { }
}
```

When building the mission, the workflow will update internal DCS mission files to reference
the briefing panels as well as copy the image files into the `.miz` package.

### _Kneeboards_

The `src\kneeboards\` subdirectory of a mission directory contains kneeboards and supporting
files for the kneeboards the mission carries. The workflow supports both global kneeboards
(visible to all pilots in any coalition) as well as airframe-specific kneeboards (visible to
all pilots of a specific airframe in any coalition). The workflow can use static images or
build kneeboards dynamically based on mission content such as radio presets. To add kneeboards,
update the `vfw51_kneeboard_settings.lua` file in the `src\kneeboards\` subdirectory.

> DCS does not currently support coalition-specific kneeboards.

When building the mission, the workflow will copy images to the proper location within the
`.miz` package, generating the image content on the fly as necessary.

The settings file contains a single Lua table, `KboardSettings` that describes how to generate
the `.miz` kneeboard content. The workflow can generate static or dynamic images,

- Static images (`.jpg` or `.png`) are directly copied from the mission directory to the
  appropriate location in the `.miz` package. Images should be 1536 x 2048 (or have the same
  aspect ratio).
- Dynamic images are built from information in the mission directory to create an image file
  that is copied to the appropriate location in the `.miz` package.

The keys in the `KboardSettings` table from the settings file are the target file names and
determine the name of the image file for the kneeboard. The value for a key describes how to
generate the file the key names. An empty value indicates the file is copied to the mission
package to be visible on all airframes. For example,

```
KboardSettings = {
    ["01_Flight.png"] = { }
}
```

copies the file `01_Flight.png` from the `src\kneeboards\` subdirectory in the mission
directory to the `.miz` to make the kneeboard available to all airframes.

To limit a kneeboard to a particular airframe, you add an `"airframe"` key with a value that
specifies the airframe. For example,

```
KboardSettings = {
    ["01_Flight.png"] = { ["airframe"] = "F-16C_50" }
}
```

makes the `01_Flight.png` kneeboard visible only on F-16C airframes. Currently, wing supported
airframes include `"AH-64D"`, `"A-10C"`, `"AV8BN"`, `"F-14B"`, `"F-16C_50"`, and
`"FA-18C_hornet"`.

A `"transform"` key specifies a script that the workflow should run to generate the indicated
file. This script can use information from the mission directory to build kneeboards. See
[Dynamic Kneeboards](#Dynamic-Kneeboards)
for further details on dynamically generating kneeboard content. For example,

```
KboardSettings = {
    ["01_Flight.png"] = { ["transform"] = "lua54 process.lua $_air $_src\\Tmplt.txt $_dst" }
}
```

builds the image file for the `01_Flight.png` kneebaord using the Lua script `process.lua`.
The command line from the `"transform"` value may contain variables starting with `"$"`. Known
variables include,

|Variable|Expansion|
|:---:|:---|
|`$_air` | Airframe from the `"airframe"` key/value pair.
|`$_mbd` | Full path to mission base directory.
|`$_src` | Full path to kneeboard source directory, `src\kneeboard\` in the mission base directory.
|`$_dst` | Full path to the destination file.
|`$<var>`| Value of the `$<var>` key in the table, quoted if it has spaces. Note that `<var>` may not start with "_".

Note that you use both `"airframe"` and `"transform"` keys for a kneeboard.

Currently, the workflow provides the `VFW51KbFlightCardinator.lua` script to generate flight
cards with radio preset and steerpoint information dynamically. This script uses a custom
`.svg` template that is available in the distribution.

### _Radio Preesets_

The `src\radio\` subdirectory of a mission directory contains settings for the radio presets
for the aircraft in the mission across the three radios DCS supports: Radio 1 (UHF), Radio 2
(VHF AM), and Radio 3 (VHF FM). The files in the standard template are initially configured
to support SOP comms with naval units using CVN-71 and CVN-75. To change the presets, update
the `vfw51_radio_settings.lua` settings file in the `src\radio\` subdirectory.

When building the mission, the workflow will inject the preset information into units in the
DCS ME files according to the settings.

> All radio presets you set up in the DCS ME for a unit that is also specified in the
> `vfw51_radio_settings.lua` settings file are **replaced** by the workflow the next time the
> mission is built or synchronized. Any preset changes through the DCS ME changes are **not**
> synchronized with the settings file.

> Currently, the functionality that supports presets in A-10C units by creating the the
> `UHF_RADIO`, `VHF_AM_RADIO`, and `VHF_FM_RADIO` hierarchy within the `.miz` package is
> disabled. This hierarchy appears to over-ride presets set for other airframes.

The settings file contains several Lua tables. The `RadioPresets[Warbird]<Blue|Red>` tables
establish the maping between a preset button and frequency and description by unit properties.
A series of rules define the mapping. For example, in `RadioPresetsBlue`

```
["$RADIO_1_10"] = {
    [1] = { ["p"] = "F-14B:*:*",         ["f"] = 271.40, ["d"] = "CVN-71 ATC" },
    [2] = { ["p"] = "FA-18C_hornet:*:*", ["f"] = 271.40, ["d"] = "CVN-71 ATC" }
},
```

sets Preset 10 on radio 1 (UHF) to 271.40MHz (CVN-71 ATC) on blue F-14B and FA-18C airframes
and unused on all other blue airframes. The `"p"` key defines a pattern of the forma
`<airframe>:<name>:<callsign>` that detemines whether the rule applies to a given unit. To
match a given row in a `RadioPresets` table, a unit's airframe must match `<airframe>` exactly,
and the unit's group name and callsign must contain `<name>` and `<callsign>`. The value `"*"`
matches anything.

When determining the frequency and description to use for a unit, the rules for a preset on
a radio are applied in order they appear in the array. For example,

```
["$RADIO_1_10"] = {
    [1] = { ["p"] = "*:*:*",            ["f"] = 270.00, ["d"] = "Tactical" },
    [2] = { ["p"] = "FA-16C_50:*:*",                    ["d"] = "Viper Tactical" }
    [3] = { ["p"] = "FA-16C_50:*:Uzi1", ["f"] = 275.00 }
},
```

results in the following frequency and descriptions for UHF (Radio 1) Preset 10 accross three
example units (Dodge21, Uzi11, and Venom21),

|Airframe|Group Name|Callsign|Preset Frequency|Preset Description|
|:---:|:---:|:---:|:---:|:---:|
|FA-14B|CAP Flight|Dodge21|270.00|Tactical|
|F-16C_50|Strike Flight|Uzi11|275.00|Viper Tactical|
|F-16C_50|SEAD Flight|Venom21|270.00|Viper Tactical|

The `RadioSettings` table provides templates of the `"Radio"` key in the DCS ME internal
mission table to inject into a unit in order to configure its presets. These tables reference
either a value from a `RadioPresets` table (e.g., `RadioPresetsBlue[$RADIO_1_10]`) or a fixed
frequency that applies to all instances of the airframe (e.g, a numeric value like 270.00).
Typically, the contents of the `RadioSettings` table are not edited unless you want a given
airframe to map preset N from `RadioPresets` to preset M in the airframe or fix a particular
preset for all instances of a given airframe for a given coalition.

### _Scripts_

The `src\scripts\` subdirectory of a mission directory contains the mission Lua scripts that
should be included in the mission package. This inculdes frameworks as well as mission-specific
scripting. To change the incorporated script files, update the `vfw51_script_settings.lua`
settings file in the `src\scripts\` subdirectory.

When building the mission, the workflow automatically updates triggers within the mission to
load the sccripts. Based on configuration, this load may be static (i.e., from the mission
`.miz` package) or dynamic (i.e., from a local directory).

The settings file contains the `ScriptSettings` Lua table that defines the scripts to be added
to the mission package. Scripts are divided into "frameworks" and "mission". All framework
scripts are loaded before any mission script. Scripts are loaded in the order in which they
appear in the Lua table.

For additional information on how the scripting functionality works in the workflow, see
[Workflow Trigger Setup](#Workflow-Trigger-Setup).

### _Waypoints_

The `src\waypoints\` subdirecotry of a mission directory contains waypoint sets for groups
in the mission that are injected when the mission is built. To change waypoints, update the
`vfw51_waypoint_settings.lua` settings file in the `src\waypoints\` subdirectory.

When building a mission, the workflow will look for groups whose name matches a waypoint set
from the settings file. When it finds a match, the workflow will inject the waypoints into
the group. This can be useful for situations where you have a number of groups that share
a common set of waypoints and you want to apply edits once rather than once for every group.

> All waypoints you set up in the DCS ME for a group that is also specified through the
> `vfw51_waypoint_settings.lua` settings file are **replaced** by the workflow the next time
> the mission is built or synchronized. Any preset changes through the DCS ME changes are
> **not** synchronized with the settings file.

The settings file contins the `WaypointSettings` Lua table that defines the waypoints to be
added to specific gropus in the mission package. Groups are identified by a Lua regular
expression that matches on the group names.

For example, assume you have two groups in your mission `Strike`, `CAP_1` and `CAP_2`, that
share the same set of waypoints. You would like to define the waypoints once and then
inject them into any other group that needs them.

You begin by defining the desired waypoints for `CAP_1` in the mission through the DCS ME.
After that, you can extract the waypoints from the `.miz` using `extract.cmd`,

```
C:\Users\Raven\Missions\Strike\> scripts\extract.cmd --wp CAP_1 Strike.miz > src\waypoints\wp.lua
```

This creates a file in `src\waypoints\wp.lua` with the necessary information to inject into
the mission file.

Once the Lua is output (to `wp.lua` in this example), you can set up your `WaypointSettings`
in `vfw51_waypoint_settings.lua` like this,

```
WaypointSettings = {
    ["CAP_1"] = "wp.lua",
    ["CAP_2"] = "wp.lua"
}
```

The next build the the `Strike` mission will inject the waypoints into groups `CAP_1` and
`CAP_2`. Note that the waypoint settings treat the key in this case as a pattern to match, so
you could also create a settings file like this,

```
WaypointSettings = {
    ["CAP_"] = "wp.lua",
}
```

This would install the waypoints in any group with a name that contains `CAP_`; for example,
`CAP_1`, `CAP_1 Flight`, and do on.

### _Mission Variants_

The `src\variants\` subdirectory of a mission directory contains settings for the mission
variants that are generated when the mission is built. Mission variants differ from the base
mission in time of day, weather, or DCS mission options. To change variants, update the
`vfw51_variant_settings.lua` settings file in the `src\variants\` subdirectory.

When building the mission, the workflow will first build the base variant and then modify
it to create mission files for each of the variants defined in the settings.

> When given the `--base` argument, `build.cmd` will only build the base mission and will not
> build any of the variants the settings file describes.

The settings file contains the `VariantSettings` Lua table that defines the "moments" (i.e.,
time of day), weather, and options for each variant. Separate Lua files in the
`src\variants\` subdirectory define the specific weather and option configurations to apply
to the base to create the variant. These files are in the internal mission format from the DCS
ME.

Given a `.miz` mission package with the desired weather or options settings, the `extract.cmd`
script can be used to extract the information of interest from an existing mission. The output
of this script can then be saved to a file in `src\variants\` for use in a variant.

For example, assume you have a separate mission `Test.miz` that has the weather settings you
want to use in your `Strike` mission. Begin by extracting the weather information from
`Test.miz` with `extract.cmd` (assuming `Test.miz` is in the mission directory for `Strike`
for simplicity).

```
C:\Users\Raven\Missions\Strike\> scripts\extract.cmd --wx Test.miz > src\variants\bad_wx.lua
```

Once the Lua is output (to `bad_wx.lua` in this example), you can set up your `VariantSettings`
in `vfw51_variant_settings.lua` like this,

```
VariantSettings = {
    ["variants"] = {
        ["bad-wx"] = {
            ["wx"] = "bad_wx.lua"
        }
    }
}
```

The next build the the `Strike` mission will produce the base variant, `Strike.miz` along
with a `bad-wx` variant, `Strike-bad-wx.miz` that has the weather imported from the
`Test.miz` mission.

# Updating the Workflow

Updates to the scripts and capabilities of the workflow will occur from time to time. The
workflow provides a script, `wfupdate.cmd` to automate the update process. Generally, you
run this script from a mission directory with the most recent workflow files to update the
workflow files in a different directory.

There are three classes of files that `wfupdate.cmd` may update: workflow scripts in the
`scripts\` subdirectory of the mission directory, mission frameworks (MapSOP, MOOSE, and
Skynet) in the `src\scripts\` subdirectory of the mission directory, and mission settings
files in subirectories of the `src\` subdirectory of the mission directory. For mission
settings, the update will copy new versions into the proper location under a name suffixed
with the version. This allows you to merge any changes with your existing settings files
based on changes to the structure of the settings files.

For example, assume the directory `C:\Users\Raven\Mission\VFW51_Core_Mission` has the most
recent version of the workflow and you want to update the `Breaking_Bad` mission at
`C:\Users\Raven\Mission\Breaking_Bad`. Invoking the command,

```
C:\Users\Raven\Mission\VFW51_Core_Mission> scripts\wfupdate.cmd ..\Breaking_Bad
```

Updates the workflow-related files in `Breaking_Bad` to match those in `VFW51_Core_Mission`.

- `--help` lists help information, including some arguments not listed here for brevity.
- `--dryrun` lists the steps `wfupdate.cmd` will take, but does not perform them.
- `--force` forces an update regardless of the version (*caution*: this may *revert* files!).
- `--frame` updates the mission frameworks.
- `--script` updates the workflow scripts.
- `--settings` updates the mission settings.
- `--verbose` turns on logging information.

If you do not specify any of `--frame`, `--script`, or `--settings` arguments, `wfupdate.cmd`
will update all classes of information.

TODO

# Technical Details, Odds, and Ends

This section covers some technical details on the workflow and its components.

## Applying the Workflow to an Existing Mission

TODO

## GitHub and the Mission Directory

The workflow is intended to support source control through GitHub. To do so, the workflow
"normalizes" all Lua files that the DCS ME generates so that they can be effectively compared
without generate false positives on changes.

> "Serialization" is the process of taking information and writing it to a file. When writing
> the data that makes up the `.miz` (primarily expressed through Lua tables) to a `.miz` file,
> the algorithm ED uses in the DCS ME can generate a different serialization each time the
> mission is saved, even if the mission was not changed. This implies that the source control
> system may believe something has changed when, in reality, it has not.
>
> To address this, the workflow will process files the DCS ME creates in a `.miz` with a tool
> that "normalizes" their contents. Normalized files will not change from save to save allowing
> source control to work as expected. For example, if DCS ME were serialize a list in a random
> order, normalizing that serialization would involve sorting the list.

To operate effectivey with GitHub, the mission directory should contain a `.gitignore` file, 

```
# 51st VFW Workflow .gitignore

/.vscode
/backup
/build
/src/miz_core/KNEEBOARD
/src/miz_core/Config
/src/miz_core/Scripts
/src/miz_core/track
/src/miz_core/track_data
*.miz
```

The files and directories this excludes are not needed for the workflow to rebuild the mission
and may duplicate information stored elsewhere in the mission directory.

## Dynamic Versus Static Scripting Setups

The workflow can configure the mission to load mission Lua scripts either statically or
dynamically. In the static setup, the scripts are kept in the `.miz` package. Any change to a
mission script requires the `.miz` package to be rebuilt. In the dynamic setup, the scripts are
kept outside the `.miz` package in the mission directory `src\scripts\` subdirectory and can be
edited without updating the `.miz` package.

> Missions set up to use dynamic scripting will typically only work on the system they were
> created on. When building a mission to share with others or host on a server, it is important
> to use static script loading.

Generally, scripts assume static setup unless given the `--dynamic` command line argument.
The `setup.cmd`, `build.cmd`, and `sync.cmd` scripts all support this argument. A mission
directory can switch between dynamic and static approaches on a build-by-build basis. There
is no need for separate dynamic and static mission directories for a mission.

## Workflow Trigger Setup

The workflow uses a standard set of six `MISSION START` triggers that it installs as the first
six triggers in the mission. These triggers are automatically inserted into a `.miz` each
time it is built and should not be edited in the DCS ME. They must always be the first six
triggers in the mission

The triggers include,

1. Sets up static/dynamic script loading via `VFW51_DYN_PATH` Lua variable
2. Load all frameworks (dynamic)
3. Load all frameworks (static)
4. Load all mission scripts (dynamic)
5. load all mission scripts (static)
6. Reference all audio files from mission

At run time only triggers 2 and 4 or triggers 3 and 5 execute, based on whether the mission
was setup as dynamic or static via the `--dynamic` argument to `build.cmd` or `sync.cmd`.

## Dynamic Kneeboards

TODO

## DCS ME Resource References

The internal DCS ME files (such as `mission`) in a mission package reference resource files
(such as audio or scirpts) through a "resource key". As part of the `.miz` creation process
in DCS ME, files may be removed from the `.miz` if they do not have a corresponding resource
key.

This is mostly an issue for files, such as audio clips, that are referenced from mission Lua
scripts and not any DCS ME triggers.

The workflow ensures all resources have references in DCS ME triggers to avoid this loss of
data. For example, as discussed above in
[Technical Details, Odds, and Ends](#Technical-Details,-Odds,-and-Ends)
the workflow creates a trigger that references all audio clips in the mission to ensure the
DCS ME will see a refernce to the clip.