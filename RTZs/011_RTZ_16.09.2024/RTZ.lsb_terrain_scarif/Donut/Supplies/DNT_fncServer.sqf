DNT_initSuppliesServer = {

	dnt_regSupplies = [];
	publicVariable "dnt_regSupplies";
	
	dnt_regCuratorLogic = [];
	publicVariable "dnt_regCuratorLogic";
	
	dnt_mpKilledRegistry = [];
	publicVariable "dnt_mpKilledRegistry";
	
	dnt_deployedVehicles = [];
	publicVariable "dnt_deployedVehicles";
	
	dnt_supplyTaskID = 0;
	publicVariable "dnt_supplyTaskID";
	
	dnt_supplySystemActive = true;
	publicVariable "dnt_supplySystemActive";
	
	dnt_registeredSupplies = [];
	publicVariable "dnt_registeredSupplies";
		
	"dnt_supplySystemActive" addPublicVariableEventHandler {remoteExec["DNT_updateSupplyTrackerTasks",2];};
		
	remoteExec["DNT_updateSupplyTrackerTasks",2];
	
	["all"] call DNT_readFromDbPublic;

};


/* DNT_readFromDb
* Reads from db and returns supplies state as an array.
*/
DNT_readFromDb = {

	private _database = "";

	waitUntil {!isNil "dnt_supplySystemActive"};

	if(dnt_supplySystemActive == true) then {
	
		_database = "Quartermasters_logbook";
	
	} else {
	
		_database = "Unlimited";
	
	};

	private _inidbi = ["new",_database] call OO_INIDBI;
	private _suppliesStatus = [];
	
	private _ammoCount = ["read", ["Supply count", "Ammo",9999]] call _inidbi; 
	private _medicalCount = ["read", ["Supply count", "Meds",9999]] call _inidbi; 
	private _scrapCount = ["read", ["Supply count", "Scrap",9999]] call _inidbi; 
	private _vehicleGarage = ["read", ["Supply count", "Vehicles",[]]] call _inidbi;
	
	private _vehicleSummary = _vehicleGarage call BIS_fnc_consolidateArray;
	private _vehicleMissionTxt = "";
									
	{					
		_vehicleMissionTxt = _vehicleMissionTxt + "- " + (_x select 0) + ": " + str(_x select 1) + endl;
	
	}forEach _vehicleSummary;
	
	if(_ammoCount <= 0) then {
	
		dnt_ammoDepleted = true;
		publicVariable "dnt_ammoDepleted";	
	
	} else {
	
		dnt_ammoDepleted = false;
		publicVariable "dnt_ammoDepleted";	
	
	};
	
	if(_medicalCount <= 0) then {
	
		dnt_medsDepleted = true;
		publicVariable "dnt_medsDepleted";	
	
	} else {
	
		dnt_medsDepleted = false;
		publicVariable "dnt_medsDepleted";	
	
	};	
	
	if(_scrapCount <= 0) then {
	
		dnt_scrapDepleted = true;
		publicVariable "dnt_scrapDepleted";	
	
	} else {
	
		dnt_scrapDepleted = false;
		publicVariable "dnt_scrapDepleted";	
	
	};	
	
	_suppliesStatus = [_ammoCount, _medicalCount, _scrapCount, _vehicleGarage, _vehicleMissionTxt];
	
	_suppliesStatus;

};

