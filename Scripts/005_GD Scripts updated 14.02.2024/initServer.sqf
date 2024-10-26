/*******Update values below with ones from quartermasters logbook!*******/

dnt_ammoCount = 672; //Update with current amount of ammo from #quartermasters-logbook! channel on discord

dnt_medicalCount = -35; //Update with current amount of medical supplies from #quartermasters-logbook! channel on discord

dnt_scrapCount = 150; //Update with current amount of scrap from #quartermasters-logbook! channel on discord

/*DONT TOUCH ANYTHING BELOW UNLESS YOU KNOW WHAT YOU'RE DOING!*/




/**********AUTOMATIC SCRIPT APPLYING IS NOT WORKING YET, LEAVE VALUES AS 0**************************************/
/*********Edit below only if you don't want supplies and vehicles actions to be applied automaticaly************/

dnt_autoCreateSuppliesOn = 0; //Change to 0 if you want to disable supplies being created automatically on supply containers 

dnt_autoClaimableVicsOn = 0; //Change to 0 if you want to disable vehicles being available for claim automatically



//Declaring global variables for supply system

publicVariable "dnt_ammoCount";
publicVariable "dnt_medicalCount";
publicVariable "dnt_scrapCount";
publicVariable "dnt_autoCrateSuppliesOn";
publicVariable "dnt_autoClaimableVicsOn";

//1 - auto assigning cargo space will be on, 0 - off

dnt_autoCargoOn = 1;
publicVariable "dnt_autoCargoOn";

//Variables for supplyTaskID
dnt_supplyTaskID = 0;
publicVariable "dnt_supplyTaskID";
dnt_supplyList = [];
publicVariable  "dnt_supplyList";

dnt_medicalItemsUsed = 0;
publicVariable "dnt_medicalItemsUsed";

dnt_VehicleList = [];
publicVariable "dnt_VehicleList";


//CargoSizes and spaces for different vehicles
tinyCargoSize = ["3AS_Barc_212", "3AS_Barc_501", "3AS_Barc", "3AS_BarcSideCar_212", "3AS_BarcSideCar_501", "3AS_BarcSideCar", "OPTRE_M274_ATV", "OPTRE_M274_ATV_Ins", "lsd_ground_lancerBike", "ls_ground_barc", "lsd_car_ast", "lsd_civ_lancerBike", "3AS_AV7", "3AS_Advanced_DSD", "3AS_LAATC", "3AS_LAATC_Wampa", "lsd_heli_laatc", "OPTRE_AV22C_Sparrowhawk", "OPTRE_AV22A_Sparrowhawk", "OPTRE_AV22_Sparrowhawk", "OPTRE_AV22B_Sparrowhawk", "3AS_Z95_Republic", "3AS_Z95_Blue", "3AS_Z95_Green", "3AS_Z95_Orange"];
publicVariable "tinyCargoSize";

