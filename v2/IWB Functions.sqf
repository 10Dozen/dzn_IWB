//#define DEBUG	true
#define DEBUG 	false
/*
	Utility function
*/
dzn_fnc_iwb_setLongTimeout = {
	_this setVariable ["IWB_LongTimeoutDone", false];
	_this spawn {
		sleep dzn_iwb_SpecialAttackLongTimeout;
		_this setVariable ["IWB_LongTimeoutDone", true];
	};
};

dzn_fnc_iwb_setShortTimeout = {
	_this setVariable ["IWB_ShortTimeoutDone", false];
	_this spawn {
		sleep dzn_iwb_SpecialAttackShortTimeout;
		_this setVariable ["IWB_ShortTimeoutDone", true];
	};
};

dzn_fnc_iwb_getShortTimeoutDone = { _this getVariable ["IWB_ShortTimeoutDone",false] };
dzn_fnc_iwb_getLongTimeoutDone = { _this getVariable ["IWB_LongTimeoutDone",false] };
dzn_fnc_IWB_ToggleHandGrenadeEH = {
	params ["_u", "_add"];
	private _eh = -1;
	
	if (!local _u) exitWith {
		_this remoteExec ["dzn_fnc_IWB_ToggleHandGrenadeEH", _u];
	};
	
	if (_add) then {
		_eh = _u addEventHandler [
			"Fired"
			, {
				if !( (_this select 5) in (dzn_iwb_HGList apply {_x select 0}) ) exitWith {};
				
				private _proj = _this select 6;
				private _dist = (_this select 0) getVariable ["IWB_HG_TargetRange", 15];
				private _velocity = [];
				
				if (_dist < 16) then {
					_velocity = [0,8 + random [-0.75, 0, 0.75] ,10];
				} else {				
					if (_dist < 23) then {
						_velocity = [0,10 + random [-1, 0, 1],10]
					} else {
						if (_dist < 30) then {
							_velocity = [0,12 + random [-1.25, 0, 1.25],10]
						} else {
							_velocity = [0,16 + random [-1.25, 0, 1.5],10]
						};
					};
				};
				
				_proj setVelocity ((_proj modelToWorldVisual _velocity) vectorDiff (_proj modelToWorldVisual [0,0,0]));
			}
		];
		_u setVariable ["IWB_FireEH", _eh];
	} else {
		_u removeEventHandler ["Fired", _u getVariable ["IWB_FireEH",-1]];
		_u setVariable ["IWB_FireEH", nil];
	};
};


/* **************** */
/* Functions
/* **************** */
dzn_fnc_iwb_GetUnitCombatAttributes = {
	private _u = _this;
	private _hasUGL = false;
	private _hasGrenades = false;
	private _hasSupportWeapon = false;
	
	private _muzzles = (getArray(configFile >> "cfgWeapons" >> primaryWeapon _u >> "muzzles")) - ["SAFE"];
	if ( 
		count _muzzles > 1 
		&& count (primaryWeaponMagazine _u) > 1 
		&& { (primaryWeaponMagazine _u select 1) in dzn_iwb_UGLRoundsList }
	) then { 
		_hasUGL = true;
	};
	
	private _mags = itemsWithMagazines _u;	
	{ 
		if ((_x select 0) in _mags) exitWith { 
			_u setVariable ["IWB_HGMuzzle", _x select 1, true];
			_hasGrenades = true;
		};
	} forEach dzn_iwb_HGList;
	
	_hasSupportWeapon = getNumber (configFile >> "CfgMagazines" >> currentMagazine _u >> "count") > 30;

	_u setVariable ["IWB_UGL", _hasUGL, true];
	_u setVariable ["IWB_HG", _hasGrenades, true];
	_u setVariable ["IWB_SW", _hasSupportWeapon, true];
};

