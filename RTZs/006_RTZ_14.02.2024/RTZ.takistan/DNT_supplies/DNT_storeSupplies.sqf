scriptName "DNT_storeSupplies";

params["_thisList", "_thisTrigger"];

private _variableList = (allVariables missionNameSpace) select {_x regexMatch ".*dntsp_.*"};

{

	private _arrayAccess = missionNamespace getVariable _x;
	private _objectVar = _arrayAccess select 0;

	if(_objectVar inArea _thisTrigger) then {
	
		private _arrayAccessScope = missionNamespace getVariable _x;
		private _loot = _arrayAccessScope select 0;
		private _amount =  _arrayAccessScope select 1;
		private _type = _arrayAccessScope select 2;
		private _task = _arrayAccessScope select 3;
		deleteVehicle _loot;   
		   
		switch(_type) do    
			{   
				case "ammunition":{dnt_ammoCount = dnt_ammoCount + _amount; publicVariable "dnt_ammoCount";};   
				case "medicaments":{dnt_medicalCount = dnt_medicalCount + _amount; publicVariable "dnt_medicalCount";};
				case "scrap":{dnt_scrapCount = dnt_scrapCount + _amount; publicVariable "dnt_scrapCount";};  				
				case "vehicle":{dnt_VehicleList append [_loot];	publicVariable "dnt_VehicleList";};  
		  
			}; 
		 
		[_task, "SUCCEEDED", true] call ENGTASKS_SetTaskState;
		["Supplies", ["Claimed supplies", (format["Current list of supplies brought to Haunter - ammunition: %1, medical: %2, scrap %3",
    dnt_ammoCount,dnt_medicalCount, dnt_scrapCount])], false] call ENGTASKS_SetTaskDescription;
		uiSleep 1;
		[_task] call ENGTASKS_DeleteTask;
	
	
	};

} forEach _variableList;


