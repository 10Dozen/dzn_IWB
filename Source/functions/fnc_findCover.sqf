/*
	author: 10Dozen
	description: Force infantry unit to find cover and sprint to nearest one
	input: OBJECT - unit
	returns: none
	exmple:
		_unit spawn dzn_IWCB_fnc_findCover;
*/
#include "..\macro.hpp"

#define HIGH_PRIORITY_COVERS	["BUILDING","HOUSE","CHURCH","CHAPEL","BUNKER","FORTRESS","FOUNTAIN","HOSPITAL","RUIN","TOURISM","WATERTOWER","POWERSOLAR","POWERWIND" ]
#define LOW_PRIORITY_COVERS		["ROCK","ROCKS","TREE","FOREST","FOREST BORDER","FOREST TRIANGLE","FOREST SQUARE","FENCE","WALL","STACK","RAILWAY"]

private _u = _this;
_u setVariable [SVAR(ICB_MovingInCover), true];

// Searching for cover in 50 meters around (except current unit's cover if already has)
private _nearestCovers = nearestTerrainObjects [getPos _u, HIGH_PRIORITY_COVERS, 50, true, false];
if (_nearestCovers isEqualTo []) then {
	_nearestCovers = nearestTerrainObjects [getPos _u, LOW_PRIORITY_COVERS, 50, true, false];
};
_nearestCovers = _nearestCovers - [_u getVariable SVAR(ICB_Cover)];	

// If No cover found -- do nothing for 5 seconds to prevent uneccessary search for cover
if (_nearestCovers isEqualTo []) exitWith {
	sleep 5;
	_u setVariable [SVAR(ICB_MovingInCover), false];
};

// Select and assign nearest cover
private _cover = _nearestCovers select 0;
_u setVariable ["ICB_Cover", _cover];	

// Force sprint move to cover
_u doMove (getPosATL _cover);
waitUntil { 
	sleep 0.5; 
	_u setAnimSpeedCoef 1.5;
	_u distance (_cover select 0) < 5
};


sleep 2;
_this setVariable [SVAR(ICB_MovingInCover), false];