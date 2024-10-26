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
		
		};
	
	}forEach _supplyList;
	
	
	private _vehicleList = (allVariables missionNameSpace) select {_x regexMatch ".*dntv_.*"};

	{
	
		private _arrayAccess = missionNamespace getVariable _x;
		private _objectVar = _arrayAccess select 0;
		private _objectMission = _arrayAccess select 2;
		
		if(!alive _objectVar) then {
		
			[_objectMission] call ENGTASKS_DeleteTask;
		};
		
	
	}forEach _vehicleList;






uiSleep 10;
};