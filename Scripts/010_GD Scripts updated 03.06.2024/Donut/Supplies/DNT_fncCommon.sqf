/* DNT_initSupplies
* Initializes supply system
*/
DNT_initSupplies = { 

	diag_log "DNT_fncCommon.sqf executed DNT_initSupplies";
	
	if(hasInterface) then {
		call DNT_onResDepletionChange;
	};

	{	
		[_x] spawn DNT_createSupply;
		
		if(_x isKindOf "LandVehicle" || _x isKindOf "Air" || _x isKindOf "Ship") then {
		
			[_x] call DNT_setVicCargoSize;
			
			if(!alive _x) then {
			
				[_x] spawn DNT_createScrap;
			};
		};
		
	} forEach entities [[],[],true,false]; 
	
};

DNT_swapDatabases = {

	params ["_advisorUnit"];
	
	private _actionText = "";
	
		if(dnt_supplySystemActive == true) then {
			_actionText = "<t color='#FF0000'>Disable supply system</t>";
		} else {
			_actionText = "<t color='#00FF00'>Enable supply system</t>";
		};
	
	private _idToggle = _advisorUnit addAction [_actionText, {
		
		params ["_target", "_caller", "_actionId"];
		
		if(dnt_supplySystemActive == true) then {
			_target setUserActionText [_actionId,"<t color='#00FF00'>Enable supply system</t>"];
			dnt_supplySystemActive = false;
			publicVariable "dnt_supplySystemActive";
		} else {
			_target setUserActionText [_actionId,"<t color='#FF0000'>Disable supply system</t>"];
			dnt_supplySystemActive = true;
			publicVariable "dnt_supplySystemActive";
		};
	},[],1.5,true,true,"","!isNull (getAssignedCuratorLogic _this)",10,false,"",""];
	
	private _idRemove = _advisorUnit addAction ["Dismiss toggle action", {
		
		params ["_target", "_caller", "_actionId"];
		
		private _idToggle = _this select 3 select 0;
		private _advisorUnit = _this select 3 select 1;
		
		_advisorUnit removeAction _idToggle;
		_advisorUnit removeAction _actionId;
		
		hint "Option to toggle supply system will be available again after respawn";
			
		
	},[_idToggle, _advisorUnit],1.5,true,true,"","!isNull (getAssignedCuratorLogic _this)",10,false,"",""];

};


/*DNT_clientWriteToDb
*	Used to pass writing values from client to server
*
*/
DNT_clientWriteToDb = {

	params ["_type", "_resource"];
	
	 [_type, _resource] remoteExec ["DNT_writeToDb", 2];

};

/* DNT_registerSupplies
* Creates mission variables to keep track of created supplies 
*	Params:
*	_target - object to register
*	_resource - quantity or claimed resources (int) or type of vehicle (char - refer to DNT_vehicleDictionary)
*	_type - type of supply
*	_actionId - id of action that will be removed on killed, stored in missionNamespace variable
*
*	Returns taskID used to create supply related tasks
*
*	Notes:
*	prefixes explained
*	"dntusp" - supply prefix if type unknown
*	"dntsp" - prefix for supplies that can be stored in supply depot eg. ammo, meds, scrap
*	"dntv" - prefix for vehicles
*	"dntask" - prefix for generated tasknames
*
*/
DNT_registerSupplies = {

	params["_target", "_resource", "_type", "_actionId"];
	
	private _resourceVName = "dntsp_"+_type+(str dnt_supplyTaskID);
	private _taskID = "dntask_"+_type+(str dnt_supplyTaskID);
	
	dnt_supplyTaskID = dnt_supplyTaskID + 1;
	publicVariable "dnt_supplyTaskID";
		
	missionNamespace setVariable [_resourceVName, [_target, _resource, _type, _taskID, _actionId], true];
	
	private _regData = [_taskID, _resourceVName];
	
	_regData

};


/* DNT_storeSupplies
* Handles storing supplies and adding them to the supply pool. 
*/
DNT_storeSupplies = {

	params["_thisTrigger"];
	
	private _variableList = (allVariables missionNameSpace) select {_x regexMatch ".*dntsp_.*"};
	
	{
	
		private _supplyObjectVariable = missionNamespace getVariable _x;
		private _objectVar = _supplyObjectVariable select 0;
	
		if(_objectVar inArea _thisTrigger) then {
		
			private _arrayAccessScope = missionNamespace getVariable _x;
			private _supplyObject = _arrayAccessScope select 0;
			private _quantity =  _arrayAccessScope select 1;
			private _type = _arrayAccessScope select 2;
			private _taskID = _arrayAccessScope select 3;
			
			switch(_type) do    
				{   
					case "ammo":{
						["ammo",_quantity] call DNT_clientWriteToDb;

					};   
					case "meds":{
						["meds",_quantity] call DNT_clientWriteToDb;

					};
					case "scrap":{
						["scrap",_quantity] call DNT_clientWriteToDb;

					};
					default {};					
			  
				}; 
				
			deleteVehicle _supplyObject;
			 
			[_taskID, "SUCCEEDED", true] call ENGTASKS_SetTaskState;
			[_taskID] call ENGTASKS_DeleteTask;
			
			remoteExec["DNT_updateSupplyTrackerTasks",2];
			
		};
	
	} forEach _variableList;

};


