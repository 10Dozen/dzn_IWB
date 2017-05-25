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


};
