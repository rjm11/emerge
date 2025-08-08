-- Message from Ruhi
-- This is my first real attempt at trying to write anything in lua on my own. I've done some edits of some Rime files in the past,
-- But I've never really tried to write anything from scratch. I'm sure there are a lot of things that could be done better, but
-- I'm just trying to get something working, and prove to myself that I can make something functional on my own.
-- Big thanks to Bulrok, ChatGPT, Github Co-Pilot, StackOverFlow, and the Rime Discord for helping me out with this.

-- Define a function to search a static list of strings and return output if available,
-- falling back to searching the database if no matching content is found

-- Use this with the static files to get outputs of just aliases and descriptions.
-- ruhi_help_database("tag", true, false)

-- DEAR GOD STOP TYPING THIS OUT, JUST COPY AND PASTE IT YOU IDIOT {title = "", alias = "", tags = "", description = "", location = "", pattern = ""},

rimehelpaliastable = {
  {title = "Help!", alias = "?<word>", tags = "help, setup", description = "You can use ?help to find the quick reference guides", location = "System Setup", pattern = "^\\?(.+)$"},
  {title = "Search!", alias = "?find <word>", tags = "help, setup", description = "You can use ?find <word> to search the alias table for Rime appropriate aliases with descriptions! This will also tell you where to find it in Mudlet itself.", location = "System Setup", pattern = "^\\?(.+)$"},
  {title = "Tag!", alias = "?tag <word>", tags = "hidden", description = "You can use ?tag <word> to search the alias tag table for Rime appropriate aliases, by tag. This will also tell you where to find it in Mudlet itself.", location = "System Setup", pattern = "^\\?(.+)$"},
  {title = "Artifact Pipes Support", alias = "rime arti pipes <yes/no>", tags = "artifacts", description = "ARTIFACT INFO ARTIFACT_PIPE. Set to \"yes\" if you have 3 artifact pipes. To set up your pipes <red>set <red><plant> <red><pipe#> <red><white>", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Goggles Support", alias = "rime arti goggles <number>", tags = "artifacts", description = "HELP GOGGLES Antiquated Artifact goggles levels 1-20 fully supported.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Gauntlet Support", alias = "rime arti gauntlet <number>", tags = "artifacts", description = "HELP GAUNTLET Antiquated Artifact Gauntlet levels 1-20 fully supported.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Mass Support", alias = "rime arti mass <yes/no>", tags = "artifacts", description = "ARTIFACT INFO STABILITY. Set this to yes if you have the stability artifact, this will keep you from using up mass.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Manaboon Support", alias = "rime arti manaboon <yes/no>", tags = "artifacts", description = "ARTIFACT INFO MANA_BOON. Set this to yes if you have the mana_boon artifact.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Lifesense Support", alias = "rime arti lifesense <yes/no>", tags = "artifacts", description = "RELIC INFO LIFESENSE. Set this to yes if you have the lifesense relic.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Mindseye Support", alias = "rime arti mindseye <yes/no>", tags = "artifacts", description = "Set this to yes if you have <red>BOTH the antenna and blindfold relics.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Webspray Support", alias = "rime arti webspray <yes/no>", tags = "artifacts", description = "Set this to yes if you have the webspray relic.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Lifevision Support", alias = "rime arti lifevision <yes/no>", tags = "artifacts", description = "ARTIFACT INFO LIFEVISION. Set this to yes if you have the lifevision artifact.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Bracer Support", alias = "rime arti bracer <yes/no>", tags = "artifacts", description = "Set this to yes if you have the combined_powers bracer relic.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Zephyr Support", alias = "rime arti zephyr <yes/no>", tags = "artifacts", description = "ARTIFACT INFO ZEPHYR. Set this to yes if you have the zephyr artifact.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Horn Support", alias = "rime arti horn <yes/no>", tags = "artifacts", description = "Set this to yes if you have the hunter horn artifact.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Crystal_Illusion Support", alias = "rime arti crystal_illusion <yes/no>", tags = "artifacts", description = "Set this to yes if you have the crystal illusion staff.", location = "System Setup", pattern = "^rime arti (\\w+) (.+)$"},
  {title = "Artifact Pairing Support", alias = "rime pair <person> <item>", tags = "artifacts, pairings", description = "ARTIFACT INFO PAIRED. Set an item into the pairing table, so you can reference it later.", location = "System Setup", pattern = "^rime pair (\\w+) (\\w+)$"},
  {title = "Artifact Pairing List", alias = "rime list pairings", tags = "artifacts, pairings", description = "View the list of saved pairings.", location = "System Setup", pattern = "^rime list pairings$"},
  {title = "Set Seperator", alias = "set sep (seperator)", tags = "setup, system", description = "Set your Rime seperator to whatever you want, but it should NOT match your Mudlet seperator", location = "System Setup", pattern = "^set sep (.+)$"},
  {title = "Colors", alias = "colors", tags = "colors, customization, misc", description = "See the rainbow that you can use!", location = "System Setup", pattern = "^colors$"},
  {title = "System Load", alias = "sload", tags = "system, help, setup", description = "This lets you reload RIME on the fly, if you make changes to code make sure you <red>save and <red>sload<white>!", location = "System Setup", pattern = "^sload$"},
  {title = "Rime Color Customization", alias = "rime color <type> <position> <color>", tags = " hidden", description = "Rime color can be customized to your liking, look at ?customization for more information!", location = "System Setup", pattern = "^rime color (\\w+) (\\w+) (\\w+)"},
  {title = "Rime Affliction Color Customization", alias = "rime affcolor <affliction> <color> <nameshown>", tags = "hidden", description = "Customize how any affliction color is shown with this, look at ?customization for more information!", location = "System Setup", pattern = "^rime affcolor (\\w+) (\\w+) (.*)$"},
  {title = "Default Aff Colors", alias = "fix aff colors", tags = "customization", description = "Reset all the affliction colors to the defaults", location = "System Setup", pattern = "^fix aff colors$"},
  {title = "Rime Colors Default", alias = "rime colors default", tags = "customization", description = "Reset all the colors to the defaults", location = "System Setup", pattern = "^rime colors default$"},
  {title = "Test", alias = "test", tags = "test", description = "test", location = "System setup", pattern = "^test$"},
  {title = "Firstaid Toggle", alias = "fa", tags = "firstaid, curing, pk", description = "Toggles the rime client side curer on or off, utilizes Firstaid in Aetolia if turned off.", location = "System Setup", pattern = "^fa$"},
  {title = "Set Default Rime Mount", alias = "set mount <number>", tags = "setup, loyals, mount", description = "Lets you set which mount Rime will call when mounting and dismounting.", location = "System Setup", pattern = "^set mount (\\w+)$"},
  {title = "Set Default Rime Mount Stable", alias = "set stable <name>", tags = "setup, loyals, mount", description = "This lets you set your default stable that is used by Rime, will automatically send your default mount to this stable on <red>QQ", location = "System Setup", pattern = "^set stable (.+)$"},
  {title = "Rime Save", alias = "save", tags = "setup, help, pk, pvp, pve, grouppk, grouppvp", description = "Make sure you save whenever you change anything in Rime, a lot of the files are saved externally so when you close Mudlet if you do not save you might lose some stuff. Save often!", location = "System Setup", pattern = "^save$"},
  {title = "Add Rime Ally", alias = "rime ally <name>", tags = "pk, pvp, grouppk, grouppvp", description = "Rime has it's own ally system to prevent things like swapping targets to a known ally. Keep your ally list up to date and accurate! This does not add someone to your in game ally list!", location = "System Setup", pattern = "^rime ally (\\w+)$"},
  {title = "Remove Rime Ally", alias = "^rime unally <person>", tags = "pk, pvp, grouppk, grouppvp", description = "Rime has it's own ally system and this lets you remove people from that ally list. This does NOT remove them from your in game ally list!", location = "System Setup", pattern = "^rime unally (\\w+)$"},
  {title = "Allies", alias = "rime allies", tags = "pk, pvp, grouppk, grouppvp", description = "View the list of all your rime allies. Keep in mind this list is separate from your in game ally list.", location = "System Setup", pattern = "^rime allies$"},
  {title = "Dab On 'Em", alias = "dab", tags = "misc", description = "Do it.", location = "System Setup", pattern = "^dab$"},
  {title = "Gag Queue Commands", alias = "rime gag send <yes/no>", tags = "help, setup", description = "This lets you select if you want to see the commands that Rime sends to the server itself, turning this on will cut down on spam but it might not be as clear what is going on.", location = "System Setup", pattern = "^rime gag send (yes|no)$"},
  {title = "Pause System", alias = "pause <white>and <red>unpause", tags = "setup, help, system", description = "This lets you pause the system in the event of an issue or loop. Don't forget you also have the Mudlet Emergency Stop button!", location = "System Setup", pattern = "^(pause|unpause)$"},
  {title = "Praenomen Weapon (1H)", alias = "set onehanded <number>", tags = "praenomensetup, setupall", description = "Set which <red>ONE-handed weapon you will use while using the Praenomen class", location = "System Setup", pattern = "^set onehanded (\\w+)$"},
  {title = "Praenomen Weapon (2H)", alias = "set twohanded <number>", tags = "praenomensetup,setupall", description = "Set which <red>TWO-handed weapon you will use while using the Praenomen class", location = "System Setup", pattern = "^set twohanded (\\w+)$"},
  {title = "Revenant Weapon (1H Blades)", alias = "set onehand blades <number for first> <number for second>", tags = "revenant, revenantsetupsetupall", description = "Set the <red>TWO blades you will use while using your <red>ONE-HANDED blades.", location = "System Setup", pattern = "^set onehand blades (\\w+) (\\w+)$"},
  {title = "Revenant Weapon (1H Blunts)", alias = "set onehand blunts <number for first> <number for second>", tags = "revenant, revenantsetupsetupall", description = "Set the <red>TWO blunt weapons you will use while using your <red>ONE-HANDED blunt weapons", location = "System Setup", pattern = "^set onehand blunts (\\d+) (\\d+)$"},
  {title = "Revenant Weapon (2H Blunt)", alias = "set twohand blunt <number>", tags = "revenant, revenantsetup, setupall", description = "Set the <red>TWO-HANDED blunt weapon you will use for Revenant.", location = "System Setup", pattern = "^set twohand blunt (\\d+)$"},
  {title = "Revenant Weapon (2H Blade)", alias = "set twohand blade <number>", tags = "revenant, revenantsetup, setupall", description = "Set the <red>TWO-HANDED bladed weapon you will use for Revenant.", location = "System Setup", pattern = "^set twohand blade (\\d+)$"},
  {title = "Set Shield", alias = "set shield <number>", tags = "setup, setupall", description = "Set's the shield that Rime will make use of.", location = "System Setup", pattern = "^set shield (\\w+)$"},
  {title = "Set Pipe Numbers", alias = "set <reishi/willow/yarrow> <number>", tags = "curing, artifacts, setup, pk", description = "This will let Rime know what pipes to smoke and refill. Useful even if you are not using artifact pipes!", location = "System Setup", pattern = "^set (reishi|willow|yarrow) (\\d+)"},
  {title = "Bard PVP Weapon", alias = "set bardsword <number>", tags = "bardsetup, setupall", description = "Set's the weapon that Rime will get out when using PVP routes.", location = "System Setup", pattern = "^set bardsword (\\w+)$"},
  {title = "Bard Bashing Weapon", alias = "set bardbashing <number>", tags = "bardsetup, setupall", description = "Set's the weapon that Rime will use for Bashing.", location = "System Setup", pattern = "^set bardbashing (\\w+)$"},
  {title = "Rime Clotter", alias = "rime bleeding <number>", tags = "curing", description = "Sets the bleeding amount you want to start clotting at", location = "System Setup", pattern = "^rime bleeding (\\d+)$"},
  {title = "Alchemist Conduit", alias = "set conduit <number>", tags = "alchemistsetup, setupall", description = "Sets your Alchemist Conduit for Rime to utilize", location = "System Setup", pattern = "^set conduit (\\w+)$"},
  {title = "Critical Hit Colors!", alias = "rime set crit <godname>", tags = "setup, customization, pve", description = "Customize your crit colors, It will be rainbow or a selection of Gods. Currently accepts: Chakrasul, Bamathis, Ivoln, Iosyne, Lexadhra, Tanixalthas, Damariel, Dhar, Ethne, Haern, Omei, Severn, Slype", location = "System Setup", pattern = "^rime set crit (\\w+)$"},
  {title = "Set Sciomancer Focus", alias = "set focus <number>", tags = "sciomancersetup, setupall", description = "Select what Sciomancer focus Rime will utilize.", location = "System Setup", pattern = "^set focus (\\w+)$"},
  {title = "Wayfarer PVP Weapon", alias = "set pvp axes <number of first> <number of second>", tags = "wayfarersetup", description = "Rime will prioritize these axes when you are using the PVP Routes.", location = "System Setup", pattern = "^set pvp axes (\\w+) (\\w+)$"},
  {title = "Wayfarer Bashing Weapon", alias = "set pve axes <number of first> <number of second>", tags = "wayfarersetup", description = "Rime will make use of these axes when you use the Bashing Routes.", location = "System Setup", pattern = "^set pve axes (\\w+) (\\w+)$"},
  {title = "Archivist Codex", alias = "set codex <number>", tags = "archivistsetup, setupall", description = "Select which codex Rime will utilize while you are in Archivist.", location = "System Setup", pattern = "^set codex (\\w+)$"},
  {title = "Set Bard Instrument", alias = "set instrument <number>", tags = "bardsetup, setupall", description = "Select which instrument Rime will use while you are in Bard.", location = "System Setup", pattern = "^set instrument (\\w+)$"},
  {title = "Teradrim Bashing Flail", alias = "set pve flail <number>", tags = "teradrimsetup, setupall", description = "Sets which flail Rime will use during Teradrim Bashing.", location = "System Setup", pattern = "^set pve flail (\\w+)$"},
  {title = "Teradrim PVP Flail", alias = "set pvp flail <number>", tags = "teradrimsetup, setupall", description = "Sets which flail Rime will use during Teradrim PVP Routes", location = "System setup", pattern = "^set pvp flail (\\w+)$"},
  {title = "Def Up", alias = "dup", tags = "defences", description = "Once you've loaded a profile with the 'ldd' alias, use this alias to start putting up your defences.", location = "Defences", pattern = "^dup ?(\\w+)?$"},
  {title = "Toggle Auto Deffing", alias = "auto def", tags = "defences", description = "This alias is a toggle to bypass one of the settings in 'ldd'. If you've told Rime you 'need' a defence, toggling 'auto def' on will continue putting that defense up whenever it drops. If it's toggled off, Rime will quit putting that defense up unless you've told it to 'keepup' that defense.", location = "Defences", pattern = "^auto def$"},
  {title = "Pause a defense", alias = "no <defense>", tags = "defences", description = "If a defense is set to auto reup, you can make it with no to take it out of the list. This will only work until you DUP or LDD again.", location = "Defences", pattern = "^no (\\w+)"},
  {title = "Bring up a defense", alias = "rdef <defense>", tags = "defences", description = "Rime will raise the defense once, but not keep it up if it is lost.", location = "Defences", pattern = "^rdef (\\w+)$"},
  {title = "Defense Profiles", alias = "ldd <nothing or a profile>", tags = "defences, quickpksetup, quickpvesetup", description = "This is an alias that is customizable within Mudlet's alias editor. It houses some default profile layouts and lets Rime know what you want to put up once, and what you want to keep up. There are some prebuilt additional profiles set up in the alias refer to the in Mudlet alias for more details.", location = "Defences", pattern = "^ldd(?: (\\w+)|)$"},
  {title = "Keep up a defense", alias = "kd <defense>", tags = "defences", description = "This alias will tell Rime to 'keepup' a defence or not. This means that Rime will try to put this defence up every time it comes down.", location = "Defences", pattern = "^kd (\\w+)$"},
  {title = "Touch Shield", alias = "ts", tags = "pkmisc", description = "Touches your shield tattoo, if you have one.", location = "Defences", pattern = "^ts$"},
  {title = "Shackle the Elds", alias = "elds", tags = "ylem, elds, lesser, twin, leylines", description = "This will queue up REFINING SHACKLE ELD.", location = "Defences", pattern = "^elds$"},
  {title = "Use your Translocator", alias = "ut", tags = "misc, miscellaneous", description = "Gets your translocator out and uses it, assumes you keep your translocator in your pack.", location = "Defences", pattern = "^ut$"},
  {title = "Static Parrying", alias = "sp <limb> or NONE to disable", tags = "quickpk, pk, pvp, defences , quickpksetup", description = "Instead of auto-parrying, this lets you opt to parry on a given limb. <red>sp <red>NONE to disable.", location = "Defences", pattern = "^sp (.+)$"},
  {title = "Aegis", alias = "aeg or aeg <anything>", tags = "pk, pvp, quickpk, defences, grouppkcombat", description = "This lets you MANIPULATE PYLON FOR AEGIS. This will not work if your reserves are low. If you add any characters after aeg it will MANIPULATE PYLON FOR AEGIS TRANSMUTATION", location = "Defences", pattern = "^aeg(?:| (\\w+))?$"},
  {title = "Touch Chameleon", alias = "cham", tags = "defences, misc", description = "Touch Chameleon tattoo from a randomized list.", location = "Defences", pattern = "^cham$"},
  {title = "Reset your afflictions", alias = "reset", tags = "curing, quickpk, pk, pvp, grouppk, grouppvp, grouppkaftercombat, quickpkaftercombat", description = "Clear ALL afflictions on yourself. ", location = "Curing", pattern = "^reset$"},
  {title = "Set Pre-Restore Levels", alias = "ltr <number>", tags = "curing, quickpk, pk, pvp, grouppk, grouppvp, quickpksetup", description = "Sets your Pre Restore Threshold to number specified. Range: 1-3333. Number should be XXXX. 1234 would be 12.34%. Very useful against limb routes Default is 1000 which is 10%.", location = "Curing", pattern = "^ltr (\\d+)$"},
  {title = "Stormtouched Mode", alias = "stt", tags = "curing", description = "Toggles Stormtouched Mode to attempt to not eat the same pill two times in a row.", location = "Curing", pattern = "^stt$"},
  {title = "Lyre Mode", alias = "lyre", tags = "misc", description = "Turns on lyre mode! This is not a toggle.", location = "Curing", pattern = "^lyre$"},
  {title = "Cure Set", alias = "cs <cure set>", tags = "curing, pk", description = "Manually set which curing priority you want to use. Options are <dark_sea_green>Default<white>, <dark_sea_green>Group<white>, and <dark_sea_green>any class.", location = "Curing", pattern = "^cs (\\w+)$"},
  {title = "Pre Cache Pills", alias = "pc", tags = "curing, pk, pvp, quickpksetup", description = "Pre-withdrawal curatives from your cache.", location = "Curing", pattern = "^pc$"},
  {title = "Target it", alias = "t <name or number>", tags = "quickpk, pk, pvp, pve, quickpve, basics, quickpksetup, quickpvemanualbashing", description = "This lets you define who or what you want to attack", location = "Offense -> Target Things", pattern = "^t (.+)$"},
  {title = "Toggle Web Calling", alias = "wco", tags = "pkleader", description = "Toggle web target calling, don't forget to get others to <red>wl you! ", location = "Offense -> Target Things", pattern = "^wco$"},
  {title = "Designate Web Listening", alias = "wl <name>", tags = "grouppksetup, pk", description = "Sets your listen target for target calling in web. You need to do this one at a time for each person you want to listen to. You can check who all you are listening to in <red>?settings.", location = "Offense -> Target Things", pattern = "^wl (\\w+)$"},
  {title = "Turn off Web Functions", alias = "woff", tags = "pk, pvp, pkleader, grouppk, grouppvp, grouppkaftercombat", description = "Turn off all web calling, web reporting, and clears web listening.", location = "Offense -> Target Things", pattern = "^woff$"},
  {title = "Clear Targets Afflictions", alias = "tc", tags = "pk, pvp, quickpk, grouppkaftercombat", description = "Clears <red>ALL afflictions off of your target.", location = "Offense -> Target Things", pattern = "^tc$"},
  {title = "Toggle Web Affliction Reporting", alias = "wro", tags = "pkleader, pk, pvp, grouppksetup, quickpkaftercombat", description = "Announce what you are doing in the web to help others track afflictions. If you are leading others in combat, remind them to use this so you can better coordinate.", location = "Offense -> Target Things", pattern = "^wro$"},
  {title = "Single Affliction Removal from Target", alias = "cat <affliction>", tags = "pk, pvp, curing", description = "Manually remove an affliction from your target for the tracker.", location = "Offense -> Target Things", pattern = "^cat (\\w+)$"},
  {title = "Turn on the PVP Route", alias = "ai", tags = "pk, pvp, quickpk, grouppk, grouppvp, pvp, grouppkcombat, quickpkcombat", description = "Toggle the route on/off and start attacking your player target that is in the room with you.", location = "Offense -> DO NOT PRESS", pattern = "^ai$"},
  {title = "Manually Bash Target", alias = "f", tags = "quickpve, pve, quickpvemanualbashing", description = "Manually bash whatever you have targetted with your bashing attack.", location = "PvE", pattern = "^f$"},
  {title = "Quickmount", alias = "qm", tags = "loyals, mounts", description = "Calls your mount to you and quick mount upon it.", location = "PvE", pattern = "^qm$"},
  {title = "Quickdismount", alias = "dm", tags = "loyals, mounts", description = "Quickdismount from your mount and order it to follow you.", location = "PvE", pattern = "^dm$"},
  {title = "Mass Token Trade", alias = "mtt", tags = "pve", description = "Gets out 5 research tokens and trades them in for each color. Works at Mogrov (42903).", location = "PvE", pattern = "^mtt$"},
  {title = "Activate your orbs!", alias = "orbs", tags = "pve", description = "Activates all the orb colors at once.", location = "PvE", pattern = "^orbs$"},
  {title = "Rise from the ground/coffin.", alias = "rise", tags = "praenomen", description = "RISE from the ground, will also send TOUCH PYLON so meant to be used with DIFFUSE MIST", location = "PvE", pattern = "^rise$"},
  {title = "Solo/Leading Basher Toggle", alias = "ba <circuit> <lead/blank>", tags = "quickpve, pve, bashing, quickpveassisted", description = "If you are in a zone with a mapped out path, it will walk around and automatically try to kill everything in the zone. If they zone is not mapped out but it has the targets it will attack targets as you walk around the area. When selecting a route to bash, you can also do BA <ROUTE> LEAD to enable leading.", location = "PvE", pattern = "^ba (\\w+)$"},
  {title = "Follow Basher Toggle", alias = "ba follow", tags = "pve, bashing, quickpveassisted", description = "This will put you in follow mode with the basher, it will not try to move you but will attack targets it finds in the room as you move around. Requires using the top alias first.", location = "PvE", pattern = "^ba (\\w+)$"},
  {title = "Bashing Circuit List", alias = "ba list", tags = "pve, bashing, quickpveassisted", description = "This will display the list of known bashing circuits for you to use!", location = "PvE", pattern = "^ba (\\w+)$"},
  {title = "Bashing Follower Clear", alias = "ba waiting", tags = "pve, bashing, quickpveassisted", description = "Clears waiting on any followers you might be waiting on.", location = "PvE", pattern = "^ba (\\w+)$"},
  {title = "Support Basher Toggle", alias = "ba support", tags = "pve, bashing, quickpveassisted", description = "This works really well as a Bard. This will put you in support mode for bashing. This will focus more on healing than attacking but will still attack occasionally.", location = "PvE", pattern = "^ba (\\w+)$"},
  --{title = "Fishing Toggle", alias = "CURRENTLY DISABLED!!ba fish", tags = "pve, fishing", description = "CURRENTLY DISABLED Fishing circuit! Fish all the things!", location = "PvE", pattern = "^ba (\\w+)$"},
  {title = "Turn off the Basher", alias = "ba off", tags = "pve, bashing, quickpve, quickpveafterbashing", description = "Clears Top, Follow, Lead, and Autobashing settings. Turns it all off.", location = "PvE", pattern = "^ba (\\w+)$"},
  {title = "Reset Bashing Stats", alias = "rsbash", tags = "pve", description = "Resets the basher and clears your bashing group and the bashing stats.", location = "PvE", pattern = "^rsbash$"},
  {title = "Groups for Bashing", alias = "group <name>", tags = "pve, quickpve, bashing, quickpveassisted", description = "Add someone to your bashing group, this will let the basher attack NPCs in the same room as them.", location = "PvE", pattern = "^group (\\w+)$"},
  {title = "Clear Bashing Group", alias = "group clear", tags = "pve, quickpve, bashing, quickpveassisted", description = "You can now GROUP CLEAR to clear your bashing group all at once.", location = "PvE", pattern = "^group (\\w+)$"},
  {title = "Push your rowan box.", alias = "psb", tags = "misc", description = "Have a rowan box? Well this pushes it.. a lot", location = "PvE", pattern = "^psb$"},
  {title = "Pull your rowan box.", alias = "plb", tags = "misc", description = "Have a rowan box? If you want to pull it, this one is for you", location = "PvE", pattern = "^plb$"},
  {title = "Pull, Open, Close that rowan box", alias = "poc", tags = "misc", description = "Rowan box alias, it will try to pull, open, and close it.", location = "PvE", pattern = "^poc$"},
  {title = "Gauntlet Grab and Eld", alias = "geld", tags = "ylem, lesser, twin, ley", description = "Grab an eld and shake the life out of it. Don't miss or people might laugh at you!", location = "PvE", pattern = "^geld$"},
  {title = "Rime Farm Almanac", alias = "rime farm <nothing> or <plant>", tags = "mercantile, farming", description = "Like farming? Want to know how long it takes something to grow, or when you can plant a certain plant? The Almanac has it all! Except animals.. Somehow those got left out.", location = "Mercantile -> Farming", pattern = "^rime farm(?:$| (\\w+)$)"},
  {title = "Bashing Stats", alias = "bash stats", tags = "pve", description = "Shows a readout of information about your bashing, this is a more detailed version of what deplays when a mob dies.", location = "PvE", pattern = "^bash stats$"},
  {title = "Support PvE", alias = "pveplacerholderalias", tags = "hidden", description = "Yeah this all got rolled into <red>BA <red>SUPPORT so just use that. Why you looking at hidden tags anyways? I wonder if I can exclude hidden tags completely except by the tag search.. Something to look at one day, not today though. Enjoy this!", location = "PvE", pattern = "^pveplacerholderalias$"},
  {title = "Designate your Bashing Leader", alias = "top <person>", tags = "pve, quickpveassisted", description = "Designates who Rime will follow around and try to keep up while they bash. Has some triggers to help you keep with them as they move around locations. Make sure you also GROUP them.", location = "PvE", pattern = "^top (\\w+)$"},
  {title = "Reset the DPS Tracker", alias = "reset dps", tags = "pve", description = "Resets your DPS tracker to zero so you can start over and try something new. More DPS!", location = "PvE", pattern = "^reset dps$"},
  {title = "XP to LEVEL", alias = "xp to <number>", tags = "pve, bashing", description = "Curious how much more XP you need to get to the next level, or level 200? This will give you a nice readout with all that information!", location = "PvE", pattern = "^xp to (\\d+)$"},
  {title = "Clear Rebounding Aura", alias = "ac", tags = "quickpk, pk, pvp, curing", description = "Clears rebounding aura from the target. Useful if you missed a rebounding go down and now Rime is desperately trying to raise it, or just frenzying.", location = "PvP -> Misc", pattern = "^ac$"},
  {title = "PVP Route Selection", alias = "rs <route>", tags = "pk, pvp, quickpk, grouppksetup, quickpksetup", description = "You can use <red>RLL to see what routes are available for your class and <red>rs <route> to choose which route will fire when you send <red>ai<white.", location = "PvP -> Misc", pattern = "^rs (.+)$"},
  {title = "PVP Route List", alias = "rll", tags = "pk, pvp, quickpk, grouppksetup, quickpksetup", description = "This lets you view the list of routes available to you for your current class.", location = "PvP -> Misc", pattern = "^rll$"},
  {title = "Order Loyals Passive", alias = "oep", tags = "pk, pvp, praenomen, indorani", description = "Orders your loyals to be passive", location = "PvP -> Misc", pattern = "^oep$"},
  {title = "Order Loyals Attack", alias = "oek", tags = "pk, pvp, praenomen, indorani", description = "Orders your loyals to kill your current Rime target", location = "PvP -> Misc", pattern = "^oek$"},
  {title = "Wield Weapon", alias = "ww", tags = "pk, pvp, quickpk, grouppk, grouppvp, quickpksetup", description = "Wield your weapon", location = "PvP -> Misc", pattern = "^ww$"},
  {title = "Firelash target", alias = "fl", tags = "pkmisc", description = "Firelash your Rime target.", location = "PvP -> Misc", pattern = "^fl$"},
  {title = "Eyesigil to Ground", alias = "esi", tags = "pkmisc, defences", description = "Wield an eye sigil, throw it on the ground. Reveal all those hidden folk!", location = "PvP -> Misc", pattern = "^esi$"},
  {title = "Where Am I?", alias = "loc", tags = "pkmisc, pkleader", description = "Announce on Web your current location. You can also customize this message, see <red>?customization", location = "PvP -> Misc", pattern = "^loc$"},
  {title = "Web Tattoo Them", alias = "tw <white>or <red>tw <target>", tags = "pkmisc", description = "Touch web for your Rime Target or you can specify a target. And Stay Down!", location = "PvP -> Misc", pattern = "^tw(?: (\\w+)|)$"},
  {title = "Brazier Them", alias = "tb <white>or<red> tb <target>", tags = "pkmisc", description = "Touch brazier for your Rime target, or the target you specify. Get over here!", location = "PvP -> Misc", pattern = "^tb(?: (\\w+)|)$"},
  {title = "Tentacle Them", alias = "tnt <white>or<red> tnt <target>", tags = "pkmisc", description = "Touch tentacle for your Rime target, or the target you specify. Get back here!", location = "PvP -> Misc", pattern = "^tnt(?: (\\w+)|)$"},
  {title = "Fire Icewall", alias = "fr", tags = "pkmisc", description = "Breath fire at an icewall. Need to be able to breath fire.", location = "PvP -> Misc", pattern = "^fr$"},
  {title = "Unblock yourself", alias = "ub <white>or <red>unblock", tags = "pkmisc", description = "Unblocks your blocked direction.", location = "PvP -> Misc", pattern = "^(ub|unblock)$"},
  {title = "Parry Prediction Mode", alias = "pp <1|2|3>", tags = "pkmisc", description = "Allows you to change how the parry prediction mode operates between 3 different modes.", location = "PvP -> Misc", pattern = "^pp <\\d+)$"},
  {title = "Firelash the Icewall", alias = "sear <direction>", tags = "pkmisc", description = "This will point your firelash ring in the direction specified. Icewalls be gone!", location = "PvP -> Misc", pattern = "^sear (\\w+)$"},
  {title = "Night Eye Pendant", alias = "pe <playername>", tags = "pkmisc", description = "If you have retrieved the Night Eye Pendant from the Hunting Grounds, you can use this to find people.", location = "PvP - Misc", pattern = "^pe (\\w+)$"},
  {title = "Icewall it up", alias = "ice <direction>", tags = "pkmisc", description = "Point your icewall enchanted ring at a direction to block movement from that direction.", location = "PvP -> Misc", pattern = "^ice (\\w+)$"},
  {title = "Bows Up", alias = "bow", tags = "pkmisc", description = "Will send QEB STAND <your rime seperator> QUICKWIELD BOTH BOW.", location = "PvP -> Misc", pattern = "^bow$"},
  {title = "Farsee", alias = "fars", tags = "pkmisc", description = "Farsee your Rime Target", location = "PvP -> Misc", pattern = "^fars$"},
  {title = "Blizzard - ICEWALLS UP", alias = "bli", tags = "pkmisc", description = "MANIPULATE PYLON FOR BLIZZARD to raise an icewall in every direction.", location = "PvP -> Misc", pattern = "^bli$"},
  {title = "Lure", alias = "lu", tags = "praenomen", description = "Lure your target to you - Works up to 3 rooms away", location = "PvP -> Misc", pattern = "^lu$"},
  {title = "Lust", alias = "lu", tags = "indorani", description = "Orders your Doppleganger to seek your Rime Target and throw a Lust card at them.", location = "PvP -> Misc", pattern = "^lu$"},
  {title = "Shoot Ghost Arrows", alias = "sg", tags = "pkmisc", description = "Quickwields your bow and shoots a ghost arrow at your Rime Target.", location = "PvP -> Misc", pattern = "^sg$"},
  {title = "Golem Call", alias = "gc", tags = "teradrim", description = "Calls your Golem to you", location = "PvP -> Misc", pattern = "^gc$"},
  {title = "Gravity Cannon", alias = "gc", tags = "sciomancer", description = "Fires a Gravity Cannon at your Rime target", location = "PvP -> Misc", pattern = "^gc$"}, 
  {title = "Handwrap them", alias = "hw", tags = "pkmisc", description = "Uses handwraps on your Rime target", location = "PvP -> Misc", pattern = "^hw$"},
  {title = "Shoot them with Voyria", alias = "sv", tags = "pkmisc", description = "Quickwields your bow and shoots them with voyria. Bard Oblivion begone!", location = "PvP -> Misc", pattern = "^sv$"},
  {title = "Boomerang", alias = "bo <target>", tags = "pkmisc", description = "Puts your weapons away, gets your boomerang out, and throws it at your Rime target.", location = "PvP -> Misc", pattern = "^bo (\\w+)$"},
  {title = "Set Location Blurb", alias = "set location <message>", tags = "setup, customization, pkleader", description = "Lets you customize what message you send out with <red>LOC. I recommend ending your message with the word at.", location = "PvP -> Misc", pattern = "^set location (.+)$"},
  {title = "Upkeep Off", alias = "wo", tags = "praenomen", description = "Turn off the Praenomen Upkeep", location = "PvP -> Praenomen", pattern = "^wo$"},
  {title = "Minion: Hallucinations / Mana Ent", alias = "wraith", tags = "praenomen", description = "Raises a mental minion with an eldritch mutation.", location = "PvP -> Praenomen", pattern = "^wraith$"},
  {title = "Minion: Paresis / HP Ent", alias = "ghast", tags = "praenomen", description = "Raises a physical minion with a ghastly mutation.", location = "PvP -> Praenomen", pattern = "^ghast$"},
  {title = "Minion: Fangbarrier / HP Ent", alias = "wight", tags = "praenomen", description = "Raises a physical minion with an oozing mutation.", location = "PvP -> Praenomen", pattern = "^wight$"},
  {title = "Minion: Haemophilia / Physical Ent", alias = "ghoul", tags = "praenomen", description = "Raises a physical minion with a festering mutation.", location = "PvP -> Praenomen", pattern = "^ghoul$"},
  {title = "Fade away", alias = "f <direction>", tags = "praenomen", description = "Dismount and fade to the direction indicated", location = "PvP -> Praenomen", pattern = "^f (\\w+)$"},
  {title = "Curse Setting", alias = "set <curse/poison> <stacks>", tags = "praenomen", description = "Sets when Rime will attempt to curse or poison your Rime target based on the number of stacks they have.", location = "PvP -> Praenomen", pattern = "^set (curse|poison) (\\d+)$"},
  {title = "Fling", alias = "fli", tags = "praenomen", description = "Fling your Rime target into the air.", location = "PvP -> Praenomen", pattern = "^fli$"},
  {title = "Simoon", alias = "simo", tags = "teradrim", description = "Uses SAND SIMOON <target> to spread your sand around.", location = "PvP -> Teradrim", pattern = "^simo$"},
  {title = "Shift", alias = "sh", tags = "teradrim", description = "Uses SAND SHIFT <target> to swap locations with your target. Provided you have your sand in your location and theirs.", location = "PvP -> Teradrim", pattern = "^sh$"},
  {title = "Slice", alias = "sli", tags = "teradrim", description = "Uses SAND SLICE <target> STORM to utilize your sandstorm and attack your target", location = "PvP -> Teradrim", pattern = "^sli$"},
  {title = "Flood", alias = "ss", tags = "teradrim", description = "Casts SAND FLOOD to get your sand down in your location", location = "PvP -> Teradrim", pattern = "^ss$"},
  {title = "Storm", alias = "st", tags = "teradrim", description = "Uses SAND STORM to summon a sandstorm in your area to be used with your other abilities", location = "PvP -> Teradrim", pattern = "^st$"},
  {title = "Desiccate", alias = "des", tags = "teradrim", description = "Uses SAND DESICCATE to remove unnatural overgrowth from your current location", location = "PvP -> Teradrim", pattern = "^des$"},
  {title = "Fracture Toggle", alias = "fm <on/off>", tags = "teradrim", description = "Toggle for Fracture mode in the PVP system to make use of EARTH FRACTURE", location = "PvP -> Teradrim", pattern = "^fm (\\w+)$"},
  {title = "Desiccation Whirl", alias = "swi", tags = "teradrim", description = "Uses SAND WHIRL to pull the sand flood in your location into your sandstorm.", location = "PvP -> Teradrim", pattern = "^fu$"},
  {title = "Sand Wave", alias = "wa <target>", tags = "teradrim", description = "Uses SAND WAVE <target> to remove the specified target from your location. You must specify the target. This ignores the mass defense!", location = "PvP -> Teradrim", pattern = "^wa (\\w+)$"},
  {title = "Set your Hounds", alias = "set hounds <trait> <hound>", tags = "carnifex, hounds", description = "Tell Rime which hound to use for which ability.", location = "PvP -> Carnifex", pattern = "^set hound(?:|(\\w+)(\\w+))$"},
  {title = "Show your Hound List", alias = "show hounds", tags = "carnifex, hounds", description = "Check which hounds you've set Rime to use with which abilities.", location = "PvP -> Carnifex", pattern = "^show hounds$"},
  {title = "Crush and Pulverise", alias = "cc", tags = "carnifex", description = "Trip a standing opponent, crush a fallen one, pulverize a crushed one.", location = "PvP -> Carnifex -> Savagery", pattern = "^cc$"},
  {title = "Pole Hook Cheese", alias = "fuckyou", tags = "carnifex", description = "Utilize the pole hook cheese", location = "PvP -> Carnifex -> Savagery", pattern = "^fuckyou$"},
  {title = "Hook Crush Cheese", alias = "fuckyou2", tags = "carnifex", description = "Utilize the hook crush cheese", location = "PvP -> Carnifex -> Savagery", pattern = "^fuckyou2$"},
  {title = "Prepare to Charge", alias = "charge", tags = "carnifex", description = "Tell the offense you would like to prepare to charge your target.", location = "PvP -> Carnifex -> Savagery", pattern = "^charge$"},
  {title = "Wrench", alias = "db", tags = "carnifex", description = "Attempt to wrench whoever you have skewered.", location = "PvP -> Carnifex -> Savagery", pattern = "^db$"},
  {title = "Bruteforce", alias = "force", tags = "carnifex", description = "Turns on HAMMER FORCE so you can smack people harder.", location = "PvP -> Carnifex -> Savagery", pattern = "^force$"},
  {title = "Hammer Batter", alias = "batter", tags = "carnifex", description = "Batter your rime target", location = "PvP -> Carnifex -> Savagery", pattern = "^batter$"},
  {title = "Pole Skewer", alias = "imp <white>or<red> imp <target>", tags = "carnifex", description = "Interrupts the offense and attempts to skewer your target.", location = "PvP - Carnifex - Savagery", pattern = "^imp(?: (\\w)|)$"},
  {title = "Pole Sweep All", alias = "psa", tags = "carnifex", description = "Pole sweep everyone", location = "PvP -> Carnifex -> Savagery", pattern = "^psa$"},
  {title = "Pole Sweep", alias = "ps", tags = "carnifex", description = "Pole sweep everyone who has recently engaged you", location = "PvP -> Carnifex -> Savagery", pattern = "^ps$"},
  {title = "Pole Hook", alias = "ph <white>or <red> ph <target>", tags = "carnifex", description = "Will attempt to trip your target, or whoever you specify.", location = "PvP -> Carnifex -> Savagery", pattern = "^ph(?:|(\\w+))$"},
  {title = "Hammer Throw", alias = "ht", tags = "carnifex", description = "Will attempt to throw your hammer at your target.", location = "PvP -> Carnifex - > Savagery", pattern = "^ht$"},
  {title = "Soul Storm", alias = "ss", tags = "carnifex", description = "Will attempt to destroy a Shaman or Alchemists familiar.", location = "PvP -> Carnifex -> Savagery", pattern = "^ss$"},
  {title = "Soul Reave", alias = "sr", tags = "carnifex", description = "Reave your targets soul", location = "PvP -> Carnifex -> Savagery", pattern = "^sr$"},
  --{title = "Restore Troops", alias = "restore <type>", tags = "ctf", description = "Used for restoring troops that have been taken down in the tower defense battleground minigame. I don't know why this is in the Carnifex folders, but it is!", location = "PvP -> Carnifex -> Deathlore", pattern = "^restore (\\w+)$"},
  {title = "Consume for Health", alias = "ch", tags = "carnifex", description = "Attempt to consume souls for health", location = "PvP -> Carnifex -> Deathlore", pattern = "^ch$"},
  {title = "Consume for Mana", alias = "cm", tags = "carnifex", description = "Attempt to consume souls for mana", location = "PvP -> Carnifex -> Deathlore", pattern = "^cm$"},
  {title = "Soul Sacrifice", alias = "dam", tags = "carnifex", description = "Sacrifice a portion of your health to bolster the next weapon attack you land against an opponent. This will increase the damage of the strike and briefly stun them for one time only.", location = "PvP -> Carnifex -> Deathlore", pattern = "^dam$"},
  {title = "Deathlore Toggle", alias = "dai", tags = "carnifex", description = "Toggles carn.wantDeathlore which allows some deathlore attacks to occur during your PVP offensive routes.", location = "PvP -> Carnifex -> Deathlore", pattern = "^dai$"},
  {title = "Get Monolith from Hound", alias = "gmono", tags = "carnifex", description = "Take a monolith from your hound, if it has one or has retrieved one.", location = "PvP -> Carnifex -> Warhounds", pattern = "^gmono$"},
  {title = "Hound retrieve monolith", alias = "hmono", tags = "carnifex", description = "Order your hound to retreieve a monolith.", location = "PvP -> Carnifex -> Warhounds", pattern = "^hmono$"},
  {title = "Hound Track", alias = "htrack <target>", tags = "carnifex", description = "Put your hound to work tracking down the designated target.", location = "PvP -> Carnifex -> Warhounds", pattern = "^htrack(?:(\\w+))$"},
  {title = "Hound Whistle", alias = "whis", tags = "carnifex", description = "Calls your hounds to you, if you are currently bashing it will also queue up for them to do HOUND OPENINGS", location = "PvP -> Carnifex -> Warhounds", pattern = "^whis$"},
  {title = "Whistle Call", alias = "whis", tags = "bard", description = "Produce such an intriguing whistle that nearby aggressive denizens and/or guards will be drawn to the sound, and will come investigate the cause.", location = "PvP -> Carnifex -> Warhounds", pattern = "^whis$"},
  {title = "Call Dogs", alias = "dogs", tags = "carnifex", description = "Cal your hounds to you.", location = "PvP -> Carnifex -> Warhounds", pattern = "^dogs$"},
  {title = "Hound Track System", alias = "track <person>", tags = "carnifex", description = "Mudlet refers to this as the 'Hound Track Annoyance System' so use with care. It will call your dogs and track your target.", location = "PvP -> Carnifex -> Warhounds", pattern = "^track (\\w+)$"},
  {title = "Track them down", alias = "track <person>", tags = "shapeshifter", description = "Using your snout you can quickly seek out your prey, bringing along anyone who might be following you. Your target must be outdoors and either in the same local area or in an adjacent one.", location = "PvP -> Carnifex -> Warhounds", pattern = "^track (\\w+)$"},
  {title = "EZ Alias", alias = "shi", tags = "shapeshifter", description = "'EZ Alias' to call the shifter offense.", location = "PvP -> Shifter", pattern = "^shi$"},
  {title = "Neckdrag", alias = "nd <direction>", tags = "shapeshifter", description = "Uses Neckdrag to pull your Rime target in the direction specified", location = "PvP -> Shifter", pattern = "^nd (\\w+)$"},
  {title = "Telepathy Lock", alias = "ml", tags = "monk", description = "Sends MIND LOCK <target> to start the locking process", location = "PvP -> Monk", pattern = "^ml$"},
  {title = "Kai Up Combo", alias = "ku <target>", tags = "monk", description = "Combo's Slam Bladehand Bladehand against your specified target", location = "PvP -> Monk", pattern = "^ku (\\w+)$"},
  {title = "Kaido Deliverance", alias = "del", tags = "monk", description = "Casts KAI DELIVERANCE and pauses the system - Get'im!", location = "PvP -> Monk", pattern = "^del$"},
  {title = "System Pause", alias = "upp", tags = "system", description = "Pauses the system completely with no commands sent to server", location = "PvP -> Monk", pattern = "^upp$"},
  {title = "Singularity", alias = "sing", tags = "sciomancer", description = "On EQ/BAL, casts Genesis with weight, absorb, attunement, pulsar, tether, and retardation", location = "PvP -> Sciomancer", pattern = "^sing$"},
  {title = "Transfix", alias = "tf", tags = "sciomancer", description = "Orders your shadeling to attack your Rime target, and then casts transfix on your target", location = "PvP -> Sciomancer", pattern = "^tf$"},
  {title = "Grip", alias = "gp", tags = "sciomancer", description = "Casts Gravity Grip on your traget, giving them paresis and a stack of gravity.", location = "PvP -> Sciomancer", pattern = "^gp$"},
  {title = "Reflection", alias = "re", tags = "sciomancer", description = "Casts Reflection on yourself", location = "PvP -> Sciomancer", pattern = "^re$"},
  {title = "Advance", alias = "ga <direction>", tags = "sciomancer", description = "Turns off the system, stops gravity tether, and casts gravity advance in specified direction", location = "PvP - > Sciomancer", pattern = "^ga (\\w+)$"},
  {title = "Gravity Recall", alias = "gre", tags = "sciomancer", description = "Using GRAVITY RECALL, brings your singularity back to you.", location = "PvP -> Sciomancer", pattern = "^gre$"},
  {title = "Gravity Tether", alias = "gto", tags = "sciomancer", description = "Casts Gravity Tether On to tether the singularity to you.", location = "PvP -> Sciomancer", pattern = "^gto$"},
  {title = "Blow this popsicle stand", alias = "boom", tags = "sciomancer", description = "Start to collapse your singularity, sends 'BRAZIER ME' over web, and tries to use a translocator.", location = "PvP -> Sciomancer", pattern = "^boom$"},
  {title = "Prop Aegis", alias = "prop", tags = "sciomancer", description = "Stand up, and CAST ENSORCELL AEGIS", location = "PvP -> Sciomancer", pattern = "^prop$"},
  {title = "Labyrinth", alias = "lab", tags = "sciomancer", description = "Casts TRACE LABYRINTH which will move the first enemy to enter to your singularity", location = "PvP -> Sciomancer", pattern = "^lab$"},
  {title = "Reverse", alias = "rev", tags = "sciomancer", description = "Casts GRAVITY REVERSE to throw anything without density defence into the sky!", location = "PvP -> Sciomancer", pattern = "^add$"},
  {title = "Dismantle", alias = "gd", tags = "sciomancer", description = "Dismantle your personal singularity", location = "PvP -> Sciomancer", pattern = "^gd$"},
  {title = "Suggestions", alias = "sug", tags = "syssin", description = "Queue up suggestions from the system on your Rime Target.", location = "PvP -> Syssin", pattern = "^sug$"},
  {title = "Riving Jumpcut", alias = "jc", tags = "revenant", description = "Uses Jumpcut to attack someone in an adjacent location", location = "PvP -> Revenant", pattern = "^jc$"},
  {title = "Manifestation Engulf", alias = "eng", tags = "revenant", description = "Uses PHANTASM ENGULF on your shaded ally.", location = "PvP -> Revenant", pattern = "^eng$"},
  {title = "Sidestep to Tether", alias = "ssp", tags = "revenant", description = "Uses Phantasm Sidestep to your Tethered Phantasm. <red> Make sure to set your tether first!", location = "PvP -> Revenant", pattern = "^ssp$"},
  {title = "Sidestep to Shade", alias = "ss", tags = "revenant", description = "Uses Phantasm Sidestep to your Shaded Ally. Does not work on Monolith.", location = "PvP -> Revenant", pattern = "^ss$"},
  {title = "Manifestation Embolden", alias = "enb", tags = "revenant", description = "Emboldens your Phantasms so they do not consume mana until your next aggressive action.", location = "PvP -> Revenant", pattern = "^enb$"},
  {title = "Umbrage Wilave", alias = "wumb", tags = "revenant", description = "Uses Umbrage to strike everyone else in the room with Wilave to cause bleeding", location = "PvP -> Revenant", pattern = "^wumb$"},
  {title = "Owinta Combo Arc", alias = "arc ", tags = "revenant", description = "Uses Owinta to strike everyone else in the direction you specify. Checks for an icewall as well to see if you can do it.", location = "PvP -> Revenant", pattern = "^arc (\\w+)$"},
  {title = "Manifestation Retrieve", alias = "ret", tags = "revenant", description = "Retrieve your shaded ally to you, as long as they aren't on a monolith.", location = "PvP -> Revenant", pattern = "^ret$"},
  {title = "Manifestation Shade", alias = "sh <target>", tags = "revenant", description = "Cast shade on your specified target, allowing them the benefits of it some of your phantasm powers and opens them up for sidestep/retrieve", location = "PvP -> Revenant", pattern = "^sh (\\w+)$"},
  {title = "Lavacoat", alias = "lc", tags = "earthcaller", description = "Coat your crozier in lava", location = "PvP -> Earthcaller -> Tectonics", pattern = "^lc$"},
  {title = "Spew", alias = "sp <a/s>", tags = "earthcaller", description = "<red>sp <red>a<white> - Casts TECTONIC SPEW <target> AURA to remove that aura. <red> sp <red>s<white> - Casts TECTONIC SPEW <target> SHIELD to remove that shield. This will also set them on fire.", location = "PvP -> Earthcaller -> Tectonics", pattern = "^sp (\\w+)$"},
  {title = "Fossilize", alias = "fsl", tags = "earthcaller", description = "Casts TECTONIC FOZZILIZE on the Rime Target - Coats their pipes in magma!", location = "PvP -> Earthcaller -> Tectonics", pattern = "^fsl$"},
  {title = "Mold", alias = "mold", tags = "earthcaller", description = "Casts TECTONIC MOLD to heal your health and mana.", location = "PvP -> Earthcaller -> Tectonics", pattern = "^mold$"},
  {title = "Geyser", alias = "gey", tags = "earthcaller", description = "Casts TECTONIC GEYSER to destroy magical darkness", location = "PvP -> Earthcaller -> Tectonics", pattern = "^gey$"},
  {title = "Thermics", alias = "trm <m/p>", tags = "earthcaller", description = "<red>trm <red>m - Casts Thermics to remove a mental affliction. <red>trm <red>p<white> - Casts Thermics to remove a physical affliction", location = "PvP -> Earthcaller -> Tectonics", pattern = "^trm (\\w+)$"},
  {title = "Swallow", alias = "swl", tags = "earthcaller", description = "Casts TECTONIC SWALLOW UNDEAD to return the undead to the earth.", location = "PvP -> Earthcaller -> Tectonics", pattern = "^swl$"},
  {title = "Firewall", alias = "fw <direction>", tags = "earthcaller", description = "Casts TECTONIC FIREWALL in the specified direction.", location = "PvP -> Earthcaller -> Tectonics", pattern = "^fw (\\w+)"},
  {title = "Motions", alias = "motions", tags = "earthcaller", description = "Casts TECTONIC MOTIONS to detect those in your location", location = "PvP -> Earthcaller -> Tectonics", pattern = "^motions$"},
  {title = "Pyroclasm", alias = "pryo", tags = "earthcaller", description = "Casts TECTONIC PYROCLASM and 'scourge all who stand before you'", location = "PvP -> Earthcaller -> Tectonics", pattern = "^pryo$"},
  {title = "Ashcloud", alias = "cloud", tags = "earthcaller", description = "Casts TECTONIC ASHCLOUD - Become an ash cloud!", location = "PvP -> Earthcaller Tectonics", pattern = "^cloud$"},
  {title = "Diverge", alias = "part <direction>", tags = "earthcaller", description = "Casts DIRGE DIVERGE <direction> to part the water in the specified direction", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^part (\\w+)$"},
  {title = "Revelation", alias = "rvl", tags = "earthcaller", description = "Casts DIRECT REVELATION to shield you from the next illusion", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^rvl$"},
  {title = "Earthcall", alias = "etc <target/nothing>", tags = "earthcaller", description = "If target specified, cast DIRGE EARTHCALL on the rime target to travel to any in the verse. If no target specified, cast DIRGE VERSE OF EARTHCALL to call the verse.", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^etc(?: (\\w+))?$"},
  {title = "Execration", alias = "exc", tags = "earthcaller", description = "Cast DIRGE EXECRATION on your Rime target.", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^exc$"},
  {title = "Ground", alias = "dgd", tags = "earthcaller", description = "Cast DIRGE GROUND to anchor yourself in place. Cast it again to unanchor yourself.", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^dgd$"},
  {title = "Enervation", alias = "env", tags = "earthcaller", description = "Cast DIRECT VERSE OF ENERVATION damaging and draining mana on your enemies.", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^env$"},
  {title = "Sentencing", alias = "stc <target/nothing>", tags = "earthcaller", description = "If target specified, cast DIRGE SENTENCE on the rime target, bring them you. If no target specified, cast DIRGE VERSE OF EARTHCALL to call the verse to the marked location", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^stc(?: (\\w+))?$"},
  {title = "Empowerment", alias = "emp", tags = "earthcaller", description = "Cast DIRGE VERSE OF EMPOWERMENT to heal you and your allies of afflictions occasionally. This is turned off in Mudlet in my version by default.", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^emp$"},
  {title = "Marshal", alias = "msh <target>", tags = "earthcaller", description = "Cast DIRGE MARSHALL against the specified target - Summon your allies!", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^msh$"},
  {title = "Imperishable", alias = "rez <target>", tags = "earthcaller", description = "If you have their corpse (living or undead, not vampires/akkari), you can resurrect them.", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^rez (\\w+)"},
  {title = "Libation", alias = "lib", tags = "earthcaller", description = "Casts DIRGE VERSE OF LIBATION to consume all corpses in the room to deny them resurrection", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^lib$"},
  {title = "Eternity", alias = "etr <anything/nothing>", tags = "earthcaller", description = "etr - Cast DIRGE VERSE OF ETERNITY - Place your verse. etr <anything> - Cast DIRGE ETERNITY - Call all verses within the Verse of Eternity", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^etr(?: (\\w+))?$"},
  {title = "Imprisonment", alias = "imp", tags = "earthcaller", description = "Casts DIRGE VERSE OF IMPRISONMENT - Try to hold your enemies in the room with you", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^imp$"},
  {title = "Bye", alias = "b <target>", tags = "earthcaller", description = "Give your translocator, give tot your target, and ordain them to use it. Poof!", location = "PvP -> Earthcaller -> Apocalyptia", pattern = "^b (\\w+)"},
  {title = "Osso Draw", alias = "od", tags = "earthcaller", description = "Draw the bones from the earth.", location = "PvP -> Earthcaller -> Subjugation", pattern = "^od$"},
  {title = "Osso Graft", alias = "og", tags = "earthcaller", description = "Graft the bones fragments to heal your physical wounds", location = "PvP -> Earthcaller -> Subjugation", pattern = "^og$"},
  {title = "Osso Swarm", alias = "swm", tags = "earthcaller", description = "Prevent anyone from glancing in your room.", location = "PvP -> Earthcaller -> Subjugation", pattern = "^swm$"},
  {title = "Osso Scatter", alias = "scat", tags = "earthcaller", description = "Track your enemies movement in the local area.", location = "PvP -> Earthcaller -> Subjugation", pattern = "^scat$"},
  {title = "Osso Glean", alias = "ogl <target>", tags = "earthcaller", description = "Find your enemy - regardless of where they might be.", location = "PvP -> Earthcaller -> Subjugation", pattern = "^ogl (\\w+)"},
  {title = "Ossification", alias = "oss", tags = "earthcaller", description = "Recall your bone fragments to replenish some of your health", location = "PvP -> Earthcaller -> Subjugation", pattern = "^oss$"},
  {title = "Osso Lurch", alias = "lch <target/nothing>", tags = "earthcaller", description = "Try to pull your target into the room with you, is no target, pull all around you.", location = "PvP -> Earthcaller -> Subjugation", pattern = "^lch(?: (\\w+))?$"},
  {title = "Osso Disperse", alias = "dsp", tags = "earthcaller", description = "Disperse bone fragments to assess the local area and gather information on all around you.", location = "PvP -> Earthcaller -> Subjugation", pattern = "^dsp$"},
  {title = "Contemplate", alias = "ctm", tags = "earthcaller", description = "Casts CONTEMPLATE on your rime target, just what is their mana level?", location = "PvP -> Earthcaller -> Subjugation", pattern = "^ocl$"},
  {title = "Osso Wyrmward", alias = "ward", tags = "earthcaller", description = "Casts OSSO WYRMWARD", location = "PvP -> Earthcaller -> Subjugation", pattern = "^ctm$"},
  {title = "Osso Endoskeleton", alias = "endo", tags = "earthcaller", description = "Casts OSSO ENDOSKELETON", location = "PvP -> Earthcaller -> Subjugation", pattern = "^ward$"},
  {title = "Osso Oracle", alias = "ocl", tags = "earthcaller", description = "Oracle will track your target", location = "PvP -> Earthcaller -> Subjugation", pattern = "^endo$"},
  {title = "Empress", alias = "emp or emp <target>", tags = "indorani", description = "Will attempt to throw the Empress card at your current target, or whoever you specify.", location = "PvP -> Indorani", pattern = "^emp(?: (\\w+)|)$"},
  {title = "Gravehands", alias = "gh", tags = "indorani", description = "Summons gravehands at your current location! Make it hard for them to leave!", location = "PvP -> Indorani", pattern = "^gh$"},
  {title = "Pathfinder", alias = "op", tags = "indorani", description = "This kills the offenses and queues up ordering your path finder. Useful for quick get aways.", location = "PvP -> Indorani", pattern = "^op$"},
  {title = "Star", alias = "sta", tags = "indorani", description = "he Star tarot will bring down a flaming meteor upon your unlucky foe's head.", location = "PvP -> Indorani", pattern = "^sta$"},
  {title = "Priestess", alias = "pr or pr <target>", tags = "indorani", description = "Will attempt to throw the Priestess card at your current target, or whoever you specify.", location = "PvP -> Indorani", pattern = "^pr(?: (\\w+)|)$"},
  {title = "Fool", alias = "fo or fo <target>", tags = "indorani", description = "Will attempt to throw the Fool card at your current target, or whoever you specify.", location = "PvP -> Indorani", pattern = "^fo(?: (\\w+)|)$"},
  {title = "Set Deform", alias = "set deform <#>", tags = "indorani", description = "Will set the number of afflictions you want to use Deform at. Deform will not be cast unless your target has that many or more applicable afflictions.", location = "PvP -> Indorani", pattern = "^set deform (\\d+)$"},
  {title = "Adder Toggle", alias = "adder", tags = "indorani", description = "Toggles throwing adder cards at the rime target", location = "PvP -> Indorani", pattern = "^adder$"},
  {title = "Eclipse Throw Toggle", alias = "et", tags = "indorani", description = "Toggles eclipse throwing", location = "PvP -> Indorani", pattern = "^et$"},
  {title = "Soulmaster Toggle", alias = "soulmaster <on/off>", tags = "indorani", description = "Toggles your soulmaster on and off", location = "PvP -> Indorani", pattern = "^soulmaster (on|off)$"},
  {title = "Aeon Throw Toggle", alias = "ae", tags = "indorani", description = "Toggles aeon throwing", location = "PvP -> Indorani", pattern = "^ae$"},
  {title = "Doppie Decay", alias = "dec", tags = "indorani", description = "Orders your doppleganger to decay your rime target", location = "PvP -> Indorani", pattern = "^dec$"},
  {title = "Doppie Creator - Sleep", alias = "dsleep", tags = "indorani", description = "Orders your doppleganger to throw creator dreamscape", location = "PvP -> Indorani", pattern = "^dsleep$"},
  {title = "Doppie Belch", alias = "dbelch", tags = "indorani", description = "Orders your doopleganger to channel belch.", location = "PvP -> Indorani", pattern = "^dbelch$"},
  {title = "Death Rub/Throw", alias = "dea", tags = "indorani", description = "Rub that death card on your rime target, throws it if it has enough", location = "PvP -> Indorani", pattern = "^dea$"},
  {title = "Behead", alias = "bb", tags = "indorani", description = "Behead them!", location = "PvP -> Indorani", pattern = "^bb$"},
  {title = "Break All Pacts", alias = "pbreak", tags = "indorani", description = "Break all the pacts with your chaos lords, sounds safe.", location = "PvP -> Indorani -> Automated Pacting", pattern = "^pbreak$"},
  {title = "Begin Auto Pacting", alias = "pactup", tags = "indorani", description = "Lets you auto pact with the chaos lords, sounds safe.", location = "PvP -> Indorani -> Automated Pacting", pattern = "^pactup$"},
  {title = "Emergency Pact Brake", alias = "pactoff", tags = "indorani", description = "Lets you turn off the Auto Pact in the event it does something awful", location = "PvP -> Indorani -> Automated Pacting", pattern = "^pactoff$"},
  {title = "Throw Voidscape", alias = "void", tags = "indorani", description = "Queues up to throw a creator voidscape card at ground", location = "PvP -> Indorani", pattern = "^void$"},
  --{title = "Flick Voyria", alias = "", tags = "indorani", description = "", location = "PvP -> Indorani", pattern = "^fv$"},
  {title = "Sandman", alias = "sand", tags = "indorani", description = "Throw sandman card and sun card at your rime target, and do a lot of other stuff.", location = "PvP -> Indorani", pattern = "^sand$"},
  {title = "Position track", alias = "pos<f/r> <target>", tags = "archivist", description = "Will empower ej'tig and elicit position on the target with follow or return modifiers if specified", location = "PvP -> Archivist -> Numerology", pattern = "^pos(f|r|)( (\\w+)|)$"},
  {title = "Recollection Toggle", alias = "rec", tags = "archivist", description = "Enabling this permits the system to use recollection - a 3-second equilibrium ability that decreases all cooldowns (tree, focus, etc.) by up to 5 seconds each. This ability can also be used while prone.", location = "PvP -> Archivist -> Numerology", pattern = "^rec$"},
  {title = "Mutagen Handling", alias = "mutagen list <white>or<red> mtl", tags = "archivist", description = "Use after every load to tell the system about existing mutagens and reduce unnecessary requests for mutagens.", location = "PvP -> Archivist -> Bioessence", pattern = "^(mutagen list|mtl)$"},
  {title = "Knitting toggle", alias = "knit", tags = "archivist", description = "'This can be turned on or off to enable or disable the use of Knitting, which consumes balance and 1 bio energy for a powerful healing effect. This ability is particularly useful for support routes as Archivist is already highly damage resistant due to its Link ability.", location = "PvP -> Archivist -> Bioessence", pattern = "^knit$"},
  {title = "Ethereal toggle", alias = "eth", tags = "archivist", description = "This toggle enables/disable the use of Ethereal, which gives a short-lived but significant buff - lowering miss chances for physical abilities and increasing physical audit - for the cost of balance and 2 bio energy. It is mostly useful for support routes.", location = "PvP -> Archivist -> Bioessence", pattern = "^eth$"},
  {title = "Toggle wait growth", alias = "wg", tags = "archivist", description = "Enabling this to prioritizes the growth ability by instructing the system to use the wait function in routes that have it, slowing down the offense for better chances of hitting with growth.", location = "PvP -> Archivist -> Bioessence", pattern = "^wg$"},
  {title = "Anelace", alias = "ane", tags = "bard", description = "Uses Anelace on your rime target", location = "PvP -> Bard", pattern = "^ane$"},
  {title = "Remembrance", alias = "rem", tags = "bard", description = "Will sing the song of remembrance, restoring dithering after completion.", location = "PvP -> Bard", pattern = "^rem$"},
  {title = "Polarity", alias = "po", tags = "bard", description = "Will use the Polarity ability from Weaving on your current target.", location = "PvP -> Bard", pattern = "^po$"},
  {title = "Boundary", alias = "bo", tags = "bard", description = "Will use Boundary ability in Weaving.", location = "PvP -> Bard", pattern = "^bo$"},
  {title = "Alchemy Electroshock", alias = "eo", tags = "alchemist", description = "Casts ALCHEMY ELECTROSHOCK on your target.", location = "PvP -> Alchemist", pattern = "^eo$"},
  {title = "Virulent", alias = "vi", tags = "alchemist", description = "Sends ALCHEMY ACCELERATE on the rime target and then it will cast ALCHEMY VIRULENT on the rime target", location = "PvP -> Alchemist", pattern = "^vi$"},
  {title = "Alchemy Axphyxiant", alias = "ax", tags = "alchemist", description = "Casts ALCHEMY AXPHYXIANT on your target. This will attempt to strangle your target if they are prone.", location = "PvP -> Alchemist", pattern = "^ax$"},
  {title = "Cheap Omen Combo", alias = "om", tags = "alchemist", description = "Will rotate between using Infiltrative and Pathogen on your target, and cast a quick 2 affliction Causality on them when it can.", location = "PvP -> Alchemist", pattern = "^om$"},
  {title = "Botany Blight", alias = "bot", tags = "alchemist", description = "Summons your Blight!", location = "PvP -> Alchemist", pattern = "^bot$"},
  {title = "Botany Alluring", alias = "all", tags = "alchemist", description = "Casts BOTANY ALLURING on your current target. This will pull them into your room if they don't have the Density defense, or if they have the Pheromones affliction.", location = "PvP -> Alchemist", pattern = "^all$"},
  {title = "Botany Pheromones", alias = "pher", tags = "alchemist", description = "Casts BOTANY PHEROMONES on your current target. This will allow you to use BOTANY ALLURING on them so long as they're within your blight of a forested room.", location = "PvP -> Alchemist", pattern = "^pher$"},
  {title = "Botany Propagate", alias = "bpr", tags = "alchemist", description = "Casts BOTANY PROPAGATE on your current target. This sends your blight into their room.", location = "PvP -> Alchemist", pattern = "^bpr$"},
  {title = "Check your Compendium", alias = "check compendium", tags = "misc", description = "Checks your compendium and enables some compendium tracking triggers.", location = "PvP", pattern = "^check compendium$"},
  {title = "Drakuum", alias = "drak", tags = "travel", description = "Travels to Drakuum (19854)", location = "Travel", pattern = "^drak$"},
  {title = "Spinesreach", alias = "spines", tags = "travel", description = "Travels to Spinesreach (11708)", location = "Travel", pattern = "^spines$"},
  {title = "Crack in Bloodloch", alias = "crack", tags = "travel", description = "Travels to 'A crack in the mountainside' (9193)", location = "Travel", pattern = "^crack$"},
  {title = "West Gate in Bloodloch", alias = "loch", tags = "travel", description = "Travels to Bloodloch (1331)", location = "Travel", pattern = "^loch$"},
  {title = "Boiling Point in Bloodloch", alias = "bp", tags = "travel", description = "Travels to 'The Boiling Point' in Bloodloch (9330)", location = "Travel", pattern = "^bp$"},
  {title = "Voltadaran", alias = "vor", tags = "travel", description = "Say 'Voltdaran' and go to the Deeper Caves - Need the Artifact!", location = "Travel", pattern = "^vor$"},
  {title = "Ayhesa", alias = "ayhesa", tags = "travel", description = "Travels to 'Cliffs along the ocean' in the Ayhesa Cliffs (19987)", location = "Travel", pattern = "^ayhesa$"},
  {title = "Hunting Grounds", alias = "hg", tags = "travel", description = "Travels to the Hunting Grounds (4746)", location = "Travel", pattern = "^hg$"},
  {title = "Grand Library", alias = "sgs", tags = "travel", description = "Travels to 'Vestibule of a research greenhouse' in the Grand Library (59238)", location = "Travel", pattern = "^sgs$"},
  {title = "Voltda", alias = "vo", tags = "travel", description = "Say 'Voltda' and go to the Caves - Need the Artifact! ARTIFACT INFO CAVES_BURROW", location = "Travel", pattern = "^vo$"},
  {title = "belmith", alias = "belmith", tags = "travel", description = "Goes to Belmith's location, Milestones!", location = "Travel", pattern = "^belmith$"},
  {title = "Number of Enchantment", alias = "enchant <number> <enchant>", tags = "mercantile, enchantment", description = "Adds the specified number of enchants to the queue.", location = "Mercantile -> Enchantment", pattern = "^enchant (\\d+) (\\w+)$"},
  {title = "Buy herbs", alias = "bh <number>", tags = "shopping", description = "Buys specified number of herbs from the store", location = "Mercantile -> Utilities", pattern = "^bh (\\d+)$"},
  {title = "Buy elixirs and salves", alias = "beas <number>", tags = "shopping", description = "Buys specified number of elixirs or salves from the store", location = "Mercantile -> Utilities", pattern = "^beas (\\d+)$"},
  {title = "Harvest plants", alias = "harvest <plants>", tags = "mercantile, harvesting", description = "Adds plants you wish to harvest to a table. Want to harvest rocks? Trying <red>Harvest with a capital. Example: harvest myrrh ginseng deathblossom", location = "Mercantile -> Utilities", pattern = "^harvest (.*)$"},
  {title = "Assisted Harvester", alias = "ahar", tags = "mercantile, harvesting", description = "Toggles on and off the assisted harvester. LOOK to get started, and then walk around the area and it will attempt to harvest as you walk into each location.", location = "Mercantile -> Utilities", pattern = "^ahar$"},
  {title = "Milk venoms", alias = "milk <venom> <number>", tags = "mercantile, toxicology", description = "Milks specified venom for specified number", location = "Mercantile -> Toxicology", pattern = "^milk (\\w+) (\\d+)$"},
  {title = "Weapon Forging for stats", alias = "wforge <style> <weapon> <number of damage tempers> <number of penetration tempers> <number of speed tempers> <damage> <penetration> <speed>", tags = "mercantile, forging", description = "Forge your weapon", location = "Mercantile -> Forging", pattern = "^wforge (\\w+) (\\w+) (\\d+) (\\d+) (\\d+) (\\d+) (\\d+) (\\d+)$"},
  {title = "Weapon Mass Production", alias = "mforge <number of items> <style> <weapon> <number of damage tempers> <number of penetration tempers> <number of speed tempers>", tags = "mercantile, forging", description = "Mass produce a specific weapon", location = "Mercantile -> Forging", pattern = "^mforge (\\d+) (\\w+) (\\w+) (\\d+) (\\d+) (\\d+)$"},
  {title = "Mass produce a specific armor", alias = "aforge <number of items> <style> <armor> <number of blunt tempers>", tags = "mercantile, forging", description = "Mass produce a specific armor.", location = "Mercantile -> Forging", pattern = "^aforge (\\d+) (\\w+) (\\w+) (\\d+) (\\d+)$"},
  {title = "Bombmaking", alias = "emir <type> <number>", tags = "mercantile, bombcrafting", description = "Create specified number of bombs of the specified type.", location = "Mercantile -> Bombcrafting", pattern = "^emir (\\w+) (\\d+)$"},
  {title = "Run lua code", alias = "lua <code>", tags = "misc", description = "This lets you test lua code from the command line, useful to testing out stuff.", location = "run-lua-code-v4", pattern = "^lua (.*)$"},
  {title = "Who Groups", alias = "whos", tags = "misc", description = "Checks WHO and sorts people into groups", location = "Mapper", pattern = "^whos$"},
  {title = "Walking", alias = "any direction", tags = "movement", description = "Used by Rime Movement so it can capture your movement to adjust it appropriately.", location = "Directions", pattern = "^(n|e|s|w|ne|nw|se|sw|in|up?|out|down|d)$"},
  {title = "Rime Movement Mode", alias = "rime movement", tags = "movement", description = "Toggles sigil movement mode (get monolith, get cube when entering a room)", location = "Directions", pattern = "^rime movement$"},
  {title = "Send Mail", alias = "mmail <item> to <person>", tags = "shopping, mail", description = "Sends specified item to specified person", location = "Misc", pattern = "^mmail (.+) to (\\w+)$"},
  {title = "Unvenom your rags", alias = "unvenom", tags = "pk", description = "Unloads your rags with all venoms into your fluidcache", location = "Misc", pattern = "^unvenom$"},
  {title = "Add venoms to rags", alias = "venoms", tags = "pk", description = "Loads your rags up with all venoms from your fluidcache", location = "Misc", pattern = "^venoms$"},
  {title = "Major Foci Logging", alias = "malpha <people names>", tags = "ylem, pkleader", description = "Takes a list of names, separated by commas, alphabetizes them and writes them to the raiders clan, logging a major foci.", location = "Misc", pattern = "^malpha (.*)$"},
  {title = "Orrery Logging", alias = "oalpha <people names>", tags = "pkleader", description = "Takes a list of names, separated by commas, alphabetizes them and writes them to the raiders clan, logging a orrery.", location = "Misc", pattern = "^oalpha (\\d+) (.*)$"},
  {title = "Lesser Foci Logging", alias = "lalpha <people names>", tags = "ylem, pkleader", description = "Takes a list of names, separated by commas, alphabetizes them and writes them to the raiders clan, logging a lesser foci.", location = "Misc", pattern = "^lalpha (.*)$"},
  {title = "Twin Foci Logging", alias = "twalpha <people names>", tags = "ylem, pkleader", description = "Takes a list of names, separated by commas, alphabetizes them and writes them to the raiders clan, logging a twin foci.", location = "Misc", pattern = "^twalpha (.*)$"},
  {title = "Alphabetize name with Web reporting", alias = "alpha <people names>", tags = "ylem, pkleader", description = "Takes a list of names, separated by commas, alphabetizes them and posts it to web. Useful to make sure you have everyone before you write it to the clan.", location = "Misc", pattern = "^alpha (.*)$"},
  {title = "Emoji search", alias = "emoji <wordsearch>", tags = "misc", description = "🎶 Search the built in emoji's for a specific one. 🎶", location = "Misc", pattern = "^emoji (\\w+)"},
  {title = "Add to Target List", alias = "atl <list of targets>", tags = "pkleader", description = "Set, and add to, a list of targets for automatic target swapping. Names are separated by spaces here.", location = "swarm -> Auto Targeting", pattern = "^atl (.+)$"},
  {title = "Reprioritize PVP Targets", alias = "atp <target> <priority>", tags = "pkleader", description = "Move a specified target around in the target list.", location = "swarm -> Auto Targeting", pattern = "^atp (\\w+)(?:\\s)?(\\d+)?$"},
  {title = "Show or Report Target List", alias = "tlist", tags = "pkleader", description = "Shows the list of targets, and calls it to web if target calling is enabled.", location = "swarm -> Auto Targeting", pattern = "^tlist$"},
  {title = "Clear the Target List", alias = "atlc", tags = "pkleader", description = "Clear the target list.", location = "swarm -> Auto Targeting", pattern = "^atlc$"},
  {title = "Automatic Target Swapping Toggle", alias = "sat", tags = "grouppksetup, pk, pvp, grouppkaftercombat", description = "Toggle automatic target swapping for group fights. This is very dangerous, make sure you toggle this off when you are done!", location = "swarm -> Auto Targeting", pattern = "^sat$"},
  {title = "Swarm Next Target", alias = "nt", tags = "pkleader, swarm", description = "Target your next player on the swarm target list.", location = "swarm -> Auto Targeting", pattern = "^nt$"},
  {title = "Swarm Remove Target", alias = "atr <target>", tags = "pkleader, swarm", description = "Remove someone from the swarm target list.", location = "swarm -> Auto Targeting", pattern = "^atr (\\w+)$"},
  {title = "Set Marching Division", alias = "set division <id number>", tags = "divisions, war, warmin", description = "Sets the rime internal reference for the current division you are marching.", location = "Totally Not War", pattern = "^set division (\\d+)"},
  {title = "March Troops", alias = "mt <direction>", tags = "divisions, war, warmin", description = "Orders your set division to march and path finds your target location", location = "Totally Not War", pattern = "^mt (\\w+)$"},
  {title = "Set March Destination", alias = "set destination <roomnum>", tags = "divisions, war, warmin", description = "Sets the destination for your division marching", location = "Totally Not War", pattern = "^set destination (.+)"},
  {title = "Fortify your Division", alias = "war fort", tags = "divisions, war, warmin", description = "Orders your set division to fortify", location = "Totally Not War", pattern = "^war fort$"},
  {title = "Go to the Bloodloch Barracks", alias = "barracks", tags = "divisions, war, warmin, travel", description = "Goes to the Bloodloch Barracks", location = "Totally Not War", pattern = "^barracks$"},
  {title = "Militia Coloring - Set City Color", alias = "mil <city> <colour>", tags = "militia, war", description = "Sets the colour for the city.", location = "Totally Not War -> Militia Colours", pattern = "^mil colour (\\w+) (\\w+)$"},
  {title = "Militia Coloring - Add militia member", alias = "mil add <city> player1 player2 etc", tags = "militia, war", description = "Adds the list of players to the specified city", location = "Totally Not War -> Militia Colours", pattern = "^mil add (\\w+) (.+)$"},
  {title = "Militia Coloring - Reset militia list", alias = "mil reset", tags = "militia, war", description = "Deletes all current militia members from their cities.", location = "Totally Not War -> Militia Colours", pattern = "^mil reset$"},
  {title = "Militia Coloring - Show city colours", alias = "mil colours", tags = "militia, war", description = "Displays the currently set colours city militia.", location = "Totally Not War -> Militia Colours", pattern = "^mil colours$"},
  {title = "Militia Coloring - Toggle highlighting colour", alias = "mil highlight", tags = "militia, war", description = "Toggles on/off militia highlights based on the colours in MIL COLOURS.", location = "Totally Not War -> Militia Colours", pattern = "^mil highlight$"},
  {title = "Militia Coloring - mil Help", alias = "mil", tags = "militia, war", description = "The old Militia Coloring help file.", location = "Totally Not War -> Militia Colours", pattern = "^mil$"},
  {title = "Militia Coloring - Display militia members", alias = "mil display", tags = "militia, war", description = "Displays all currently known militia members and their cities", location = "Totally Not War -> Militia Colours", pattern = "^mil display$"},
  {title = "Militia Coloring - Update city militia list", alias = "mil update <city>", tags = "militia, war", description = "Updates the list of militia members for the specified city", location = "Totally Not War -> Militia Colours", pattern = "^mil update (\\w+)$"},
  {title = "zGUI -> (ZGUI)", alias = "zgui", tags = "zgui", description = "Restarts zGUI completely", location = "zGUI", pattern = "^zgui$"},
  {title = "zGUI -> zGUI Default Font Size", alias = "zguis", tags = "zgui", description = "Sets defaults for zGUI font sizes", location = "zGUI", pattern = "^zguis$"},
  {title = "zGUI -> Show zGui window", alias = "zshow <white>or <red>zshow <window>", tags = "zgui", description = "Reveals the window indicated, zshow will show more specific syntax.", location = "zGUI", pattern = "^zshow(?: (\\w+))?$"},
  {title = "zGUI -> Changes zGUI Style", alias = "zstyle <white>or <red>zstyle <style>", tags = "zgui", description = "Changes windows to the specified style, zstyle will show more specific syntax", location = "zGUI", pattern = "^zstyle(?: (\\w+))?$"},
  {title = "zGUI -> zGUI Window Fixer", alias = "zfix<white> or <red>zfix <window>", tags = "zgui", description = "Attempts to fix a specific window, zfix will show more information", location = "zGUI", pattern = "^zfix(?: (\\w+))?$"},
  {title = "zGUI -> zGUI Chat Prompt", alias = "zchat", tags = "zgui", description = "Adds a command line to your chat window.", location = "zGUI", pattern = "^zchat$"},
  {title = "zGUI -> Help Window Revealer", alias = "zhelp", tags = "zgui", description = "Opens the zhelp window so you can turn on and off modules.", location = "zGUI", pattern = "^zhelp$"},
  {title = "Web Info", alias = "web info", tags = "pkleader, pkmisc, misc, swarm", description = "Looks over all the web members and gives you a printout of what classes everyone is in.", location = "swarm-qol", pattern = "^(web info)$"},
  {title = "Buy 20 Milestone Credits", alias = "mcreds", tags = "swarm, milestones, misc, pve", description = "Buy Milestone Credits, 20 at a time.", location = "swarm-qol - Milestone Credit Helpers", pattern = "^mcreds$"},
  {title = "Milestone checker", alias = "mlist", tags = "swarm, milestones, pve, misc", description = "Check your milestones.", location = "swarm-qol - Milestone Credit Helpers", pattern = "^mlist$"},
  {title = "Claim Credit Milestones", alias = "mclaim", tags = "swarm, milestones, pve, misc", description = "Claim your milestones.", location = "swarm-qol - Milestone Credit Helpers", pattern = "^mclaim$"},
  {title = "Loop Sending", alias = "#<number> <command>", tags = "swarm", description = "Sends the command the specified number of times. Do not use this to spam people. >:(", location = "swarm-qol", pattern = "^#(\\d+) (.*)$"},
  {title = "Mapper Goto", alias = "goto <vnum/area/feature>", tags = "referential, mmapper", description = "Goto has a lot of things you can specify with it, vnum will take you to that vnum, area will take you to that area, and goto feature <feature> will go to the nearest room with the specified map feature.", location = "Mudlet Mapper", pattern = "^goto (.+)$"},
  {title = "Mapper Pause", alias = "mpp <on/off>", tags = "referential, mmapper", description = "Toggles mapper to be paused on or off, this can stop pathing and other things.", location = "Mudlet Mapper", pattern = "^mpp(?:\\s?(on|off))?$"},
  {title = "Mapper Stop", alias = "mstop", tags = "referential, mmapper", description = "Stops the mapper completely - Useful if you GOTO the wrong location and need to stop moving.", location = "Mudlet Mapper", pattern = "^mstop$"},
  {title = "Mapper Room Find", alias = "rf <name>", tags = "referential, mmapper", description = "Searches the map for the room name you have provided.", location = "Mudlet Mapper", pattern = "^(?:rf|room find) (.+)$"},
  {title = "Mapper Room Marks", alias = "room marks", tags = "referential, mmapper", description = "Lists all room marks the map has stored.", location = "Mudlet Mapper", pattern = "^room marks$"},
  {title = "Mapper Marking Rooms", alias = "room mark <mark_name> <room>", tags = "referential, mmapper", description = "Adds a mark for a given room with the name. Doing goto <mark_name> will take you directly there.", location = "Mudlet Mapper", pattern = "^room mark (\\w+)(?: (\\w+))?$"},
  {title = "Mapper Unmarking Room", alias = "room unmark <mark_name>", tags = "referential, mmapper", description = "Removes a mark with that name from your current room..", location = "Mudlet Mapper", pattern = "^room unmark (\\w+)$"},
  {title = "Mapper Area List", alias = "area list", tags = "referential, mmapper", description = "Shows the known area list", location = "Mudlet Mapper", pattern = "^area list$"},
  {title = "Mapper Room List", alias = "room list <area>", tags = "referential, mmapper", description = "Shows the list of rooms in an area", location = "Mudlet Mapper", pattern = "^room list(?: (.+))?$"},
  {title = "Mapper Area Lock", alias = "arealock <area>", tags = "referential, mmapper", description = "displays a list of areas you can lock/unlock, can also give it an area name to filter by. If an area is locked the mapper will not attempt to walk through or go through any of the rooms in the area", location = "Mudlet Mapper", pattern = "^arealock(?: (.*))?$"},
  {title = "Mapper Room Look", alias = "rl or rl <id>", tags = "referential, mmapper", description = "Displays information either about the room you are in, or the room you have specified. ", location = "Mudlet Mapper", pattern = "^(?:rl|room look)(?: (.+))?$"},
  {title = "Mapper Show Path", alias = "showpath <vnum>", tags = "referential, mmapper", description = "Shows you a path from where you are to another room", location = "Mudlet Mapper", pattern = "^showpath(?: (\\d+))?(?: (\\d+))?$"},
  {title = "Mapper Show Path Remote", alias = "showpath <fromVnum> <toVnum>", tags = "referential, mmapper", description = "Shows the path between two rooms", location = "Mudlet Mapper", pattern = "^showpath(?: (\\d+))?(?: (\\d+))?$"},
  {title = "Mapper Special Lists", alias = "spe list <optional filter>", tags = "referential, mmapper", description = "Shows a list of all known special exits, you can also filter it down spe list worm warp", location = "Mudlet Mapper", pattern = "^spe list(?: (.+))?$"},
  {title = "Mapper Make Special Exit", alias = "spe <other room> <command>", tags = "referential, mmapper", description = "While you need to <red>mc to enter mapping mode, you can use this to set special exits if your map lacks them.", location = "Mudlet Mapper", pattern = "^(?:spe|exit special) (\\w+) (.+)$"},
  {title = "Mapper Mapping Mode", alias = "mc", tags = "referential, mmapper", description = "Turning the mapping mode on enables the mapping aliases, along with several automapping things", location = "Mudlet Mapper", pattern = "^(?:mc|map create) ?(on|off)?$"},
  {title = "Mapper Room Delete", alias = "rld", tags = "referential, mmapper", description = "Deletes a room in the mapper, make sure you <red>mc first to go into mapping mode.", location = "Mudlet Mapper", pattern = "^(?:rld|room delete) ?(\\w+)?$"},
  {title = "Mapper Room Link", alias = "rlk <vnum> <direction> <optional one>", tags = "referential, mmapper", description = "*rlk or room link <option>*, where option will specify the room and exit to link with. You can also tack on 'one' at the end to make it be a one-way link.", location = "Mudlet Mapper", pattern = "^(?:rlk|room link) ?(\\d+)? (\\w+)( one)?$"},
  {title = "Mapper Room Unlink", alias = "urlk <direction>", tags = "referential, mmapper", description = "*urlk or room unlink <direction>*, where direction will specify the direction of the exit to unlink. This function will unlink exits both ways, or one way if there is no incoming exit.", location = "Mudlet Mapper", pattern = "^(?:urlk|room unlink) (\\w+)$"},
  {title = "Mapper Make Special Exit Remotely", alias = "spec <from room> <to room> <command> ", tags = "referential, mmapper", description = "This different than spe, which allows you to link only the current room to another room - this command doesn't require you to be in the starting room.", location = "Mudlet Mapper", pattern = "^spev (\\d+) (\\d+) (.+)$"},
  {title = "Mapper Make New Area", alias = "area add <area name>", tags = "referential, mmapper", description = "Create a new area and automatically give it an ID.", location = "Mudlet Mapper", pattern = "^area add (.+)$"},
  {title = "Mapper save", alias = "map save <optional name>", tags = "referential, mmapper", description = "Save all of the map", location = "Mudlet Mapper", pattern = "^map save(?: (json|all))?(?: (.+))?$"},
  {title = "Mapper load", alias = "map load <optional name>", tags = "referential, mmapper", description = "Load the default map or the specified map", location = "Mudlet Mapper", pattern = "^map load(?: (.+))?$"},
  {title = "Mapper config", alias = "mconfig", tags = "referential, mmapper", description = "Lets you customize your mapper experience", location = "Mudlet Mapper", pattern = "^mconfig( (\\w+) (.*))?$"},
  {title = "Artifact Help File", alias = "?artifacts", tags = "index", description = "Syntax for utilizing the artifact support in Rime", location = "Rime Help.lua", pattern = "It's Code"},
  {title = "Settings Help File", alias = "?settings", tags = "index", description = "Overview of a lot of the saved variables for reference ", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Current Class Help File", alias = "?class or ?<currentclass>", tags = "index", description = "Current class specific aliases", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Curing Help File", alias = "?curing", tags = "index", description = "Explanation of how the curing is handled, and how to manipulate it", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Customization Help File", alias = "?customization", tags = "index", description = "Rime customization aliases - Change affliction and system colors", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Defences Help File", alias = "?defences", tags = "index", description = "Explanations on how to use the defences system", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Loyals Help File", alias = "?loyals", tags = "index", description = "Ordering around entities and mounts", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Mercantile Help File", alias = "?mercantile", tags = "index", description = "Herbalism, Bombmaking, Forging and more!", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Militia Help File", alias = "?militia", tags = "index", description = "Militia coloring and aliases", location = "Rime Help.lua", pattern = "N/A"},
  {title = "PK Help File", alias = "?pk", tags = "index", description = "An expanded version of <red>?quickpk <white>and <red>?quickgrouppk", location = "Rime Help.lua", pattern = "N/A"},
  {title = "PK Leaders Help File", alias = "?pkleader", tags = "index", description = "Leading the fight? This is for you.", location = "Rime Help.lua", pattern = "N/A"},
  {title = "PK Misc Help File", alias = "?pkmisc", tags = "index", description = "PK Aliases that did not fit anywhere else", location = "Rime Help.lua", pattern = "N/A"},
  {title = "PVE Help File", alias = "?pve", tags = "index", description = "An expanded version of <red>?quickpve", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Quick PVE Help File", alias = "?quickpve", tags = "index", description = "The Quick PVE Primer", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Quick PK Help File", alias = "?quickpk", tags = "index", description = "The Quick PK Primer", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Quick Group PK Help File", alias = "?gpk", tags = "index", description = "The Quick Group PK Primer", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Shopping Help File", alias = "?shopping", tags = "index", description = "Quick aliases for resupplying yourself while shopping", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Travel Help File", alias = "?travel", tags = "index", description = "Prebuilt Travel Aliases", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Ylem Help File", alias = "?ylem", tags = "index", description = "Ylem Mist / Eld / Leyline related Aliases", location = "Rime Help.lua", pattern = "N/A"},
  {title = "zGUI Help File", alias = "?zgui", tags = "index", description = "The GUI interface has a few useful aliases you might want to know", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Misc Help File", alias = "?misc", tags = "index", description = "Miscellaneous Rime system aliases", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Index Help File", alias = "?index", tags = "index", description = "The index iyself.", location = "Rime Help.lua", pattern = "N/A"},
  {title = "MMapper Help File", alias = "?mmapper", tags = "index", description = "MMapper Aliases.", location = "Rime Help.lua", pattern = "N/A"},
  {title = "Voltda Amulet Setting", alias = "set amulet <number>", tags = "pairings", description = "Do you have the Caves (Voltda) amulet? Use this to make <red>vo work appropriately.", location = "System Setup", pattern = "^set amulet (\\w+)$"},
  {title = "Wings Amulet Setting", alias = "set wings <number>", tags = "pairings", description = "Do you have the Clouds (Wings) amulet? Use this to make the alias work appropriately.", location = "System Setup", pattern = "^set wings (\\w+)$"},
  {title = "Torch Setting", alias = "set <torch|everburning> <number>", tags = "pairings", description = "Set your torches up", location = "System Setup", pattern = "^set (torch|everburning) (\\w+)"},
  {title = "Ascended Classes - 200 Setting", alias = "set 200 <class>", tags = "pairings, setupall", description = "Set what type of Level 200 Ascended Class you are", location = "System Setup", pattern = "^set 200 (\\w+)$"},
  {title = "Set Bloodborn Weapon", alias = "set bloodborn <number>", tags = "setupall, bloodbornsetup, bloodborn", description = "Allows you set your sceptre/dagger/staff as your weapon for Bloodborn.", location = "System Setup", pattern = "^set bloodborn (\\w+)$"},
  {title = "Check your Rime Version", alias = "rime version", tags = "setup, index", description = "Allows you check what Rime Version you are currently using.", location = "System Setup", pattern = "^rime version$"},
}

     -- Define a function to search a Lua table of help entries for a group of tags and return output if found
     function ruhi_help_database(query, searchTagsOnly, expertOutput)
      -- Standardize the query to lowercase
      query = query:lower()
      local matchingEntries = {}
      local addedEntries = {} -- flag to track added entries when searching by tags
      local isTagSearch = false
      local classsearch = rime.status.class:lower()
      local classsetup = classsearch .. "setup"
      
      -- Check if the query is a tag search
      if searchTagsOnly or query:find("^tag:") then
        isTagSearch = true
        query = query:gsub("^tag:", ""):lower()
    
        -- search tags
        if isTagSearch then
          local tagPattern = "%f[%a]" .. query .. "%f[%A]"
          for _, entry in ipairs(rimehelpaliastable) do
            local tags = entry.tags:lower()
            if string.match(tags, tagPattern) and not addedEntries[entry] then
              table.insert(matchingEntries, entry)
              addedEntries[entry] = true
            end
          end
        end
      else
        -- search fields
        for _, entry in ipairs(rimehelpaliastable) do
          local foundMatch = false
    
          -- Check if the query matches any of the words in the fields
          local lowerAlias = entry.alias:lower()
          local lowerTitle = entry.title:lower()
          local lowerDescription = entry.description:lower()
          for _, word in ipairs(lowerAlias:split(" ")) do
            if word:find(query) then
              foundMatch = true
              break
            end
          end
          if not foundMatch then
            for _, word in ipairs(lowerTitle:split(" ")) do
              if word:find(query) then
                foundMatch = true
                break
              end
            end
          end
          if not foundMatch then
            for _, word in ipairs(lowerDescription:split(" ")) do
              if word:find(query) then
                foundMatch = true
                break
              end
            end
          end
          
          -- Add the entry to the list of matching entries if a match was found
          if foundMatch then
            table.insert(matchingEntries, entry)
          end
        end
      end
      
      -- Print header if expertOutput is true
      if expertOutput then
        cecho("<dodger_blue>----------------------------<light_steel_blue>Searching Rime Aliases<dodger_blue>----------------------------\n\n")
      end
      
      -- If there is at least one matching entry, return a cecho for each matching entry
      if #matchingEntries > 0 then
        -- Sort the entries alphabetically by the "alias" field
        table.sort(matchingEntries, function(a, b)
          return a.alias < b.alias
        end)
        
        for _, entry in ipairs(matchingEntries) do
          if expertOutput then
            format_help_entry(entry.title, entry.alias, entry.location, entry.pattern, entry.description)
          else
            local alias = entry.alias
            local description = entry.description
            local output = string.format("<red>    %s", alias)
            local indent = "       "
            local len = #output
            while len < 72 do
              output = output.." "
              len = len + 1
            end
            output = output.."\n"
            len = 0
            local firstLine = true
            local words = description:split(" ")
            for _, word in ipairs(words) do
              if not firstLine and len == 0 then
                  output = output..indent
                end
                if len + #word + 1 > 72 then
                  output = output.."\n"..indent
                  len = 0
                  firstLine = false
                end
                if not firstLine then
                  output = output.." "
                  len = len + 1
                else
                  output = output..string.rep(" ", 6)
                end
                output = output.."<white>"..word
                len = len + #word
                firstLine = false
              end
              cecho(output.."\n\n")
            end
          end
        
        -- Print footer if expertOutput is true
        if expertOutput then
          cecho("\n<dodger_blue>------------------------------------------------------------------------------\n")
        end
        
      else
        if query == classsetup then
          cecho("\n<orange>           No Weapon Setup for Class Detected\n\n")
        else
          cecho("<red> No results found in Rime Help Database\n TIP: Try searching using only one word to increase the chance for matches.\n\n<dodger_blue>------------------------------------------------------------------------------\n")
        end
      end
    end
    
      
    function format_help_entry(title, alias, location, pattern, description)
      local output = string.format("    <sea_green>Title: <NavajoWhite>%s\n", title)
      output = output..string.format("    <sea_green>Alias: <red>%s\n", alias)
      output = output..string.format("    <sea_green>Mudlet Location: <gold>%s\n", location)
      output = output..string.format("    <sea_green>Regex: <dodger_blue>%s\n", pattern)
      local indent = "     "
      local len = 0
      local firstLine = true
      local words = description:split(" ")
      for _, word in ipairs(words) do
        if not firstLine and len == 0 then
          output = output..indent
        end
        if len + #word + 1 > 72 then
          output = output.."\n"..indent
          len = 0
          firstLine = false
        end
        if firstLine then
          output = output.."     "
          firstLine = false
        end
        output = output.." ".."<white>"..word
        len = len + #word + 1
      end
      cecho(output.."\n\n")
    end
    


function alwayssave()
  cecho("\n<white>Don't forget to <red>save<white>!")
end

function rime_help_handle_input(input)
  input = input:lower() -- Convert input to lowercase
  if input == "artifacts" then
    rime_help_artifact()
  elseif input == "settings" then
    rime_help_settings()
  elseif input == "class" then -- I need to add in all the classes, but I need a way for index to check their class like it currently does so I'm not just spamming people with ALL of them unless they look at ?classes directly.
    rime_help_classes()
  elseif input == "curing" then
    rime_help_curing()
  elseif input == "customization" then
    rime_help_customization()
  elseif input == "defences" then
    rime_help_defences()
  elseif input == "loyals" then
    rime_help_loyals()
  elseif input == "mercantile" then
    rime_help_mercantile()
  elseif input == "militia" then
    rime_help_militia()
  elseif input == "mmapper" then
    rime_help_mmapper()
  elseif input == "pk" or input == "pvp" then
    rime_help_pk()
  elseif input == "pkleader" or input == "pvpleader" then
    rime_help_pkleader()
  elseif input == "pkmisc" or input == "pvpmisc" then
    rime_help_pkmisc()
  elseif input == "pve" then
    rime_help_pve()
  elseif input == "quickpve" then
    rime_help_quickpve()
  elseif input == "quickpk" or input == "grouppvp" then
    rime_help_quickpk()
  elseif input == "quickpgrouppk" or input == "gpk" or input == "grouppk" or input == "grouppvp" then
    rime_help_quickgrouppk()
  elseif input == "shopping" then
    rime_help_shopping()
  elseif input == "system" then
    rime_help_system()
  elseif input == "travel" then
    rime_help_travel()
  elseif input == "ylem" then
    rime_help_ylem()
  elseif input == "zgui" then
    rime_help_zgui()
  elseif input == "miscellaneous" or input == "misc" then
    rime_help_misc()
  elseif input == "index" then
    rime_help_index()
  elseif input == "help" then
    rime_help_help()
  elseif input == "setup" then
    rime_help_setup()
  elseif input == "setupall" then
    rime_help_setupall()
  else
    rime_help_noresults()
    end
  alwayssave()
end

function rime_help_help()
  cecho([[<dodger_blue>
Welcome to Rime! Below are a list of options you can ?query for help

<dodger_blue> First Time
<red>     ?setup
<white>      - Just getting started with Rime? <red>?setup<white> will walk you through the
        essentials.

<dodger_blue> Quick References
<red>     ?quickpve
<white>      - Quick primer on bashing
<red>     ?quickpk
<white>      - Quick primer on Solo PK
<red>     ?quickgrouppk
<white>      - Quick primer on Group PK

<dodger_blue> More Information
<red>     ?index
<white>      - More indepth help files exist and are available in <red>?index
<red>     ?find <word>
<white>      - Search the alias table for matches to your query.

<dodger_blue> Useful Commands
<red>     pause
<white>      - If you run into any major issues you can always use <red>pause<white> to halt the
        system.
<red>     unpause
<white>      - Resumes the system.
<red>     ?settings
<white>      - See what variables you currently have saved into Rime.

<dodger_blue> Class Specific Aliases
<red>     ?]]..gmcp.Char.Status.class:lower()..[[ 
<white>      - ]]..gmcp.Char.Status.class..[[ specific aliases or aliases.
  ]])
end

-- Artifacts, Index, and Settings are going to live like they use to, because it makes more sense for them to right now.

function rime_help_artifact()
  local subit = {["true"] = "(active)", ["false"] = "(not active)", ["nil"] = "(not active)",}
  cecho([[<dodger_blue>Rime can account for a lot of artifacts, including Antiquated 

<red>     rime arti pipes <yes/no> <green>]]..(subit[tostring(rime.saved.arti_pipes)])..[[ 
<white>      - Set to "yes" if you have 3 artifact pipes.
<white>      - You should also <red> set <plant> <pipe#><white> to set up each pipe.

<red>     rime arti goggles <level number> <green>]]..tostring(rime.saved.goggles)..[[ 
<white>      - Antiquated Artifact goggles levels 1-20 fully supported.

<red>     rime arti gauntlet <level number> <green>]]..tostring(rime.saved.gauntlet)..[[ 
<white>      - Anitquated Artifact Gauntlet levels 1-20 fully supported.

<red>     rime arti mass <yes/no> <green>]]..(subit[tostring(rime.saved.stability)])..[[ 
<white>      - Set to "yes" if you have the stability artifact power.

<red>     rime arti manaboon <yes/no> <green>]]..(subit[tostring(rime.saved.mana_boon)])..[[ 
<white>      - Set to "yes" if you have the mana_boon artifact power.

<red>     rime arti lifesense <yes/no> <green>]]..(subit[tostring(rime.saved.lifesense)])..[[ 
<white>      - Set to "yes" if you have the lifesense relic.

<red>     rime arti mindseye <yes/no> <green>]]..(subit[tostring(rime.saved.mindseye)])..[[ 
<white>      - Set to "yes" if you have BOTH the antenna and blindfold relics.

<red>     rime arti webspray <yes/no> <green>]]..(subit[tostring(rime.saved.webspray)])..[[ 
<white>      - Set to "yes" if you have the webspray relic.

<red>     rime arti lifevision <yes/no> <green>]]..(subit[tostring(rime.saved.lifevision)])..[[ 
<white>      - Set to "yes" if you have the lifevision artifact.

<red>     rime arti bracer <yes/no> <green>]]..(subit[tostring(rime.saved.bracer)])..[[ 
<white>      - Set to "yes" if you have the combined_powers bracer relic.

<red>     rime arti zephyr <yes/no> <green>]]..(subit[tostring(rime.saved.zephyr)])..[[ 
<white>      - Set to "yes" if you have the zephyr artifact.

<red>     rime arti horn <yes/no> <green>]]..(subit[tostring(rime.saved.hunter_horn)])..[[ 
<white>      - Set to "yes" if you have the hunter horn artifact.

<red>     rime arti crystal_illusion <yes/no> <green>]]..(subit[tostring(rime.saved.crystal_illusion)])..[[ 
<white>      - Set to "yes" if you have the crystal illusion staff.]])
cecho("\n\n")
ruhi_help_database("pairings", true, false)
end

function rime_help_settings()
  if rime.firstaid == true then naadurimefirstaidsetting = "Server Side - Firstaid On" else naadurimefirstaidsetting = "Client Side - Rime Curing On" end
  if rime.saved.gag_command == true then naadurimegagging = "Gagging Messages sent through act()" else naadurimegagging = "Not Gagging Messages sent through act()" end
  if rime.defences.auto == true then naaduautodef = "ON" else naaduautodef = "OFF" end
  if swarm.targeting.auto == true then naaduautotar = "ON" else naaduautotar = "OFF" end
  if rime.pvp.web_aff_calling == true then naaduwebaffcall = "Reporting Afflictions to Web" else naaduwebaffcall = "OFF" end
  if rime.pvp.calling == true then naaduwebtarcall = "Reporting Targets to Web" else naaduwebtarcall = "OFF" end
  if not next(rime.pvp.boss) then naaduwebcaller = "No one" else naaduwebcaller = table.concat(rime.pvp.boss, ", ") end
  if not next(bashingGroup) then naadubashgroup = "No one" else naadubashgroup = table.concat(bashingGroup, ", ") end
  hit_one = true
  cecho([[<dodger_blue>
------ Rime Settings ------

<dodger_blue>System Settings
<red>    System Separator: <white> ]]..tostring(rime.saved.separator)..[[ 
<red>    Rime or Firstaid:<white> ]]..naadurimefirstaidsetting..[[ 
<red>    Saved Mount:<white> ]]..tostring(rime.saved.mount)..[[ 
<red>    Saved Stables:<white> ]]..tostring(rime.saved.stable)..[[       
<red>    Rime act() Gagging:<white> ]]..naadurimegagging..[[ 

<dodger_blue>Pipe Settings    
<red>    Reishi Pipe:<white> ]]..tostring(rime.saved.reishi_pipe)..[[ 
<red>    Willow Pipe:<white> ]]..tostring(rime.saved.willow_pipe)..[[ 
<red>    Yarrow Pipe:<white> ]]..tostring(rime.saved.yarrow_pipe)..[[ 

<dodger_blue>PVP Settings 
<red>    PVP Route Selected:<white> ]]..tostring(rime.pvp.route_choice)..[[ 
<red>    Rime Bleeding value:<white> ]]..bleeding_floor..[[ 
<red>    Swarm Auto Targetting:<white> ]]..tostring(naaduautotar)..[[ 
<red>    Web Affliction Calling:<white> ]]..tostring(naaduwebaffcall)..[[  
<red>    Web Leading Target Calling:<white> ]]..tostring(naaduwebtarcall)..[[  
<red>    Listening to in Web for Targets:<white> ]]..naaduwebcaller..[[  

<dodger_blue>Weapon Settings
<red>    Shield:<white> ]]..tostring(rime.saved.shield)..[[ 

<red>    Praenomen Weapon (1H):<white> ]]..tostring(rime.saved.flavor_1h)..[[              
<red>    Praenomen Weapon (2H):<white> ]]..tostring(rime.saved.flavor_2h)..[[ 

<red>    Revenant Weapon (1H Blades):<white> ]]..tostring(rime.saved.revblade1)..[[ and ]]..tostring(rime.saved.revblade2)..[[ 
<red>    Revenant Weapon (1H Blunts):<white> ]]..tostring(rime.saved.revblunt1)..[[ and ]]..tostring(rime.saved.revblunt2)..[[ 
<red>    Revenant Weapon (2H Blade):<white> ]]..tostring(rime.saved.rev2handblade)..[[ 
<red>    Revenant Weapon (2H Blunt):<white> ]]..tostring(rime.saved.rev2handblunt)..[[  

<red>    Bard PVP Weapon:<white> ]]..tostring(rime.saved.bard_weapon)..[[  
<red>    Bard Bashing Weapon:<white> ]]..tostring(rime.saved.bard_bashing)..[[ 

<red>    Sciomancer Focus:<white> ]]..tostring(rime.saved.sciomancer_focus)..[[ 

<red>    Alchemist Conduit:<white> ]]..tostring(rime.saved.alchemist_conduit)..[[ 


<dodger_blue>Misc Settings
<red>    Auto Defences:<white> ]]..naaduautodef..[[ 
<red>    Rime Movement Mode:<white> ]]..tostring(rime.movement.mode)..[[ 
<red>    Bashing Group:<white> ]]..tostring(naadubashgroup)..[[ 
]])
end

function rime_help_classes()
  local classsearch = rime.status.class:lower()
  local titleclass = rime.status.class
  cecho ([[ <dodger_blue>------ ]]..titleclass..[[ Aliases ------
]])
  ruhi_help_database(classsearch, true, false)
end

function rime_help_setup()
  local classsearch = rime.status.class:lower()
  local classsetup = classsearch .. "setup"
  cecho([[
<dodger_blue>First Time getting started with Rime? Follow this carefully!

Setup your Weapons
]])
ruhi_help_database(classsetup, true, false)
cecho([[
<red>     Multiple Classes?
<white>      - See <red>?setupall<white> for all weapon setups.
<dodger_blue>
Mounts, Artifacts, and Defences
<red>     set mount <mount id number>
<white>      - Tell the system which mount is yours.
<red>     set stable <stable>
<white>      - Tell the system which stable you'd like to store your mounts in.
<red>     ?artifacts
<white>      - If you have some artifacts, you can go over to <red>?artifacts<white> to 
          toggle them on.
<red>     ?defences
<white>      - Rime includes a client side healing system along with support for 
          Firstaid<red> ?defences<white> for more.

<dodger_blue>Misc Setup
<red>     set sep <separator>
<white>      - Set the system separator to anything you want.
<white>      - This should NOT match your Mudlet separator.
<red>     rime gag send <yes/no>
<white>      - Gag the text sent by the system to Aetolia.
<red>     save
<white>      - Save your settings.
<red>     sload
<white>      - Load the system after making changes to any .lua file.
]])
end

function rime_help_setupall()
cecho([[<dodger_blue> ------ All Weapon Setup ------
]])
ruhi_help_database("setupall", true, false)
end


function rime_help_curing()
  cecho([[<dodger_blue> ------ Curing Aliases ------

]])
    ruhi_help_database("curing", true, false)
end

function rime_help_customization()
  cecho ([[<dodger_blue> ------ Rime Customization ------
  <white>Rime's base color scheme can be changed.

<red>     rime color <type> <position> <color>
<white>        <red><type><white> can be <dark_sea_green>def, order, curing, pve,
<white>           pvp, target, tga, tca, or affcolor
<white>             def is defences, tga and tca are target gained/cured aff
<white>             tga is target gained aff
<white>             tca is target cured aff
<white>        <red><position><white> can be <dark_sea_green>title <white>or <dark_sea_green>parenthesis
<white>             tga, tca, and target do not have parenthesis entries
<white>        <red><color><white> can be any color AS IT APPEARS when you type <red>colors
<white>        An example
<white>            <red>rime color pvp title DeepSkyBlue
<white>            <red>rime color pvp parenthesis RoyalBlue
<white>       this will set the pvp echo to the system default of <RoyalBlue>(<DeepSkyBlue>PvP<RoyalBlue>)

<red>    rime affcolor <affliction> <color> <nameshown>
<white>        <red><affliction><white> can be any affliction as shown in <red>AFFLICT LIST
<white>        <red><color><white> is the color of the word as it will show in the afflict list.
<white>        <red><nameshown><white> is the word that will show when you receive that affliction.
<white>        An example
<white>            <red>rime affcolor paresis blue Potato
<white>        Echo: <DeepPink>(<CornflowerBlue>Rime<DeepPink>)<white> paresis will now appear as <blue>Potato<white> in the affliction window.
  
]])
ruhi_help_database("customization", true, false)

end

function rime_help_defences()
   cecho([[<dodger_blue> ------ Defensive Aliases ------

]])
     ruhi_help_database("defences", true, false)
end

function rime_help_loyals()
  cecho([[<dodger_blue> ------ Loyals Aliases ------

]])
    ruhi_help_database("loyals", true, false)
end
function rime_help_mmapper()
  cecho([[<dodger_blue> ------ MMapper Aliases ------
  <red> RIME DOES NOT SUPPORT THESE, THEY ARE HERE FOR REFERENTIAL PURPOSE ONLY.

]])
    ruhi_help_database("mmapper", true, false)
end


function rime_help_mercantile()
  cecho([[<dodger_blue> ------ Mercantile Aliases ------

]])
    ruhi_help_database("mercantile", true, false)
end

function rime_help_militia()
  cecho([[<dodger_blue> ------ Militia Aliases ------

]])
    ruhi_help_database("militia", true, false)
end

function rime_help_pk()
  cecho([[<dodger_blue>     Rime PK Aliases

]])
  ruhi_help_database("pk", true, false)
end

function rime_help_pkleader()
  cecho([[<dodger_blue> ------ PK Leader Aliases ------

]])
    ruhi_help_database("pkleader", true, false)
end

function rime_help_pkmisc()
  cecho([[<dodger_blue> ------ PK Misc Aliases ------

]])
    ruhi_help_database("pkmisc", true, false)
end

function rime_help_pve()
  cecho([[<dodger_blue> ------ PvE Aliases ------

]])
    ruhi_help_database("pve", true, false)
end

function rime_help_quickpve()
  cecho([[<dodger_blue>
  The Rime PVE / Bashing Primer<dodger_blue>
  <dodger_blue>
  ---- Setup ----
]]) 
ruhi_help_database("quickpvesetup", true, false) 
cecho([[
      <dodger_blue>
  ---- Manual Bashing ----
]]) 
      ruhi_help_database("quickpvemanualbashing", true, false) 
      
cecho([[
        <dodger_blue>
  ----  Assisted Bashing ----
]]) 
        ruhi_help_database("quickpveassisted", true, false) 
cecho([[
          <dodger_blue>
    ----  After Bashing ----
  ]]) 
          ruhi_help_database("quickpveafterbashing", true, false) 
  
cecho([[
        <dodger_blue>
   ----  Would you like to know more? ----
<red>    ?pve
<white>      A more indepth guide to PK with Rime

  
]])
end

function rime_help_quickpk()
  cecho([[<dodger_blue>
  The Rime PK Primer<dodger_blue>
  <dodger_blue>
  ---- Setup ----
]]) 
ruhi_help_database("quickpksetup", true, false) 
cecho([[
      <dodger_blue>
  ---- Combat ----
]]) 
      ruhi_help_database("quickpkcombat", true, false) 
      
      cecho([[
        <dodger_blue>
  ----  After Combat ----
]]) 
        ruhi_help_database("quickpkaftercombat", true, false) 

cecho([[
        <dodger_blue>
      Would you like to know more?
<red>    ?pk
<white>      A more indepth guide to PK with Rime

<red>    ?]]..rime.status.class:lower()..[[ 
 <white>     ]]..rime.status.class..[[ specific aliases or aliases.
  
]])
end

function rime_help_quickgrouppk()
  cecho([[<dodger_blue>
  The Rime Group PK Primer<dodger_blue>
  <dodger_blue>
  ---- Setup ----
]]) 
ruhi_help_database("grouppksetup", true, false) 
cecho([[
      <dodger_blue>
  ---- Combat ----
]]) 
      ruhi_help_database("grouppkcombat", true, false) 
      
      cecho([[
        <dodger_blue>
  ----  After Combat ----
]]) 
        ruhi_help_database("grouppkaftercombat", true, false) 

cecho([[
        <dodger_blue>
      Would you like to know more?
<red>    ?pk
<white>      A more indepth guide to PK with Rime

<red>    ?]]..rime.status.class:lower()..[[ 
 <white>     ]]..rime.status.class..[[ specific aliases or aliases.
  
]])
end

function rime_help_shopping()
  cecho([[<dodger_blue> ------ Shopping Aliases ------

]])
    ruhi_help_database("shopping", true, false)
end

function rime_help_system()
  cecho([[<dodger_blue> ------ System Aliases ------

]])
    ruhi_help_database("system", true, false)
end

function rime_help_travel()
  cecho([[<dodger_blue> ------ Travel Aliases ------

]])
    ruhi_help_database("travel", true, false)
end

function rime_help_ylem()
  cecho([[<dodger_blue> ------ Ylem Related Aliases ------

]])
    ruhi_help_database("ylem", true, false)
end

function rime_help_zgui()
  cecho([[<dodger_blue>     zGUI Aliases

]])
   ruhi_help_database("zgui", true, false)
end

function rime_help_misc()
  cecho([[<dodger_blue>     Miscellaneous Aliases

]])
   ruhi_help_database("misc", true, false)
end

function rime_help_index()
  cecho([[<dodger_blue> ------ Rime Help Index ------

]])
  ruhi_help_database("index", true, false)
end

function rime_help_noresults()
  cecho([[<red> ------ No Help File Found ------

<white>Maybe try <red>?find <white>or <red>?tag <white>for what you are looking for?

]])
end

local farming_seeds = {
  ["Artichoke"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 4,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Asparagus"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 6,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Barley"] = {
    ["family"] = "Grain",
    ["season"] = {"Spring"},
    ["weeks"] = 4,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Beet"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Blueberry"] = {
    ["family"] = "Field",
    ["season"] = {"Spring"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Cabbage"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Summer"},
    ["weeks"] = 4.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Cauliflower"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 6,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Corn"] = {
    ["family"] = "Field",
    ["season"] = {"Summer"},
    ["weeks"] = 7,
    ["trellis"] = false,
    ["regrow"] = 2
  },
  ["Cotton"] = {
    ["family"] = "Field",
    ["season"] = {"Spring", "Summer"},
    ["weeks"] = 7,
    ["trellis"] = false,
    ["regrow"] = 2
  },
  ["Cranberry"] = {
    ["family"] = "Fruit",
    ["season"] = {"Autumn"},
    ["weeks"] = 3.5,
    ["trellis"] = true,
    ["regrow"] = 2.5
  },
  ["Cucumber"] = {
    ["family"] = "Fruit",
    ["season"] = {"Spring", "Summer"},
    ["weeks"] = 3.5,
    ["trellis"] = true,
    ["regrow"] = 2
  },
  ["Eggplant"] = {
    ["family"] = "Field",
    ["season"] = {"Autumn"},
    ["weeks"] = 2,5,
    ["trellis"] = false,
    ["regrow"] = 2.5
  },
  ["Garlic"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Grape"] = {
    ["family"] = "Fruit",
    ["season"] = {"Autumn"},
    ["weeks"] = 5,
    ["trellis"] = true,
    ["regrow"] = 1.5
  },
  ["Grass"] = {
    ["family"] = "Field",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Greenbean"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 5,
    ["trellis"] = true,
    ["regrow"] = 1.5
  },
  ["Hemp"] = {
    ["family"] = "Field",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Hop"] = {
    ["family"] = "Field",
    ["season"] = {"Summer"},
    ["weeks"] = 5.5,
    ["trellis"] = true,
    ["regrow"] = 1
  },
  ["Kale"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Onion"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 4.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Parsnip"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Pepper"] = {
    ["family"] = "Field",
    ["season"] = {"Spring"},
    ["weeks"] = 2.5,
    ["trellis"] = false,
    ["regrow"] = 1.5
  },
  ["Pine"] = {
    ["family"] = "Tree",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 9.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Potato"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Pumpkin"] = {
    ["family"] = "Fruit",
    ["season"] = {"Autumn"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Radish"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Summer"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Rhubarb"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Strawberry"] = {
    ["family"] = "Field",
    ["season"] = {"Spring"},
    ["weeks"] = 4,
    ["trellis"] = false,
    ["regrow"] = 2
  },
  ["Tomato"] = {
    ["family"] = "Fruit",
    ["season"] = {"Summer"},
    ["weeks"] = 5.5,
    ["trellis"] = true,
    ["regrow"] = 2
  },
  ["Watermelon"] = {
    ["family"] = "Fruit",
    ["season"] = {"Summer"},
    ["weeks"] = 6,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Wheat"] = {
    ["family"] = "Grain",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Yam"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 5,
    ["trellis"] = false,
    ["regrow"] = false
  }
}

RimeFarm = RimeFarm or {}

function RimeFarm.search_seeds(...)
  arg.n = nil
  local queries = {}
  local seedlist = farming_seeds
  local result = {}
  for i in string.gmatch(arg[1], "%S+") do
    if #i == 1 then
      table.insert(queries, tonumber(i))
    else
      table.insert(queries, i)
    end
  end
  if arg ~= nil then
    for _, query in pairs(queries) do
      for seed, _ in spairs(seedlist) do
        if type(query) == "number" then
          if query - seedlist[seed]["weeks"] >= 0 then
            result[seed] = seedlist[seed]
          end
        end
        if string.lower(query) == string.lower(seed) then
          result[seed] = seedlist[seed]
        end
        if string.lower(query) == string.lower(seedlist[seed]["family"]) then
          result[seed] = seedlist[seed]
        end
        if string.lower(query) == "regrow" then
          if seedlist[seed]["regrow"] then
            result[seed] = seedlist[seed]
          end
        end
        if string.lower(query) == "trellis" then
          if seedlist[seed]["trellis"] then
            result[seed] = seedlist[seed]
          end
        end
        for _, season in pairs(seedlist[seed]["season"]) do
          if string.lower(season) == string.lower(query) then
            result[seed] = seedlist[seed]
          end
        end
      end
      seedlist = result
      result = {}
    end
  return seedlist
  else
    RimeFarm.print_seeds()
  end
end


function RimeFarm.print_seeds(seedlist)
  -- This function reads the farming_seeds database above,
  -- and prints out an easy to read table.
  if seedlist == nil then
    seedlist = farming_seeds
  end
  local string = ""
  cecho("<grey>Name           <ansi_blue>| <grey>Family       <ansi_blue>| <grey>Weeks <ansi_blue>| <grey>Regrow <ansi_blue>| <grey>Trellis <ansi_blue>| <grey>Season(s)\n")
  cecho("<ansi_blue>---------------+--------------+-------+--------+---------+----------\n")
  for seed, _ in spairs(seedlist) do
    -- We start by looping through farming_seeds, and defining
    -- the default string. Every seed has a name stored in 'seed',
    -- as well as a 'family', and how many 'weeks' until maturity.
    string = string.format("<DarkGreen> %-12s  <ansi_blue>|<grey>  %-10s  <ansi_blue>|  <orchid>%3.1f<grey>", seed, seedlist[seed]["family"], seedlist[seed]["weeks"])
    if seedlist[seed]["regrow"] then
      -- After, we check if the plant regrows. If it does, we format
      -- it as a single floating point integer, otherwise a string is
      -- used. Either way, the result is attached to the previous string.
      formatted = string.format("<cyan>%.1f", seedlist[seed]["regrow"])
      string = string.."  <ansi_blue>|   "..formatted.."<grey>"
    elseif not seedlist[seed]["regrow"] then
      string = string.."  <ansi_blue>|   <red>-<DarkSlateGrey>Re<grey>"
    end
    if seedlist[seed]["trellis"] then
      -- Same as regrow, we check if the plant requires a trellis,
      -- and adjust the string as appropriate.
      string = string.."  <ansi_blue>|    <green>+<yellow>Tr<grey>  <ansi_blue>|  "
    elseif not seedlist[seed]["trellis"] then
      string = string.."  <ansi_blue>|    <red>-<a_brown>Tr<grey>  <ansi_blue>|  "
    end
    for i, season in pairs(seedlist[seed]["season"]) do
      -- When we get to the 'season' list, we iterate through it
      -- and adjust its color.
      if season == "Spring" then
        season = "<LightGoldenrod>"..season
      elseif season == "Summer" then
        season = "<DeepSkyBlue>"..season
      elseif season == "Autumn" then
        season = "<OrangeRed>"..season
      end
      -- And attach it to the end of our string with the appropriate
      -- punctuation.
      if i == #seedlist[seed]["season"] then
        string = string..season.."<grey>."
      else
        string = string..season.."<grey>, "
      end
    end
    -- And lastly, a newline is attached to the end and the formatted
    -- string is output.
    string = string.."\n"
    cecho(string)
  end
  cecho("<ansi_blue>---------------+--------------+-------+--------+---------+----------\n")
end



