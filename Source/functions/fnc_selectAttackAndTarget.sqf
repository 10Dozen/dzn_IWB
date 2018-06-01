/*
	author: 10Dozen
	description: Select target and attack type for unit and check attack chance
	input: OBJECT - unit
	returns: ARRAY - 0: (BOOLEAN) - Attack allowed, 1: (OBJECT) - Target, 2: (STRING) - Attack type (same as unit combat attribute)
	exmple:
		_unit call dzn_IWCB_fnc_selectAttackAndTarget;
*/
#include "..\macro.hpp"
#define	DEBUG		false
#define	NO_ATTACK	[false, objNull, ""]	

private _u = _this;

// Exit if unit is not simulated/not able to make actions
if (
	!simulationEnabled _u
	|| vehicle _u != _u
	|| side _u == civilian
	
	|| _u getVariable ["dzn_dynai_isCached", false]	
	|| _u getVariable ["ACE_isUnconscious", false]
	|| _u getVariable ["ACE_isSurrendering", false]
	|| _u getVariable ["ACE_isHandcuffed", false]
) exitWith {
	if (DEBUG) then { systemChat "SelectAttack: Unit cached/not simulated!"; };
	NO_ATTACK
};

// Exit if already doing action
if (_u getVariable [SVAR(inSequence), false]) exitWith {
	if (DEBUG) then { systemChat "SelectAttack: Sequence in progress"; };
	NO_ATTACK
};

// Calculate chance of attack
//
//	How it's work in general:
//	Get random chance (e.g. 83) and compate it with chance limit per each attack type (UGL, HG, SW) and overall chance.
//	If all fails - exit with no attack; if anything is ok -- check if unit has special attack ability at current time (exit if not).
//	Now looks for a targets (because it's more performance heavy) and assosiate targets to special attack (by distance)
//	If there are targets exists for unit's available special attacks - it will be engaged.

// Get random and check for each attack type
private _overallChance = random(100);
private _attackChanceByType = [
	_overallChance <= GVAR(UGL_Chance)
	, _overallChance <= GVAR(HG_Chance)
	, _overallChance <= GVAR(SW_Chance)	
];

// Compare with overall chance (e.g. random return 92, Overall chacne is 50 and UGL chacne is 100 -- no attack happens -- 92 > 50)
if ( 
	_overallChance > GVAR(IWB_SpecialAttackChance)
	|| (_attackChanceByType select { true }) isEqualTo [] 
) exitWith { 
	if (DEBUG) then { systemChat format ["SelectAttack: No % chance ( %1 )", _overallChance]; };
	NO_ATTACK
};
	
// Check is unit able to use special attacks
private _modes = ["IWB_UGL","IWB_HG","IWB_SW"] select { _u getVariable [_x, false] };
if (_modes isEqualTo []) exitWith {  
	if (DEBUG) then { systemChat format ["SelectAttack: No modes available ( %1 )", _modes]; };
	NO_ATTACK
};

// Get targets
private _targets = _u call GVAR(fnc_getTargets);
if (_targets isEqualTo []) exitWith { 
	if (DEBUG) then { systemChat format ["SelectAttack: Targets ( %1 )", _tgts]; };
	NO_ATTACK
};

// Select target and attack type with apporpriate chance	
#define IN_MODES(X)	(X in _modes)
#define HAS_TGTS(X)	!((_targets select X) isEqualTo [])
#define GET_TGT(X)	(selectRandom (_targets select X)) select 1
	
if (IN_MODES("IWB_UGL") && (_attackChanceByType select 0) && { HAS_TGTS(0) }) exitWith {	
	private _tgt = GET_TGT(0);
	if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_UGL ( %1 )", _tgt]; };
	[true, _tgt, "IWB_UGL"]
};

if (IN_MODES("IWB_HG") && (_attackChanceByType select 1) && { HAS_TGTS(1) }) exitWith {	
	private _tgt = GET_TGT(1);
	if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_HG ( %1 )", _tgt]; };
	[true, _tgt, "IWB_HG"]
};
	
if (IN_MODES("IWB_SW") && (_attackChanceByType select 2) && { HAS_TGTS(2) }) exitWith {	
	private _tgt = GET_TGT(2);
	if (DEBUG) then { systemChat format ["SelectAttack: Attack mode is IWB_SW ( %1 )", _tgt]; };
	[true, _tgt, "IWB_SW"]
};

NO_ATTACK