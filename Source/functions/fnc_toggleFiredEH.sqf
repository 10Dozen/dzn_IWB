/*
	author: 10Dozen
	description: Turn on/off Fired EH 
	input: ARRAY - 0: (OBJECT) - Unit, 1: (BOOLEAN) - true to ADD, false to REMOVE
	returns: none
	exmple:
		[_unit, true] call dzn_IWCB_fnc_toggleFiredEH;
*/

#include "..\macro.hpp"

params ["_u", "_add"];

if (!local _u) exitWith {
	_this remoteExec [SVAR(fnc_toggleFiredEH), _u];
};

private _eh = _u getVariable [SVAR(Fired_EH), -1];

if (_add) then {
	_eh = _u addEventHandler ["Fired", GVAR(fnc_firedEH)];	
	_u setVariable [SVAR(Fired_EH), _eh];
} else {
	_u removeEventHandler ["Fired", _eh];
	_u setVariable [SVAR(Fired_EH), nil];
};