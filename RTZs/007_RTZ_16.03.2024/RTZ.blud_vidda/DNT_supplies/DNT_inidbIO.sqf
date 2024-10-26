/*
 * Name:	DNT_inidbIO
 * Date:	09.03.2024
 * Version: 1.0
 * Author:  Donut
 */

scriptName "DNT_inidbIO";

private _inidbi = ["new","Quartermasters_logbook"] call OO_INIDBI;

dnt_ammoCount = ["read", ["Supply count", "Ammo",9999]] call _inidbi; 
publicVariable "dnt_ammoCount";

dnt_medicalCount = ["read", ["Supply count", "Meds",9999]] call _inidbi; 
publicVariable "dnt_medicalCount";

dnt_scrapCount = ["read", ["Supply count", "Scrap",9999]] call _inidbi; 
publicVariable "dnt_scrapCount";

dnt_vehicleList = ["read", ["Supply count", "Vehicles",[]]] call _inidbi;
publicVariable "dnt_vehicleList";

dnt_vehicleSummary = dnt_vehicleList call BIS_fnc_consolidateArray;
publicVariable "dnt_vehicleSummary";

dnt_vehicleMissionTxt = "";
								
{					
	dnt_vehicleMissionTxt = dnt_vehicleMissionTxt + "- " + (_x select 0) + ": " + str(_x select 1) + endl;

}forEach dnt_vehicleSummary;

publicVariable "dnt_vehicleMissionTxt";



while {true} do {

	private _ammocount = ["read", ["Supply count", "Ammo"]] call _inidbi;
	private _medscount = ["read", ["Supply count", "Meds"]] call _inidbi;
	private _scrapcount = ["read", ["Supply count", "Scrap"]] call _inidbi;
	private _vehicleList = ["read", ["Supply count", "Vehicles"]] call _inidbi;
	
	if(_ammocount != dnt_ammoCount) then {
	
		["write", ["Supply count", "Ammo", dnt_ammoCount]] call _inidbi;
	
		};

	if(_medscount != dnt_medicalCount) then {
	
		["write", ["Supply count", "Meds", dnt_medicalCount]] call _inidbi;
			
		};
		
	if(_scrapcount != dnt_scrapCount) then {
	
		["write", ["Supply count", "Scrap", dnt_scrapCount]] call _inidbi;
		
		};
		
	if(!([_vehicleList,dnt_vehicleList] call BIS_fnc_areEqual)) then {
	
		["write", ["Supply count", "Vehicles", dnt_vehicleList]] call _inidbi;
		
		dnt_vehicleSummary = dnt_vehicleList call BIS_fnc_consolidateArray;
		
		["write", ["Supply count", "VehiclesCons ", dnt_vehicleSummary]] call _inidbi;
		
		};


uiSleep 5;
};

