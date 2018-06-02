/*
	author: 10Dozen
	description: Parse input data in foramt "@Min-@Max" (e.g. "15-55") to array in format [@Min,@Max] and create global variable with given name
	input: ARRAY - 0: (STRING) Variable name, 1: (STRING) Variable new value
	returns: nothing
	exmple:
		["dzn_IWCB_Timeout", "15-30"] call dzn_IWCB_fnc_updateRangedValues
*/

params ["_varName", "_val"];

#define DEFAULT_VAL  [15,17,30]

private _vals = (_val splitString "-") apply { parseNumber _x };
private _newVal =  switch (count _vals) do {
	case 1: { [_vals select 0, _vals select 0] };
	case 2: { [_vals select 0, _vals select 1] };
	default { DEFAULT_VAL };
};

if (_newVal isEqualTo [0,0] || _newVal isEqualTo DEFAULT_VAL) exitWith { hint "Wrong setting value! Should be in format ""10-30"""; };
if (_newVal select 0 > _newVal select 1) exitWith { hint "Wrong setting value! Should be in format ""@Min - @Max"""; };

call compile format ["%1 = %2", _varName, _newVal];