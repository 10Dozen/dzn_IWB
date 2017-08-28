dzn_fnc_icb_SetSuppressionHandler =  {
	private _u = _this;
	if (side _u == civilian || _u getVariable ["ICB_Handled", false]) exitWith {};
	
	if (!local _u) exitWith {
		_u remoteExec ["dzn_fnc_icb_SetSuppressionHandler",_u];
	};
	
	_u setVariable ["ICB_Handled", true, true];
	_u setVariable ["ICB_Cover", objNull];
	_u setVariable ["ICB_Skills", [_u skill "aimingAccuracy", _u skill "aimingShake", _u skill "aimingSpeed", _u skill "reloadSpeed"]];
	
	while { alive _u } do {
		if (
			dzn_icb_Enabled
			&& {
				simulationEnabled _u 
				&& !(_u getVariable ["dzn_dynai_isCached", false])
				&& vehicle _u == _u
				&& side _u != civilian
				&& !(_u getVariable ["ACE_isUnconscious", false])
				&& !(_u getVariable ["ACE_isSurrendering", false])
				&& !(_u getVariable ["ACE_isHandcuffed", false])
			}
		) then {		
			if (
				( 
					(getSuppression _u > 0 	&& isNull (_u getVariable "ICB_Cover")) 
					|| (getSuppression _u > 0.75) 
				)
				&& !(_u getVariable ["ICB_MovingInCover", false])
			) then {	
				_u spawn dzn_fnc_icb_FindCover;
				if !(combatMode (group _u) in ["RED","YELLOW"]) then {
					(group _u) setCombatMode "RED";
					(group _u) setSpeedMode "FULL";
				};
			};

			_u call dzn_fnc_icb_ProvideSuppressEffect;
		
		};
		sleep 1;
	};
};

dzn_fnc_icb_SetSkillAffected = {
	params ["_u", "_skillMultiplier"];
	
	{
		_u setSkill [_x, ((_u getVariable "ICB_Skills") select _forEachIndex) * _skillMultiplier];
	} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "reloadSpeed"];
};

dzn_fnc_icb_ProvideSuppressEffect = {
	if (!dzn_icb_AllowSkillAffected) exitWith {};
	
	private _u = _this;
	private _supression = if (!isNil {getSuppression _u}) then { getSuppression _u } else { 0 };
	_u setUnitPos "AUTO";
	
	if (_supression < 0.2) exitWith {
		[_u, 1] call dzn_fnc_icb_SetSkillAffected;
	};
	
	switch (true) do {
		case (_supression > 0.5): {
			[_u, 0.5] call dzn_fnc_icb_SetSkillAffected;
		};
		case (_supression > 0.7): {
			[_u, 0.25] call dzn_fnc_icb_SetSkillAffected;
		};
		case (_supression > 0.9): {			
			[_u, 0] call dzn_fnc_icb_SetSkillAffected;
			_u doTarget objNull;
			_u setUnitPos "DOWN";
		};
	};
};

dzn_fnc_icb_FindCover = {
	if !(dzn_icb_AllowFindCover) exitWith {};
	
	private _u = _this;
	_u setVariable ["ICB_MovingInCover", true];
	
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
	
	private _cover = _nearestCovers - [_u getVariable "ICB_Cover"];	
	if (_cover isEqualTo []) exitWith {
		sleep 5;
		_u setVariable ["ICB_MovingInCover", false];
	};
	
	_u setVariable ["ICB_Cover", _cover select 0];	
	_u doMove (getPosATL (_cover select 0));
	
	waitUntil { 
		sleep 0.5; 
		// _u setUnitPos "UP";
		_u setAnimSpeedCoef 1.5;
		_u distance (_cover select 0) < 5
	};
	
	_this setVariable ["ICB_MovingInCover", false];
};
