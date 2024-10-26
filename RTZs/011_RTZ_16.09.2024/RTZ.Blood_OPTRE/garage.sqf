_vehicle = _this select 0;

zen_garage_center = _vehicle;
createDialog "zen_garage_display";

zen_garage_mouseButtons = [[], []];
zen_garage_interfaceShown = true;
zen_garage_visionMode = 0;

[] call zen_garage_fnc_showVehicleInfo;
[] call zen_garage_fnc_populateLists;

[zen_garage_currentTab, true] call zen_garage_fnc_onTabSelect;

private _ctrlButtonApply = findDisplay 10500 displayCtrl 341;
_ctrlButtonApply ctrlSetTooltip "Cannot apply to all";
_ctrlButtonApply ctrlEnable false;

zen_garage_camHelper = "Logic" createVehicleLocal [0, 0, 0];
zen_garage_camHelper attachTo [_vehicle, zen_garage_helperPos];

zen_garage_camera = "camera" camCreate ASLtoAGL getPosASL _vehicle;
zen_garage_camera cameraEffect ["internal", "back"];
zen_garage_camera camPrepareFocus [-1, -1];
zen_garage_camera camPrepareFov 0.35;
zen_garage_camera camCommitPrepared 0;

showCinemaBorder false;

[nil, 0] call zen_garage_fnc_onMouseZChanged;

zen_garage_camDraw3D = addMissionEventHandler ["Draw3D", {call zen_garage_fnc_updateCamera}];