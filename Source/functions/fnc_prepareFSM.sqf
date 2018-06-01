/*
	author: 10Dozen
	description: 
	input: NAMESPACE - FSM namespace
	returns: none
	exmple:
		_fsmNamespace spawn dzn_IWCB_fnc_findCover;
*/
#include "..\macro.hpp"

_this setFSMVariable ["_fnc_setLongTimeout", {
	// Set up long FSM timeout
	_this setVariable [SVAR(LongTimeoutDone), false];
	_this spawn {
		sleep GVAR(IWB_SpecialAttackLongTimeout);
		_this setVariable [SVAR(LongTimeoutDone), true];
	};
}];

_this setFSMVariable ["_fnc_setShortTimeout", {
	// Set up short FSM timeout
	_this setVariable [SVAR(ShortTimeoutDone), false];
	_this spawn {
		sleep GVAR(IWB_SpecialAttackShortTimeout);
		_this setVariable [SVAR(ShortTimeoutDone), true];
	};
}];

_this setFSMVariable ["_fnc_getLongTimeoutDone", {
	// Return state of FSM long timeout
	_this getVariable [SVAR(LongTimeoutDone),false]
}];

_this setFSMVariable ["_fnc_getShortTimeoutDone", {
	// Return state of FSM short timeout
	_this getVariable [SVAR(ShortTimeoutDone),false]
}];

_this setFSMVariable ["_fnc_toggleFiredEH", GVAR(fnc_toggleFiredEH)];
_this setFSMVariable ["_fnc_getUnitCombatAttributes", GVAR(fnc_getUnitCombatAttributes)];
_this setFSMVariable ["_fnc_selectAttackAndTarget", GVAR(fnc_selectAttackAndTarget)];
_this setFSMVariable ["_fnc_getTargets", GVAR(fnc_getTargets)];
_this setFSMVariable ["_fnc_runAttackSequenceRemote", GVAR(fnc_runAttackSequenceRemote)];
_this setFSMVariable ["_fnc_toggleForUnit", GVAR(fnc_toggleForUnit)];

_this setFSMVariable ["_fsmPrepared", true];