/* DNT_writeToDb
* Writes to DB provided parameters
* 	Params:
*	- _type - string, can be "ammo", "meds", "scrap" or "vehicle" - determines which values in DB are edited
*	- _resources - if _type is ammo, meds or scrap should be INT, reflecting mumber of supplies to be set in db. If is vehicle appropriate short name for vehicle should be added. 
*					Refer to "DNT_vehicleDictionary" for valid vehicle types
*/
DNT_writeToDb = {

	params ["_type", "_resource"];
	
	private _database = "";

	if(dnt_supplySystemActive == true) then {
	
		_database = "Quartermasters_logbook";
	
	} else {
	
		_database = "Unlimited";
	
	};
	
	private _inidbi = ["new",_database] call OO_INIDBI;
	
	diag_log format ["%1 %2 written to DB",_type, _resource];
	
	switch (_type) do {
	
		case "ammo": {
			private _ammoCount = ["read", ["Supply count", "Ammo",9999]] call _inidbi; 
			["write", ["Supply count", "Ammo", (_ammoCount + _resource)]] call _inidbi;
		};
		case "meds": {
			private _medicalCount = ["read", ["Supply count", "Meds",9999]] call _inidbi; 
			["write", ["Supply count", "Meds", (_medicalCount + _resource)]] call _inidbi;
		};
		case "scrap": {
			private _scrapCount = ["read", ["Supply count", "Scrap",9999]] call _inidbi;
			["write", ["Supply count", "Scrap", (_scrapCount + _resource)]] call _inidbi;
		};
		case "vehicle": {
			private _vehicleGarage = ["read", ["Supply count", "Vehicles",[]]] call _inidbi;
			_vehicleGarage pushBack _resource;
			["write", ["Supply count", "Vehicles", _vehicleGarage]] call _inidbi;
			private _vehicleSummary = _vehicleGarage call BIS_fnc_consolidateArray;
			["write", ["Supply count", "VehiclesCons", _vehicleSummary]] call _inidbi;
		};
		case "removeVehicle": {
			private _vehicleGarage = ["read", ["Supply count", "Vehicles",[]]] call _inidbi;
			
			private _removeIndex = _vehicleGarage find _resource;
			if(_removeIndex != -1) then {
				_vehicleGarage deleteAt _removeIndex;
			};
			
			["write", ["Supply count", "Vehicles", _vehicleGarage]] call _inidbi;
			private _vehicleSummary = _vehicleGarage call BIS_fnc_consolidateArray;
			
			["write", ["Supply count", "VehiclesCons", _vehicleSummary]] call _inidbi;
		};
		
		default {hint format ["%1 is not valid value",_type]};
	};
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];

};

/* DNT_updateSupplyTrackerTasks 
* Updates supply tracking tasks, uses values stored in dnt_suppliesStatus server variable retrieved via DNT_clientReadFromDb function
*/
DNT_updateSupplyTrackerTasks = {
	
    private _suppliesStatus = call DNT_readFromDb;
    
    ["all"] call DNT_readFromDbPublic;
	
    private _ammoCount = _suppliesStatus select 0;
    private _medicalCount = _suppliesStatus select 1;
    private _scrapCount = _suppliesStatus select 2;
    private _vehicleMissionTxt = _suppliesStatus select 4;
    
    if((["Supplies"] call ENGTASKS_GetTaskState)== "") then {

        ["Supplies", ["Claimed supplies", (format["Current list of supplies brought to Haunter - ammunition: %1, medical: %2, scrap %3",
        _ammoCount,_medicalCount, _scrapCount])], "CREATED"] call ENGTASKS_CreateTask;

        
    } else {
    
        ["Supplies", ["Claimed supplies", (format["Current list of supplies brought to Haunter - ammunition: %1, medical: %2, scrap %3",
        _ammoCount,_medicalCount, _scrapCount])], false] call ENGTASKS_SetTaskDescription;
        
    
    };

    if((["VehiclesList"] call ENGTASKS_GetTaskState)== "") then {
    
        ["VehiclesList", ["Available vehicles", (format["Current list of available vehicle types: %1 %2",
        endl,_vehicleMissionTxt])], "CREATED"] call ENGTASKS_CreateTask;
    } else {
    
        ["VehiclesList", ["Available vehicles", (format["Current list of available vehicle types: %1 %2",
        endl,_vehicleMissionTxt])], false] call ENGTASKS_SetTaskDescription;    
    
    };
    
};


