scriptName "DNT_trackSupplies";

while{true} do {

	private _supplyList = (allVariables missionNameSpace) select {_x regexMatch ".*dntsp_.*"};
	
	{
	
		private _arrayAccess = missionNamespace getVariable _x;
		private _objectVar = _arrayAccess select 0;
		private _objectMission = _arrayAccess select 3;
		private _missionState = [_objectMission] call ENGTASKS_GetTaskState;
		
		if(!alive _objectVar && _missionState != "SUCCEDED") then {
		
			[_objectMission] call ENGTASKS_DeleteTask;
			dnt_registeredSupplyObjects deleteAt (dnt_registeredSupplyObjects find _objectVar);
			publicVariableServer "dnt_registeredSupplyObjects";
		
		};
	
	}forEach _supplyList;
	
	
	private _vehicleList = (allVariables missionNameSpace) select {_x regexMatch ".*dntv_.*"};

	{
	
		private _arrayAccess = missionNamespace getVariable _x;
		private _objectVar = _arrayAccess select 0;
		private _objectMission = _arrayAccess select 2;
		private _vicType = _arrayAccess select 4;
		
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
		
		if(!alive _objectVar) then {
		
			[_objectMission] call ENGTASKS_DeleteTask;
			
			_inidbi = ["new","Quartermasters_logbook"] call OO_INIDBI;
			private _vehicleList = ["read", ["Supply count", "Vehicles"]] call _inidbi;
			_removeVicIndex = _vehicleList find _vicType;			
			_vehicleList deleteAt _removeVicIndex;
			dnt_vehicleList = _vehicleList;
			publicVariable "dnt_vehicleList";
			
			private _vehicleListConsolidated = _vehicleList call BIS_fnc_consolidateArray;
			
			private _vehicleTxtLines = "";
								
			{								
				_vehicleTxtLines = _vehicleTxtLines + "- " + (_x select 0) + ": " + str(_x select 1) + endl;
								
			}forEach _vehicleListConsolidated;
								
			["VehiclesList", ["Available vehicles", (format["Current list of available vehicle types: %1 %2",
			endl,_vehicleTxtLines])], false] call ENGTASKS_SetTaskDescription;

			dnt_registeredSupplyObjects deleteAt (dnt_registeredSupplyObjects find _objectVar);
			publicVariableServer "dnt_registeredSupplyObjects";
		
			missionNamespace setVariable [_x, nil, true];			
		};
		
	
	}forEach _vehicleList;


uiSleep 7;
};