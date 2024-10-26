//Supplies

remoteExec ["DNT_initSuppliesServer",2,false];

diag_log "initServer.sqf executed DNT_initSuppliesServer on server";

addMissionEventHandler ["MPEnded", {

	private _vicType = "";
		
	{	
		if(alive _x) then {
			_vicType = [_x] call DNT_vehicleDictionary;
				
			["vehicle", _vicType] call DNT_writeToDb;
			
			diag_log format ["DNT_storeVehicles calls DNT_clientWriteToDb with params 'vehicle', _vicType = %1", _vicType];
		};
	}forEach dnt_deployedVehicles;
		
	diag_log "DNT_storeVehicles executed at mission end";

}];


[west, -1, [
	["Land_BagFence_Long_F", 5]
]] call ace_fortify_fnc_registerObjects;

/*, line for potential later addition for engineers
    ["3AS_Barricade_2_C_prop", 1],
    ["3AS_Barricade_3_prop", 1],
    ["3AS_Shield_3_prop", 1],
    ["ls_stone_cover", 1],
    ["Land_OPTRE_M72S_barrierBlk", 1],
    ["Land_BagFence_Long_F", 1], 
    ["Land_BagBunker_Small_F", 1]*/


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