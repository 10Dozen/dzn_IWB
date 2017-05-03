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



/* **************** */
/* Functions
/* **************** */
dzn_fnc_iwb_GetUnitCombatAttributes = {
	private _u = _this;
	private _hasUGL = false;
	
	private _muzzles = (getArray(configFile >> "cfgWeapons" >> primaryWeapon _u >> "muzzles")) - ["SAFE"];
	if ( 
		count _muzzles > 1 
		&& count (primaryWeaponMagazine _u) > 1 
		&& { (primaryWeaponMagazine _u select 1) in dzn_iwb_UGLRoundsList }
	) then { 
		_hasUGL = true;
	};
	
	_u setVariable ["IWB_UGL", _hasUGL, true];
};

dzn_fnc_iwb_SelectAttackAndTarget = {
	private _u = _this;
	
	if (_u getVariable ["IWB_inSequence", false]) exitWith {
		if (DEBUG) then { systemChat "SelectAttack: Sequence in progress"; };
		[false, objNull, ""]	
	};
	
	private _chance = random(100);
	if ( _chance > dzn_iwb_SpecialAttackChance ) exitWith { 
		if (DEBUG) then { systemChat format ["SelectAttack: No % chance ( %1 )", _chance]; };
		[false, objNull, ""]	
	};
	
	private _modes = ["IWB_UGL"] select { _u getVariable [_x, false] };
	if (_modes isEqualTo []) exitWith {  
		if (DEBUG) then { systemChat format ["SelectAttack: No modes available ( %1 )", _modes]; };
		[false, objNull, ""]
	};
	
	private _targets = _u call dzn_fnc_iwb_GetTargets;
	if (_targets isEqualTo []) exitWith { 
		if (DEBUG) then { systemChat format ["SelectAttack: Targets ( %1 )", _tgts]; };
		[false, objNull, ""]
	};
	
	#define IN_MODES(X)	(X in _modes)
	#define HAS_TGTS(X)	!((_targets select X) isEqualTo [])
	#define GET_TGT(X)	(selectRandom (_targets select X)) select 1
	
	if (IN_MODES("IWB_UGL") && { HAS_TGTS(0) }) exitWith {	
		private _tgt = GET_TGT(0);
		if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_UGL ( %1 )", _tgt]; };
		[true, _tgt, "IWB_UGL"]
	};
	
	[false, objNull, ""]
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
			}		
		);
	} forEach [ 
		dzn_iwb_UGLAttackRange
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
	};
	
	[_u, _sequenceParams] remoteExec [_seqFunction, _u];	
};

dzn_fnc_iwb_UGLAttack = {
	params["_u","_tgt"];
	
	private _priWpn = primaryWeapon _u;
	if (_priWpn == "") exitWith { systemChat "No Primary weapon"; };
	
	_u setVariable ["IWB_inSequence", true, true];
	_u doWatch _tgt;
	
	if (DEBUG) then { systemChat "Attacking with UGL!"; };	
	
	private _allMags = primaryWeaponMagazine _u;	
	if (
		!isNil {_allMags select 1} 
		&& { !((_allMags select 1) in dzn_iwb_UGLRoundsList) }
	) exitWith { 
		if (DEBUG) then { systemChat "No GL ammo!"; };	
		
		_u selectWeapon _priWpn;
		_u setVariable ["IWB_inSequence", false, true];
		_u call dzn_fnc_iwb_GetUnitCombatAttributes;
	};
	
	// Primary gun
	private _curMagAmmo = _u ammo _priWpn;
	private _mainMag = _allMags select 0;
	private _magCount = { _x == _mainMag } count (magazines _u);	
	for "_i" from 0 to (_magCount - 1) do { _u removeMagazine _mainMag; };
	_u setAmmo [_priWpn, 0];
	
	if (_priWpn != currentWeapon _u) then {
		_u selectWeapon _priWpn;
		sleep 1;
	};
	
	_u commandFire _tgt;
	
	sleep 3;
	
	_u doWatch objNull;
	_u selectWeapon _priWpn;
	_u addMagazines [_mainMag, _magCount];
	_u setAmmo [_priWpn, _curMagAmmo];
	
	_u setVariable ["IWB_inSequence", false, true];
	if (DEBUG) then { systemChat "Out of sequence"; };
};

