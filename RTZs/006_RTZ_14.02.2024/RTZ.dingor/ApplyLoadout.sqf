if (!isNil "_this") then {
	
	_playerUnit = _this select 0;
	_roleSet = _this select 1;
 
 	switch (_roleSet) do 
	{ 
	 case "Lead Zeus@Zeus Team": { _playerUnit setUnitLoadout(missionConfigFile >> "c_trooper"); }; 
	case "Co-Zeus": { _playerUnit setUnitLoadout(missionConfigFile >> "c_trooper"); }; 
	case "Clone Trooper": { _playerUnit setUnitLoadout(missionConfigFile >> "c_trooper"); }; 
	case "Reservist": { _playerUnit setUnitLoadout(missionConfigFile >> "c_trooper"); }; 
	case "Visitor": { _playerUnit setUnitLoadout(missionConfigFile >> "c_reg"); }; 
	case "Recruit": { _playerUnit setUnitLoadout(missionConfigFile >> "c_recruit"); }; 
	case "Clone Pilot Sergeant@Casper Squadron": { _playerUnit setUnitLoadout(missionConfigFile >> "c_sergeant_pilot"); }; 
	case "Clone Pilot Corporal": { _playerUnit setUnitLoadout(missionConfigFile >> "c_corporal_pilot"); }; 
	case "Clone Pilot": { _playerUnit setUnitLoadout(missionConfigFile >> "c_trooper_pilot"); }; 
	case "Clone Sergeant@Devil Squad": { _playerUnit setUnitLoadout(missionConfigFile >> "c_sergeant"); }; 
	case "Clone Sergeant@Reaper Squad": { _playerUnit setUnitLoadout(missionConfigFile >> "c_sergeant"); }; 
	case "Clone Sergeant@Phantom Squad": { _playerUnit setUnitLoadout(missionConfigFile >> "c_sergeant"); }; 
	case "Clone Corporal": { _playerUnit setUnitLoadout(missionConfigFile >> "c_corporal"); }; 
	case "Clone Sergeant Major": { _playerUnit setUnitLoadout(missionConfigFile >> "c_sergeant_major"); }; 
	case "Clone Lieutanant": { _playerUnit setUnitLoadout(missionConfigFile >> "c_lieutenant"); }; 
	case "Clone Captain": { _playerUnit setUnitLoadout(missionConfigFile >> "c_captain"); }; 
	case "Clone Commander@Division Lead": { _playerUnit setUnitLoadout(missionConfigFile >> "c_commander"); }; 
  
	default { _playerUnit setUnitLoadout(missionConfigFile >> "c_reg"); };
	
	};

};

