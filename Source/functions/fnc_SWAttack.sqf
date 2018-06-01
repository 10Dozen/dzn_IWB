/*
	author: 10Dozen
	description: Do suppression attack using units primary weapon
	input: ARRAY - 0: (OBJECT) - Unit, 1: (OBJECT) - Target
	returns: none
	exmple:
		[_unit, _target] spawn dzn_IWCB_fnc_SWAttack;
*/

#include "..\macro.hpp"
#define DEBUG false

params["_u","_tgt"];
_u setVariable [SVAR(inSequence),true,true];

// Targeting
private _tgtPos = selectRandom ([_u, _tgt] call GVAR(fnc_selectSuppressPos));
private _tgtObj = "Land_HelipadEmpty_F" createVehicleLocal _tgtPos;
_tgtObj setPosASL _tgtPos;
_u reveal _tgtObj;

// Firing
_u doSuppressiveFire _tgtObj;
sleep round(random [8,10,13]);

// Exiting sequence
deleteVehicle _tgtObj;
_u setVariable [SVAR(inSequence),false,true];