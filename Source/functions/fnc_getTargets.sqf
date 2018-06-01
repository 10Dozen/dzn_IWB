/*
	author: 10Dozen
	description: Return list of targets per each special attack range 
	input: OBJECT - Unit
	returns: none
	exmple:
		_targets = _unit call dzn_IWCB_fnc_getTargets;
*/
#include "..\macro.hpp"

private _u = _this;
	
private _filteredTargets = [];
private _targets = (_u targetsQuery [objNull, sideEnemy, "", [], 0]) select { 
	[side _u, _x select 2] call BIS_fnc_sideIsEnemy 
};

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
	GVAR(UGL_Range)
	, GVAR(HG_Range)
	, GVAR(SW_Range)
];

_filteredTargets