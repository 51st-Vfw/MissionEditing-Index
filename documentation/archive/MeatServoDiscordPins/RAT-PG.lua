

--Departures

local DsaudiA320=RAT:New("RAT_SAUDI")
DsaudiA320:SetFLmin(300)
DsaudiA320:SetFLmax(420)
DsaudiA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DsaudiA320:DestinationZone()
DsaudiA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DsaudiA320:ATC_Messages(false)
DsaudiA320:Spawn(1)

local Dsaudi2A320=RAT:New("RAT_SAUDI-2")
Dsaudi2A320:SetFLmin(300)
Dsaudi2A320:SetFLmax(420)
Dsaudi2A320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
Dsaudi2A320:DestinationZone()
Dsaudi2A320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
Dsaudi2A320:ATC_Messages(false)
Dsaudi2A320:Spawn(1)

local DmeaA320=RAT:New("RAT_MEA")
DmeaA320:SetFLmin(300)
DmeaA320:SetFLmax(420)
DmeaA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DmeaA320:DestinationZone()
DmeaA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DmeaA320:ATC_Messages(false)
DmeaA320:Spawn(1)

local DqatarA320=RAT:New("RAT_QATAR")
DqatarA320:SetDeparture({"Dubai Intl", "Abu Dhabi Intl", "Al Ain Intl", "Ras Al Khaimah"})
DqatarA320:SetFLmin(300)
DqatarA320:SetFLmax(420)
DqatarA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DqatarA320:DestinationZone()
DqatarA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DqatarA320:ATC_Messages(false)
DqatarA320:Spawn(1)

local DemiratesA320=RAT:New("RAT_Emirates")
DemiratesA320:SetDeparture("Dubai Intl")
DemiratesA320:SetFLmin(300)
DemiratesA320:SetFLmax(420)
DemiratesA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DemiratesA320:DestinationZone()
DemiratesA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DemiratesA320:ATC_Messages(false)
DemiratesA320:Spawn(2)

local DgulfA320=RAT:New("RAT_GULF")
DgulfA320:SetFLmin(300)
DgulfA320:SetFLmax(420)
DgulfA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DgulfA320:DestinationZone()
DgulfA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DgulfA320:ATC_Messages(false)
DgulfA320:Spawn(1)

local DiranA320=RAT:New("RAT_IRAN")
DiranA320:SetDeparture("Shiraz Intl")
DiranA320:SetFLmin(300)
DiranA320:SetFLmax(420)
DiranA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DiranA320:DestinationZone()
DiranA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DiranA320:ATC_Messages(false)
DiranA320:Spawn(1)

local DkuwaitA320=RAT:New("RAT_KUWAIT")
DkuwaitA320:SetFLmin(300)
DkuwaitA320:SetFLmax(420)
DkuwaitA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DkuwaitA320:DestinationZone()
DkuwaitA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DkuwaitA320:ATC_Messages(false)
DkuwaitA320:Spawn(2)

local DetihadA320=RAT:New("RAT_ETIHAD")
DetihadA320:SetDeparture("Abu Dhabi Intl")
DetihadA320:SetFLmin(300)
DetihadA320:SetFLmax(420)
DetihadA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DetihadA320:DestinationZone()
DetihadA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DetihadA320:ATC_Messages(false)
DetihadA320:Spawn(2)

local DomanA320=RAT:New("RAT_OMAN")
DomanA320:SetDeparture("Ras Al Khaimah")
DomanA320:SetFLmin(300)
DomanA320:SetFLmax(420)
DomanA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DomanA320:DestinationZone()
DomanA320:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DomanA320:ATC_Messages(false)
DomanA320:Spawn(1)

local DqatarA380=RAT:New("RAT_QATAR380")
DqatarA380:SetDeparture({"Dubai Intl", "Abu Dhabi Intl"})
DqatarA380:SetFLmin(300)
DqatarA380:SetFLmax(420)
DqatarA380:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DqatarA380:DestinationZone()
DqatarA380:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DqatarA380:ATC_Messages(false)
DqatarA380:Spawn(1)

local DemiratesA380=RAT:New("RAT_EMIRATES380")
DemiratesA380:SetDeparture("Dubai Intl")
DemiratesA380:SetFLmin(350)
DemiratesA380:SetFLmax(420)
DemiratesA380:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DemiratesA380:DestinationZone()
DemiratesA380:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DemiratesA380:ATC_Messages(false)
DemiratesA380:Spawn(1)

