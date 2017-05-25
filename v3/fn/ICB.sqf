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
	
	// Search for COVER
	private _nearestCovers = nearestTerrainObjects [
		getPos _u
		,  ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "BUNKER", "FORTRESS", "FOUNTAIN", "HOSPITAL", "RUIN", "TOURISM", "WATERTOWER","POWERSOLAR", "POWERWIND" ]
		, 50
		, true
		, false
	];
	
	// If none - searching for CONCEALMENT
	if (_nearestCovers isEqualTo []) then {
		_nearestCovers = nearestTerrainObjects [
			getPos _u
			,  ["ROCK", "ROCKS", "TREE", "FOREST", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FENCE", "WALL", "STACK", "RAILWAY"]
			, 50
			, true
			, false
		];
	};
	
	// Non of cover or concelment - exit
	if (_nearestCovers isEqualTo []) exitWith {};
	
	private _cover = selectRandom (_nearestCovers - [_u getVariable "CENA_Cover"]);	
	if (_cover isEqualTo []) exitWith {
		sleep 5;
		_u setVariable ["CENA_MovingInCover", false];
	};	
	
	// If cover is a house - select inside position
	if (_cover isKindOf "House") then {
		_cover = selectRandom ([_cover] call BIS_fnc_buildingPositions);	
	};	
	
	// Move to cover with speed boost
	_u setVariable ["CENA_Cover", _cover];	
	_u doMove (getPosATL _cover);
	
	waitUntil { 
		sleep 0.5; 
		_u setAnimSpeedCoef 1.5;
		_u distance (_cover select 0) < 5
	};
	
	_this setVariable ["CENA_MovingInCover", false];
};

dzn_CENA_fnc_ScheduleContactReport = {
	sleep 30;
	if !(alive _this) exitWith {};
	if (_this getVariable ["CENA_KnownTargets", []] isEqualTo []) exitWith {};
	
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
};
