scriptName "DNT_setCargoSpace";

{	
		if(typeOf _x in tinyCargoSize) then {[ _x, 2] call ace_cargo_fnc_setSpace};
		if(typeOf _x in smallCargoSize) then {[ _x, 5] call ace_cargo_fnc_setSpace};
		if(typeOf _x in mediumCargoSize) then {[_x, 25] call ace_cargo_fnc_setSpace};
		if(typeOf _x in largeCargoSize) then {[_x, 50] call ace_cargo_fnc_setSpace};
		if(typeOf _x in gargantuanCargoSize) then {[_x, 1000] call ace_cargo_fnc_setSpace};
			
}forEach vehicles;

{
	_x addEventHandler ["CuratorObjectPlaced",{
		
		params ["_curator", "_entity"];
		private _targetType = typeOf _entity;
			
		if(_targetType in tinyCargoSize) then {[_entity, 2] call ace_cargo_fnc_setSpace};
		if(_targetType in smallCargoSize) then {[_entity, 5] call ace_cargo_fnc_setSpace};
		if(_targetType in mediumCargoSize) then {[_entity, 25] call ace_cargo_fnc_setSpace};
		if(_targetType in largeCargoSize) then {[_entity, 50] call ace_cargo_fnc_setSpace};
		if(_targetType in gargantuanCargoSize) then {[_entity, 1000] call ace_cargo_fnc_setSpace};
		
		_entity addEventHandler ["Killed",{
	
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		
		_unit removeAllEventHandlers "CuratorObjectPlaced";
		_unit removeAllEventHandlers "Killed";
			
		}];
	
	}];
	

	
}forEach allCurators;








