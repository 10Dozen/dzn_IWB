/*
	author: 10Dozen
	description: Do attack using units UGL 
	input: ARRAY - 0: (OBJECT) - Unit, 1: (OBJECT) - Target
	returns: none
	exmple:
		[_unit, _target] spawn dzn_IWCB_fnc_UGLAttack;
*/

#include "..\macro.hpp"
#define DEBUG false

params ["_u", "_tgt"];

// Exit if unit has no primary weapon
private _priWpn = primaryWeapon _u;
if (_priWpn == "") exitWith {};

// Start sequence
_u setVariable [SVAR(inSequence), true, true];
_u doWatch _tgt;
private _uglMuzzle = _u getVariable SVAR(UGLMuzzle);

// Verify that unit still has UGL ammo (AI loads round in UGL, so if no rounds loaded == no rounds left)
private _allMags = primaryWeaponMagazine _u;	
if (
	isNil {_allMags select 1} || 
	( 
		!isNil {_allMags select 1} 
		&& { !((_allMags select 1) in GVAR(UGL_List) } 
	)
) exitWith { 
	// If no ammo -- exit sequence and re-calculate unit's combat attributes
	_u selectWeapon _priWpn;
	_u setVariable [SVAR(inSequence), false, true];
	_u call GVAR(fnc_getUnitCombatAttributes;
};


// Targeting
private _dir = _u getDir _tgt;
private _dist = _u distance _tgt;
private _distanceError = _dist / (
	if ( (_u getVariable [SVAR(UGL_LastTargetPos), [0,0,0]]) distance _tgt < 50 ) then { 10 } else { 5 }
);

private _tgtPos = (getPosATL _u) getPos [
	_dist + random[ -1*_distanceError, (-1*_distanceError)/3, _distanceError]
	, (_u getDir _tgt) + (random[-4,0,4]) 
];
	
private _tgtObj = "Land_HelipadEmpty_F" createVehicleLocal _tgtPos;
_tgtObj setPosATL _tgtPos;
_u reveal _tgtObj;
_u doWatch _tgtObj;
	
// Shooting
_u doTarget _tgtObj;

private _cancelTimer = time + 1;	
waitUntil {
	sleep .1;
	abs(_dir - (getDir _u)) < 30 || time > _cancelTimer
};
_u forceWeaponFire ["GL_3GL_F", "Single"];	
	
// Sequence end
_u doWatch objNull;
_u selectWeapon _priWpn;
_u setVariable [SVAR(inSequence), false, true];
_u setVariable [SVAR(UGL_LastTargetPos), getPosATL _tgt];
deleteVehicle _tgtObj;
	
if (DEBUG) then { systemChat "Out of sequence"; };