if(isServer) then {

	call compile preprocessFileLineNumbers "Donut\Supplies\DNT_fncServer.sqf";
	
};

call compile preprocessFileLineNumbers "Donut\Supplies\DNT_fncCommon.sqf"; 

call compile preprocessFileLineNumbers "Donut\Supplies\DNT_EventHandlers.sqf"; 

