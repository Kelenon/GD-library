scriptName "DNT_createSupplies";

params ["_this","_type", "_mod", "_cargoSize"];

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
				_supType = _this select 3 select 0;
				_mod = _this select 3 select 1;
				_cargoSize = _this select 3 select 2;
				private _rollD20 = floor(random 20) + _mod;

				if(_supType == "scrap" && ([_caller, 1] call ace_repair_fnc_isEngineer) == true) then {
				
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
						
						if(_targetType in tinyCargoSize) then {_target = createVehicle["3as_Small_Box_1_prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "NONE"];[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 1] call ace_cargo_fnc_setSize; _base = 2;};
						if(_targetType in smallCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "NONE"];[_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 1.2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 2] call ace_cargo_fnc_setSize; _base = 5};
						if(_targetType in mediumCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "NONE"];[_target, true, [0, 2, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 2, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 5] call ace_cargo_fnc_setSize; _base = 10};
						if(_targetType in largeCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "NONE"];[_target, true, [0, 2.5, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 2.5, 1.2], 0, true] call ace_dragging_fnc_setDraggable; [_target, 15] call ace_cargo_fnc_setSize;  _base = 15};
						if(_targetType in gargantuanCargoSize) then {_target = createVehicle["3AS_Small_Box_10_Prop", (_scrapPos vectorAdd [0,0,0.5]), [], 0, "NONE"];[_target, true, [0, 3, 1.2], 0, true] call ace_dragging_fnc_setCarryable; [_target, true, [0, 3, 1.5], 0, true] call ace_dragging_fnc_setDraggable; [_target, 20] call ace_cargo_fnc_setSize;  _base = 20};
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
						[_mission, getPos _target, false] call ENGTASKS_SetTaskDestination;
						
					
					}
					
					else {hint "There is nothing to salvage!";
					[_target,_actionId]remoteExec ["removeAction"];
					};
				}
			}
			
			else {hint "You need to be an engineer to salvage!"};

},[_type,_mod, _cargoSize],6,true,true,"","true", 10,false,"",""];}



else{
	if(alive _this) then {
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
								
								missionNamespace setVariable [_vehicleVName, [_target, _vicName, _vehicleId,_supType], true];
								
								dnt_VehicleList pushBack _vicName;
												
								[_vehicleId, (format ["Claimed %1", _vicName])] call ENGTASKS_CreateTask;
								[_vehicleId, getPos _target, false] call ENGTASKS_SetTaskDestination;
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
								[_mission, getPos _target, false] call ENGTASKS_SetTaskDestination;
								
							}
							
							else {hint "You find nothing";};
						}
						
						else {[_target,_actionId]remoteExec ["removeAction"];};
					};
			
			},[_type,_mod, _cargoSize],6,true,true,"","true", 10,false,"",""];
			
		};
	
};
	
	
	
	
	
	
	
	

