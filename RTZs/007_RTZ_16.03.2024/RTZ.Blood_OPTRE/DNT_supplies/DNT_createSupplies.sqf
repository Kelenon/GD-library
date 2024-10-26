scriptName "DNT_createSupplies";

params ["_this","_type", "_mod", "_cargoSize"];

//Array of items to which supply action was attached to. Used so it's not possible to attach it more than once
if(isNil "dnt_initRegObjArray") then{
	dnt_initRegObjArray = 1;
	publicVariableServer "dnt_initRegObjArray";
	dnt_registeredSupplyObjects = [];
	publicVariableServer "dnt_registeredSupplyObjects";
	};


if(_this in dnt_registeredSupplyObjects) then {} else {


dnt_registeredSupplyObjects pushBack _this;
publicVariableServer "dnt_registeredSupplyObjects";


private _validSupplies = ["JLTS_Ammobox_ammo_GAR",
"JLTS_Ammobox_weapons_GAR", 
"JLTS_Ammobox_explosives_GAR", 
"JLTS_Ammobox_grenades_GAR", 
"JLTS_Ammobox_launchers_GAR", 
"JLTS_Ammobox_weapons_special_GAR", 
"JLTS_Ammobox_support_GAR", 
"JLTS_Ammobox_ammo_CIS", 
"JLTS_Ammobox_weapons_CIS", 
"JLTS_Ammobox_launchers_CIS", 
"JLTS_Ammobox_weapons_special_CIS", 
"JLTS_Ammobox_support_CIS",
"3AS_Supply_Large_Medical_Prop",
"lsd_heli_laatc", "3AS_LAATC", "3AS_Barc_212", "3AS_Barc_501", "3AS_Barc", "3AS_BarcSideCar_212", "3AS_BarcSideCar_501", "3AS_BarcSideCar", "lsd_ground_lancerBike", "ls_ground_barc", "lsd_civ_lancerBike", "3AS_LAATC_Wampa", "3AS_Z95_Orange", "3AS_Z95_Green", "3AS_Z95_Republic", "3AS_Z95_Blue", "3AS_AV7", "3AS_BTLB_Bomber", "3AS_BTLB_Bomber_Shadow", "3AS_BTLB_Bomber_RedLeader", "3AS_BTLB_Bomber_ShadowLeader", "3AS_ARC_170_Red", "3AS_ARC_170_Blue", "3AS_ARC_170_Yellow", "3AS_ARC_170_Orange", "3AS_ARC_170_Green", "3AS_Delta7_Green", "3AS_Delta7_Blue", "3AS_Delta7_TANO", "3AS_Delta7_F", "3AS_Delta7_ANI", "3AS_Delta7_Orange", "3as_Vwing_base", "3AS_VWing_Imperial", "3AS_Snowspeeder_Rogue", "3AS_Snowspeeder_Blue", "3AS_SandSpeeder", "3AS_SnowSpeeder", "ls_heli_laatle", "ls_heli_laatle_policeGunship", "ls_heli_laatle_transportGunship", "3AS_Delta7_PLO", "3AS_Delta7_Purple", "3AS_ISP", "3AS_Patrol_LAAT_Imperial", "3AS_Patrol_LAAT_Republic", "3AS_Patrol_LAAT_Police", "3AS_ISP_Transport", "3AS_Saber_M1_Imperial", "3AS_Saber_M1G_Imperial", "3AS_Saber_M1G", "3AS_Saber_M1G_501", "796th_TX130", "115th_TX130", "985th_TX130", "SWLG_tanks_tx130", "Shadow_TX130", "GD_TX130", "3AS_Saber_M1Recon_Imperial", "3AS_Saber_Super_Imperial", "3as_V19_base", "lsd_air_v19", "GD_LAAT_Airborne", "GD_LAAT_Gunship", "3AS_LAAT_Mk2", "3AS_LAAT_Mk2Lights", "3AS_LAAT_Mk1Lights", "GD_LAAT_MedEvac", "3AS_LAAT_Mk1_Imperial", "3AS_LAAT_Mk1", "lsd_heli_laati_transport", "3AS_LAAT_Mk1Lights_Imperial", "lsd_heli_laati_medevac", "lsd_heli_laati", "lsd_heli_laati_ab", "3AS_LAAT_Mk2Lights_Imperial", "3AS_LAAT_Mk2_Imperial", "3AS_Saber_Super_501", "3AS_Saber_Super", "3AS_Saber_M1Recon_501", "3AS_Saber_M1Recon", "3AS_Saber_M1_501", "3AS_Saber_M1", "3AS_ITT", "3AS_ITT_Logistic", "3AS_ITT_Medical", "3AS_RTT", "3AS_RTT_Wheeled", "3AS_ATTE_Ryloth", "3AS_ATTE_Base", "3AS_ATTE_TCW", "3AS_ATAP_Base", "3AS_ATTE_Imperial", "3AS_Civilian_Transport_02", "3AS_Civilian_Transport_03", "3AS_Civilian_Transport_01", "3AS_Republic_Transport_01", "3AS_Imperial_Transport_01", "3AS_Nuclass", "3as_Jug", "3AS_UTAT", "3AS_ATAT"];


private _actionText = "";

switch(_type) do {

	case "ammunition":{_actionText = "Search for supplies"};
	case "medicaments":{_actionText = "Search for supplies"};
	case "vehicle":{_actionText = "Claim vehicle"};
	case "scrap":{_actionText = "Scrap for salvage"};
	default {_actionText = "Search for supplies"};

};

if(_type == "scrap") then {

	_this addAction[_actionText,{
	
		params ["_target", "_caller", "_actionId", "_supType", "_mod", "_cargoSize"];
		
		clearItemCargo _target; 		
		
		if(([_caller, 1] call ace_repair_fnc_isEngineer) == true) then {
				
				[_target,_actionId]remoteExec ["removeAction"];				
				private _supType = _this select 3 select 0;
				private _mod = _this select 3 select 1;
				if(_mod >10) then {_mod = 10};
				private _cargoSize = _this select 3 select 2;
				private _rollD20 = floor(random 20) + _mod;

		
				if(_rollD20 >= 10) then {
					
					private _scrapPos = getPos _target; 
					private _targetType = typeOf _target;
					private _modifier = _rollD20 - 10;
					private _base = 0;
					private _salvageTime = 10;
						
					if(_targetType in tinyCargoSize) then {_salvageTime = 10};
					if(_targetType in smallCargoSize) then {_salvageTime = 15};
					if(_targetType in mediumCargoSize) then {_salvageTime = 20};
					if(_targetType in largeCargoSize) then {_salvageTime = 30};
					if(_targetType in gargantuanCargoSize) then {_salvageTime = 40};
						
					_caller enableSimulationGlobal false;
						
					private _animationUnit = group _caller createUnit ["B_RangeMaster_F", (getPosASL _caller vectorAdd [10000000, 10000000, 10000000]), [], 0, "CAN_COLLIDE"];
					_animationUnit allowDamage false;
						
					[_animationUnit, true] remoteExec ["hideObjectGlobal", 2]; //hides animation unit
						
					[_animationUnit, _caller] remoteExecCall ["disableCollisionWith", 0, _animationUnit];
					[_animationUnit, _target] remoteExecCall ["disableCollisionWith", 0, _animationUnit];

						
					_animationUnit setUnitLoadout (getUnitLoadout _caller);
					_animationUnit disableAI "ANIM";
					_animationUnit setPosASL (getPosASL _caller vectorAdd [0.3, 0.3, 0]);
					_animationUnit setVectorDir (vectorDir _caller);
					[_animationUnit, "InBaseMoves_repairVehicleKnl"] remoteExec ["switchMove"];
					[_animationUnit, false] remoteExec ["hideObjectGlobal", 2]; //shows animation unit
					[_caller, true] remoteExec ["hideObjectGlobal", 2]; //hides player
					
					[_salvageTime, [], {}, {}, "Salvaging", {true}, [], true] call ace_common_fnc_progressBar;
					
					_soundSource = "HeliHempty" createvehicleLocal position _target;
					_soundSource attachTo [_target, [0, 0, 0.5]];
					[_soundSource, "salvageWreck"] remoteExec ["say"];
					
					uiSleep (_salvageTime-3);
					deleteVehicle _target;
					
					if(_targetType in tinyCargoSize) then {_target = createVehicle["3as_Small_Box_1_prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "CAN_COLLIDE"];[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 1] call ace_cargo_fnc_setSize; _base = 2;};
					if(_targetType in smallCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "CAN_COLLIDE"];[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 2] call ace_cargo_fnc_setSize; _base = 5};
					if(_targetType in mediumCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "CAN_COLLIDE"];[_target, true, [0, 2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 5] call ace_cargo_fnc_setSize; _base = 10};
					if(_targetType in largeCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "CAN_COLLIDE"];[_target, true, [0, 2.5, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 2.5, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 15] call ace_cargo_fnc_setSize;  _base = 15};
					if(_targetType in gargantuanCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "CAN_COLLIDE"];[_target, true, [0, 3, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 3, 1.5], 0, true] call ace_dragging_fnc_setDraggable; [_target, 20] call ace_cargo_fnc_setSize;  _base = 20};
					if((_targetType in tinyCargoSize) == false && (_targetType in smallCargoSize) == false && (_targetType in mediumCargoSize) == false && (_targetType in largeCargoSize) == false && (_targetType in gargantuanCargoSize) == false) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "NONE"];[_target, true, [0, 2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 5] call ace_cargo_fnc_setSize;_base = _cargoSize}; 
					_target setDamage 0;
					uiSleep 3;
					deleteVehicle _soundSource;
					
					[_caller, false] remoteExec ["hideObjectGlobal", 2]; //shows player
					
					deleteVehicle _animationUnit; //removes animation unit
					_caller enableSimulationGlobal true;
					
					private _amount = _base + (_base *_modifier);
					hint parseText format["You have salvaged <t color='#FF8000'> %1 </t> units of %2!", _amount,_supType];
					
					
					[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; //Potentialy problematic lines with interactions
					[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; 
					[_target, _cargoSize] call ace_cargo_fnc_setSize;
					
					
					private _resourceVName = "dntsp_"+_supType+(str dnt_supplyTaskID);
					private _mission = "dntask_"+_supType+(str dnt_supplyTaskID);
																		
					dnt_supplyTaskID = dnt_supplyTaskID + 1;
					publicVariable "dnt_supplyTaskID";
																	
					missionNamespace setVariable [_resourceVName, [_target, _amount, _supType, _mission], true];												

					[_mission, (format ["Deliver %1 units of %2 to the Haunter",_amount, _supType])] call ENGTASKS_CreateTask;
										
				}
				
				else {hint "There is nothing to salvage!";
				[_target,_actionId]remoteExec ["removeAction"];
				};
				
			} else {hint "You need to be an engineer to salvage!"};

},[_type,_mod, _cargoSize],6,true,true,"","true", 10,false,"",""];}



else{
	if(alive _this && ((typeOf _this) in _validSupplies)) then {	
		_this addAction[_actionText,{
		
			params ["_target", "_caller", "_actionId", "_supType", "_mod", "_cargoSize"];
						
					clearItemCargo _target;
					
					_supType = _this select 3 select 0;
					_mod = _this select 3 select 1;
					_cargoSize = _this select 3 select 2;
					private _rollD20 = floor(random 20) + _mod;
									
					if(_supType == "vehicle") then {
					
						if({alive _x} count crew _target == 0) then {
							if(alive _target == true) then {
						
								[_target,_actionId]remoteExec ["removeAction"];		
									
								hint "Vehicle claimed!";
							
								if(typeOf _target in tinyCargoSize) then {_cargoSpace = dnt_spaceXS;_isVehicle = true;};
								if(typeOf _target in smallCargoSize) then {_cargoSpace = dnt_spaceS;_isVehicle = true;};
								if(typeOf _target in mediumCargoSize) then {_cargoSpace = dnt_spaceM;_isVehicle = true;};
								if(typeOf _target in largeCargoSize) then {_cargoSpace = dnt_spaceL;_isVehicle = true;};
								if(typeOf _target in gargantuanCargoSize) then {_cargoSpace = dnt_spaceXL;_isVehicle = true;};
								
								private _vehicleId = "_vid_" + str(dnt_supplyTaskID);
								dnt_supplyTaskID = dnt_supplyTaskID + 1;
								publicVariable "dnt_supplyTaskID";
								private _vicName = (getText (configFile >> "cfgVehicles" >> typeOf _target >> "displayName")) + _vehicleId;
								
								private _vehicleVName = "dntv_vehicle"+(str(dnt_supplyTaskID));
								private _vicType = (getText (configFile >> "cfgVehicles" >> typeOf _target >> "displayName"));
								
								
								switch (true) do {
								
									case (_vicType regexMatch ".*TX-130.*"): {_vicType = "Sabre tank";};
									case (_vicType regexMatch ".*RTT.*"): {_vicType = "RTT";};
									case (_vicType regexMatch ".*Delta.*"): {_vicType = "Delta Starfighter";};
									case (_vicType regexMatch ".*T-47.*"): {_vicType = "Snowspeeder";};
									case (_vicType regexMatch ".*BTL-Y.*"): {_vicType = "Y-Wing";};
									case (_vicType regexMatch ".*ARC-170.*"): {_vicType = "ARC-170";};
									case (_vicType regexMatch ".*LAAT\/LE.*"): {_vicType = "Police LAAT";};
									case (_vicType regexMatch ".*LAAT\/c.*"): {_vicType = "LAAT C";};
									case (_vicType regexMatch ".*LAAT\/i.*"): {_vicType = "LAAT I";};
									case (_vicType regexMatch ".*Swamp.*"): {_vicType = "Swamp speeder";};
									case (_vicType regexMatch ".*BARC.*"): {_vicType = "Speeder";};
									case (_vicType regexMatch ".*105-K.*"): {_vicType = "Speeder";};
									case (_vicType regexMatch ".*AV-7.*"): {_vicType = "GAR AV-7 Artillery";};
									case (_vicType regexMatch ".*V-wing.*"): {_vicType = "V-Wing";};
									case (_vicType regexMatch ".*Z-95.*"): {_vicType = "Z-95 HeadHunter";};
									case (_vicType regexMatch ".*ITT.*"): {_vicType = "ITT";};
									case (_vicType regexMatch ".*ATTE.*"): {_vicType = "ATTE";};
									case (_vicType regexMatch ".*ATAP.*"): {_vicType = "ATAP";};
									case (_vicType regexMatch ".*Civilian Transport.*"): {_vicType = "Civilian Transport";};
									case (_vicType regexMatch ".*AT-AT.*"): {_vicType = "AT-AT";};
									case (_vicType regexMatch ".*Juggernaut.*"): {_vicType = "Juggernaut";};
									case (_vicType regexMatch ".*UT-AT.*"): {_vicType = "UT-AT";};
									case (_vicType regexMatch ".*Nu A-Class.*"): {_vicType = "Nu A-Class Shuttle";};
									case (_vicType regexMatch ".*V-19.*"): {_vicType = "V-19 Torrent";};
						
									default{};
																	
								};		
								
								missionNamespace setVariable [_vehicleVName, [_target, _vicName, _vehicleId,_supType, _vicType], true];							
								
								[_vehicleId, (format ["Claimed %1", _vicName])] call ENGTASKS_CreateTask;
								[_vehicleId, getPos _target, false] call ENGTASKS_SetTaskDestination;
								
								dnt_vehicleList pushBack _vicType;
								publicVariable "dnt_vehicleList";
								
								dnt_vehicleSummary = dnt_vehicleList call BIS_fnc_consolidateArray;
								publicVariable "dnt_vehicleSummary";
								
								dnt_vehicleMissionTxt = "";
																
								{					
									dnt_vehicleMissionTxt = dnt_vehicleMissionTxt + "- " + (_x select 0) + ": " + str(_x select 1) + endl;
								
								}forEach dnt_vehicleSummary;
								
								publicVariable "dnt_vehicleMissionTxt";
								
								["VehiclesList", ["Available vehicles", (format["Current list of available vehicle types: %1 %2",
								endl,dnt_vehicleMissionTxt])]] call ENGTASKS_SetTaskDescription;
							}
							else {[_target,_actionId]remoteExec ["removeAction"];};
						}
						
						else {hint "You can't claim occupied vehicle";};
						
					};
		
					
					if(_supType == "ammunition" || _supType == "medicaments") then {
					
						if(alive _target == true) then {
	
							[_target,_actionId]remoteExec ["removeAction"];
							
							_caller enableSimulationGlobal false;
								
							private _animationUnit = group _caller createUnit ["B_RangeMaster_F", (getPosASL _caller vectorAdd [10000000, 10000000, 10000000]), [], 0, "CAN_COLLIDE"];
		
							_animationUnit allowDamage false;
							[_animationUnit, true] remoteExec ["hideObjectGlobal", 2]; //hides animation unit
							[_animationUnit, _caller] remoteExecCall ["disableCollisionWith", 0, _animationUnit];
							[_animationUnit, _target] remoteExecCall ["disableCollisionWith", 0, _animationUnit];
							
							
							_animationUnit setUnitLoadout (getUnitLoadout _caller);
							
							_animationUnit disableAI "ANIM";
							_animationUnit setPosASL (getPosASL _caller vectorAdd [0.3, 0.3, 0]);
							_animationUnit setVectorDir (vectorDir _caller);
							[_animationUnit, "InBaseMoves_repairVehicleKnl"] remoteExec ["switchMove"];
							[_animationUnit, false] remoteExec ["hideObjectGlobal", 2]; //shows animation unit
							[_caller, true] remoteExec ["hideObjectGlobal", 2]; //hides player
							
							[3, [], {}, {}, "Searching", {true}, [], true] call ace_common_fnc_progressBar;
								
							_soundSource = "HeliHempty" createvehicleLocal position _target;
							_soundSource attachTo [_target, [0, 0, 0.5]];
							[_soundSource, "searchCrate"] remoteExec ["say"];
								
							uiSleep 3;
							
							deleteVehicle _soundSource;
								
							[_caller, false] remoteExec ["hideObjectGlobal", 2]; //shows player
							deleteVehicle _animationUnit; //removes animation unit
		
							_caller enableSimulationGlobal true;
							
						
							if(_rollD20 >= 10) then {
								
								[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; 
								[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; 
								[_target, _cargoSize] call ace_cargo_fnc_setSize;
								
								private _base = 0;
						
								switch(_supType) do {
							
									case "ammunition":{_base = 5};
								
									case "medicaments":{_base = 1};
									
									default {hint "No supply type defined"};
									
									};
									
								private _modifier = _rollD20 - 10;
								private _amount = _base + (_base *_modifier);
												
								hint parseText format["You have found <t color='#FF8000'> %1 </t> units of %2!", _amount,_supType];
													
								private _resourceVName = "dntsp_"+_supType+(str dnt_supplyTaskID);
								private _mission = "dntask_"+_supType+(str dnt_supplyTaskID);
																					
								dnt_supplyTaskID = dnt_supplyTaskID + 1;
								publicVariable "dnt_supplyTaskID";
																				
								missionNamespace setVariable [_resourceVName, [_target, _amount, _supType, _mission], true];												
			
								[_mission, (format ["Deliver %1 units of %2 to the Haunter",_amount, _supType])] call ENGTASKS_CreateTask;
								
							}
							
							else {hint "You find nothing";_target setDamage 1;};
						}
						
						else {[_target,_actionId]remoteExec ["removeAction"];};
					};
					
			},[_type,_mod, _cargoSize],6,true,true,"","true", 10,false,"",""];
		
		} else {};		
		};
	
};
	

	
	
	
	
	
	

