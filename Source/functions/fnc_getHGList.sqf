/*
	author: 10Dozen
	description: Return list of Grenade Magazine - Grenade Muzzle pairs according to given whitelist and current ingame config
	input: ARRAY - list of grenade magazine classes
	returns: ARRAY - paired array of Grenade magazine - @Grenade muzzle
	exmple:
		_list = "HandGrenade", "MiniGrenade"] call dzn_IWCB_fnc_getHGList; // [ ["HandGrenade", "HandGrenadeMuzzle"], ["MiniGrenade", "HandGrenadeMuzzle"]]
*/

private _whitelist = _this;
private _throwMuzzles = getArray (configFile >> "CfgWeapons" >> "Throw" >> "muzzles");
private _result = [];

{
	private _muzzle = _x;
	private _mags = getArray (configFile >> "CfgWeapons" >> "Throw" >> _muzzle >> "magazines");
	
	{
		if (_x in _whitelist) then { _result pushBack [_x, _muzzle]; };
	} forEach _mags;
} forEach _throwMuzzles;

_result