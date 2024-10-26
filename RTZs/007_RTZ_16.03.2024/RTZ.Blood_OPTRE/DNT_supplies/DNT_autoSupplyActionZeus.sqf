scriptName "DNT_autoSupplyActionZeus";


		{
			if(_x in dnt_registeredSupplyObjects) then {} else {
				private _cargoSpace = dnt_spaceXS;
				private _isVehicle = false;
						
				if(typeOf _x in tinyCargoSize) then {_cargoSpace = dnt_spaceXS;_isVehicle = true;};
				if(typeOf _x in smallCargoSize) then {_cargoSpace = dnt_spaceS;_isVehicle = true;};
				if(typeOf _x in mediumCargoSize) then {_cargoSpace = dnt_spaceM;_isVehicle = true;};
				if(typeOf _x in largeCargoSize) then {_cargoSpace = dnt_spaceL;_isVehicle = true;};
				if(typeOf _x in gargantuanCargoSize) then {_cargoSpace = dnt_spaceXL;_isVehicle = true;};
				
				if(typeOf _x in dnt_ammoContainers) then {[[_x, "ammunition", 0, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",0,true];}; 
				if(typeOf _x in dnt_medicalContainers) then {[[_x, "medicaments", 0, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",0,true];}; 
				
				if(_isVehicle == true) then {
				
					[_x, _cargoSpace] remoteExec ["ace_cargo_fnc_setSpace",0,true];
					
					if(typeOf _x in dnt_claimVic && dnt_autoClaimableVicsOn == 1) then {
						[[_x, "vehicle", 0, 2],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",0,true]; 
					};
					
					_x addMPEventHandler ["MPKilled", {
							params ["_unit", "_killer", "_instigator", "_useEffects"];
							dnt_registeredSupplyObjects deleteAt (dnt_registeredSupplyObjects find _unit);
							publicVariableServer "dnt_registeredSupplyObjects";
							private _scrapSize = dnt_scrapXS;
							if(typeOf _unit in smallCargoSize) then {_scrapSize = dnt_scrapS;};
							if(typeOf _unit in mediumCargoSize) then {_scrapSize = dnt_scrapM;};
							if(typeOf _unit in largeCargoSize) then {_scrapSize = dnt_scrapL;};
							if(typeOf _unit in gargantuanCargoSize) then {_scrapSize = dnt_scrapXL;};
							
							[[_unit, "scrap", 0, _scrapSize],"DNT_supplies\DNT_createSupplies.sqf"] remoteExec ["execVM",0,true]; 
					}];
				};
			};
		}forEach entities [["LandVehicle","Air","ReammoBox_F"],[],false, true];




			



