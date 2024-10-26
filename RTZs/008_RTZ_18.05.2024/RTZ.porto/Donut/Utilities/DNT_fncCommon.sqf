DNT_spawnVehicleFromGarage = { 

	params ["_spawnLocation", "_type", "_caller"];
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];
	
	private _vicType = [_type] call DNT_vehicleDictionary;
		
	if(_vicType in dnt_vehicleGarage) then {
		
		if(count (_spawnLocation nearEntities [["LandVehicle", "Air", "Ship"],7])>0) then {
		
			["Move other vehicles to a safe distance before deploying another!"] remoteExec ["hint",_caller];
		
		} else {
			
			private _vic = createVehicle[_type, getPosATL _spawnLocation, [], 0, "CAN_COLLIDE"];
			_vic allowDamage false;
			
			if(dnt_ammoDepleted == true) then {
				
				_vic setVehicleAmmo  0;
				
			};
			
			private _vicParams = [_vic] call DNT_evaluateVehicle;
			private _vicCargoSize = _vicParams select 0;
			[_vic, _vicCargoSize] call ace_cargo_fnc_setSpace;
							
			dnt_deployedVehicles pushBack _vic;
			publicVariable "dnt_deployedVehicles";
				
			["removeVehicle", _vicType] call DNT_clientWriteToDb;
				
			[_vic, true] call DNT_onSupplyLost;		

					
			if (!isNil "phantPole") then {  
				_vic setDir (getDir phantPole);
			};
			
			if (!isNil "dirPole") then {  
				_vic setDir (getDir dirPole);
			};
	
			uiSleep 3;
			_vic allowDamage true;
			_vic setDamage 0;
			
		};
		
	} else {
		["vehicle unavailable!"] remoteExec ["hint",_caller]; 
	};
	
	uiSleep 2;
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];
};

DNT_garageVehicles = {

	params ["_garagePanel", "_thisTriggerList", "_phantomSpawnToReset"];
	
	private _matchingObjects = dnt_deployedVehicles arrayIntersect _thisTriggerList;
	
	{
		if(!alive _x) then {
		
			_matchingObjects deleteAt (_matchingObjects find _x);
		
		};
	
	}forEach _matchingObjects;
	
	{	
		private _vicType = [_x] call DNT_vehicleDictionary;
		
		private _actionText = format ["<t color='#00FF00'>Store %1 in garage</t>",_vicType];
		
		if(hasInterface == true) then {
		
		private _garageActionId = _garagePanel addAction [_actionText,{
		
			params ["_target", "_caller", "_actionId"];
			[_target, "ls_lighting_activationRepublic"]remoteExec["say3D"];
			
			private _vicObject = _this select 3 select 0;
			
			private _checkCargo = _vicObject getVariable ["ace_cargo_loaded", []];
			private _supplyItemClasses = ["3AS_Supply_Large_Blue_Prop", "3AS_Supply_Large_Medical_Prop", "JLTS_Ammobox_ammo_GAR", "JLTS_Ammobox_weapons_GAR", "JLTS_Ammobox_explosives_GAR", "JLTS_Ammobox_grenades_GAR", "JLTS_Ammobox_launchers_GAR", "JLTS_Ammobox_weapons_special_GAR", "JLTS_Ammobox_support_GAR", "JLTS_Ammobox_ammo_CIS", "JLTS_Ammobox_weapons_CIS", "JLTS_Ammobox_launchers_CIS", "JLTS_Ammobox_weapons_special_CIS", "JLTS_Ammobox_support_CIS"];
			private _cargoClasses = [];
			private _cargoClassIter = "";
			
			{
				if(typeName _x == "OBJECT") then {_cargoClassIter = typeOf _x;};
				if (_cargoClassIter in _supplyItemClasses) then {_cargoClasses pushBack _cargoClassIter};
			
			}forEach _checkCargo;
			
			if(count(_supplyItemClasses arrayIntersect _cargoClasses) == 0) then {
			
				private _vicType = _this select 3 select 1;
				private _phantomSpawnToReset = _this select 3 select 2;
				
				if(_vicObject in dnt_deployedVehicles) then {
	
					private _removeIndex = dnt_deployedVehicles find _vicObject;
					if(_removeIndex != -1) then {
						dnt_deployedVehicles deleteAt _removeIndex;
						publicVariable "dnt_deployedVehicles";
					};
				};			
				[_vicObject] call DNT_removeRegObject;
				
				["vehicle", _vicType] call DNT_clientWriteToDb;		
				
				deleteVehicle _vicObject;
				
				[_target, _actionId] remoteExec ["removeAction",0,true]; 
				
				hint format ["%1 stored in garage!", _vicType];
				
				remoteExec ["DNT_removeSupplies",0,true];
				
				remoteExec["DNT_updateSupplyTrackerTasks",2];
				
				[_phantomSpawnToReset, phantSpawn] remoteExec ["DNT_phantomSpawn",-2,true];
				
			} else {
			
				["There might be cargo in a vehicle you try to store. Make sure to unload it before proceeding!"] remoteExec ["hint", _caller];
			
			};
		
		},[_x, _vicType, _phantomSpawnToReset],1.5,true,true,"","true",10,false,"",""];
		
	};
		
	
	}forEach _matchingObjects;
};

