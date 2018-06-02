/*
	author: 10Dozen
	description: Executes attack sequence on current or remote machine according to unit locality
	input: ARRAY - 0: (OBJECT) Unit, 1: (OBJECT) Target, 2: (STRING) Attack type
	returns: nothing
	exmple:
		[_unit, _tgt, "UGL"] call dzn_IWCB_fnc_runAttackSequenceRemote
*/
#include "..\macro.hpp"
params ["_u", "_tgt", "_sequenceName"];
	
private _seqFunction = switch toUpper(_sequenceName) do {
	case "UGL": { SVAR(fnc_attackByUGL) };
	case "HG": { SVAR(fnc_attackByHG) };
	case "SW": { SVAR(fnc_attackBySW) };
};
	
[_u, _tgt] remoteExec [_seqFunction, _u];	