/*
	author: 10Dozen
	description: Do attack using units UGL 
	input: ARRAY - 0: (OBJECT) - Unit, 1: (OBJECT) - Target
	returns: none
	exmple:
		[_unit, _target] spawn dzn_IWCB_fnc_attackByUGL;
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

// Verify that unit still has UGL ammo (AI loads round in UGL, so if no rounds loaded == no rounds left)
private _allMags = primaryWeaponMagazine _u;
hint format ["UGL: Check %1 and %2", isNil {_allMags select 1}, !((_allMags select 1) in GVAR(UGL_List))];

if (
	isNil {_allMags select 1}
	|| !( (_allMags select 1) in GVAR(UGL_List) )
) exitWith {
	
	// If no ammo -- exit sequence and re-calculate unit's combat attributes
	_u setVariable [SVAR(inSequence), false, true];
	_u selectWeapon _priWpn;
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

sleep 1.25;
private _cancelTimer = time + 1.5;
waitUntil {
	sleep .1;
	abs(_dir - (getDir _u)) < 15 || time > _cancelTimer
};
_u forceWeaponFire [_u getVariable SVAR(UGLMuzzle), "Single"];	
	
// Sequence end
_u doWatch objNull;
_u selectWeapon _priWpn;
_u setVariable [SVAR(inSequence), false, true];
_u setVariable [SVAR(UGL_LastTargetPos), getPosATL _tgt];
deleteVehicle _tgtObj;
	
if (DEBUG) then { systemChat "Out of sequence"; };