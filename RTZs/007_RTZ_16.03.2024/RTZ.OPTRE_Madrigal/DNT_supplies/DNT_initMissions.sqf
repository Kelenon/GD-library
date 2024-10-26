/*
 * Name:	DNT_initMissions
 * Date:	09.03.2024
 * Version: 1.0
 * Author:  Donut
 */

scriptName "DNT_initMissions";

uiSleep 5;

["Supplies", ["Claimed supplies", (format["Current list of supplies brought to Haunter - ammunition: %1, medical: %2, scrap %3",
dnt_ammoCount,dnt_medicalCount, dnt_scrapCount])], "CREATED"] call ENGTASKS_CreateTask;


["VehiclesList", ["Available vehicles", (format["Current list of available vehicle types: %1 %2",
endl,dnt_vehicleMissionTxt])], "CREATED"] call ENGTASKS_CreateTask;