/* DNT_readFromDbPublic
* Makes data read from DB public
*/
DNT_readFromDbPublic = {

	params["_value"];

	private _database = "";

	waitUntil {!isNil "dnt_supplySystemActive"};

	if(dnt_supplySystemActive == true) then {
	
		_database = "Quartermasters_logbook";
	
	} else {
	
		_database = "Unlimited";
	
	};

	private _inidbi = ["new",_database] call OO_INIDBI;
	
	switch (_value) do {
	
		case "ammo": {
			dnt_ammoCount = ["read", ["Supply count", "Ammo",9999]] call _inidbi; 
			publicVariable "dnt_ammoCount";
		};
		case "meds": {
			dnt_medicalCount = ["read", ["Supply count", "Meds",9999]] call _inidbi;
			publicVariable "dnt_medicalCount";
		};	
		case "scrap": {		
			dnt_scrapCount = ["read", ["Supply count", "Scrap",9999]] call _inidbi;
			publicVariable "dnt_scrapCount";
		};
			
		case "vehicle": {	
			dnt_vehicleGarage = ["read", ["Supply count", "Vehicles",[]]] call _inidbi;
			publicVariable "dnt_vehicleGarage";	
		};
		
		case "all":{
		
			dnt_ammoCount = ["read", ["Supply count", "Ammo",9999]] call _inidbi; 
			publicVariable "dnt_ammoCount";
			dnt_medicalCount = ["read", ["Supply count", "Meds",9999]] call _inidbi;
			publicVariable "dnt_medicalCount";
			dnt_scrapCount = ["read", ["Supply count", "Scrap",9999]] call _inidbi;
			publicVariable "dnt_scrapCount";
			dnt_vehicleGarage = ["read", ["Supply count", "Vehicles",[]]] call _inidbi;
			publicVariable "dnt_vehicleGarage";	
		};
	};
};

DNT_onReloadServer = {

	private _suppliesStatus = call DNT_readFromDb;	
	private _currentAmmoStatus =  _suppliesStatus select 0;
	remoteExec["DNT_updateSupplyTrackerTasks",2];

	if(_currentAmmoStatus>0) then {;		
		["ammo", -1] call DNT_clientWriteToDb;
		remoteExec["DNT_updateSupplyTrackerTasks",2];
		dnt_ammoDepleted = false;
		publicVariable "dnt_ammoDepleted";
				
	} else {
	
		dnt_ammoDepleted = true;
		publicVariable "dnt_ammoDepleted";

	};
};

DNT_onTreatmentServer = {

	private _suppliesStatus = call DNT_readFromDb;	
	private _currentMedsStatus =  _suppliesStatus select 1;

	if(_currentMedsStatus > 0) then {
	
		["meds", -1] call DNT_writeToDb;
		remoteExec["DNT_updateSupplyTrackerTasks",2];
		dnt_medsDepleted = false;
		publicVariable "dnt_medsDepleted";
					
	} else {
	
		dnt_medsDepleted = true;
		publicVariable "dnt_medsDepleted";

	};
};

DNT_onFortifyServer = {
	
	params ["_cost"];
	private _suppliesStatus = call DNT_readFromDb;	
	private _currentScrapStatus =  _suppliesStatus select 2;
	private _newScrapStatus = _currentScrapStatus - _cost;
	
	remoteExec["DNT_updateSupplyTrackerTasks",2];
	
	switch (true) do {
	
		case (_newScrapStatus > 0): {
		
			["scrap", (_cost* -1)] call DNT_clientWriteToDb;
			remoteExec["DNT_updateSupplyTrackerTasks",2];
			dnt_scrapDepleted = false;
			publicVariable "dnt_scrapDepleted";
		};
		
		case (_newScrapStatus <= 0): {
		
			["scrap", (_cost* -1)] call DNT_clientWriteToDb;
			remoteExec["DNT_updateSupplyTrackerTasks",2];
			dnt_scrapDepleted = true;
			publicVariable "dnt_scrapDepleted";
		};
	
	
	};

};