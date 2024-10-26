_controls = allControls findDisplay 300;
_statuses = [[_controls select 0 ctrlChecked 0,pad1],[_controls select 0 ctrlChecked 1,pad2],[_controls select 0 ctrlChecked 2,pad3],[_controls select 0 ctrlChecked 3,pad4]];
{
	if (_x select 0) then 
	{
		_veh = ( nearestObjects [_x select 1, ["Helicopter", "Plane"], 25] ) select 0;
		_veh setFuel 1;
		_veh setDamage 0;
		if(dnt_ammoDepleted == false) then {
			_veh setVehicleAmmo 1;
			
		} else {hint "No ammo, can't rearm vehicle!"};
	};
} forEach _statuses;
_controls select 0 ctrlSetChecked [0, false];
_controls select 0 ctrlSetChecked [1, false];
_controls select 0 ctrlSetChecked [2, false];
_controls select 0 ctrlSetChecked [3, false];