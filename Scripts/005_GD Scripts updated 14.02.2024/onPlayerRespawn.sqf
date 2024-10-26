scriptName "onPlayerRespawn";

private _newUnit = _this select 0;
if ((group _newUnit == casper) || (group _newUnit == advisor) && !(isNil "Haunter")) then 
{
	_newUnit addAction ["<t color='#0000FF'>Open Casper Spawn Menu</t>", {createDialog "RscCaspSpawnDialog";}, [], 1, true, true, "", "_target inArea Haunter"];
	_newUnit addAction ["<t color='#00FF00'>Open Casper Repair Menu</t>", {createDialog "RscCaspRepairDialog";}, [], 1, true, true, "", "_target inArea Haunter"];
};


player setUnitLoadout(player getVariable["Saved_Loadout",[]]);


player addEventHandler ["Reloaded", {
	params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];
	
	private _oldMagClass = _oldMagazine select 0;
	private _oldMagAmmoLeft = _oldMagazine select 1;
	private _oldMagCapacity = getNumber (configfile >> "CfgMagazines" >> _oldMagClass >> "count");
	private _ammoLeftPercent = round((_oldMagAmmoLeft/_oldMagCapacity) * 100);
	if(_ammoLeftPercent<=10) then {
		dnt_ammoCount = dnt_ammoCount - 1; 
		publicVariable "dnt_ammoCount";
		["Supplies", ["Claimed supplies", (format["Current list of supplies brought to Haunter - ammunition: %1, medical: %2, scrap %3",
    		dnt_ammoCount,dnt_medicalCount, dnt_scrapCount])], false] call ENGTASKS_SetTaskDescription;
		
	};
	
}];


["ace_treatmentStarted", {

	params["_caller", "_target", "_selectionName", "_className", "_itemUser", "_usedItem"];
	
	
	if(_usedItem != "") then {dnt_medicalItemsUsed = dnt_medicalItemsUsed + 1; publicVariable "dnt_medicalItemsUsed";};

	
	if(dnt_medicalItemsUsed >=10) then {
		dnt_medicalCount = dnt_medicalCount - 1; 
		publicVariable "dnt_medicalCount";
		dnt_medicalItemsUsed = 0;
		publicVariable "dnt_medicalItemsUsed";
		["Supplies", ["Claimed supplies", (format["Current list of supplies brought to Haunter - ammunition: %1, medical: %2, scrap %3",
    dnt_ammoCount,dnt_medicalCount, dnt_scrapCount])], false] call ENGTASKS_SetTaskDescription;
	};

}] call CBA_fnc_addEventHandler;


//to fix sometime later
/*player addEventHandler ["Hit", {
	params ["_unit", "_source", "_damage", "_instigator"];
	
	private _soundsArray = ["onPlayerHit_1", "onPlayerHit_2", "onPlayerHit_3", "onPlayerHit_4", "onPlayerHit_5", "onPlayerHit_6", "onPlayerHit_7"];
	private _sound = selectRandom _soundsArray;
	private _activator = floor(random 15);
	if(_activator == 3) then {
		[_unit, _sound] remoteExec ["say"];
	};}];*/