/* DNT_removeSupplies
*	Script checks for supplies that were destroyed before delivery and removes them from missionNamespace and related tasks
*/
DNT_removeSupplies = {
									
	{
	
		private _objectVariable = missionNamespace getVariable _x;
		private _supplyObject = _objectVariable select 0;
		private _objectMission = _objectVariable select 3;
		private _missionState = [_objectMission] call ENGTASKS_GetTaskState;
		if((!alive _supplyObject && _missionState != "SUCCEDED") || (isNil "_supplyObject" && _missionState != "SUCCEDED")) then {
			
			 
			[_objectMission] call ENGTASKS_DeleteTask;
			[_supplyObject] call DNT_removeRegObject;
		
		};
	
	} forEach ((allVariables missionNamespace) select {_x regexMatch ".*dntsp_.*"});

};


DNT_removeRegObject = {

	params ["_target"];
	
	private _removeIndex = dnt_regSupplies find _target;
	if(_removeIndex != -1) then {
		dnt_regSupplies deleteAt _removeIndex;
		publicVariable "dnt_regSupplies";
		
	};
};



/* DNT_evaluateVehicle
*	Determines how much a salvage yield and how much time it takes to salvage an object, also provides cargo size of vehicle 
*
*	Params
*	_object - object to be evaluated
*	
*	Returns
*	Array - scrap value/cargo size, salvaging time
*/
DNT_evaluateVehicle = {

	params ["_object"];
	
	private _tinyCargoSize = ["3AS_Barc_212", "3AS_Barc_501", "3AS_Barc", "3AS_BarcSideCar_212", "3AS_BarcSideCar_501", "3AS_BarcSideCar", "OPTRE_M274_ATV", "OPTRE_M274_ATV_Ins", "lsd_ground_lancerBike", "ls_ground_barc", "lsd_car_ast", "lsd_civ_lancerBike", "3AS_AV7", "3AS_Advanced_DSD", "3AS_LAATC", "3AS_LAATC_Wampa", "lsd_heli_laatc", "OPTRE_AV22C_Sparrowhawk", "OPTRE_AV22A_Sparrowhawk", "OPTRE_AV22_Sparrowhawk", "OPTRE_AV22B_Sparrowhawk", "3AS_Z95_Republic", "3AS_Z95_Blue", "3AS_Z95_Green", "3AS_Z95_Orange"];
	private _smallCargoSize = ["lsd_ground_agtRaptor","3AS_ISP", "OPTRE_M12_LRV", "OPTRE_M12A1_LRV", "OPTRE_M12G1_LRV", "OPTRE_M12R_AA", "OPTRE_M813_TT", "OPTRE_m1087_stallion_device_unsc", "OPTRE_m1087_stallion_unsc_refuel", "OPTRE_m1015_mule_fuel_ins", "OPTRE_M12_LRV_ins", "OPTRE_M12_TD_ins", "OPTRE_M12_VBIED_Big", "OPTRE_M12A1_LRV_ins", "OPTRE_M12R_AA_ins", "OPTRE_Genet_IND", "OPTRE_M12_CIV2_IND", "OPTRE_M12_LRV_PD", "OPTRE_M12_LRV_DME", "OPTRE_m1015_mule_fuel_ins_IND", "OPTRE_M12_LRV_ins_IND", "OPTRE_M12_TD_ins_IND", "OPTRE_M12A1_LRV_ins_IND", "OPTRE_M12R_AA_ins_IND", "OPTRE_Genet", "OPTRE_M12_CIV2", "3AS_SandSpeeder", "3AS_SnowSpeeder", "3AS_Snowspeeder_Blue", "3AS_Snowspeeder_Rogue", "3AS_Hailfire_SAM", "3AS_Hailfire_Rocket", "3AS_Hailfire_AT", "3AS_N99", "3AS_SAC_Trade", "3AS_Patrol_LAAT_Imperial", "3AS_Patrol_LAAT_Police", "3AS_Patrol_LAAT_Republic", "ls_heli_laatle", "ls_heli_laatle_policeGunship", "ls_heli_laatle_transportGunship", "OPTRE_UNSC_hornet", "OPTRE_UNSC_hornet_CAP", "OPTRE_UNSC_hornet_CAS", "OPTRE_UNSC_falcon_armed", "OPTRE_UNSC_falcon", "OPTRE_UNSC_falcon_armed_S", "OPTRE_UNSC_falcon_S", "OPTRE_UNSC_hornet_ins", "OPTRE_ins_falcon", "OPTRE_ins_falcon_unarmed", "OPTRE_UNSC_falcon_armed_S_ins", "OPTRE_UNSC_falcon_S_ins", "OPTRE_CMA_hornet", "OPTRE_CMA_falcon", "OPTRE_CMA_falcon_unarmed", "OPTRE_UNSC_falcon_PD", "OPTRE_DME_hornet", "OPTRE_DME_falcon_armed", "OPTRE_DME_falcon_unarmed", "OPTRE_UNSC_hornet_ins_IND", "OPTRE_ins_falcon_IND", "OPTRE_ins_falcon_unarmed_IND", "3AS_VWing_Imperial", "3AS_ARC_170_Blue", "3AS_ARC_170_Green", "3AS_ARC_170_Orange", "3AS_ARC_170_Red", "3AS_ARC_170_Yellow", "3AS_BTLB_Bomber", "3AS_BTLB_Bomber_RedLeader", "3AS_BTLB_Bomber_ShadowLeader", "3AS_BTLB_Bomber_Shadow", "3AS_Delta7_F", "3AS_Delta7_TANO", "3AS_Delta7_ANI", "3AS_Delta7_Blue", "3AS_Delta7_Green", "3AS_Delta7_Orange", "3AS_Delta7_PLO", "3AS_Delta7_Purple", "3as_Vwing_base", "OPTRE_EscapePod", "OPTRE_YSS_1000_A", "OPTRE_YSS_1000_A_VTOL"];
	private _mediumCargoSize = ["3AS_Rho_Crate_REP_Barracks", "3AS_Rho_Crate_REP_Medical", "3AS_Rho_Crate_REP_Transport","3AS_ISP_Transport", "OPTRE_M12_FAV_APC", "OPTRE_M12_FAV_APC_MED", "OPTRE_M12_FAV", "OPTRE_M914_RV", "OPTRE_M12_ins_APC", "OPTRE_M12_ins_MED", "OPTRE_M12_VBIED", "OPTRE_M12_FAV_ins", "OPTRE_M914_RV_ins", "OPTRE_M12_CIV_IND", "OPTRE_M12_FAV_APC_PD", "OPTRE_M12_FAV_PD", "OPTRE_DME_M12_FAV", "OPTRE_M12_ins_APC_IND", "OPTRE_M12_ins_MED_IND", "OPTRE_M12_FAV_ins_IND", "OPTRE_M914_RV_ins_IND", "OPTRE_M12_CIV", "OPTRE_M411_APC_UNSC", "OPTRE_M412_IFV_UNSC", "OPTRE_M413_MGS_UNSC", "OPTRE_M412_IFV_INS", "OPTRE_M413_MGS_INS", "lsd_air_v19", "GD_LAAT_Airborne", "GD_LAAT_Gunship", "GD_LAAT_MedEvac", "GD_TX130", "3AS_Saber_M1_Imperial", "3AS_Saber_M1Recon_Imperial", "3AS_Saber_Super_Imperial", "3AS_Saber_M1G_Imperial", "3AS_Saber_M1", "3AS_Saber_M1_501", "3AS_Saber_M1Recon", "3AS_Saber_M1Recon_501", "3AS_Saber_Super", "3AS_Saber_Super_501", "3AS_Saber_M1G", "3AS_Saber_M1G_501", "115th_TX130", "796th_TX130", "985th_TX130", "Shadow_TX130", "SWLG_tanks_tx130", "OPTRE_M808B_UNSC", "OPTRE_M808BM_UNSC", "OPTRE_M808L", "OPTRE_M808S", "OPTRE_M850_UNSC", "3AS_AAT", "3AS_AAT_Aqua", "3AS_AAT_Arid", "3AS_AAT_CIS", "3AS_AAT_Desert", "3AS_AAT_Geonosis", "3AS_AAT_Green", "3AS_AAT_tan", "3AS_AAT_Tropical", "3AS_AAT_Winter", "3AS_AAT_Woodland", "3AS_GAT", "3AS_GAT_Olive", "3AS_GAT_Light", "3AS_GAT_Light_Olive", "3AS_HAGM_Tan", "3AS_HAGM_CIS", "3AS_AAT_Red", "OPTRE_M808B_INS", "OPTRE_M808B_INS_IND", "3AS_LAAT_Mk1_Imperial", "3AS_LAAT_Mk1Lights_Imperial", "3AS_LAAT_Mk2_Imperial", "3AS_LAAT_Mk2Lights_Imperial", "3AS_LAAT_Mk1", "3AS_LAAT_Mk1Lights", "3AS_LAAT_Mk2", "3AS_LAAT_Mk2Lights", "lsd_heli_laati_ab", "lsd_heli_laati", "lsd_heli_laati_medevac", "lsd_heli_laati_transport", "OPTRE_Pelican_unarmed", "OPTRE_Pelican_unarmed_SOCOM", "OPTRE_Pelican_armed", "OPTRE_Pelican_armed_70mm", "OPTRE_Pelican_armed_SOCOM", "3AS_HMP_Transport", "3AS_HMP_Gunship", "ls_cis_hmp", "ls_cis_hmp_transport", "OPTRE_Pelican_unarmed_ins", "OPTRE_Pelican_armed_ins", "OPTRE_Pelican_armed_70mm_ins", "OPTRE_Pelican_armed_CMA", "OPTRE_Pelican_unarmed_PD", "OPTRE_Pelican_unarmed_ins_IND", "OPTRE_Pelican_armed_ins_IND", "3as_V19_base"];
	private _largeCargoSize = ["3AS_Rho_REP_F", "3AS_Rho_REP_Medical","3AS_ITT","OPTRE_m1087_stallion_unsc_resupply", "OPTRE_m1087_stallion_cover_unsc", "OPTRE_m1087_stallion_unsc_medical", "OPTRE_m1087_stallion_unsc_repair", "OPTRE_m1015_mule_ins", "OPTRE_m1015_mule_ammo_ins", "OPTRE_m1015_mule_cover_ins", "OPTRE_m1015_mule_medical_ins", "OPTRE_m1015_mule_ins_IND", "OPTRE_m1015_mule_ammo_ins_IND", "OPTRE_m1015_mule_cover_ins_IND", "OPTRE_m1015_mule_medical_ins_IND", "3AS_ITT_Logistic", "3AS_ITT_Medical", "3AS_RTT", "3AS_RTT_Wheeled", "3AS_ATTE_Base", "3AS_ATTE_Ryloth", "3AS_ATTE_TCW", "3AS_ATAP_Base", "3AS_ATTE_Imperial"];
	private _gargantuanCargoSize = ["3as_Jug", "3AS_ATAT", "3AS_UTAT", "OPTRE_M313_UNSC", "3AS_MTT", "3AS_Nuclass", "3AS_Rho_REP_F","3AS_Rho_REP_Medical","lsd_largeVTOL_cisDropship", "lsd_largeVTOL_federationDropship_base", "3AS_Imperial_Transport_01", "3AS_Republic_Transport_01", "3AS_Civilian_Transport_01", "3AS_Civilian_Transport_03", "3AS_Civilian_Transport_02"];
	
	private _sizeXS = 2;
	private _sizeS = 5;
	private _sizeM = 25;
	private _sizeL = 50;
	private _sizeXL = 1000;
	
	private _timeXS = 10;
	private _timeS = 15;
	private _timeM = 20;
	private _timeL = 30;
	private _timeXL = 40;
	
	private _objectType = typeOf _object;
	private _vicParams = [];
	
	switch (true) do {
		
		case (_objectType in _tinyCargoSize):{_vicParams = [_sizeXS, _timeXS]};
		case (_objectType in _smallCargoSize):{_vicParams = [_sizeS, _timeS]};
		case (_objectType in _mediumCargoSize):{_vicParams = [_sizeM, _timeM]};
		case (_objectType in _largeCargoSize):{_vicParams = [_sizeL, _timeL]};
		case (_objectType in _gargantuanCargoSize):{_vicParams = [_sizeXL, _timeXL]};
		
		default {
		
			_vicParams = [5, 15];
			
			};
		
	};
	
	_vicParams;

};
	
