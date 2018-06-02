/*
	author: 10Dozen
	description: Do attack using units Hand grenades 
	input: ARRAY - 0: (OBJECT) - Unit, 1: (OBJECT) - Target
	returns: none
	exmple:
		[_unit, _target] spawn dzn_IWCB_fnc_attackByHG;
*/

#include "..\macro.hpp"
#define DEBUG false

params ["_u", "_tgt"];

// Start sequence
_u setVariable [SVAR(inSequence),true,true];

private _dir = _u getDir _tgt;
private _dist = (_u distance _tgt) max 15;
private _intersects = false;
private _eyePos = eyePos _u;
private _uPos = getPosASL _u;

// Check unit or target is inside building (under the roof) and cancel attack OR check collisions in front of the target
if (
	lineIntersects [_eyePos, [_uPos select 0, (_uPos select 1), (_uPos select 2) + 16], _u]
	|| lineIntersects [getPosASL _tgt, [(getPosASL _tgt) select 0, ((getPosASL _tgt) select 1), ((getPosASL _tgt) select 2) + 16], _tgt]
) then {
	_intersects = true;
} else {
	{
		private _xVal = (_uPos select 0) + ((sin (_dir + _x)) * 5);
		private _yVal = (_uPos select 1) + ((cos (_dir + _x)) * 5);		
		{
			if (lineIntersects [_eyePos, [_xVal, _yVal, (_uPos select 2) + _x], _u]) exitWith {
				_intersects = true;
			};			
		} forEach [4,5];
	} forEach [0, -1, 1];
};

// Expected greande trajectory colides with object -- cancel attack
if (_intersects) exitWith { _u setVariable [SVAR(inSequence), false, true]; };

// Targeting
_u doWatch _tgt;
_u doTarget _tgt;
_u setVariable [SVAR(HG_TargetRange), _dist, true];

private _cancelTimer = time + 1;	
waitUntil {
	sleep .5;
	abs(_dir - (getDir _u)) < 30 || time > _cancelTimer
};

// Enforcement of unit direction to make throw in required direction
private _distanceError = _dist / 10;
_dir = _dir + random[-1*_distanceError,0,_distanceError];
	
[_u, _dir] spawn { 
	for "_i" from 0 to 20 do { 
		sleep .025; (_this select 0) setDir (_this select 1); 
	}; 
};


// Attack
_u forceWeaponFire [_u getVariable SVAR(HGMuzzle), _u getVariable SVAR(HGMuzzle)];

// Sequence end
sleep 1;
_u selectWeapon (primaryWeapon _u);
_u doWatch objNull;
_u doTarget objNull;
	
_u setVariable [SVAR(inSequence), false, true];	