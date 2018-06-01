/*
	author: 10Dozen
	description: Affect skill of suppressed unit
	input: ARRAY - 0: (OBJECT) - Unit, 1: (SCALAR) - Skill level value
	returns: none
	exmple:
		[_unit, 0.5] spawn dzn_IWCB_fnc_setSkillAffected;
*/
#include "..\macro.hpp"

params ["_u", "_skillMultiplier"];
	
{
	_u setSkill [
		_x
		, ((_u getVariable SVAR(ICB_Skills)) select _forEachIndex) * _skillMultiplier
	];
} forEach [
	"aimingAccuracy"
	, "aimingShake"
	, "aimingSpeed"
	, "reloadSpeed"
];