DNT_vehicleDictionary = {

	params ["_target"];
	
	private _vicType = "";
	
	switch (true) do {
	
		case (typeName _target == "OBJECT"): {_vicType = (getText (configFile >> "cfgVehicles" >> typeOf _target >> "displayName"));};
		case (typeName _target == "STRING"): {_vicType = (getText (configFile >> "cfgVehicles" >> _target >> "displayName"));};
	};
	
	switch (true) do {
	
		case (_vicType regexMatch ".*TX-130.*"): {_vicType = "Sabre tank";};
		case (_vicType regexMatch ".*RTT.*"): {_vicType = "RTT";};
		case (_vicType regexMatch ".*Delta.*"): {_vicType = "Delta Starfighter";};
		case (_vicType regexMatch ".*T-47.*"): {_vicType = "Snowspeeder";};
		case (_vicType regexMatch ".*BTL-Y.*"): {_vicType = "Y-Wing";};
		case (_vicType regexMatch ".*ARC-170.*"): {_vicType = "ARC-170";};
		case (_vicType regexMatch ".*LAAT\/LE.*"): {_vicType = "Police LAAT";};
		case (_vicType regexMatch ".*LAAT\/c.*"): {_vicType = "LAAT C";};
		case (_vicType regexMatch ".*LAAT\/i.*"): {_vicType = "LAAT I";};
		case (_vicType regexMatch ".*Swamp.*"): {_vicType = "Swamp speeder";};
		case (_vicType regexMatch ".*BARC.*"): {_vicType = "Speeder";};
		case (_vicType regexMatch ".*105-K.*"): {_vicType = "Speeder";};
		case (_vicType regexMatch ".*AV-7.*"): {_vicType = "GAR AV-7 Artillery";};
		case (_vicType regexMatch ".*V19.*"): {_vicType = "V-Wing";};
		case (_vicType regexMatch ".*Z-95.*"): {_vicType = "Z-95 HeadHunter";};
		case (_vicType regexMatch ".*ITT.*"): {_vicType = "ITT";};
		case (_vicType regexMatch ".*AT-TE.*"): {_vicType = "ATTE";};
		case (_vicType regexMatch ".*ATAP.*"): {_vicType = "ATAP";};
		case (_vicType regexMatch ".*Civilian Transport.*"): {_vicType = "Transport ship";};
		case (_vicType regexMatch ".*Republic Transport.*"): {_vicType = "Transport ship";};
		case (_vicType regexMatch ".*AT-AT.*"): {_vicType = "AT-AT";};
		case (_vicType regexMatch ".*Juggernaut.*"): {_vicType = "Juggernaut";};
		case (_vicType regexMatch ".*UT-AT.*"): {_vicType = "UT-AT";};
		case (_vicType regexMatch ".*Nu A-Class.*"): {_vicType = "Nu A-Class Shuttle";};
		case (_vicType regexMatch ".*Rho A-Class.*"): {_vicType = "Rho A-Class Shuttle";};
		case (_vicType regexMatch ".*V-19.*"): {_vicType = "V-19 Torrent";};
		case (_vicType regexMatch ".*PX-10.*"): {_vicType = "PX-10";};
		case (_vicType regexMatch ".*Rho Crate.*"): {_vicType = "Rho Crate";};
		
		default{
		
			diag_log format ["DNT_vehicleDictionary ERROR: No match for %1", _vicType];
			_vicType = false;
		
		};
	
	};

	_vicType;
};


