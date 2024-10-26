_actionID = player addAction ["<t color='#0000FF'>Open Casper Spawn Menu</t>", {createDialog "RscCaspSpawnDialog";}];
_actionID2 = player addAction ["<t color='#00FF00'>Open Casper Repair Menu</t>", {createDialog "RscCaspRepairDialog";}];
while {true} do 
{
	if (!(player inArea Haunter) and _actionID in actionIDs player) then 
	{
		player removeAction _actionID;
		player removeAction _actionID2;
	};
	if (player inArea Haunter and !(_actionID in actionIDs player)) then 
	{
		_actionID = player addAction["<t color='#0000FF'>Open Casper Spawn Menu</t>", {createDialog "RscCaspSpawnDialog";}];
		_actionID2 = player addAction ["<t color='#00FF00'>Open Casper Repair Menu</t>", {createDialog "RscCaspRepairDialog";}];
	};
	sleep 5;
};

