/*
	author: 10Dozen
	description: Runs IWB FSM for given unit
	input: OBJECT - unit
	returns: none
	exmple:
		_unit call dzn_IWCB_fnc_startIWB;
*/
#include "..\macro.hpp"

if (_this getVariable [SVAR(IWB_Disable), false]) exitWith {};

_this setVariable [SVAR(Running), true];
private _fsmNamespace = _this execFSM "IWB.fsm";
_fsmNamespace call GVAR(fnc_prepareFSM);