/* DNT_setVicCargoSize
* Sets vehicles cargo size based on size category
*
*	Params
*	_vehicle - vehicle for which cargo is set
*
*/
DNT_setVicCargoSize = {

	params ["_vehicle"];
	
	private _vicEvaluation = [_vehicle] call DNT_evaluateVehicle;
	private _cargoSpace = _vicEvaluation select 0;
	[_vehicle, _cargoSpace] call ace_cargo_fnc_setSpace;

};

/* DNT_createSupply, DNT_createMeds, DNT_createScrap
* Creates supply crates on valid objects. Should be called with spawn
*/

DNT_createSupply = {

params ["_supplyObject"];

	private _typeOfObj = typeOf _supplyObject;
	private _ammoBoxes = ["JLTS_Ammobox_ammo_GAR", "JLTS_Ammobox_weapons_GAR", "JLTS_Ammobox_explosives_GAR", "JLTS_Ammobox_grenades_GAR", "JLTS_Ammobox_launchers_GAR", "JLTS_Ammobox_weapons_special_GAR", "JLTS_Ammobox_support_GAR", "JLTS_Ammobox_ammo_CIS", "JLTS_Ammobox_weapons_CIS", "JLTS_Ammobox_launchers_CIS", "JLTS_Ammobox_weapons_special_CIS", "JLTS_Ammobox_support_CIS"];
	private _medsBoxes = ["3AS_Supply_Large_Medical_Prop"];
	private _claimableVic = ["3AS_Rho_Crate_REP_Barracks", "3AS_Rho_Crate_REP_Medical", "3AS_Rho_Crate_REP_Transport","3AS_Rho_REP_F", "3AS_Rho_REP_Medical","lsd_heli_laatc", "3AS_LAATC", "3AS_Barc_212", "3AS_Barc_501", "3AS_Barc", "3AS_BarcSideCar_212", "3AS_BarcSideCar_501", "3AS_BarcSideCar", "lsd_ground_lancerBike", "ls_ground_barc", "lsd_civ_lancerBike", "3AS_LAATC_Wampa", "3AS_Z95_Orange", "3AS_Z95_Green", "3AS_Z95_Republic", "3AS_Z95_Blue", "3AS_AV7", "3AS_BTLB_Bomber", "3AS_BTLB_Bomber_Shadow", "3AS_BTLB_Bomber_RedLeader", "3AS_BTLB_Bomber_ShadowLeader", "3AS_ARC_170_Red", "3AS_ARC_170_Blue", "3AS_ARC_170_Yellow", "3AS_ARC_170_Orange", "3AS_ARC_170_Green", "3AS_Delta7_Green", "3AS_Delta7_Blue", "3AS_Delta7_TANO", "3AS_Delta7_F", "3AS_Delta7_ANI", "3AS_Delta7_Orange", "3as_Vwing_base", "3AS_VWing_Imperial", "3AS_Snowspeeder_Rogue", "3AS_Snowspeeder_Blue", "3AS_SandSpeeder", "3AS_SnowSpeeder", "ls_heli_laatle", "ls_heli_laatle_policeGunship", "ls_heli_laatle_transportGunship", "3AS_Delta7_PLO", "3AS_Delta7_Purple", "3AS_ISP", "3AS_Patrol_LAAT_Imperial", "3AS_Patrol_LAAT_Republic", "3AS_Patrol_LAAT_Police", "3AS_ISP_Transport", "3AS_Saber_M1_Imperial", "3AS_Saber_M1G_Imperial", "3AS_Saber_M1G", "3AS_Saber_M1G_501", "796th_TX130", "115th_TX130", "985th_TX130", "SWLG_tanks_tx130", "Shadow_TX130", "GD_TX130", "3AS_Saber_M1Recon_Imperial", "3AS_Saber_Super_Imperial", "3as_V19_base", "lsd_air_v19", "GD_LAAT_Airborne", "GD_LAAT_Gunship", "3AS_LAAT_Mk2", "3AS_LAAT_Mk2Lights", "3AS_LAAT_Mk1Lights", "GD_LAAT_MedEvac", "3AS_LAAT_Mk1_Imperial", "3AS_LAAT_Mk1", "lsd_heli_laati_transport", "3AS_LAAT_Mk1Lights_Imperial", "lsd_heli_laati_medevac", "lsd_heli_laati", "lsd_heli_laati_ab", "3AS_LAAT_Mk2Lights_Imperial", "3AS_LAAT_Mk2_Imperial", "3AS_Saber_Super_501", "3AS_Saber_Super", "3AS_Saber_M1Recon_501", "3AS_Saber_M1Recon", "3AS_Saber_M1_501", "3AS_Saber_M1", "3AS_ITT", "3AS_ITT_Logistic", "3AS_ITT_Medical", "3AS_RTT", "3AS_RTT_Wheeled", "3AS_ATTE_Ryloth", "3AS_ATTE_Base", "3AS_ATTE_TCW", "3AS_ATAP_Base", "3AS_ATTE_Imperial", "3AS_Civilian_Transport_02", "3AS_Civilian_Transport_03", "3AS_Civilian_Transport_01", "3AS_Republic_Transport_01", "3AS_Imperial_Transport_01", "3AS_Nuclass", "3as_Jug", "3AS_UTAT", "3AS_ATAT","3AS_PX10_REP_F", "3AS_PX10_REP_R3", "3AS_PX10_REP_UP"];
	private _isAlive = alive _supplyObject;
	private _isRegistered = _supplyObject in dnt_regSupplies;
	private _isSalvageble = false;
	
	private _isValidSupply = false;
	private _actionText = "";
	private _supType = "";
	
	switch (true) do {
	
		case (_typeOfObj in _ammoBoxes): {
			
			_isValidSupply = true;
			_actionText = "Search for ammunition";
			_supType = "ammo";
			
		};
		case (_typeOfObj in _medsBoxes): {
		
			_isValidSupply = true;
			_actionText = "Search for medical supplies";
			_supType = "meds";
			
		};
		case (_typeOfObj in _claimableVic): {
		
			_isValidSupply = true;
			_actionText = "Claim the vehicle";
			_supType = "vehicle";
			_isSalvageble = true;
			
		};
		
		default {
		
			_isValidSupply = false;
			
			if(_supplyObject in vehicles) then {
			
				_isSalvageble = true;
			};
		
		};
	};
	
	

	[_supplyObject, _isSalvageble] remoteExec ["DNT_onSupplyLost",2];
	
	if(_isAlive == true && _isRegistered == false && _isValidSupply == true) then {
	
		_supplyObject addAction [_actionText,{
			
			params ["_target", "_caller", "_actionId"];
				
			private _supType = _this select 3 select 0;
				
				clearItemCargo _target;
					
				switch (_supType) do {
					
					case "ammo": {
						[_caller, _target, 3, "searchCrate"] spawn DNT_searchAnimation;
						uiSleep 3;
						private _rollD20 = floor(random 20);
						[_target,_actionId]remoteExec ["removeAction",-2,true];
							
						if(_rollD20 >= 10) then {
						
								private _amount = 5 + (5 * (_rollD20 - 10));
								hint parseText format["You have found <t color='#FF8000'> %1 </t> units of ammunition!", _amount];
								private _regData = [_target, _amount, "ammo", _actionId] call DNT_registerSupplies;
								private _taskID = _regData select 0;
								[_taskID, (format ["Deliver %1 units of ammunition to the Haunter",_amount])] call ENGTASKS_CreateTask; 
								
								dnt_regSupplies pushBack _target;
								publicVariable "dnt_regSupplies"; 
								
							} 
							else {
								hint "You find nothing";
								_target setDamage 1;
							};
						};
						
						case "meds": {
						
							[_caller, _target, 3, "searchCrate"] spawn DNT_searchAnimation;
							uiSleep 3;
							private _rollD20 = floor(random 20);
							[_target,_actionId]remoteExec ["removeAction",-2,true];
							
							if(_rollD20 >= 10) then {
							
								private _amount = 2 + (2 * (_rollD20 - 10));
								hint parseText format["You have found <t color='#FF8000'> %1 </t> units of medical supplies!", _amount];
								private _regData = [_target, _amount, "meds", _actionId] call DNT_registerSupplies;
								private _taskID = _regData select 0;
								[_taskID, (format ["Deliver %1 units of medical supplies to the Haunter",_amount])] call ENGTASKS_CreateTask; 
													
								dnt_regSupplies pushBack _target;
								publicVariable "dnt_regSupplies"; 

							} 
							else {
								hint "You find nothing";
								_target setDamage 1;
							};
						};
						
						case "vehicle": {
						
							if({alive _x} count crew _target == 0) then {
											
								[_target,_actionId]remoteExec ["removeAction",-2,true];
								
								dnt_deployedVehicles pushBack _target;
								publicVariable "dnt_deployedVehicles";
								
								private _vehicleKind = [_target] call DNT_vehicleDictionary;
				
								hint parseText format["You have claimed <t color='#FF8000'> %1 </t>!", _vehicleKind];
								private _regData = [_target, _vehicleKind, "vehicle", _actionId] call DNT_registerSupplies;
								private _taskID = _regData select 0;
								[_taskID, (format ["Claimed %1 id: %2", _vehicleKind, _taskID])] call ENGTASKS_CreateTask;
								
								dnt_regSupplies pushBack _target;
								publicVariable "dnt_regSupplies"; 
																			
							} else {
							
								hint "You can't claim an occupied vehicle!";
							
							};
						};
					};


			},[_supType],6,true,true,"","true", 10,false,"",""];
		
	};
	
};

