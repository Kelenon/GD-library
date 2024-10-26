/*
 * Name:	DNT_setCargoSize
 * Date:	13.02.2024
 * Version: 1.0
 * Author:  Donut
 *
 */

scriptName "DNT_setCargoSize";

while{true && dnt_autoCargoOn == 1} do 
{
	{
			
		if(typeOf _x in tinyCargoSize) then {_cargoSpace = dnt_spaceXS;[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace"];};
		if(typeOf _x in smallCargoSize) then {_cargoSpace = dnt_spaceS;[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace"];};
		if(typeOf _x in mediumCargoSize) then {_cargoSpace = dnt_spaceM;[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace"];};
		if(typeOf _x in largeCargoSize) then {_cargoSpace = dnt_spaceL;[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace"];};
		if(typeOf _x in gargantuanCargoSize) then {_cargoSpace = dnt_spaceXL;[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace"];};
		
	}forEach vehicles;
	uiSleep 30;
}