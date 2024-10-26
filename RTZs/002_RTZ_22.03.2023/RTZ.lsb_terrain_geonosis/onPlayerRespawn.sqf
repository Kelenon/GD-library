_newUnit = _this select 0;
if ((group _newUnit == casper) || (group _newUnit == advisor) && !(isNil "Haunter")) then 
{
	_newUnit addAction ["<t color='#0000FF'>Open Casper Spawn Menu</t>", {createDialog "RscCaspSpawnDialog";}, [], 1, true, true, "", "_target inArea Haunter"];
	_newUnit addAction ["<t color='#00FF00'>Open Casper Repair Menu</t>", {createDialog "RscCaspRepairDialog";}, [], 1, true, true, "", "_target inArea Haunter"];
};