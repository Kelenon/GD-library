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

params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

_oldUnit setVariable["Saved_Loadout", getUnitLoadout _oldUnit];