smallCargoSize = ["lsd_ground_agtRaptor","3AS_ISP", "OPTRE_M12_LRV", "OPTRE_M12A1_LRV", "OPTRE_M12G1_LRV", "OPTRE_M12R_AA", "OPTRE_M813_TT", "OPTRE_m1087_stallion_device_unsc", "OPTRE_m1087_stallion_unsc_refuel", "OPTRE_m1015_mule_fuel_ins", "OPTRE_M12_LRV_ins", "OPTRE_M12_TD_ins", "OPTRE_M12_VBIED_Big", "OPTRE_M12A1_LRV_ins", "OPTRE_M12R_AA_ins", "OPTRE_Genet_IND", "OPTRE_M12_CIV2_IND", "OPTRE_M12_LRV_PD", "OPTRE_M12_LRV_DME", "OPTRE_m1015_mule_fuel_ins_IND", "OPTRE_M12_LRV_ins_IND", "OPTRE_M12_TD_ins_IND", "OPTRE_M12A1_LRV_ins_IND", "OPTRE_M12R_AA_ins_IND", "OPTRE_Genet", "OPTRE_M12_CIV2", "3AS_SandSpeeder", "3AS_SnowSpeeder", "3AS_Snowspeeder_Blue", "3AS_Snowspeeder_Rogue", "3AS_Hailfire_SAM", "3AS_Hailfire_Rocket", "3AS_Hailfire_AT", "3AS_N99", "3AS_SAC_Trade", "3AS_Patrol_LAAT_Imperial", "3AS_Patrol_LAAT_Police", "3AS_Patrol_LAAT_Republic", "ls_heli_laatle", "ls_heli_laatle_policeGunship", "ls_heli_laatle_transportGunship", "OPTRE_UNSC_hornet", "OPTRE_UNSC_hornet_CAP", "OPTRE_UNSC_hornet_CAS", "OPTRE_UNSC_falcon_armed", "OPTRE_UNSC_falcon", "OPTRE_UNSC_falcon_armed_S", "OPTRE_UNSC_falcon_S", "OPTRE_UNSC_hornet_ins", "OPTRE_ins_falcon", "OPTRE_ins_falcon_unarmed", "OPTRE_UNSC_falcon_armed_S_ins", "OPTRE_UNSC_falcon_S_ins", "OPTRE_CMA_hornet", "OPTRE_CMA_falcon", "OPTRE_CMA_falcon_unarmed", "OPTRE_UNSC_falcon_PD", "OPTRE_DME_hornet", "OPTRE_DME_falcon_armed", "OPTRE_DME_falcon_unarmed", "OPTRE_UNSC_hornet_ins_IND", "OPTRE_ins_falcon_IND", "OPTRE_ins_falcon_unarmed_IND", "3AS_VWing_Imperial", "3AS_ARC_170_Blue", "3AS_ARC_170_Green", "3AS_ARC_170_Orange", "3AS_ARC_170_Red", "3AS_ARC_170_Yellow", "3AS_BTLB_Bomber", "3AS_BTLB_Bomber_RedLeader", "3AS_BTLB_Bomber_ShadowLeader", "3AS_BTLB_Bomber_Shadow", "3AS_Delta7_F", "3AS_Delta7_TANO", "3AS_Delta7_ANI", "3AS_Delta7_Blue", "3AS_Delta7_Green", "3AS_Delta7_Orange", "3AS_Delta7_PLO", "3AS_Delta7_Purple", "3as_Vwing_base", "OPTRE_EscapePod", "OPTRE_YSS_1000_A", "OPTRE_YSS_1000_A_VTOL"];
publicVariable "smallCargoSize";

mediumCargoSize = ["3AS_ISP_Transport", "OPTRE_M12_FAV_APC", "OPTRE_M12_FAV_APC_MED", "OPTRE_M12_FAV", "OPTRE_M914_RV", "OPTRE_M12_ins_APC", "OPTRE_M12_ins_MED", "OPTRE_M12_VBIED", "OPTRE_M12_FAV_ins", "OPTRE_M914_RV_ins", "OPTRE_M12_CIV_IND", "OPTRE_M12_FAV_APC_PD", "OPTRE_M12_FAV_PD", "OPTRE_DME_M12_FAV", "OPTRE_M12_ins_APC_IND", "OPTRE_M12_ins_MED_IND", "OPTRE_M12_FAV_ins_IND", "OPTRE_M914_RV_ins_IND", "OPTRE_M12_CIV", "OPTRE_M411_APC_UNSC", "OPTRE_M412_IFV_UNSC", "OPTRE_M413_MGS_UNSC", "OPTRE_M412_IFV_INS", "OPTRE_M413_MGS_INS", "lsd_air_v19", "GD_LAAT_Airborne", "GD_LAAT_Gunship", "GD_LAAT_MedEvac", "GD_TX130", "3AS_Saber_M1_Imperial", "3AS_Saber_M1Recon_Imperial", "3AS_Saber_Super_Imperial", "3AS_Saber_M1G_Imperial", "3AS_Saber_M1", "3AS_Saber_M1_501", "3AS_Saber_M1Recon", "3AS_Saber_M1Recon_501", "3AS_Saber_Super", "3AS_Saber_Super_501", "3AS_Saber_M1G", "3AS_Saber_M1G_501", "115th_TX130", "796th_TX130", "985th_TX130", "Shadow_TX130", "SWLG_tanks_tx130", "OPTRE_M808B_UNSC", "OPTRE_M808BM_UNSC", "OPTRE_M808L", "OPTRE_M808S", "OPTRE_M850_UNSC", "3AS_AAT", "3AS_AAT_Aqua", "3AS_AAT_Arid", "3AS_AAT_CIS", "3AS_AAT_Desert", "3AS_AAT_Geonosis", "3AS_AAT_Green", "3AS_AAT_tan", "3AS_AAT_Tropical", "3AS_AAT_Winter", "3AS_AAT_Woodland", "3AS_GAT", "3AS_GAT_Olive", "3AS_GAT_Light", "3AS_GAT_Light_Olive", "3AS_HAGM_Tan", "3AS_HAGM_CIS", "3AS_AAT_Red", "OPTRE_M808B_INS", "OPTRE_M808B_INS_IND", "3AS_LAAT_Mk1_Imperial", "3AS_LAAT_Mk1Lights_Imperial", "3AS_LAAT_Mk2_Imperial", "3AS_LAAT_Mk2Lights_Imperial", "3AS_LAAT_Mk1", "3AS_LAAT_Mk1Lights", "3AS_LAAT_Mk2", "3AS_LAAT_Mk2Lights", "lsd_heli_laati_ab", "lsd_heli_laati", "lsd_heli_laati_medevac", "lsd_heli_laati_transport", "OPTRE_Pelican_unarmed", "OPTRE_Pelican_unarmed_SOCOM", "OPTRE_Pelican_armed", "OPTRE_Pelican_armed_70mm", "OPTRE_Pelican_armed_SOCOM", "3AS_HMP_Transport", "3AS_HMP_Gunship", "ls_cis_hmp", "ls_cis_hmp_transport", "OPTRE_Pelican_unarmed_ins", "OPTRE_Pelican_armed_ins", "OPTRE_Pelican_armed_70mm_ins", "OPTRE_Pelican_armed_CMA", "OPTRE_Pelican_unarmed_PD", "OPTRE_Pelican_unarmed_ins_IND", "OPTRE_Pelican_armed_ins_IND", "3as_V19_base"];
publicVariable "mediumCargoSize";

