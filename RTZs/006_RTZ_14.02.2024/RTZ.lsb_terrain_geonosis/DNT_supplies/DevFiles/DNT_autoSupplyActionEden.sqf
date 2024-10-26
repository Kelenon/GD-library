if(dnt_autoCreateSuppliesOn == 1) then {
	{
		
		[[_x, "ammunition", 0, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",-2,true]; //V2 - at start first player gets 2 actions, after rejoin only 1 //V1 LM - works DS - first player gets 2 claims, but after rejoin there is only 1
	

	}forEach entities[dnt_ammoContainers,[],false,true];
};

if(dnt_autoCreateSuppliesOn == 1) then {
	{
		
		[[_x, "medicaments", 0, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",-2,true]; //V2 - at start first player gets 2 actions, after rejoin only 1 //V1 LM - works DS - first player gets 2 claims, but after rejoin there is only 1
	

	}forEach entities[dnt_medicalContainers,[],false,true];
};



{ 

	private _cargoSpace = dnt_spaceXS;
	private _isVehicle = false;
	
	if(typeOf _x in tinyCargoSize) then {_cargoSpace = dnt_spaceXS;_isVehicle = true;};
	if(typeOf _x in smallCargoSize) then {_cargoSpace = dnt_spaceS;_isVehicle = true;};
	if(typeOf _x in mediumCargoSize) then {_cargoSpace = dnt_spaceM;_isVehicle = true;};
	if(typeOf _x in largeCargoSize) then {_cargoSpace = dnt_spaceL;_isVehicle = true;};
	if(typeOf _x in gargantuanCargoSize) then {_cargoSpace = dnt_spaceXL;_isVehicle = true;};
	
	if(_isVehicle == true) then {
	
		[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace",-2,true]; //V2 - works //V1 LM - works DS - works
		
		if(typeOf _x in dnt_claimVic && dnt_autoClaimableVicsOn == 1) then {
			[[_x, "vehicle", 0, 1],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",-2,true]; //V2 - at start first player gets 2 actions, after rejoin only 1 //V1 LM - works DS - first player gets 2 claims, but after rejoin there is only 1
			
		};
		
		_x addEventHandler ["Killed", {
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				
				private _scrapSize = dnt_scrapXS;
				if(typeOf _unit in smallCargoSize) then {_scrapSize = dnt_scrapS;};
				if(typeOf _unit in mediumCargoSize) then {_scrapSize = dnt_scrapM;};
				if(typeOf _unit in largeCargoSize) then {_scrapSize = dnt_scrapL;};
				if(typeOf _unit in gargantuanCargoSize) then {_scrapSize = dnt_scrapXL;};
				
				[[_unit, "scrap", 0, _scrapSize],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",-2,true]; //V2 - all players see 3 actions //V1 LM - works DS - double action
		}];
	};


}forEach vehicles;