local DemiratesA330=RAT:New("RAT_EMIRATES330")
DemiratesA330:SetDeparture("Dubai Intl")
DemiratesA330:SetFLmin(350)
DemiratesA330:SetFLmax(420)
DemiratesA330:SetTerminalType(AIRBASE.TerminalType.OpenBig)
DemiratesA330:DestinationZone()
DemiratesA330:SetDestination({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
DemiratesA330:ATC_Messages(false)
DemiratesA330:Spawn(1)

--Arrivals

local saudiA320=RAT:New("RAT_SAUDI-1")
saudiA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
saudiA320:SetFLmin(300)
saudiA320:SetFLmax(420)
saudiA320:SetSpawnInterval(300)
saudiA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
saudiA320:SetTakeoff("air")
saudiA320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Fujairah Intl", "Al Ain Intl", "Shiraz Intl"})
saudiA320:ATC_Messages(false)
saudiA320:Spawn(1)

local saudi2A320=RAT:New("RAT_SAUDI-3")
saudi2A320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
saudi2A320:SetFLmin(300)
saudi2A320:SetFLmax(420)
saudi2A320:SetSpawnInterval(300)
saudi2A320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
saudi2A320:SetTakeoff("air")
saudi2A320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Al Ain Intl", "Shiraz Intl"})
saudi2A320:ATC_Messages(false)
saudi2A320:Spawn(1)

local meaA320=RAT:New("RAT_MEA-1")
meaA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
meaA320:SetFLmin(300)
meaA320:SetFLmax(420)
meaA320:SetSpawnInterval(300)
meaA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
meaA320:SetTakeoff("air")
meaA320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Fujairah Intl", "Al Ain Intl", "Shiraz Intl"})
meaA320:ATC_Messages(false)
meaA320:Spawn(1)

local qatarA320=RAT:New("RAT_QATAR-1")
qatarA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
qatarA320:SetFLmin(300)
qatarA320:SetFLmax(420)
qatarA320:SetSpawnInterval(300)
qatarA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
qatarA320:SetTakeoff("air")
qatarA320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Fujairah Intl", "Al Ain Intl", "Ras Al Khaimah"})
qatarA320:ATC_Messages(false)
qatarA320:Spawn(1)

local emiratesA320=RAT:New("RAT_Emirates-1")
emiratesA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
emiratesA320:SetFLmin(300)
emiratesA320:SetFLmax(420)
emiratesA320:SetSpawnInterval(300)
emiratesA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
emiratesA320:SetTakeoff("air")
emiratesA320:SetDestination({"Dubai Intl"})
emiratesA320:ATC_Messages(false)
emiratesA320:Spawn(2)

local gulfA320=RAT:New("RAT_GULF-1")
gulfA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
gulfA320:SetFLmin(300)
gulfA320:SetFLmax(420)
gulfA320:SetSpawnInterval(300)
gulfA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
gulfA320:SetTakeoff("air")
gulfA320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Fujairah Intl", "Al Ain Intl", "Shiraz Intl"})
gulfA320:ATC_Messages(false)
gulfA320:Spawn(1)

local iranA320=RAT:New("RAT_IRAN-1")
iranA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
iranA320:SetFLmin(300)
iranA320:SetFLmax(420)
iranA320:SetSpawnInterval(300)
iranA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
iranA320:SetTakeoff("air")
iranA320:SetDestination({"Shiraz Intl"})
iranA320:ATC_Messages(false)
iranA320:Spawn(1)

local kuwaitA320=RAT:New("RAT_KUWAIT-1")
kuwaitA320:SetDeparture({"RAT Zone North West", "RAT Zone North"})
kuwaitA320:SetFLmin(300)
kuwaitA320:SetFLmax(420)
kuwaitA320:SetSpawnInterval(300)
kuwaitA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
kuwaitA320:SetTakeoff("air")
kuwaitA320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Fujairah Intl", "Al Ain Intl", "Ras Al Khaimah", "Shiraz Intl"})
kuwaitA320:ATC_Messages(false)
kuwaitA320:Spawn(1)

local etihadA320=RAT:New("RAT_ETIHAD-1")
etihadA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
etihadA320:SetFLmin(300)
etihadA320:SetFLmax(420)
etihadA320:SetSpawnInterval(300)
etihadA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
etihadA320:SetTakeoff("air")
etihadA320:SetDestination("Abu Dhabi Intl")
etihadA320:ATC_Messages(false)
etihadA320:Spawn(1)

local omanA320=RAT:New("RAT_OMAN-1")
omanA320:SetDeparture({"RAT Zone North West", "RAT Zone North", "RAT Zone East", "RAT Zone West"})
omanA320:SetFLmin(300)
omanA320:SetFLmax(420)
omanA320:SetSpawnInterval(300)
omanA320:SetTerminalType(AIRBASE.TerminalType.OpenBig)
omanA320:SetTakeoff("air")
omanA320:SetDestination({"Dubai Intl", "Abu Dhabi Intl", "Fujairah Intl", "Al Ain Intl", "Ras Al Khaimah"})
omanA320:ATC_Messages(false)
omanA320:Spawn(1)

local emiratesA330=RAT:New("RAT_EMIRATES380-1")
emiratesA330:SetFLmin(350)
emiratesA330:SetFLmax(420)
emiratesA330:SetTerminalType(AIRBASE.TerminalType.OpenBig)
emiratesA330:DestinationZone()
emiratesA330:SetDestination("Dubai Intl")
emiratesA330:ATC_Messages(false)
emiratesA330:Spawn(1)