largeCargoSize = ["3AS_ITT","OPTRE_m1087_stallion_unsc_resupply", "OPTRE_m1087_stallion_cover_unsc", "OPTRE_m1087_stallion_unsc_medical", "OPTRE_m1087_stallion_unsc_repair", "OPTRE_m1015_mule_ins", "OPTRE_m1015_mule_ammo_ins", "OPTRE_m1015_mule_cover_ins", "OPTRE_m1015_mule_medical_ins", "OPTRE_m1015_mule_ins_IND", "OPTRE_m1015_mule_ammo_ins_IND", "OPTRE_m1015_mule_cover_ins_IND", "OPTRE_m1015_mule_medical_ins_IND", "3AS_ITT_Logistic", "3AS_ITT_Medical", "3AS_RTT", "3AS_RTT_Wheeled", "3AS_ATTE_Base", "3AS_ATTE_Ryloth", "3AS_ATTE_TCW", "3AS_ATAP_Base", "3AS_ATTE_Imperial"];
publicVariable "largeCargoSize";

gargantuanCargoSize = ["3as_Jug", "3AS_ATAT", "3AS_UTAT", "OPTRE_M313_UNSC", "3AS_MTT", "3AS_Nuclass", "lsd_largeVTOL_cisDropship", "lsd_largeVTOL_federationDropship_base", "3AS_Imperial_Transport_01", "3AS_Republic_Transport_01", "3AS_Civilian_Transport_01", "3AS_Civilian_Transport_03", "3AS_Civilian_Transport_02"];
publicVariable "gargantuanCargoSize";

//Containers that are considered supplies automaticaly

dnt_ammoContainers = ["JLTS_Ammobox_ammo_GAR", "JLTS_Ammobox_weapons_GAR", "JLTS_Ammobox_explosives_GAR", "JLTS_Ammobox_grenades_GAR", "JLTS_Ammobox_launchers_GAR", "JLTS_Ammobox_weapons_special_GAR", "JLTS_Ammobox_support_GAR", "JLTS_Ammobox_ammo_CIS", "JLTS_Ammobox_weapons_CIS", "JLTS_Ammobox_launchers_CIS", "JLTS_Ammobox_weapons_special_CIS", "JLTS_Ammobox_support_CIS", "ls_supplies_commando_box", "ls_supplies_dc15aResupply_box", "ls_supplies_dc15sResupply_box", "ls_supplies_droidAssault_box", "ls_supplies_e60r_box", "ls_supplies_generalResupply_box", "ls_supplies_rocket_box", "ls_supplies_grenade_box", "ls_supplies_plx_box", "ls_supplies_republicAssault_box", "ls_supplies_rps6_box", "ls_supplies_specOps_box", "ls_supplies_z6Resupply_box", "3as_Small_Box_1_prop", "3AS_Small_Box_10_Prop", "3as_Small_Box_7_prop", "3AS_Small_Box_6_Prop", "3AS_Small_Box_6_CIS_Prop", "3AS_Small_Box_6_Civilian_Prop", "3AS_Small_Box_9_Prop", "3AS_Small_Box_9_Black_Prop", "3AS_Small_Box_9_Blue_Prop", "3AS_Small_Box_9_Grey_Prop"];
dnt_medicalContainers = ["3AS_Supply_Large_Medical_Prop"];