DNT_createScrap = {

	params ["_supplyObject"];
	
	private _isRegistered = _supplyObject in dnt_regSupplies; 
	
	if(_isRegistered == false) then {
	
		_supplyObject addAction ["Salvage for scrap",{
		
			params ["_target", "_caller", "_actionId"];
			
			if({alive _x} count crew _target == 0) then {
			
				if(([_caller, 1] call ace_repair_fnc_isEngineer) == true) then {
				
					[_target,_actionId]remoteExec ["removeAction",-2, true];
					clearItemCargo _target;
					
					private _salvageParameters = [_target] call DNT_evaluateVehicle;
					private _salvageYield = _salvageParameters select 0;
					private _salvageTime = _salvageParameters select 1;
					
					private _rollD20 = floor(random 20);
					
					if(_rollD20 >= 10) then {
					
						[_caller, _target, _salvageTime, "salvageWreck"] spawn DNT_salvageAnimation;
						uiSleep _salvageTime - 3;
						[_target] call DNT_removeRegObject;
						deleteVehicle _target;
						
						private _scrapPos = getPosATL _target;
						private _scrapCrate = createVehicle["3AS_Supply_Large_Blue_Prop", (_scrapPos vectorAdd [0,0,0.2]), [], 0, "CAN_COLLIDE"];
						_scrapCrate allowDamage false;
	
						uiSleep 3;
						
						_scrapCrate allowDamage true;
						
						private _amount = _salvageYield + (_salvageYield * (_rollD20 - 10));
						hint parseText format["You have found <t color='#FF8000'> %1 </t> units of scrap!", _amount];
						private _regData = [_scrapCrate, _amount, "scrap", _actionId] call DNT_registerSupplies;
						private _taskID = _regData select 0;
						[_taskID, (format ["Deliver %1 units of scrap to the Haunter",_amount])] call ENGTASKS_CreateTask; 
						
						dnt_regSupplies pushBack _target;
						publicVariable "dnt_regSupplies"; 
						
						[_target, false] call DNT_onSupplyLost;
					} 
					else {
						[_caller, _target, 2, ""] spawn DNT_salvageAnimation;
						uiSleep 2;
						hint "There is nothing useful to salvage!";
						[_target,_actionId]remoteExec ["removeAction",-2,true];
						
						dnt_regSupplies pushBack _target;
						publicVariable "dnt_regSupplies"; 
					};
					
				}
				else {
					hint "You must be an engineer to scrap for salvage!";
				};
			} else {hint "You can't scrap an occupied vehicle!";};
		
		},[],6,true,true,"","true", 10,false,"",""];
		
	};
};


