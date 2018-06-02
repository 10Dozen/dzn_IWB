/*
	author: 10Dozen
	description: Toggle IWB state
	input: OBJECT - unit
	returns: none
	exmple:
		_unit call dzn_IWCB_fnc_toggleForUnit;
*/
#include "..\macro.hpp"

params ["_u", "_enable"];

_u setVariable [SVAR(Running), false, true];
_u setVariable [SVAR(Disable), !_enable, true];