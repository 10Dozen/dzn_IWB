/*
	author: 10Dozen
	description: Runs ICB behavior for given unit
	input: OBJECT - unit
	returns: none
	exmple:
		_unit spawn dzn_IWCB_fnc_startICB;
*/
#include "..\macro.hpp"

if (_this getVariable [SVAR(ICB_Disable), false]) exitWith {};
if (_this getVariable [SVAR(ICB_Running), false]) exitWith {};

if (!local _this) exitWith {
	_this remoteExec [SVAR(fnc_startICB),_this];
};

private _u = _this;

_u setVariable [SVAR(ICB_Running), true, true];
_u setVariable [SVAR(ICB_Suppressed), false]; // Used in IWB fired handler to add additional dispersion
_u setVariable [SVAR(ICB_Cover), objNull];
_u setVariable [SVAR(ICB_Skills), [
	_u skill "aimingAccuracy"
	, _u skill "aimingShake"
	, _u skill "aimingSpeed"
	, _u skill "reloadSpeed"
]];
	
while { alive _u } do {
	if (
		GVAR(ICB_Enabled)
		&& simulationEnabled _u
		&& vehicle _u == _u
		&& side _u != civilian
		&& {
			!(_u getVariable ["dzn_dynai_isCached", false])			
			&& !(_u getVariable ["ACE_isUnconscious", false])
			&& !(_u getVariable ["ACE_isSurrendering", false])
			&& !(_u getVariable ["ACE_isHandcuffed", false])
		}
	) then {
		if (
			( 
				( getSuppression _u > 0 && isNull (_u getVariable SVAR(ICB_Cover)) ) 
				|| (getSuppression _u > 0.75) 
			)
			&& !(_u getVariable [SVAR(ICB_MovingInCover), false])
		) then {
			if (GVAR(ICB_AllowFindCover)) then {
				_u spawn GVAR(fnc_findCover);
			};
			
			if !(combatMode (group _u) in ["RED","YELLOW"]) then {
				(group _u) setCombatMode "RED";
				(group _u) setSpeedMode "FULL";
			};
		};
		
		if (GVAR(ICB_AllowSuppressed)) then {
			_u call GVAR(fnc_provideSuppressEffect);
		};
	};
	
	sleep 1;
};