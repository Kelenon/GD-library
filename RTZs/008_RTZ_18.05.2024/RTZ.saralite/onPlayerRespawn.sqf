scriptName "onPlayerRespawn";

private _newUnit = _this select 0;

_newUnit setUnitFreefallHeight 1500;

if ((group _newUnit == casper) || (group _newUnit == advisor) && !(isNil "Haunter")) then 
{
	_newUnit addAction ["<t color='#0000FF'>Open Casper Spawn Menu</t>", {
	
			createDialog "RscCaspSpawnDialog";
		},

	[], 1, true, true, "", "_target inArea Haunter"];
	
	_newUnit addAction ["<t color='#00FF00'>Open Casper Repair Menu</t>", {
	
			createDialog "RscCaspRepairDialog";
						
		},
	[], 1, true, true, "", "_target inArea Haunter"];
};

//Supply system related section

private _loadout = _newUnit getVariable "Saved_Loadout";

if(isNil "_loadout") then {

	[_newUnit, (roleDescription _newUnit)] execVM "ApplyLoadout.sqf";

} else {
	_newUnit setUnitLoadout _loadout;
};

uiSleep 3;

if(isNull getAssignedCuratorLogic _newUnit) then {
	if(dnt_ammoDepleted == true) then {
		private _standardWeapons = ["JLTS_DC15A_plastic","JLTS_DC15A","SWLW_DC15A","SWLW_DC15A_wooden","JLTS_DC15A_ugl_plastic","JLTS_DC15A_ugl","JLTS_DC15S","JLTS_DC15X","JLTS_DP23","JLTS_DW32S","JLTS_Z6","JLTS_DC17SA","3AS_DC15L_F","JLTS_DC15S_mag","JLTS_DC15A_mag","SWLW_DC15A_UGL_flare_red_Mag","JLTS_stun_mag_short","JLTS_stun_mag_long","SWLW_DC15A_Mag","1Rnd_HE_Grenade_shell","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F","UGL_FlareCIR_F","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","ACE_HuntIR_M203","OPTRE_1Rnd_Smoke_Grenade_shell","OPTRE_1Rnd_SmokeRed_Grenade_shell","OPTRE_1Rnd_SmokeGreen_Grenade_shell","OPTRE_1Rnd_SmokeYellow_Grenade_shell","OPTRE_1Rnd_SmokePurple_Grenade_shell","OPTRE_1Rnd_SmokeBlue_Grenade_shell","OPTRE_1Rnd_SmokeOrange_Grenade_shell","ACE_40mm_Flare_white","ACE_40mm_Flare_red","ACE_40mm_Flare_green","ACE_40mm_Flare_ir","WNZ_EMP40mm_Grenade_Magazine","OPTRE_3Rnd_Smoke_Grenade_shell","OPTRE_3Rnd_SmokeRed_Grenade_shell","OPTRE_3Rnd_SmokeGreen_Grenade_shell","OPTRE_3Rnd_SmokeYellow_Grenade_shell","OPTRE_3Rnd_SmokePurple_Grenade_shell","OPTRE_3Rnd_SmokeBlue_Grenade_shell","OPTRE_3Rnd_SmokeOrange_Grenade_shell","JLTS_DC15X_mag","JLTS_DP23_mag","JLTS_DW32S_mag","JLTS_Z6_mag","JLTS_DC17SA_mag","3AS_200Rnd_EC40_Mag","3AS_PLX1_F","JLTS_PLX1_AT","SWLW_PLX1","ls_weapon_at_plx1","SWLW_PLX1_AA","ls_weapon_aa_plx1","JLTS_DC15X_scope","3AS_Optic_DC15L","JLTS_DC17SA_flashlight","acc_flashlight","acc_pointer_IR","ACE_acc_pointer_green","3AS_Bipod_DC15L_f","3AS_JLTS_MK43_AT","3AS_JLTS_MK44_HE","3AS_JLTS_MK39_AA","JLTS_PLX1_AT_mag","JLTS_PLX1_AP_mag","SWLW_plx1_at_mag","SWLW_plx1_ap_mag","ls_mag_at_plx","ls_mag_ap_plx","SWLW_plx1_aa_mag","ls_mag_aa_plx","3AS_BaridumCore","Luma_Blue","Luma_Green","Luma_Red","Luma_Yellow","3AS_SmokeBlue","3AS_SmokeGreen","3AS_SmokeOrange","3AS_SmokePurple","3AS_SmokeRed","3AS_SmokeWhite","3AS_SmokeYellow","ShieldGrenade_Mag","ShieldGrenadePersonal_Mag","SquadShieldMagazine","Chemlight_blue","Chemlight_green","ACE_Chemlight_HiBlue","ACE_Chemlight_HiGreen","ACE_Chemlight_HiRed","ACE_Chemlight_HiWhite","ACE_Chemlight_HiYellow","ACE_Chemlight_IR","ACE_Chemlight_Orange","Chemlight_red","ACE_Chemlight_UltraHiOrange","ACE_Chemlight_White","Chemlight_yellow","ACE_CTS9","WNZ_EMPGrenade","B_IR_Grenade","ACE_HandFlare_Green","ACE_HandFlare_Red","ACE_HandFlare_White","ACE_HandFlare_Yellow","SmokeShellBlue","SmokeShellGreen","SmokeShellOrange","SmokeShellPurple","SmokeShellRed","SmokeShellYellow","OPTRE_M2_Smoke_Blue","OPTRE_M2_Smoke_Green","OPTRE_M2_Smoke_Orange","OPTRE_M2_Smoke_Purple","OPTRE_M2_Smoke_Red","OPTRE_M2_Smoke","OPTRE_M2_Smoke_Yellow","OPTRE_M8_Flare_Blue","OPTRE_M8_Flare_Green","OPTRE_M8_Flare","OPTRE_M8_Flare_White","OPTRE_M8_Flare_Yellow","SmokeShell","ACE_M84","ls_mag_n20_thermalDet","ls_mag_classB_thermalDet","ls_mag_classC_thermalDet","3AS_DetPack","EC01_RemoteMagazine","HX_AT_Mine_Mag","RTX_RemoteMagazine","APERSMineDispenser_Mag","SWLW_clones_spec_breach_mag","ls_mag_breach_remoteCharge","C7_Remote_Mag","C12_Remote_Mag","ls_mag_caltrops_mine","ls_mag_caltrops_dispenser","SWLW_clones_spec_demo_mag","SWLW_DetPack_remote_mag","OPTRE_FC_BubbleShield","ls_mag_detPack_remoteCharge","ls_mag_demo_remoteCharge","WNZ_EMPATMine_Range_Mag","JLTS_explosive_emp_10_mag","JLTS_explosive_emp_20_mag","JLTS_explosive_emp_50_mag","WNZ_EMPSatchelCharge_Remote_Mag","IEDLandBig_Remote_Mag","IEDUrbanBig_Remote_Mag","DemoCharge_Remote_Mag","ATMine_Range_Mag","UNSCMine_Range_Mag","M168_Remote_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag","APERSBoundingMine_Range_Mag","SLAMDirectionalMine_Wire_Mag","APERSMine_Range_Mag","3AS_DymekBlasterRifle_F","3AS_DymekSniperRifle_F","3AS_Valken38X_F","3AS_optic_holo_DC15S","3AS_Optic_Red_DC15A","3AS_optic_acog_DC15C","3AS_optic_ATRT","3AS_Optic_Scope_WestarM5","3AS_Optic_VK38X","3AS_Optic_LEScope_DC15A","SWLW_Westar35SA_flash","3AS_Muzzle_LE_DC15A","OPTRE_signalSmokeR","OPTRE_signalSmokeO","OPTRE_signalSmokeY","OPTRE_signalSmokeG","OPTRE_signalSmokeB","OPTRE_signalSmokeP","3AS_200Rnd_EM40_Mag","3AS_45Rnd_EY50_Mag","3AS_10Rnd_EY80_Mag","3AS_10Rnd_EC80_Mag","3AS_10Rnd_EM80_Mag","3AS_Bipod_VK38X_f","optic_Nightstalker","optic_tws","optic_tws_mg","optic_NVS","optic_DMS","optic_LRPS","optic_AMS","optic_AMS_snd","optic_AMS_khk","optic_KHS_blk","optic_KHS_tan","optic_KHS_hex","optic_KHS_old","optic_SOS","optic_MRCO","optic_Arco","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","optic_Hamr","optic_Holosight","optic_Holosight_smg","optic_Hamr_khk_F","optic_SOS_khk_F","optic_Arco_ghex_F","optic_Arco_blk_F","optic_DMS_ghex_F","optic_ERCO_blk_F","optic_ERCO_khk_F","optic_ERCO_snd_F","optic_LRPS_ghex_F","optic_LRPS_tna_F","optic_Holosight_blk_F","optic_Holosight_khk_F","optic_Holosight_smg_blk_F","optic_Holosight_smg_khk_F","optic_Arco_AK_blk_F","optic_Arco_AK_lush_F","optic_Arco_AK_arid_F","optic_DMS_weathered_F","optic_DMS_weathered_Kir_F","optic_Arco_lush_F","optic_Arco_arid_F","optic_Holosight_lush_F","optic_Holosight_arid_F","ACE_optic_Hamr_2D","ACE_optic_Hamr_PIP","ACE_optic_Arco_2D","ACE_optic_Arco_PIP","ACE_optic_MRCO_2D","ACE_optic_SOS_2D","ACE_optic_SOS_PIP","ACE_optic_LRPS_2D","ACE_optic_LRPS_PIP","DymekBlasterPistol_F","JLTS_RG4D","ls_weapon_westar35sa_secondary","acc_flashlight_pistol","SWLW_Westar35SA_laser","3AS_16Rnd_EY20_Mag","JLTS_RG4D_mag","SWLW_westar35sa_Mag","3AS_SonicDet","3AS_ThermalDetonator","3AS_ThrowableCharge","Optre_Recon_Sight","Optre_Recon_Sight_UNSC","OPTRE_BR55HB_Scope_Grey","OPTRE_MA5_BUIS","Optre_Recon_Sight_Snow","OPTRE_BR45_Scope","OPTRE_M393_ACOG","OPTRE_M7_Sight","OPTRE_M12_Optic_Green","OPTRE_SRM_Sight","OPTRE_SRS99_Scope","OPTRE_MA5C_SmartLink","OPTRE_M12_Optic","Optre_Recon_Sight_Red","OPTRE_BMR_Scope","OPTRE_M392_Scope","OPTRE_SRS99C_Scope","OPTRE_M393_EOTECH","OPTRE_M73_SmartLink","OPTRE_MA5_SmartLink","OPTRE_M6C_Scope","Optre_Recon_Sight_Desert","OPTRE_HMG38_CarryHandle","OPTRE_M12_Optic_Red","OPTRE_M6G_Scope","Optre_Recon_Sight_Green","OPTRE_BR55HB_Scope","OPTRE_M393_Scope","OPTRE_M7_Laser","OPTRE_BMR_Laser","ACE_DBAL_A3_Green","OPTRE_M45_Flashlight","OPTRE_M7_Flashlight","OPTRE_M6C_Laser","OPTRE_M6G_Flashlight","OPTRE_M12_Laser","ACE_DBAL_A3_Red","ACE_SPIR"]; 
		{_newUnit removeWeapon _x;}forEach _standardWeapons;
		{_newUnit removeItems _x;}forEach _standardWeapons;
		{_newUnit removeMagazine _x} forEach magazines _newUnit;			
	};
	
	if(dnt_medsDepleted == true) then {
		private _standardMeds = ["OPTRE_Biofoam","ACE_Flashlight_KSF1","ACE_adenosine","ACE_fieldDressing","ACE_elasticBandage","ACE_packingBandage","ACE_quikclot","ACE_bloodIV","ACE_bloodIV_250","ACE_bloodIV_500","ACE_bodyBag","ACE_morphine","ACE_plasmaIV","ACE_plasmaIV_250","ACE_plasmaIV_500","ACE_salineIV","ACE_salineIV_250","ACE_salineIV_500","ACE_splint","ACE_surgicalKit","ACE_tourniquet","ACE_epinephrine"];
		{_newUnit removeItems _x;}forEach _standardMeds;
	
	};	
};

waitUntil {!isNull (getAssignedCuratorLogic _newUnit)};

if(!isNull getAssignedCuratorLogic _newUnit) then {

	[_newUnit] call DNT_swapDatabases;
	
};

if(!isNull getAssignedCuratorLogic _newUnit) then {

	_newUnit setUnitTrait ["Medic",false];
	_newUnit setUnitTrait ["Engineer",false];

};

if(getAssignedCuratorLogic _newUnit in dnt_regCuratorLogic) then {} else {

	getAssignedCuratorLogic _newUnit addEventHandler ["CuratorObjectPlaced", {
		params ["_curator", "_entity"];
		
		[_entity] remoteExec ["DNT_createSupply", -2];
	
	}];
	
	//Adds curator EH to remove tasks and related variables on objects removed by zeus
	getAssignedCuratorLogic _newUnit addEventHandler ["CuratorObjectDeleted", {
		params ["_curator", "_entity"];
		
		[] spawn DNT_removeSupplies;
	
	}];
	
	dnt_regCuratorLogic pushBack getAssignedCuratorLogic _newUnit;
	publicVariable "dnt_regCuratorLogic";

};