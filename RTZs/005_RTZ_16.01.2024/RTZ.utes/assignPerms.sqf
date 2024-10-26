if (!isNil "_this") then {
	_assign = _this select 0;
	
	_assign addAction ["Assign Medic Perms", {if(typeOf unitBackpack player regexMatch ".*GD_Backpack_Medic.*") 
				then {player setUnitTrait ["Medic", true];hint parseText "<t color='#009900' size='1.5'>[[Beep boop, medic permissions given, beep boop.]]</t>"} 
				else {hint parseText "<t color='#990000' size='1.5'>[[Beep boop,you are not a medic, beep boop.]]</t>"}}];

	_assign addAction ["Assign Engineer Perms", {if(typeOf unitBackpack player regexMatch ".*GD_Backpack_EOD.*") 
				then {player setUnitTrait ["Engineer", true];hint parseText "<t color='#009900' size='1.5'>[[Beep boop, engineer permissions given, beep boop.]]</t>"} 
				else {hint parseText "<t color='#990000' size='1.5'>[[Beep boop,you are not an engineer, beep boop.]]</t>"}}];  

	_assign addAction ["Remove Medic Perms", {player setUnitTrait ["Medic",false];
				hint parseText "<t color='#eeee00' size='1.5'>[[Beep boop, medic permissions removed, beep boop.]]</t>"}];    
  
	_assign addAction ["Remove Engineer Perms", {player setUnitTrait ["Engineer",false];
				hint parseText "<t color='#eeee00' size='1.5'>[[Beep boop, engineer permissions removed, beep boop.]]</t>"}];
		
	
	};	
