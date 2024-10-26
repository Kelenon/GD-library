	getAssignedCuratorLogic player addEventHandler ["CuratorObjectPlaced", {
			params ["_curator", "_entity"];
			
			private _cargoSpace = dnt_spaceXS;
			private _isVehicle = false;
			
			if(typeOf _entity in tinyCargoSize) then {_cargoSpace = dnt_spaceXS;_isVehicle = true;};
			if(typeOf _entity in smallCargoSize) then {_cargoSpace = dnt_spaceS;_isVehicle = true;};
			if(typeOf _entity in mediumCargoSize) then {_cargoSpace = dnt_spaceM;_isVehicle = true;};
			if(typeOf _entity in largeCargoSize) then {_cargoSpace = dnt_spaceL;_isVehicle = true;};
			if(typeOf _entity in gargantuanCargoSize) then {_cargoSpace = dnt_spaceXL;_isVehicle = true;};
			
			if(typeOf _entity in dnt_ammoContainers) then {[[_entity, "ammunition", -2, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",0,true];}; //V2 - doesn't work	//V1 LM - works DS - doesn't work
			if(typeOf _entity in dnt_medicalContainers) then {[[_entity, "medicaments", -2, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",0,true];}; //V2 - doesn't work //V1 LM - works DS - doesn't work
			
			if(_isVehicle == true) then {
			
				[_entity, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace",-2,true]; //V2 - doesn't work //V1 LM - works DS - doesn't work
				if(typeOf _entity in dnt_claimVic  && dnt_autoClaimableVicsOn == 1) then {
					[[_entity, "vehicle", 0, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",-2,true]; //V2 - doesn't work //V1 LM - works DS - doesn't work
				};
				
				_entity addEventHandler ["Killed", {
						params ["_unit", "_killer", "_instigator", "_useEffects"];
						
						private _scrapSize = dnt_scrapXS;
						if(typeOf _unit in smallCargoSize) then {_scrapSize = dnt_scrapS;};
						if(typeOf _unit in mediumCargoSize) then {_scrapSize = dnt_scrapM;};
						if(typeOf _unit in largeCargoSize) then {_scrapSize = dnt_scrapL;};
						if(typeOf _unit in gargantuanCargoSize) then {_scrapSize = dnt_scrapXL;};
						
						[[_unit, "scrap", 0, _scrapSize],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",-2,true]; //V2 - doesn't work //V1 LM - works DS - doesn't work
				}];
			};
	}];

