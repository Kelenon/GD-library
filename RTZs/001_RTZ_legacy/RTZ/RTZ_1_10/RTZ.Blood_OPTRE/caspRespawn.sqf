_type = _this select 0;
_controls = allControls findDisplay 200;
_statuses = [[_controls select 0 ctrlChecked 0,pad1],[_controls select 0 ctrlChecked 1,pad2],[_controls select 0 ctrlChecked 2,pad3],[_controls select 0 ctrlChecked 3,pad4]];
{
	if (_x select 0) then 
	{	_vic = createVehicle[_type, getPosATL (_x select 1)];
		
		private _var = missionNamespace getVariable "dirPole"; 
		if (!isNil "_var") then {  //line strictly for RTZ files. Invisible flagpole is present to apply correct rotation at which aircrafts will be spawned
			_acDir = getDir dirPole;
			_vic setDir _acDir;
			};
		if (_type regexMatch "GD_LAAT.*") then
		{
			_vic addaction ["<t color='#FF0000'>Open Vehicle Garage</t>", {[_this select 0] execVM "garage.sqf"; }, [], 1, true, true, "", "_target inArea Haunter"];
		};
	};
} forEach _statuses;
_controls select 0 ctrlSetChecked [0, false];
_controls select 0 ctrlSetChecked [1, false];
_controls select 0 ctrlSetChecked [2, false];
_controls select 0 ctrlSetChecked [3, false];