//Claimable vehicles

dnt_claimVic = ["lsd_heli_laatc", "3AS_LAATC", "3AS_Barc_212", "3AS_Barc_501", "3AS_Barc", "3AS_BarcSideCar_212", "3AS_BarcSideCar_501", "3AS_BarcSideCar", "lsd_ground_lancerBike", "ls_ground_barc", "lsd_civ_lancerBike", "3AS_LAATC_Wampa", "3AS_Z95_Orange", "3AS_Z95_Green", "3AS_Z95_Republic", "3AS_Z95_Blue", "3AS_AV7", "3AS_BTLB_Bomber", "3AS_BTLB_Bomber_Shadow", "3AS_BTLB_Bomber_RedLeader", "3AS_BTLB_Bomber_ShadowLeader", "3AS_ARC_170_Red", "3AS_ARC_170_Blue", "3AS_ARC_170_Yellow", "3AS_ARC_170_Orange", "3AS_ARC_170_Green", "3AS_Delta7_Green", "3AS_Delta7_Blue", "3AS_Delta7_TANO", "3AS_Delta7_F", "3AS_Delta7_ANI", "3AS_Delta7_Orange", "3as_Vwing_base", "3AS_VWing_Imperial", "3AS_Snowspeeder_Rogue", "3AS_Snowspeeder_Blue", "3AS_SandSpeeder", "3AS_SnowSpeeder", "ls_heli_laatle", "ls_heli_laatle_policeGunship", "ls_heli_laatle_transportGunship", "3AS_Delta7_PLO", "3AS_Delta7_Purple", "3AS_ISP", "3AS_Patrol_LAAT_Imperial", "3AS_Patrol_LAAT_Republic", "3AS_Patrol_LAAT_Police", "3AS_ISP_Transport", "3AS_Saber_M1_Imperial", "3AS_Saber_M1G_Imperial", "3AS_Saber_M1G", "3AS_Saber_M1G_501", "796th_TX130", "115th_TX130", "985th_TX130", "SWLG_tanks_tx130", "Shadow_TX130", "GD_TX130", "3AS_Saber_M1Recon_Imperial", "3AS_Saber_Super_Imperial", "3as_V19_base", "lsd_air_v19", "GD_LAAT_Airborne", "GD_LAAT_Gunship", "3AS_LAAT_Mk2", "3AS_LAAT_Mk2Lights", "3AS_LAAT_Mk1Lights", "GD_LAAT_MedEvac", "3AS_LAAT_Mk1_Imperial", "3AS_LAAT_Mk1", "lsd_heli_laati_transport", "3AS_LAAT_Mk1Lights_Imperial", "lsd_heli_laati_medevac", "lsd_heli_laati", "lsd_heli_laati_ab", "3AS_LAAT_Mk2Lights_Imperial", "3AS_LAAT_Mk2_Imperial", "3AS_Saber_Super_501", "3AS_Saber_Super", "3AS_Saber_M1Recon_501", "3AS_Saber_M1Recon", "3AS_Saber_M1_501", "3AS_Saber_M1", "3AS_ITT", "3AS_ITT_Logistic", "3AS_ITT_Medical", "3AS_RTT", "3AS_RTT_Wheeled", "3AS_ATTE_Ryloth", "3AS_ATTE_Base", "3AS_ATTE_TCW", "3AS_ATAP_Base", "3AS_ATTE_Imperial", "3AS_Civilian_Transport_02", "3AS_Civilian_Transport_03", "3AS_Civilian_Transport_01", "3AS_Republic_Transport_01", "3AS_Imperial_Transport_01", "3AS_Nuclass", "3as_Jug", "3AS_UTAT", "3AS_ATAT"];

