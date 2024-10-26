/*
 * Name:	DNT_limitSupplies
 * Date:	24.02.2024
 * Version: 1.0
 * Author:  Donut
 *
 */

scriptName "DNT_limitSupplies";

uiSleep 2;

while{true} do {

uiSleep 2;

if(isNull (getAssignedCuratorLogic player)) then { 
	if(dnt_ammoCount<=0) then {

		["ace_arsenal_displayOpened", {[ace_arsenal_currentBox, dnt_standardWeapons] call ace_arsenal_fnc_removeVirtualItems}] call CBA_fnc_addEventHandler;
		dnt_ammoRemoved = 1;
		publicVariable "dnt_ammoRemoved";
	
	};
	if(dnt_ammoCount>0) then {
	
		["ace_arsenal_displayOpened", {[ace_arsenal_currentBox, dnt_standardWeapons ] call ace_arsenal_fnc_addVirtualItems}] call CBA_fnc_addEventHandler;
		dnt_ammoRemoved = 0;
		publicVariable "dnt_ammoRemoved";
	
	};
	

	if(dnt_medicalCount<=0) then {
		
		["ace_arsenal_displayOpened", {[ace_arsenal_currentBox, dnt_standardMeds ] call ace_arsenal_fnc_removeVirtualItems}] call CBA_fnc_addEventHandler;
		dnt_medicamentsRemoved = 1;
		publicVariable "dnt_medicamentsRemoved";		
			
	
	};
	if(dnt_medicalCount>0) then {
	
		["ace_arsenal_displayOpened", {[ace_arsenal_currentBox, dnt_standardMeds ] call ace_arsenal_fnc_addVirtualItems}] call CBA_fnc_addEventHandler;	
		dnt_medicamentsRemoved = 0;
		publicVariable "dnt_medicamentsRemoved";	
	};
};	
	uiSleep 28;

};