dzn_fnc_iwb_SelectAttackAndTarget = {
	#define	NO_ATTACK	[false, objNull, ""]	
	private _u = _this;
	
	if (
		!simulationEnabled _u 
		|| _u getVariable ["dzn_dynai_isCached", false] 
		|| side _u == civilian
		|| _u getVariable ["ACE_isUnconscious", false]
		|| _u getVariable ["ACE_isSurrendering", false]
		|| _u getVariable ["ACE_isHandcuffed", false]
	)  exitWith {
		if (DEBUG) then { systemChat "SelectAttack: Unit cached/not simulated!"; };
		NO_ATTACK
	};
	
	if (_u getVariable ["IWB_inSequence", false]) exitWith {
		if (DEBUG) then { systemChat "SelectAttack: Sequence in progress"; };
		NO_ATTACK	
	};
	
	private _chance = random(100);
	if ( _chance > dzn_iwb_SpecialAttackChance ) exitWith { 
		if (DEBUG) then { systemChat format ["SelectAttack: No % chance ( %1 )", _chance]; };
		NO_ATTACK
	};
	
	private _modes = ["IWB_UGL","IWB_HG","IWB_SW"] select { _u getVariable [_x, false] };
	if (_modes isEqualTo []) exitWith {  
		if (DEBUG) then { systemChat format ["SelectAttack: No modes available ( %1 )", _modes]; };
		NO_ATTACK
	};
	
	private _targets = _u call dzn_fnc_iwb_GetTargets;
	if (_targets isEqualTo []) exitWith { 
		if (DEBUG) then { systemChat format ["SelectAttack: Targets ( %1 )", _tgts]; };
		NO_ATTACK
	};
	
	#define IN_MODES(X)	(X in _modes)
	#define HAS_TGTS(X)	!((_targets select X) isEqualTo [])
	#define GET_TGT(X)	(selectRandom (_targets select X)) select 1
	
	if (IN_MODES("IWB_UGL") && { HAS_TGTS(0) }) exitWith {	
		private _tgt = GET_TGT(0);
		if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_UGL ( %1 )", _tgt]; };
		[true, _tgt, "IWB_UGL"]
	};
	
	if (IN_MODES("IWB_HG") && { HAS_TGTS(1) }) exitWith {	
		private _tgt = GET_TGT(1);
		if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_HG ( %1 )", _tgt]; };
		[true, _tgt, "IWB_HG"]
	};
	
	if (IN_MODES("IWB_SW") && { HAS_TGTS(2) }) exitWith {	
		private _tgt = GET_TGT(2);
		if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_SW ( %1 )", _tgt]; };
		[true, _tgt, "IWB_SW"]
	};
	
	NO_ATTACK
};

dzn_fnc_iwb_GetTargets = {
	private _u = _this;
	
	private _filteredTargets = [];
	private _targets = _u targetsQuery [objNull, sideEnemy, "", [], 0];
	//	[1,gl1,GUER,"I_Soldier_GL_F",[6750.39,5563.42],-1]
	
	{
		private _rng = _x;
		_filteredTargets pushBack (
			_targets select {
				(_x select 3) isKindOf "CAManBase" 
				&& _u distance (_x select 1) >= (_rng select 0)
				&& _u distance (_x select 1) <= (_rng select 1)
				&& !((side (_x select 1)) in [side _u, civilian])
			}		
		);
	} forEach [ 
		dzn_iwb_UGLAttackRange
		, dzn_iwb_HGAttackRange
		, dzn_iwb_SWAttackRange
	];
	
	_filteredTargets
};


/**
	Attack Sequences
 **/
dzn_fnc_iwb_runAttackSequenceRemote = {
	params ["_u", "_sequenceParams", "_sequenceName"];
	
	private _seqFunction = switch toUpper(_sequenceName) do {
		case "UGL": { "dzn_fnc_iwb_UGLAttack" };
		case "HG": { "dzn_fnc_iwb_HGAttack" };
		case "SW": { "dzn_fnc_iwb_Suppress" };
	};
	
	[_u, _sequenceParams] remoteExec [_seqFunction, _u];	
};




dzn_fnc_iwb_UGLAttack = {
	params["_u","_tgt"];
	
	private _priWpn = primaryWeapon _u;
	if (_priWpn == "") exitWith {};
	
	_u setVariable ["IWB_inSequence", true, true];
	_u doWatch _tgt;
	
	private _allMags = primaryWeaponMagazine _u;	
	if (
		isNil {_allMags select 1} || 
		( !isNil {_allMags select 1} && { !((_allMags select 1) in dzn_iwb_UGLRoundsList) } )
	) exitWith { 
		_u selectWeapon _priWpn;
		_u setVariable ["IWB_inSequence", false, true];
		_u call dzn_fnc_iwb_GetUnitCombatAttributes;
	};
	
	// Targeting
	private _dist = _u distance _tgt;
	private _distanceError = _dist / (
		if ( (_u getVariable ["IWB_UGL_LastTargetPos", [0,0,0]]) distance _tgt < 50 ) then { 10 } else { 5 }
	);
	private _tgtPos = (getPosATL _u) getPos [
		_dist + random[ -1*_distanceError, (-1*_distanceError)/3, _distanceError]
		, (_u getDir _tgt) + (random[-4,0,4]) 
	];
	
	private _tgtObj = "Land_HelipadEmpty_F" createVehicleLocal _tgtPos;
	_tgtObj setPosATL _tgtPos;	
	
	_u reveal _tgtObj;
	_u doWatch _tgtObj;
	
	// Primary gun
	private _curMagAmmo = _u ammo _priWpn;
	private _mainMag = _allMags select 0;
	private _magCount = { _x == _mainMag } count (magazines _u);	
	for "_i" from 0 to (_magCount - 1) do { _u removeMagazine _mainMag; };
	_u setAmmo [_priWpn, 0];
	
	if (_priWpn != currentWeapon _u) then {	_u selectWeapon _priWpn; sleep 1; };
	_u commandFire _tgtObj;
	
	sleep 2;
	
	_u doWatch objNull;
	_u selectWeapon _priWpn;
	_u addMagazines [_mainMag, _magCount];
	_u setAmmo [_priWpn, _curMagAmmo];
	
	_u setVariable ["IWB_inSequence", false, true];
	_u setVariable ["IWB_UGL_LastTargetPos", getPosATL _tgt];
	deleteVehicle _tgtObj;
	
	if (DEBUG) then { systemChat "Out of sequence"; };
};

