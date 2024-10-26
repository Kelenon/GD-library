/*
 * Name:	onPlayerKilled
 * Date:	11.09.2023
 * Version: 1.0
 * Author:  Donut
 *
 * Description:
 * %DESCRIPTION%
 *
 * Parameter(s):
 * _PARAM1 (TYPE): - DESCRIPTION.
 * _PARAM2 (TYPE): - DESCRIPTION.
 */

scriptName "onPlayerKilled";

player setVariable["Saved_Loadout", getUnitLoadout player];

if(dnt_supplySystemON == 1) then {
player removeAllEventHandlers "Reloaded";
};
