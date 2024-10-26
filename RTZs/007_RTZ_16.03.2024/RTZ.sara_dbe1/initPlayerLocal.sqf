//maptracking
_jkrptMapActionParent = ["Tracking Menu","Tracking Menu","",{},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionCallsign = ["Set Callsign","Set Callsign","",{createDialog "RscCaspTrackingSet";},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupTmb = ["Select Group Tombstone","Select Group Tombstone","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "tombstone", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupDev = ["Select Group Devil","Select Group Devil","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "devilActual", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupRea = ["Select Group Reaper","Select Group Reaper","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "reaperActual", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupPha = ["Select Group Phantom","Select Group Phantom","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "phantomActual", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroup104 = ["Select Vode An: 104th","Select Vode An: 104th","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "104th", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroup985 = ["Select Vode An: 985th","Select Vode An: 985th","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "985th", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupInf = ["Select Other Unit","Select Other Unit","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", "infantry", true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupNil = ["Remove Marker","Remove Marker","",{if(isFormationLeader _player)then{_jkrptMapGroup = group _player;_jkrptMapGroup setVariable ["KRPT_mark", nil, true];};},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupCAd = ["Assign Pilot Marker","Assign Pilot Marker","",{_player setVariable ["KRPT_pilot", true, true]},{visibleMap}] call ace_interact_menu_fnc_createAction;
_jkrptMapActionGroupCRe = ["Remove Pilot Marker","Remove Pilot Marker","",{_player setVariable ["KRPT_pilot", false, true]},{visibleMap}] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions"], _jkrptMapActionParent] call ace_interact_menu_fnc_addActionToObject;
{[player, 1, ["ACE_SelfActions","Tracking Menu"], _x] call ace_interact_menu_fnc_addActionToObject;} forEach [_jkrptMapActionCallsign,_jkrptMapActionGroupTmb,_jkrptMapActionGroupDev,_jkrptMapActionGroupRea,_jkrptMapActionGroupPha,_jkrptMapActionGroup104,_jkrptMapActionGroup985,_jkrptMapActionGroupInf,_jkrptMapActionGroupNil,_jkrptMapActionGroupCAd,_jkrptMapActionGroupCRe];

if(isClass(configFile>>"cfgPatches">>"Patch_Template"))then{endMission "END2";};

if(isClass(configFile>>"cfgPatches">>"insignia_addon"))then{endMission "END2";};

if(isClass(configFile>>"cfgPatches">>"PA_arsenal"))then{endMission "END2";};

if(isClass(configFile>>"cfgPatches">>"Alternative_Running"))then{endMission "END2";};

if(dnt_supplySystemON == 1) then {null = execVM "DNT_supplies\DNT_limitSupplies.sqf";};