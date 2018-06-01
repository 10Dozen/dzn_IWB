/*
	author: 10Dozen
	description: Check unit's state (amount of grenades, UGLs and MG) and update unit's IWCB variables
	input: OBJECT - unit
	returns: none
	exmple:
		_unit call dzn_IWCB_fnc_getUnitCombatAttributes;
*/
#include "..\macro.hpp"

private _u = _this;

private _hasUGL = false;
private _hasGrenades = false;
private _hasSupportWeapon = false;

// Get weapones of unit
private _muzzles = (getArray(configFile >> "cfgWeapons" >> primaryWeapon _u >> "muzzles")) - ["SAFE"];

// Check that unit has UGL 
if ( 
	count _muzzles > 1 
	&& count (primaryWeaponMagazine _u) > 1 
	&& { (primaryWeaponMagazine _u select 1) in GVAR(UGL_List) }
) then { 
	_hasUGL = true;
	_u setVariable [SVAR(UGLMuzzle), _muzzles select 1, true];
};

// Check for Hand grenades
private _mags = itemsWithMagazines _u;	
{ 
	if ((_x select 0) in _mags) exitWith { 
		_u setVariable [SVAR(HGMuzzle), _x select 1, true];
		_hasGrenades = true;
	};
} forEach GVAR(HG_List);
	
// Check weapons with big magazine (>30 rounds)
_hasSupportWeapon = getNumber (configFile >> "CfgMagazines" >> currentMagazine _u >> "count") > 30;

// Set variables
_u setVariable ["IWB_UGL", (GVAR(UGL_Allowed) && _hasUGL), true];
_u setVariable ["IWB_HG", (GVAR(HG_Allowed) && _hasGrenades), true];
_u setVariable ["IWB_SW", (GVAR(SW_Allowed) && _hasSupportWeapon), true];