/*Animation for searching crates for supplies, and function below for salvage. Must be launched via spawn. 
*	Params:
*	_caller - unit that will play animation
*	_target - object on which animation will be played
*	_duration - duration of the animation in seconds
*/
DNT_searchAnimation = {

	params ["_caller", "_target", "_duration", "_sound"];

	_caller enableSimulationGlobal false;
	
	private _animationUnit = group _caller createUnit ["B_RangeMaster_F", (getPosASL _caller vectorAdd [10000000, 10000000, 10000000]), [], 0, "CAN_COLLIDE"];
	
	_animationUnit setUnitFreefallHeight 100000;
	_animationUnit allowDamage false;
	[_animationUnit, true] remoteExec ["hideObjectGlobal",2]; 
	_animationUnit setUnitLoadout (getUnitLoadout _caller);
	_animationUnit disableAI "ANIM";
	_animationUnit disableAI "PATH";
	private _playerPos = getPosASL _caller;
	_caller setPosASL (_playerPos vectorAdd [0.3, 0.3, 0]);
	_animationUnit setPosASL _playerPos;
	
	_animationUnit setVectorDir (vectorDir _caller);
	[_animationUnit, "InBaseMoves_repairVehicleKnl"] remoteExec ["switchMove"];
	[_animationUnit, false] remoteExec ["hideObjectGlobal",2];  
	
	[_caller, true] remoteExec ["hideObjectGlobal",2]; 	
	
	[_target, _sound]remoteExec["say3D"];
	
	_caller switchCamera "External";
	
	[_duration, [], {}, {}, "Searching", {true}, [], true] call ace_common_fnc_progressBar;
	uiSleep _duration;
	
	_caller setPosASL _playerPos;
	
	[_caller, false] remoteExec ["hideObjectGlobal",2];	
	
	deleteVehicle _animationUnit; 
	
	_caller enableSimulationGlobal true;

};