//Vehicle cargo space customizable

dnt_spaceXS = 2;
dnt_spaceS = 5;
dnt_spaceM = 25;
dnt_spaceL = 50;
dnt_spaceXL = 1000;

publicVariable "dnt_spaceXS";
publicVariable "dnt_spaceS";
publicVariable "dnt_spaceM";
publicVariable "dnt_spaceL";
publicVariable "dnt_spaceXL";

//Salvageble scrap size

dnt_scrapXS = 1;
dnt_scrapS = 2;
dnt_scrapM = 5;
dnt_scrapL = 15;
dnt_scrapXL = 25;

publicVariable "dnt_scrapXS";
publicVariable "dnt_scrapS";
publicVariable "dnt_scrapM";
publicVariable "dnt_scrapL";
publicVariable "dnt_scrapXL";


//Launch supply system - for curator logic system is launched in initPlayerServer.sqf
null = execVM "DNT_supplies\DNT_trackSupplies.sqf";
null = execVM "DNT_supplies\DNT_setCargoSize.sqf";
//null = execVM "DNT_supplies\DNT_autoSupplyActionEden.sqf";

[west, -1, [
	["Land_BagFence_Long_F", 5],
    ["3AS_Barricade_2_C_prop", 1],
    ["3AS_Barricade_3_prop", 1],
    ["3AS_Shield_3_prop", 1],
    ["ls_stone_cover", 1],
    ["Land_OPTRE_M72S_barrierBlk", 1],
    ["Land_BagFence_Long_F", 1], 
    ["Land_BagBunker_Small_F", 1]
]] call ace_fortify_fnc_registerObjects;


while {true} do 
{
    //get all groups with players
    private _allgroups = [];
    private _pilots = [];
    {_allgroups pushBackUnique group _x;if(_x getVariable "KRPT_pilot")then{_pilots pushBackUnique _x};} forEach allPlayers;
    
    _markers = [];
    { 
        
        
        
        _leader = leader _x;
        if (not isNull _leader) then 
        {
            _marker = createMarker["location" + groupId _x, getPos _leader];
            
            _mts = _x getVariable "KRPT_mark";
			
            
            if(!(isNil "_mts")) then
            {
                switch (_mts) do
                {
                    case "tombstone": {_marker setMarkerType "gdm_div"};
                    case "devilActual": {_marker setMarkerType "gdm_d_a"};
                    case "reaperActual": {_marker setMarkerType "gdm_r_a"};
                    case "phantomActual": {_marker setMarkerType "gdm_p_a"};
                    case "104th": {_marker setMarkerType "gdm_104";_name = _leader getVariable "KRPT_callsign";if(not isNil "_name")then{_marker setMarkerText _name};};
                    case "985th": {_marker setMarkerType "gdm_985";_name = _leader getVariable "KRPT_callsign";if(not isNil "_name")then{_marker setMarkerText _name};};
                    case "infantry": {_marker setMarkerType "b_inf";_name = _leader getVariable "KRPT_callsign";if(not isNil "_name")then{_marker setMarkerText _name};};
                };
            };
            _markers pushBack _marker;
        };
    } forEach _allGroups;
    
    {
        if (vehicle _x != _x and driver vehicle _x == _x) then 
        {
            _marker = createMarker["location" + str _x, getPos _x];
            switch (typeOf vehicle _x) do
            {
                case "3as_arc_170_red": {_marker setMarkerType "gdm_c_arc"};
                case "3as_Z95_Republic": {_marker setMarkerType "gdm_c_z95"};
                case "lsd_heli_laatc": {_marker setMarkerType "gdm_c_laatc"};
                case "GD_LAAT_Airbourne": {_marker setMarkerType "gdm_c_laat"};
                case "GD_LAAT_Gunship": {_marker setMarkerType "gdm_c_laat"};
                case "3AS_Patrol_LAAT_Republic": {_marker setMarkerType "gdm_c_laat"};
                case "3AS_Nuclass": {_marker setMarkerType "gdm_c_nu"};
                case "3as_V19_base": {_marker setMarkerType "gdm_c_v19"};
            };
            _name = _x getVariable "KRPT_callsign";
            if(not isNil "_name")then{_marker setMarkerText _name};
            
            _markers pushBack _marker;
        };
    } forEach _pilots;
    
    sleep 10;
    
    {
        deleteMarker _x;
    } forEach _markers;
};