DNT_casperSpawn = {

	params ["_vicType"];

	waitUntil {!isNil "DNT_spawnVehicleFromGarage"};
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];
	
	private _controls = allControls findDisplay 200;
	private _statuses = [[_controls select 0 ctrlChecked 0,pad1],[_controls select 0 ctrlChecked 1,pad2],[_controls select 0 ctrlChecked 2,pad3],[_controls select 0 ctrlChecked 3,pad4]];
	
	{	
		if (_x select 0) then {
			[(_x select 1),_vicType, -2] remoteExec ["DNT_spawnVehicleFromGarage",2];
			
		};
		
	} forEach _statuses;
	
	_controls select 0 ctrlSetChecked [0, false];
	_controls select 0 ctrlSetChecked [1, false];
	_controls select 0 ctrlSetChecked [2, false];
	_controls select 0 ctrlSetChecked [3, false];
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];
	
};

DNT_phantomSpawn = {

	params ["_spawnPanel", "_spawnLocation"];
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];
	
	private _garageVehicles = dnt_vehicleGarage;
	
	private _garageVehiclesDistinct = _garageVehicles arrayIntersect _garageVehicles;
	
	private _casperVehicles = ["Delta Starfighter", "Y-Wing", "ARC-170", "LAAT C", "LAAT I", "V-Wing", "Z-95 HeadHunter", "Nu A-Class Shuttle", "Transport Ship"]; //List of vehicles that are to only be spawned via Casper respawn script
	
	_garageVehiclesDistinct = _garageVehiclesDistinct - _casperVehicles;
	
	removeAllActions _spawnPanel;
	
	_spawnPanel addAction ["Login to vehicle dispenser...",{
		
		params ["_target", "_caller", "_actionId"];
		
		private _garageVehiclesDistinct = _this select 3 select 0;
		
		private _spawnLocation = _this select 3 select 1;
		
		private _actionText = "";
		
		[_target] remoteExec ["removeAllActions",0,true];
		
		if(count _garageVehiclesDistinct > 0) then { 
		
		{
			_actionText = format ["Select %1", _x];
			
			_target addAction [_actionText,{
			
				params ["_target", "_caller", "_actionId"]; 
				
				private _vicType = _this select 3 select 0;
				private _spawnLocation = _this select 3 select 1;
				
				private _subTypesClasses = [_vicType, _target, _actionId] call DNT_phantomSpawnActions;
				
				[_target] remoteExec ["removeAllActions",-2,true];
				
				{
					_actionText = format ["<t color = '#ff0000'>Deploy %1</t>", _x select 0];
					_target addAction [_actionText, {
					
						params ["_target", "_caller", "_actionId"];
						
						private _vicClass = _this select 3 select 0;
						private _spawnLocation = _this select 3 select 1;
						private _vicType = _this select 3 select 2;
						
						if(_vicType in ["Transport ship", "Juggernaut", "GAR AV-7 Artillery", "AT-AT"]) then {
						
							[phantSpawnAlt, _vicClass] remoteExec ["DNT_spawnVehicleFromGarage",2];
						
						} else {
						
							[phantSpawn, _vicClass] remoteExec ["DNT_spawnVehicleFromGarage",2];
						};
						
						[_target, _spawnLocation] remoteExec ["DNT_phantomSpawn",-2,true];
					
					},[_x select 1, _spawnLocation, _vicType],1.5,true,true,"","true",10,false,"",""];
				
				}forEach _subTypesClasses;
			
			},[_x, _spawnLocation],1.5,true,true,"","true",10,false,"",""];
			
		
		}forEach _garageVehiclesDistinct;
		
		} else {
		
			hint "Garage is empty!";
		
			[_target, _spawnLocation] remoteExec ["DNT_phantomSpawn",-2, true];
		
		};
	
	},[_garageVehiclesDistinct, _spawnLocation],1.5,true,true,"","true",10,false,"",""];
	

};

