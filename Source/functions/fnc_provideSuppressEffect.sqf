/*
	author: 10Dozen
	description: Handle additional suppress effects
	input: OBJECT - unit
	returns: none
	exmple:
		_unit spawn dzn_IWCB_fnc_provideSuppressEffect;
*/
#include "..\macro.hpp"

private _u = _this;

private _supression = if (!isNil {getSuppression _u}) then { getSuppression _u } else { 0 };
_u setUnitPos "AUTO";
	
if (_supression < 0.2) exitWith {
	[_u, 1] call GVAR(fnc_setSkillAffected);
	_u setVariable [SVAR(ICB_Suppressed), false];
};

_u setVariable [SVAR(ICB_Suppressed), true];

switch (true) do {
	case (_supression > 0.5): {
		[_u, 0.5] call GVAR(fnc_setSkillAffected);
	};
	case (_supression > 0.7): {
		[_u, 0.25] call GVAR(fnc_setSkillAffected);
	};
	case (_supression > 0.9): {			
		[_u, 0] call GVAR(fnc_setSkillAffected);
		_u doTarget objNull;
		_u setUnitPos "DOWN";
	};
};