DNT_salvageAnimation = {

	params ["_caller", "_target", "_duration", "_sound"];

	_caller enableSimulationGlobal false;
	
	private _animationUnit = group _caller createUnit ["B_RangeMaster_F", (getPosASL _caller vectorAdd [10000000, 10000000, 10000000]), [], 0, "CAN_COLLIDE"]; 
	
	_animationUnit setUnitFreefallHeight 100000;
	_animationUnit allowDamage false;
	[_animationUnit, true] remoteExec ["hideObjectGlobal",2];
	_animationUnit setUnitLoadout (getUnitLoadout _caller);
	_animationUnit disableAI "ANIM";
	_animationUnit disableAI "PATH";
	private _playerPos = getPosASL _caller;
	_caller setPosASL (_playerPos vectorAdd [0.3, 0.3, 0]);
	_animationUnit setPosASL _playerPos;
	
	_animationUnit setVectorDir (vectorDir _caller);
	[_animationUnit, "InBaseMoves_repairVehicleKnl"] remoteExec ["switchMove"];
	[_animationUnit, false] remoteExec ["hideObjectGlobal",2];
	
	[_caller, true] remoteExec ["hideObjectGlobal",2];  
	
	[_animationUnit, _sound]remoteExec["say3D"];
	
	_caller switchCamera "External";
	
	[_duration, [], {}, {}, "Salvaging", {true}, [], true] call ace_common_fnc_progressBar;
	
	uiSleep _duration;
	
	_caller setPosASL _playerPos;
	
	[_caller, false] remoteExec ["hideObjectGlobal",2];  
	
	deleteVehicle _animationUnit; 
	_caller enableSimulationGlobal true;

};