dzn_fnc_iwb_HGAttack = {
	params["_u","_tgt"];
	
	_u setVariable ["IWB_inSequence",true,true];
	private _dir = _u getDir _tgt;
	private _dist = _u distance _tgt;
	
	private _intersects = false;
	private _posData = [eyePos _u, getPosASL _u];
	
	{
		private _unitPos = _posData select 1;
		private _xVal = (_unitPos select 0) + ((sin (_dir + _x)) * 5);
		private _yVal = (_unitPos select 1) + ((cos (_dir + _x)) * 5);
		
		{
			if (lineIntersects [_posData select 0, [_xVal, _yVal, (_unitPos select 2) + _x], _u]) exitWith {
				_intersects = true;
			};			
		} forEach [4,5];
	} forEach [0, -1, 1];
	
	if (_intersects) exitWith { _u setVariable ["IWB_inSequence", false, true];	 };

	_u doWatch _tgt;
	_u doTarget _tgt;
	_u setVariable ["IWB_HG_TargetRange", _dist, true];	
	
	private _cancelTimer = time + 1;	
	waitUntil {
		sleep .1;
		abs(_dir - (getDir _u)) < 30 || time > _cancelTimer
	};
	
	private _distanceError = _dist / 10;
	_dir = _dir + random[-1*_distanceError,0,_distanceError];
	
	[_u, _dir] spawn { 
		for "_i" from 0 to 20 do { 
			sleep .025; (_this select 0) setDir (_this select 1); 
		}; 
	};
	
	_u fire (_u getVariable "IWB_HGMuzzle");
	
	sleep 1;
	
	_u selectWeapon (primaryWeapon _u);
	_u switchMove "";
	
	_u setVariable ["IWB_inSequence", false, true];	
};

dzn_fnc_iwb_Suppress = {
	params["_u","_tgt"];	
	_u setVariable ["IWB_inSequence",true,true];
	
	private _tgtPos = selectRandom ([_u, _tgt] call dzn_fnc_iwb_SelectSuppressPos);	
	private _tgtObj = "Land_HelipadEmpty_F" createVehicleLocal _tgtPos;
	_tgtObj setPosASL _tgtPos;
	
	_u reveal _tgtObj;	
	_u doSuppressiveFire _tgtObj;
	sleep round(random [8,10,13]);
	
	deleteVehicle _tgtObj;	
	_u setVariable ["IWB_inSequence", false, true];		
};

dzn_fnc_iwb_SelectSuppressPos = {
	params["_u","_tgt"];
	
	private _unitPos = getPos _u;
	private _dir = _u getDir _tgt;
	private _dist = _u distance _tgt;	
	private _tgtZOffset = (_tgt selectionPosition "pelvis") select 2;
	
	private _suppressPositions = [];	
	{	
		private _tgtCheckPos = _unitPos getPos [
			sqrt(_dist^2 + _x^2)
			, _dir + asin (_x/sqrt(_dist^2 + _x^2))
		];
		_tgtCheckPos set [2, _tgtZOffset];
		_tgtCheckPos = ATLtoASL(_tgtCheckPos);
		
		private _tgtPos = _tgtCheckPos;
		private _intersectedPosition = false;		
		private _intersectTerrainPos = terrainIntersectAtASL [eyePos _u, _tgtCheckPos];
		
		if !(_intersectTerrainPos isEqualTo [0,0,0]) then {
			// Check terrain interference
			_intersectedPosition = true;
			_tgtPos = _intersectTerrainPos;
		} else {
			private _inresectedObjects = lineIntersectsObjs [eyePos _u, _tgtCheckPos, objNull, _u, true];
			if !(_inresectedObjects isEqualTo [])  then {
				// Check objects interfence
				_intersectedPosition = true;
				_tgtPos = _tgtCheckPos;
			};
		};		
		
		if !(_intersectedPosition) exitWith { _suppressPositions = [_tgtPos]; };
		
		_suppressPositions pushBack _tgtPos;	
	} forEach [0,5,-5];

	_suppressPositions
};
