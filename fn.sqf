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
	private _targets = _u targetsQuery [objNull, sideUnknown, "", [], 0];
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
		[25, 200]
	];
	
	_filteredTargets
};


/**
	Attack Sequences
 **/

dzn_fnc_iwb_UGLAttack = {
	params["_u","_tgt"];
	
	private _priWpn = primaryWeapon _u;
	if (_priWpn == "") exitWith { systemChat "No Primary weapon"; };
	
	_u setVariable ["IWB_inSequence", true];
	_u doWatch _tgt;
	
	if (DEBUG) then { systemChat "Attacking with UGL!"; };	
	
	private _allMags = primaryWeaponMagazine _u;	
	if (
		!isNil {_allMags select 1} 
		&& { !((_allMags select 1) in dzn_iwb_UGLRoundsList) }
	) exitWith { 
		if (DEBUG) then { systemChat "No GL ammo!"; };	
		
		_u selectWeapon _priWpn;
		_u setVariable ["IWB_inSequence", false];
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
	
	_u setVariable ["IWB_inSequence", false];
	if (DEBUG) then { systemChat "Out of sequence"; };
};


///////
dzn_fnc_convertInventoryToLine = {
	// @InventoryArray call dzn_fnc_convertInventoryToLine
	private["_line","_cat","_subCat"];
	#define	linePush(X)		if (_x != "") then {_line pushBack X;};
	_line = [];
	{
		_cat = _x;
		if (typename _cat == "ARRAY") then {
			{
				_subCat = _x;
				if (typename _subCat == "ARRAY") then {
					{
						linePush(_x)
					} forEach _subCat;
				} else {
					linePush(_x)
				};
			} forEach _cat;
		} else {
			linePush(_x)
		};
	} forEach _this;
	
	_line
};

dzn_fnc_showGearTotals = {
	// @ArrayOfTotals call dzn_fnc_gear_editMode_showGearTotals	
	private["_inv","_items","_stringsToShow","_itemName","_headlineItems","_haedlines"];
	
	_inv = _this call BIS_fnc_saveInventory;
	_items = (_inv call dzn_fnc_convertInventoryToLine) call BIS_fnc_consolidateArray;
	
	_stringsToShow = [
		parseText "<t color='#FFD000' size='1' align='center'>GEAR TOTALS</t>"
	];
	
	_headlineItems = [
		(_inv select 0 select 0) call dzn_fnc_getItemDisplayName
		, (_inv select 1 select 0) call dzn_fnc_getItemDisplayName
		, (_inv select 2 select 0) call dzn_fnc_getItemDisplayName
		, (_inv select 3) call dzn_fnc_getItemDisplayName
		, (_inv select 4) call dzn_fnc_getItemDisplayName
		, (_inv select 6 select 0) call dzn_fnc_getItemDisplayName
		, (_inv select 7 select 0) call dzn_fnc_getItemDisplayName
		, (_inv select 8 select 0) call dzn_fnc_getItemDisplayName		
	];
	
	_haedlines = [
		["Uniform:", 	'#3F738F']
		,["Vest:", 		'#3F738F']
		,["Backpack:", 	'#3F738F']
		,["Headgear:", 	'#3F738F']
		,["Goggles:", 	'#3F738F']
		,["Primary:", 	'#059CED']
		,["Secondary:", 	'#059CED']
		,["Handgun:", 	'#059CED']
	];	
	
	{
		_stringsToShow = _stringsToShow + [
			parseText (format [
				"<t color='%2' align='left' size='0.8'>%1</t><t align='right' size='0.8'>%3</t>"
				, toUpper(_x select 0)
				, _x select 1
				, if ((_headlineItems select _forEachIndex) == "") then {"-no-"} else {_headlineItems select _forEachIndex}
			])		
		];		
	} forEach _haedlines;	
	
	{
		
		_itemName = (_x select 0) call dzn_fnc_getItemDisplayName;
		if !(_itemName in _headlineItems) then {
			_stringsToShow = _stringsToShow + [
				if (_x select 1 > 1) then {
					parseText (format ["<t color='#AAAAAA' align='left' size='0.8'>x%1 %2</t>", _x select 1, _itemName])
				} else {
					parseText (format ["<t color='#AAAAAA' align='left' size='0.8'>%1</t>", _itemName])
				}
			];
		};		
	} forEach _items;

	[
		_stringsToShow
		, [35.2,-7.1, 35, 0.03]
		, dzn_gear_GearTotalsBG_RGBA
		, dzn_gear_editMode_arsenalTimerPause
	] call dzn_fnc_ShowMessage;
};