DNT_manageHaunterArsenals = {

	params ["_container", "_isFullArsenal"];
	
	if(_isFullArsenal == true) then {
	
		_container addAction ["Open full ACE Arsenal", {
			
			params ["_target", "_caller", "_actionId"];
			
			[_target, _caller, true] call ace_arsenal_fnc_openBox;
		
		}];
	
	} else {
	
		_container addAction ["Open GD armoury", {
		
			params ["_target", "_caller", "_actionId"];
			
			[_target, _caller, false] call ace_arsenal_fnc_openBox;
		
		}];
		
		private _defaultWhiteList = getArray (missionConfigFile >> "arsenalList" >> "whiteList");
			
		[_container, _defaultWhiteList] call ace_arsenal_fnc_addVirtualItems;
	};
};

DNT_scrapFabricator = {

	params ["_terminal"];
	
	_terminal addAction ["Login to scrap fabricator...",{
	
		params ["_target", "_caller", "_actionId"];
		
		remoteExec["DNT_updateSupplyTrackerTasks",2];
		
		if(([_caller, 1] call ace_repair_fnc_isEngineer) == true) then {
		
			_target removeAction _actionId;
			
			private _scrapToAmmo = 100;
			private _scrapToMeds = 100;
			
			_target addAction [format["Turn %1 units of scrap into 10 units of ammo",_scrapToAmmo],{
				
				params ["_target", "_caller", "_actionId"];
				
				private _scrapToAmmo = _this select 3 select 0;
				
				[_target, "ls_lighting_activationRepublic"]remoteExec["say3D"];
				
				uiSleep 1;
				
				if(dnt_scrapCount >= _scrapToAmmo) then {
			
					[5, [], {}, {}, "Ammo fabrication in progress...", {true}, [], true] call ace_common_fnc_progressBar;
					
					[_target, "ls_hologram_activation"]remoteExec["say3D"];
					
					uiSleep 2;
					
					["ammo", 10] call DNT_clientWriteToDb;
					
					uiSleep 1;
					
					remoteExec["DNT_updateSupplyTrackerTasks",2];
					
					uiSleep 1;
					
					["scrap", -100] call DNT_clientWriteToDb;
					
					uiSleep 1;
					
					remoteExec["DNT_updateSupplyTrackerTasks",2];
				
				} else { 
				
					hint "Insufficient scrap";
				
				};
			
			},[_scrapToAmmo],1.5,true,true,"","true",10,false,"",""];
			
			_target addAction [format["Turn %1 units of scrap into 1 unit of meds",_scrapToMeds],{
				
				params ["_target", "_caller", "_actionId"];
				
				private _scrapToMeds = _this select 3 select 0;
				
				uiSleep 1;
				
				if(dnt_scrapCount >= _scrapToMeds) then {
			
					[5, [], {}, {}, "Meds fabrication in progress...", {true}, [], true] call ace_common_fnc_progressBar;
					
					[_target, "ls_hologram_activation"]remoteExec["say3D"];
					
					uiSleep 2;
				
					["meds", 1] call DNT_clientWriteToDb;
					
					uiSleep 1;
					
					remoteExec["DNT_updateSupplyTrackerTasks",2];
					
					uiSleep 1;
					
					["scrap", -100] call DNT_clientWriteToDb;
					
					uiSleep 1;
					
					remoteExec["DNT_updateSupplyTrackerTasks",2];

				} else { 
				
					hint "Insufficient scrap";
				
				};
			
			},[_scrapToMeds],1.5,true,true,"","true",10,false,"",""];
			
			_target addAction ["<t color='#FF0000'>Cancel operation</t>",{
								
				params ["_target", "_caller", "_actionId"];
				
				removeAllActions _target;
				[_target] spawn DNT_scrapFabricator;	
								
			},[],1.5,true,true,"","true",10,false,"",""];
		
		} else {
		
			hint "You need to be an engineer to use scrap fabricator!";
		
		}
	
	},[],1.5,true,true,"","true",10,false,"",""];

};