DNT_phantomSpawnActions = {
	
	params ["_vicType", "_target", "_actionId"];
	
	[_target] remoteExec ["removeAllActions",0,true];
	
	private _subTypesClasses = [];
	
	switch (true) do {
	
		case (_vicType == "Sabre tank"): {_subTypesClasses = [["Standard Sabre", "3AS_Saber_M1"], ["Recon Sabre", "3AS_Saber_M1Recon"], ["Super Sabre", "3AS_Saber_Super"], ["Sabre GL", "3AS_Saber_M1G"]]};
		case (_vicType == "RTT"): {_subTypesClasses = [["RTT", "3AS_RTT_Wheeled"]]};
		case (_vicType == "Snowspeeder"): {_subTypesClasses = [["Snowspeeder", "3AS_Snowspeeder_Rogue"],["Snowspeeder - red", "3AS_Snowspeeder"],["Snowspeeder - blue", "3AS_Snowspeeder_Blue"]]};
		case (_vicType == "Police LAAT"): {_subTypesClasses = [["Standard LAAT LE","ls_heli_laatle"], ["Transport LAAT LE","ls_heli_laatle_transportGunship"], ["Light LAAT LE","3AS_Patrol_LAAT_Republic"]]};
		case (_vicType == "Swamp speeder"): {_subTypesClasses = [["Armed Swamp Speeder", "3AS_ISP"], ["Transport Swamp Speeder", "3AS_ISP_Transport"]]};
		case (_vicType == "Speeder"): {_subTypesClasses = [["BARC Speeder","3AS_Barc"], ["Sidecar variant BARC Speeder","3AS_BarcSideCar"], ["105-K Speeder","lsd_ground_lancerBike"], ["Heavy BARC speeder","ls_ground_barc"]]};
		case (_vicType == "GAR AV-7 Artillery"):{_subTypesClasses = [["GAR AV-7 Artillery", "3AS_AV7"]]};
		case (_vicType == "ITT"): {_subTypesClasses = [["Standard ITT","3AS_ITT"], ["Logistics ITT","3AS_ITT_Logistic"], ["Medical ITT","3AS_ITT_Medical"]]};
		case (_vicType == "ATTE"): {_subTypesClasses = [["ATTE", "3AS_ATTE_Base"]]};
		case (_vicType == "ATAP"): {_subTypesClasses = [["ATAP", "3AS_ATAP_Base"]]};
		case (_vicType == "Transport ship"): {_subTypesClasses = [["Transport ship","3AS_Republic_Transport_01"]]};
		case (_vicType == "AT-AT"): {_subTypesClasses = [["AT-AT", "3AS_ATAT"]]};
		case (_vicType == "Juggernaut"): {_subTypesClasses = [["Juggernaut", "3as_Jug"]]};
		case (_vicType == "UT-AT"): {_subTypesClasses = [["UT-AT", "3AS_UTAT"]]};
		case (_vicType == "PX-10"): {_subTypesClasses = [["Standard PX-10","3AS_PX10_REP_F"], ["Minesweeper PX-10","3AS_PX10_REP_R3"], ["Up-armor variant PX-10","3AS_PX10_REP_UP"]]};
		
		default{
		
			diag_log format ["DNT_phantomSpawnActions ERROR: No match for %1", _vicType];
			_subTypesClasses = false;
		
		};
	};
		
		_subTypesClasses

};