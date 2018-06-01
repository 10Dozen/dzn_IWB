/*
	author: 10Dozen
	description: Return positions to suppress -- exact target position or side of the cover if target hidding
	input: ARRAY - 0: (OBJECT) - Unit, 1: (OBJECT) - Target
	returns: none
	exmple:
		[_unit, _target] spawn dzn_IWCB_fnc_selectSuppressPos;
*/

#include "..\macro.hpp"
#define DEBUG false

params["_u","_tgt"];

private _unitPos = getPos _u;
private _dir = _u getDir _tgt;
private _dist = _u distance _tgt;	
private _tgtZOffset = (_tgt selectionPosition "pelvis") select 2;

// Check positions to the left, exact and to the right from the target
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