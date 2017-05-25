dzn_fnc_CENA_SetSkillAffected = {
	params ["_u", "_skillMultiplier"];
	
	{
		_u setSkill [_x, ((_u getVariable "CENA_Skills") select _forEachIndex) * _skillMultiplier];
	} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "reloadSpeed"];
};

dzn_fnc_CENA_ProvideSuppressEffect = {
	private _u = _this;
	private _supression = if (!isNil {getSuppression _u}) then { getSuppression _u } else { 0 };
	_u setUnitPos "AUTO";
	
	if (_supression < 0.2) exitWith {
		[_u, 1] call dzn_fnc_CENA_SetSkillAffected;
	};
	
	switch (true) do {
		case (_supression > 0.5): {
			[_u, 0.5] call dzn_fnc_CENA_SetSkillAffected;
		};
		case (_supression > 0.7): {
			[_u, 0.25] call dzn_fnc_CENA_SetSkillAffected;
		};
		case (_supression > 0.9): {			
			[_u, 0] call dzn_fnc_CENA_SetSkillAffected;
			_u doTarget objNull;
			_u setUnitPos "DOWN";
		};
	};
};

dzn_fnc_CENA_FindCover = {
	private _u = _this;
	_u setVariable ["CENA_MovingInCover", true];
	
	private _nearestCovers = nearestTerrainObjects [
		getPos _u
		,  ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "BUNKER", "FORTRESS", "FOUNTAIN", "HOSPITAL", "RUIN", "TOURISM", "WATERTOWER","POWERSOLAR", "POWERWIND" ]
		, 50
		, true
		, false
	];
	
	if (_nearestCovers isEqualTo []) then {
		_nearestCovers = nearestTerrainObjects [
			getPos _u
			,  ["ROCK", "ROCKS", "TREE", "FOREST", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FENCE", "WALL", "STACK", "RAILWAY"]
			, 50
			, true
			, false
		];
	};
	
	if (_nearestCovers isEqualTo []) exitWith {};
	
	private _cover = _nearestCovers - [_u getVariable "CENA_Cover"];	
	if (_cover isEqualTo []) exitWith {
		sleep 5;
		_u setVariable ["CENA_MovingInCover", false];
	};	
	
	if (_cover isKindOf "House") then {
		private _positions = [];
		private _index = 0;
		
		while { !((_cover buildingPos _index) isEqualTo [0,0,0]) } do {
			_positions = _positions + [_index];
			_index = _index + 1;
		};

		_cover = selectRandom _positions;	
	};	
	
	_u setVariable ["CENA_Cover", _cover select 0];	
	_u doMove (getPosATL (_cover select 0));
	
	waitUntil { 
		sleep 0.5; 
		// _u setUnitPos "UP";
		_u setAnimSpeedCoef 1.5;
		_u distance (_cover select 0) < 5
	};
	
	_this setVariable ["CENA_MovingInCover", false];
};

dzn_CENA_fnc_ScheduleContactReport = {
	sleep 30;
	if !(alive _this) exitWith {};
	if (_this getVariable ["CENA_ContactsToReport", []] isEqualTo []) exitWith {};
	
	{
		if (_x distance2d _this < 1000) then {
			private _sl = _x;
			{
				_sl reveal [_x, 1.5];
			} forEach (_this getVariable ["CENA_ContactsToReport]);
		};
	} forEach (allUnits select {
		alive _x
		&& side _x == side _this 
		&& leader (group _x) == _x
	});
	
	_this setVariable ["CENA_ContactsToReport", []];
};
