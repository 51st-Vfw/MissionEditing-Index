# Mission Editing and Packaging Workflow

_Version: 3.0.0 of 4-Apr-23, covering workflow 5-10-5_

> The workflow builds on the [VEAF](https://github.com/VEAF) mission creation and conversion
> tools, using some of the VEAF scripts along with techniques borrowed from VEAF and previous
> 51st VFW workflows.

This document describes a directory structure and workflows for mission editing that supports
packaging missions and associated materials. As of DCS 2.8, the handling of assets such as
external Lua scripts or kneeboards in the DCS Mission Editor (DCS ME) is clumsy, at best;
and hostile, at worst. This workflow attempts to help make that less painful.

The workflow is based on a set of Windows `cmd.exe` scripts. Internally, these scripts may
invoke Lua scripts to perform some operations though this is transparent to the user.
Generally, when using the workflow, you will need to have a `cmd.exe` shell running.

> Using all capabilities of the workflow requires some basic familiarity with programming
> and scripting concepts.

A mission template set up for the workflow, `VFW51_Core_Mission`, is available through the
51st VFW `git` repository at
[51st VFW Mission Templates](https://github.com/51st-Vfw/MissionEditing-Templates).
For those not familiar with `git`, a `.zip` file with the template is available at
[TODO](TODO).
The template supports all of the maps currently active in the wing.

# Quick Start Guide

To use the workflow,

- Install `7-zip`, `Lua`, and (optionally) `ImageMagick` tools, see
  [Before Using the Workflow](#Before-Using-the-Workflow)
  for further details.
- Copy the entire `VFW51_Core_Mission` directory to where you store your missions and rename it
  to match the name of your mission. The path to this directory, the "mission directory", must
  contain only alphanumeric, "-", and "_" characters.
- Launch a `cmd.exe` shell and change directories to the mission directory you created in the
  previous step.
- If you are creating a new mission, run "`scripts\setup.cmd --map <map>`" in the shell. Here,
  `<map>` is either "CAU" (Caucuses), "MAR" (Marianas), "NTTR" (NTTR), "PG" (Persian Gulf), "SNA"
  (Sinai), or "SYR" (Syria) depending on the map your mission uses, see
  [Creating a Mission That Uses the Workflow](#Creating-a-Mission-That-Uses-the-Workflow).
- Run `scripts\build.cmd` in the shell to rebuild the mission and synchronize the mission
  directory with the `.miz` package, see
  [Basic Concepts and Operation](#Basic-Concepts-and-Operation).
  Generally, you should do this every time you make changes to the mission.

It is worth reading on, the wokflow can do a lot more than we can describe in a paragraph or
two...

# Workflow Capabilities

The workflow supports mission designers by providing better management of external mission
resources, such as scripts or kneeboards, through automation to setup of properties like
radio presets or waypoints across multiple units, and providing better integration with
source control systems like GitHub to allow more efficient collaboartion.

The workflow assmebles a `.miz` file for the mission from the associated source files. In
addition, it supports the automatic generation of mission variants that differ from the base
mission in DCS mission options (such as dot labels or F10 map setup, weather, time of day,
or mission contents).

During assembly, the workflow can make edits to internal mission state on a unit or group
basis. This allows for easier setup of radio presets, mission steerpoints, or group loadouts
without requiring the mission designer to make similar edits to multiple units or groups
in the mission. In addition, the workflow supports dynamic generate of kneeboards, such as
comms cards, that reflect mission setup and can automatically change as the setup changes.

During mission development, the workflow allows a mission to be built in a "dynamic"
configuration that allows mission scripts to be edited in an IDE outside of the mission
editor without requiring a rebuild of the mission package. This can streamline development by
eliminating the need to repackage the `.miz` every time a script changes.

Finally, the workflow represents missions in a format that works efficiently with source
control systems such as GitHub. This enables better collaboration between mission designers
while preventing the need to place the raw `.miz` files under source control.

# Before Using the Workflow

The 51st VFW workflow require several tools to support its operation. We will list the version
numbers we have tested here, but installing more recent versions should be fine. The workflow
has been tested against 64-bit versions of the tools. The first group of tools, including
`7-Zip` and `Lua`, are required to run the workflow and must be installed,

- [7-Zip](https://www.7-zip.org/download.html)
  packs and unpacks a DCS `.miz` file. The workflow has been tested with 7-zip 21.07.
- [Lua](https://sourceforge.net/projects/luabinaries/files/5.4.2/Tools%20Executables/)
  runs some of the internal scripts the workflow uses to process missions. The workflow
  has been tested with Lua 5.4.2.

In addition, `ImageMagick` is required if you want to use capabilities to automatically
generate kneeboards.

- [ImageMagick](https://imagemagick.org/script/index.php)
  processes image files for use in dynamic kneeboard construction. ImageMagick is only needed
  if you are generating kneeboards dynamically based on mission content. The workflow has been
  tested with ImageMagick 7.1.0-46 Q16-HDRI x64.

In addition to these tools, you may also want to install,

- [Visual Studio Code](https://code.visualstudio.com/) is a free Microsoft IDE that supports
  Lua development. You should also install the Lua and PowerShell plug-ins from VSC to get
  Lua syntax checking and other nice things if you want to script in Lua in your mission.
- [GitHub](https://desktop.github.com/) is a desktop `git` client to allow access to the 51st
  VFW repositories and enable collaboration between multiple designers on a shared mission.

The `7-zip` and `Lua` programs linked above are not packaged with Windows installers and must
be installed manually. Typically, you can extract the downloaded files to a directory such as
`C:\Program Files\<tool>` or equivalent. You will need to manually add the install paths to
the `PATH` environment variable. Generally,

1. Type `[WIN]+S` to bring up Windows search and then type "Environment"
2. Select the "Edit System Environment Variables" match, this will bring up "System Properties"
3. In the properties, click the "Environment Variables..." button at the bottom of the window
4. In the "System Variables" panel from the window that opens, scroll down and select the
   "PATH" row (any capitalization is fine), then click the "Edit..." button
5. This will open up a list of directories currently in the path. Click the "Browse..."
   button to bring up a folder broswer.
6. Navigate to the folder where the `.exe` for the tool resides. For example, for `7-Zip`
   you will want to find the folder where `7z.exe` resides (generally, this will be whatever
   folder you installed `7-zip` in; for example, `C:\Program Files\7-Zip`). Select the folder
   and click "OK".
7. You can now add another path if you want to (for `Lua`, for example)
8. Once you are done, back out by clicking "OK" to dismiss the windows and apply the changes.

These steps will set the `PATH` for all users of the system. If you want to limit it to the
currently logged in user, in step (4), instead select the "PATH" row from the "User
Variables" panel.

`ImageMagick`, `Visual Studio Code`, and `GitHub` are packaged with a Windows installer that
will handle `PATH` setup for you (for `ImageMagick`, make sure to check the "Add to PATH"
option during install).

# Mission Directory Structure

The workflow operates in a _Mission Directory_ that contains all of the files related to the
mission, including source, scripts, `.miz` files, etc. A mission directory **MUST** have the
same name as the base mission. For example, the mission directory for a mission
`Breaking_Bad.miz` might be

```
C:\Users\Raven\51st_VFW_DCS_Missions\Breaking_Bad
```

Due to scripting limitations, the _full_ path to a mission directory **MUST** only contain
alphanumeric, "-", and "_" characters. For example, the directory

```
C:\Users\Raven\51st VFW DCS Missions\Reactor 69 Strike
```

is **NOT** a valid mission directory name.

> As a rule, keep paths to alphanumeric, "-", and "_" characters, and everyone will be happy.
> This is unfortunately, a limitation of the current enviornment.

Given a mission named `<mission_name>`, the root of its mission directory, also named
`<mission_name>`, contains these subdirectories,

- `backup\` holds backups of the previous version of the `.miz` files generated by a mission
  build.
- `docs\` holds optional mission-related support documentation such as briefing material.
- `build\` holds temporary build products and files during mission assembly.
- `scripts\` holds the Windows `.cmd` and Lua `.lua` scripts that implement the workflow.
- `src\` holds the source files that make up the mission. This includes user-generated files
  (e.g., Lua scripts, kneeboards) along with internal DCS files extracted from the `.miz`.

The `src\` directory contains a number of subdirectories that can be divided into two groups.
The first group, which we collectively refer to as "`src\<usr>`" includes subdirectories that
contain content produced by the user,

- `audio\` holds audio resources (primarily audio files) and configuration.
- `briefing\` holds briefing panel resources (primarily image files) and configuration.
- `kneeboards\` holds kneeboard page resources (primarily image files) and configuration.
- `loadouts\` holds loadouts and configuration.
- `radio\` holds radio preset configuration.
- `scripts\` holds mission Lua scripts and configuration.
- `variants\` holds mission variant specifications.
- `waypoints\`holds waypoints and configuration.

The second group, which we collectively refer to as "`src\<dcs>`", includes a single
subdirectory that contains content produced by DCS ME (though the user may edit this content),

- `miz_core\` holds key files extracted from the base mission `.miz` package.

In addition to these directories, the top level of the mission directory typically contains a
`README` file and a number of packaged `.miz` files that provide different variants of the
mission.

The mission file `<mission_name>.miz` in the mission directory is known as the **base**
mission. A mission directory **always** contains a base mission. All changes to the mission
through the DCS ME should be made by editing the base mission file. Also, the mission
directory and base mission **always** share the same name (excluding extension).

In addition to the base mission, the mission directory may include mission files named
`<mission_name>-<variant>.miz`. These are *optional* variants of the base mission (see the
discussion of [mission variants](#mission-variants) below) that differ from the base mission in
weather, time of mission, mission options, etc. The workflow creates a variant by applying
changes to the base mission. As a result, these `.miz` files can be deleted safely and should
*not* be edited in the DCS ME.

# Workflow Scripts

The `scripts\` subdirectory of a mission directory contains the scripts that implement the
workflow. 

- `build.cmd` builds mission `.miz` packages from the mission directory hierarchy
- `sync.cmd` synchronizes `.miz` packages with the mission directory hierarchy
- `setup.cmd` sets up a mission directory for a mission
- `cleanmission.cmd` cleans up temporary build files
- `extract.cmd` extracts information from a `.miz` package
- `wfupdate.cmd` updates the mission directory for a new version of the workflow

All scripts support a `--help` command line argument to output usage information. These scripts
make use of the Lua scripts in `scripts\lua` as necessary. Typically, you will not need to
invoke the Lua scripts directly.

You invoke a script from a Windows shell such as `cmd.exe`. For example,

```
scripts\build.cmd --dynamic --base --verbose
```

> Scripts are **ALWAYS** run from the **ROOT** of the mission directory. Invoking a script from
> outside the mission directory will result in an error.

The remainder of this document will cover these scripts in more detail.

# Creating a Mission That Uses the Workflow

There are two ways to set up a mission that uses the 51st VFW workflow: create a new mission
from a 51st VFW mission template or transition an existing mission to use the workflow. Both
approaches use the `setup.cmd` script and start with the same initial setup steps.

## Initial Setup

In either approach to create a mission that uses the workflow, you begin by making a copy of
the `VFW51_Core_Mission` directory that provides a starting template for a workflow-managed
mission. You can find this directory in the
[51st VFW Mission Templates](https://github.com/51st-Vfw/MissionEditing-Templates)
repository on GitHub or as a separate
[TODO `.zip` package](TODO_LINK).

> If you are working from GitHub, you **MUST** make a copy of the `VFW51_Core_Mission`
> directory outside of the repository since you don't want to change the template in the
> repository.

Place the copy of `VFW51_Core_Mission` where want to store your mission and then rename it
to match the mission name. The full path to this directory **MUST** include only alphanumeric,
"-" and "_" characters as [discussed earlier](#mission-directories).

For example, assume you want to name the mission `Breaking_Bad` and you want to put it in
the directory `C:\Users\Raven\51st_VFW_DCS_Missions\`. To use this setup,

1. Copy the `VFW51_Core_Mission` directory into the directory
   `C:\Users\Raven\51st_VFW_DCS_Missions\`
2. Rename the directory `VFW51_Core_Mission` to `Breaking_Bad`.

The next step depends on whether you are creating a new mission from a template or changing
an existing mission to use the workflow.

## Creating a New Mission From a Mission Template

The `VFW51_Core_Mission` directory includes basic mission templates for all of the maps that
the wing supports: Caucuses (CAU), Marianas (MAR), NTTR (NTTR), Persian Gulf (PG), Sinai (SNA),
and Syria (SYR).

> While the `VFW51_Core_Mission` only provides templates for wing-supported maps, the workflow
> itself can handle missions on any map.

These templates include basic mission setup for the SOPs (e.g., groups for the SOP flights for
supported airframes, groups for a carrier) along with key MapSOP zones to set up tankers, set
up AWACS, or support other MapSOP capabilities. These basic templates can be found at the root
of the `VFW51_Core_Mission` directory in files named `Tmplt_<map>_core.miz`, where `<map>` is
the abbreviated map name.

> The template `.miz` files in the `VFW51_Core_Mission` directory are not completely set up
> until the workflow has finished its processing with the `setup.cmd` script.

To complete setup of a new mission from a template, run the `setup.cmd` script. For example,
to continue the `Breaking_Bad` example from earlier, the following shell commands would set up
`Breaking_Bad` to use the NTTR map (remember, the script is run from the mission's mission
directory, `C:\Users\Raven\51st_VFW_DCS_Missions\Breaking_Bad` in this example),

```
scripts\setup.cmd --map NTTR
```

This will create a `Breaking_Bad.miz` file from the NTTR template and synchronize it with
the contents of the mission directory. Setup will also remove any uneeded files such as the
templates for the other maps.

At this point, the mission directory is set up and ready for use. You can open up
`Breaking_Bad.miz` in the DCS ME and start editing.

## Bringing an Existing Mission Into the Workflow

The `setup.cmd` script can also start from an existing `.miz` file to set up that mission to
take advantage of the workflow. Unlike the template approach, which is limited to base wing
maps, this approach can use a mission on any map.

> When updating an existing mission, you may need to make some changes to be consistent with
> workflow expectations as
> [Applying the Workflow to an Existing Mission](#Applying-the-Workflow-to-an-Existing-Mission)
> describes.

For example, let's say we have an existing mission `C:\Stuff\Breaking_Bad.miz` that we want
to use as the starting point for a new `Breaking_Bad` workflow mission. After setting up
the mission directory for `Breaking_Bad` as
[described earlier](#initial-setup),
we use the `setup.cmd` script to incorporate the original `Breaking_Bad.miz` into the mission
directory.

```
scripts\setup.cmd --miz C:\Stuff\Breaking_Bad.miz
```

The workflow will copy `C:\Stuff\Breaking_Bad.miz` to `Breaking_Bad.miz` in the mission
directory and perform some initial synchronization of the mission directory with the `.miz`
package.

> `setup.cmd` takes a path to a mission file as an argument to `--miz`. The full path to the
> existing `.miz` file must conform to the requirements on mission directory paths: it should
> only contain alphanumeric, "-", and "_" characters.

Once this script completes, the mission directory is only partially built. After the first
run of `setup.cmd` is complete, the `src\miz_core\` subdirectory will contain the files
extracted from the `.miz` package. Files such as scripts, kneeboards, or briefing panels
will need to be manually moved from `src\miz_core\` into their correct locations in the
mission directory for use by the workflow. Once this manual step is complete, run `setup.cmd`
again with `--finalize` to complete the setup.

```
scripts\setup.cmd --finalize
```

At this point, the mission directory is setup and ready for use. You may need to make
further adjustments to the scripting and triggers in the mission.

# Using the Workflow

Once the mission directory is set up using the `setup.cmd` script, you can use the workflow
to build and manage the mission and its resources.

## Basic Concepts and Operation

The contents of the `src\` subdirectory of a mission directory provides all the data needed
to construct the base and (optaionlly) variant `.miz` packages for the mission. A primary
responsibility of the workflow is to provide a means to keep the base mission `.miz` package
and contents of `src\` consistent. Generally, "consistent" implies that,

1. Changes in the base `.miz` package are reflected in `src\<dcs>` (see
   [mission directory structure](#mission-directory-structure)
   ).
2. Changes in `src\<dcs>` are reflected in the base `.miz` package (note that workflow users
   typically do _not_ edit content in `src\<dcs>` directly).
3. Changes in `src\<usr>` are reflected in the base `.miz` package.

It is important to note that changes in the base `.miz` package are **not** reflected in 
`src\<usr>`.

> Primarily, this is due to the fact that extracting `src\<usr>` content from a `.miz` package
> is difficult in general because of the types of information in `src\<usr>`.

There are two "directions" in which the workflow must help provide consistency: from the base
`.miz` package to `src\` (that is, (1) in the list) and from `src\` to the base `.miz` package
(that is, (2) and (3) in the list). Each direction corresponds to a workflow script,

- `sync.cmd` handles `.miz` to `src\` by extracting information from the base `.miz`
  package and reflecting it in `src\<dcs>`.
- `build.cmd` handles `src\` to `.miz` by using the information in `src\<dcs>` and `src\<usr>`
  to assemble the base `.miz` package. Because `build.cmd` relies on `src\<dcs>`, it will, by
  default, use `sync.cmd` to first update `src\<dcs>` prior to assembly.

The next sections will look at these commands in further detail.

## Synchronizing the Base `.miz` Package to `src\` with `sync.cmd`

The `sync.cmd` script updates files in the mission directory hierarchy (primarily in
`src\<dcs\`) following changes to the base `.miz` package by something outside the workflow
(for example, the DCS ME). You invoke this script by typing the following command in a shell
(remember, scripts are always invoked from the root of the mission directory),

```
scripts\sync.cmd
```

The `sync.cmd` script has several command line arguments. The main arguments include,

- `--help` lists help information, including some arguments not listed here for brevity.
- `--dirty` disables clean up of redundnat files in the `src\miz_core\` subdirectory allowing
  you to examine what was pulled from the `.miz` package. The `cleanmission.cmd` script will
  clean up this subdirectory.
- `--dynamic` configures the mission directory files for
  [dynamic script handling](#dynamic-versus-static-scripting-setups)
- `--verbose` turns on logging information.

At minimum, you should run `sync.cmd` after every exiting DCS ME following an editing session.
However, you can run `sync.cmd` at any time after you make a change to the base `.miz` package.
For example, you could edit a `.miz`, save it with the DCS ME "save" operation, and then run
`sync.cmd` from a shell.

## Assembling Mission Packages from `src\` with `build.cmd`

The `build.cmd` script assembles mission packages for the mission (including the base mission
package) from the mission directory hierarchy (primarily in `src\`) following changes to
information in the `src\` hierarchy (for example, changing the radio preset assignments). You
invoke `build.cmd` by typing the following command in a shell (remember, scripts are always
invoked from the root of the mission directory),

```
scripts\build.cmd
```

The `build.cmd` script may assemble one or more `.miz` packages, named according to the
convnetion outlined in 
[Mission Directories](#Mission-Directories)
, depending on the configuration the mission directory specifies (see
[Mission Variants](#Mission-Variants)
).

The main command line arguments of `build.cmd` include,

- `--help` lists help information, including some arguments not listed here for brevity.
- `--dirty` disables deletion of the mission package build directory, `build\miz_image\`, after
  the build is complete allowing you to examine what was assembled in the `.miz` packages.
- `--dynamic` builds the mission packages for
  [dynamic script handling](#dynamic-versus-static-scripting-setups).
- `--nosync` prevents `build.cmd` from running `sync.cmd` prior to bulding the mission packages.
- `--base` builds the base mission package only and does not build any other variants the
  mission directory might specify, see
  [Mission Variants](#Mission-Variants) for further details.
- `--version` TODO
- `--verbose` turns on logging information.

Because `build.cmd` depends on the contents of `src\<dcs>` and `src\<dcs>` may not be consistent
with the base mission `.miz` package, `build.cmd` by default will run `sync.cmd` prior to
beginning assembly (invoking `build.cmd` with `--nosync` prevents it from running `sync.cmd` in
this fashion).

You must run `build.cmd` after making changes to any information in the `src\` hierarchy (with
one exception we discuss shortly). Because `build.cmd` creates new `.miz` packages for the
mission, it is important to avoid having any mission `.miz` packages open in the DCS Mission
Editor when running `build.cmd` (this also ensures `sync.cmd` functions correctly in the case
where `build.cmd` runs that script).

> Running `build.cmd` while the base mission `.miz` package is open in DCS ME can lead to
> edits being lost. Further, keep in mind that DCS ME does not see changes others make to a
> `.miz` package it has open and is editing.
>
> As a general rule, quit out of the DCS ME (though not DCS) before running `build.cmd`.

If the mission is assembled with the `--dynamic` command line argument, you may make changes to
Lua script files incorporated into the mission (typically, from `src\scripts`) without needing
to invoke `build.cmd` to assemble the changes.

# Mission Assembly

The workflow allows you to edit and inject different types of information in the base mission
package. Each type of information has its own subdirectory in the `src\` subdirectory of the
mission directory. Generally, you will put relevant files into the appropriate subdirectory
and edit a settings file to inform the workflow scripts how it should construct the mission.
Scripts such as `build.cmd` use the settings along with the relevant files from `src\` to
assemble the base and variant `.miz` packages.

> The workflow uses Lua tables to specify settings. Though often it should be clear how
> to modify a settings file, a basic understanding of Lua tables will be helpful. See this
> [tutorial on Lua tables](https://www.tutorialspoint.com/lua/lua_tables.htm).

The following sections describe each type of information that the workflow can assmeble into
a mission.

## Audio Files

The `src\audio\` subdirectory of a mission directory contains audio files, in `.ogg` or `.wav`
format, to include in the mission. When assembling the mission, the workflow copies the audio
files into the `.miz` package and updates a workflow-managed trigger that ensures the mission
references all audio files (this is necessary to keep the DCS ME from deleting files that do
not appear in DCS ME triggers, see
[DCS ME Resource References](#DCS-ME-Resource-References)
for further details).

To add audio files, edit the `src\audio\vfw51_audio_settings.lua` settings file. This file
contains a single Lua table, `AudioSettings`, that specifies an array of filenames of audio
files to include in the mission. For example,

```
AudioSettings = {
    [1] = "ao_check_in.ogg",
    [2] = "jtac_xmit.ogg"
}
```

adds the audio files named `ao_check_in.ogg` and `jtac_xmit.ogg` to the mission. Filenames are
specified relative to `src\audio\`.

`AudioSettings` only makes the audio files available to the mission. Playing the audio files
requires the use of appropriate scripting.

## Briefing Panels

The `src\briefing\` subdirectory of a mission directory contains images, in `.jpg` or `.png`
format, to present on the briefing panel that DCS shows at mission start. When assembling the
mission, the workflow copies the images into the `.miz` package and updates internal `.miz`
state to assign the images to briefing panels.

To set the briefing panels in the mission, edit the `src\briefing\vfw51_briefing_settings.lua`
settings file. This file contains a single Lua table, `BriefingSettings`, that specifies the
briefing panels to use for each coalition. This table is keyed by coalition name ("red",
"blue", or "neutral") with array values that list the filenames of the images to use as
briefing panels for the keyed coalition. For example,

```
BriefingSettings = {
    ["blue"] = {
        [1] = "51st_VFW_Logo.png",
        [2] = "Blue_Brief.png"
    },
    ["red"] = {
        [1] = "51st_VFW_Logo.png"
    },
    ["neutral"] = { }
}
```

adds two images, named `51st_VFW_Logo.png` and `Blue_Brief.png` to the briefing panel for the
blue coalition, and the image named `51st_VFW_Logo.png` to the briefing panel for the red
coalition. Filenames are specified relative to `src\briefing`.

## Kneeboards

The `src\kneeboards\` subdirectory of a mission directory contains images and supporting files
for the kneeboard pages the mission includes. The workflow supports both global pages (visible
to all pilots in any coalition) as well as airframe-specific pages (visible to all pilots of a
specific airframe in any coalition).

> DCS does not currently support coalition-specific kneeboard pages.

The workflow can use static or dynamically-generated images (built based on mission content
such as radio presets) for the kneeboard pages.

- Static images (`.jpg` or `.png` files) are directly copied from the mission directory into
  the `.miz` package. Images should be 1536 x 2048 (or have the same aspect ratio).
- Dynamic images use information in the mission directory to build an image file that is
  copied into the `.miz` package.

To specify the kneeboard pages to include in the mission, edit the
`src\kneeboards\vfw51_kneeboard_settings.lua` settings file. This file contains a single Lua
table, `KboardSettings`, that describes how to create the kneeboard content. This table is
keyed by target file name with tables that describe how to arrive at the target file as
values. For static images, the value table identifies the airframe the target file is
associated with through an optional `"airframe"` key. For example,

```
KboardSettings = {
    ["01_Mission.png"] = { },
    ["02_Viper_DMPI.png"] = { ["airframe"] = "F-16C_50" },
    ["02_Hornet_DMPI.png"] = { ["airframe"] = "FA-18C_hornet" },
}
```

This settings file causes the workflow to take the following actions,

- Copy the files `01_Flight.png`, `02_Viper_DMPI.png`, and `02_Hornet_DMPI.png` from
  `src\kneeboards\` to the `.miz` as kneeboard pages.
- The page `01_Flight.png` is made available on the kneeboards of all airframes as an
  `"airframe"` key is not specified.
- The page `02_Viper_DMPI.png` is made available on the kneeboards of all F-16C airframes.
- The page `02_Hornet_DMPI.png` is made available on the kneeboards of all F/A-18C airframes.

The value of the `"airframe"` key is the DCS name for the airframe. The workflow currently
supports `"AH-64D"`, `"A-10C_2"`, `"AV8BN"`, `"F-14B"`, `"F-16C_50"`, and `"FA-18C_hornet"`.
At present, a target file can be associated with either all or one airframe.

For dynamic images, the value table must include a `"transform"` key that specifies a script
that the workflow can run to generate the image file. This script can use information from the
mission directory to build kneeboards. See
[Dynamic Kneeboards](#Dynamic-Kneeboards)
for further details on dynamically generating kneeboard content. For example,

```
KboardSettings = {
    ["01_Flight.png"] = { ["airframe"] = "F-16C_50",
                          ["transform"] = "lua54 process.lua $_air $_src\\Tmplt.txt $_dst" }
}
```

builds the image file for the `01_Flight.png` kneebaord page using the Lua script
`process.lua` and makes the page available on the kneeboards of all F-16C airframes. The
command line from the `"transform"` value may contain variables starting with `"$"`.
Supported variables include,

|Variable|Expansion|
|:---:|:---|
|`$_air` | Airframe from the `"airframe"` key/value pair.
|`$_mbd` | Full path to mission base directory.
|`$_src` | Full path to kneeboard source directory, `src\kneeboard\` in the mission base directory.
|`$_dst` | Full path to the destination file.
|`$<var>`| Value of the `$<var>` key in the table, quoted if it has spaces. Note that `<var>` may not start with "_".

Currently, the workflow provides the (WIP) `VFW51KbFlightCardinator.lua` script to generate
flight cards with radio preset and steerpoint information dynamically. This script uses a
custom `.svg` template that is available in the distribution.

## Radio Presets

The `src\radio\` subdirectory of a mission directory contains settings for the radio presets
for the aircraft in the mission across the three radios DCS supports (the specific type of
radio is airframe-dependent). The initial configuration sets the presets according to the
[51st VFW SOPs](https://github.com/51st-Vfw/MissionEditing-Index/blob/master/documentation/me_sops.md)
with naval units set up for CVN-71 and CVN-75. When assembling the mission, the workflow
injects presets into units according to the settings.

> The workflow only supports presets in the modern A-10C module (`A-10C_2`), not the legacy
> A-10C module (`A-10C`)

To set the presets for use in the mission, edit the `src\radio\vfw51_radio_settings.lua`
settings file. This file contains several Lua tables, `RadioPresetsBlue`,
`RadioPresetsRed`, `RadioPresetsWarbirdBlue`, `RadioPresetsWarbirdRed`, that specify the
mapping between preset buttons on the three radios to frequencies to apply to groups within
each coalition ("red" or "blue). Each table is keyed by a radio and preset string (of the
form `$RADIO_<radio_number>_<preset_number>`) with a value table that defines an array with
rules to apply to determine the frequency to assign to the keyed radio and preset pair.

> All radio presets you set up in the DCS ME for a unit that is also specified in the
> `vfw51_radio_settings.lua` settings file are **replaced** by the workflow the next time the
> mission is built or synchronized. Any preset changes through the DCS ME changes are **not**
> synchronized with the settings file.

Each element the rules array is a table with three keys,

- `"p"` defines the pattern used to check if a unit matches the rule, the value is a string
  pattern the workflow uses to determine if a unit matches the rule.
- `"f"` defines the frequency (in MHz) of the preset, the value is a decimal number with the
  frequency. If unspecified, the DCS ME default frequency for the radio is used.
- `"d"` defines a human-readable description of the frequency, the value is a string
  description.

The value of the `"p"` key is a string pattern of the form `<airframe>:<name>:<callsign>`. A
unit matches this pattern if all three of the following tests are true,

- The unit's airframe exactly matches the `<airframe>` field.
- The unit's name contains the `<name>` field.
- The unit's callsign contains the `<callsign>` field.

In each test, case is ignored (that is `JEDI`, `Jedi`, `JeDi` are all considered to be the
same) and a value of "`*`" matches anything.

When determining the frequency and description to use for a radio preset for a unit, the
workflow applies the rules in order they appear in the rules array and checks all rules.
The last rule that matches a given unit and defines a frequency or description provides the
frequency or description for the preset. For example, assume a mission with an F-14B unit
(Dodge 2-1), and two F-16C units (Venom 2-1 and Uzi 1-1)

```
RadioPresetsBlue = {
    ["$RADIO_1_10"] = {
        [1] = { ["p"] = "*:*:*",            ["f"] = 270.00, ["d"] = "Tactical" },
        [2] = { ["p"] = "FA-16C_50:*:*",                    ["d"] = "Viper Tactical" }
        [3] = { ["p"] = "FA-16C_50:*:Uzi1", ["f"] = 275.00, ["d"] = "Viper Strke" }
    }
}
```

This results in the following set ups for preset 10 of radio 1,

|Airframe|Group Name|Callsign|Preset Frequency<br>[Match Rule]|Preset Description<br>[Match Rule]|
|:---:|:---:|:---:|:---:|:---:|
|F-14B|CAP Flight|Dodge21|270.00 [1]|Tactical [1]|
|F-16C_50|Strike Flight|Uzi11|275.00 [3]|Viper Strike [3]|
|F-16C_50|SEAD Flight|Venom21|270.00 [1]|Viper Tactical [2]|

The `RadioSettings` table provides templates for the `"Radio"` key in the DCS ME internal
mission table to inject into a unit in order to configure its presets. These tables reference
either a value from a `RadioPresets` table (e.g., `RadioPresetsBlue[$RADIO_1_10]`) or a fixed
frequency that applies to all instances of the airframe (e.g, a numeric value like 270.00).
Typically, the contents of the `RadioSettings` table are not edited unless you want a given
airframe to map preset N from `RadioPresets` to preset M in the airframe or fix a particular
preset for all instances of a given airframe for a given coalition.

## Scripts

The `src\scripts\` subdirectory of a mission directory contains the mission Lua scripts.
Scripts are loosely grouped into "framework" scripts and "mission" scripts, where the former
is loaded before the latter. When assembling the mission, the workflow copies the images into
the `.miz` package and updates internal `.miz` state to load the scripts.

To set the scripts in the mission, edit the `src\scripts\vfw51_script_settings.lua`
settings file. This file contains a single Lua table, `ScriptSettings`, that specifies the
scripts to include. This table is keyed by `"framework"` or `"mission"` the value of each
key is an array of the names of the scripts to load. For example,

```
ScriptSettings = {
    ["framework"] = {
        [1] = "MOOSE.lua"
    },
    ["mission"] = {
        [1] = "mission_globals.lua",
        [2] = "mission_logic.lua"
    }
}
```

loads the script files named `MOOSE.lua`, `mission_globals.lua`, and `mission_logic.lua`
(in that order). Filenames are specified relative to `src\scripts\`.

Based on the arguments provided to the workflow scripts, the workflow may assemble a version
of the mission that loads the scripts statically (i.e., they are included in the `.miz`
package and loaded from there) or dynamically (i.e., they are linked from the `.miz` package
and loaded from a directory outside of the `.miz`). See
[static versus dynamic scripts](#dynamic-versus-static-scripting-setups)
for details on static and dynamic configurations and
[workflow trigger setup](#Workflow-Trigger-Setup)
for details on how the workflow manages triggers.

## Loadouts & Waypoints

The `src\loadouts\` and `src\waypoints\` subdirectories of a mission directory contain loadout
and waypoint sets to apply to groups in the mission. This allows waypoints or loadouts to be
shared by multiple groups without needing to manually replicate the setup in the DCS ME. When
assembling the mission, the workflow updates the loadouts or waypoints of groups whose name
matches the settings.

> The template includes a number of SOP A2A loadouts in the `51st_sop_a2a_*` files.

To set the loadout or waypoint mapping in the mission, edit the
`src\loadouts\vfw51_loadout_settings.lua` or `src\waypoints\vfw51_waypoint_settings.lua`
settings files, respectively. These files each contain a single Lua table, either
`LoadoutSettings` or `WaypointSettings`, that specifies how to map a group to a loadout
or waypoint configuration. These tables are keyed by group name pattern with a file name
value that identifies the specific configuration to apply. For example,

```
LoadoutSettings = {
    ["SEAD"] = "sead_loadout.lua"
}
```

This example specifies that any group with a name containing "SEAD" (regardless of case) will
have its loadout set according to the file named `sead_loadout.lua`. Filenames are specified
relative to `src\loadouts\` or `src\waypoints\` as appropriate.

> All loadouts or waypoints you set up in the DCS ME for a group that is also specified
> through the `vfw51_loadout_settings.lua` or `vfw51_waypoint_settings.lua` settings files
> are **replaced** by the workflow the next time the mission is assembled. Any loadout or
> waypoint changes through the DCS ME changes are **not** automatically synchronized with the
> settings files.

The configuration file (`sead_loadout.lua` in the example) contains a single Lua table,
`LoadoutData` or `WaypointData` that defines the configuration to inject into the mission.
This data is formatted according to the internal format DCS uses for this information in a
`.miz` package. The `extract.cmd` workflow script can help create the contents of these
configuration files.

For example, assume you have two groups in your mission, `SEAD_1` and `SEAD_2`, that
share the same loadout. With the desired loadout defined in `sead_loadout.lua`, the example
`LoadoutSettings` table above would match the loadout of these two flights. To generate the
loadout definition, you would first update a flight in the DCS ME with the desired loadout.
In this example, you might do this on the group `SEAD_1`.

Next, you can use the `extract.cmd` workflow script to extract the loadout configuration from
`SEAD_1` and use it to create the `sead_loadout.lua` file for use when next assembling the
mission. From the mission directory,

```
scripts\extract.cmd --loadout SEAD_1 Breaking_Bad.miz > src\loadouts\sead_loadout.lua
```

A similar approach could be used for waypoints. For example, if you wanted `SEAD_1` and
`SEAD_2` to share waypoints, you could set up the desired waypoints for `SEAD_1` in the
DCS ME and then extract them using `extract.cmd`

```
scripts\extract.cmd --wp SEAD_1 Breaking_Bad.miz > src\waypoints\sead_waypoints.lua
```

In this case, the waypoints settings file would look similar to the loadout settings file
shown earlier.

## Mission Variants

The `src\variants\` subdirectory of a mission directory contains settings for the mission
variants of the base mission that are generated when the mission is assembled by `build.cmd`.
Mission variants differ from the base mission in time of day, weather, or DCS mission
options. Variants may also redact units and scripting to make them suitable for planning
purposes. To change the variants created by the `build.cmd` script, update the 
`vfw51_variant_settings.lua` settings file in the `src\variants\` subdirectory.

When assembling the mission, the workflow will first build the base variant and then modify
it to create mission files for each of the variants defined in the variant settings.

> When given the `--base` argument, `build.cmd` will only assemble the base mission and will
> not build any of the variants the settings file describes.

The settings file contains the `VariantSettings` Lua table that defines the "moments" (i.e.,
time of day), weather, options, and redactions for each variant. Separate Lua files in the
`src\variants\` subdirectory define the specific weather and option configurations to apply
to the base mission build to create the variant. These files are in the internal mission
format from the DCS ME.

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
with a `bad-wx` variant, `Strike-bad-wx.miz` that has the weather that was previously
imported from the `Test.miz` mission.

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
- `--version` displays the version of the components in the current mission directory.
- `--verbose` turns on logging information.

If you do not specify any of `--frame`, `--script`, or `--settings` arguments, `wfupdate.cmd`
will update all classes of information.

TODO

# Technical Details, Odds, & Ends

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
> that "normalizes" their contents. Normalized files will not change from save to save unless
> there are actual changes allowing source control to work as expected. For example, if DCS ME
> were serialize a list in a random order, normalizing that serialization would involve
> sorting the list.

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
edited without requiring the `.miz` package to be updated. Using dynamic loading can greatly
reduce the amount of time necessary to make a change in an external script (i.e., one that is
not encoded directly in the mission through something like the DCS ME `DO_SCRIPT` action) and
 test it in the mission.

> Missions set up to use dynamic scripting will typically only work on the system they were
> created on. When building a mission to share with others or host on a server, it is important
> to use static script loading.

Generally, workflow scripts assume static setup unless given the `--dynamic` command line
argument. The `setup.cmd`, `build.cmd`, and `sync.cmd` scripts all support this argument. A
mission directory can switch between dynamic and static approaches on a build-by-build basis.

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
