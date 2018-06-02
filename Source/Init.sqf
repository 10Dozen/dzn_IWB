/*
	U1 call dzn_IWCB_fnc_getUnitCombatAttributes;
	[U1, true] call dzn_IWCB_fnc_toggleFiredEH;
	
	[U2, player, "HG"] call dzn_IWCB_fnc_runAttackSequenceRemote
*/

enableSaving [false,false];

#include "macro.hpp"

/*
 *	Infantry Weapon and Combat Behavior
 *	v.1
 */
GVAR(Version) 	= "v.1";

// Variables
GVAR(HG_Range) 	= [0,0];
GVAR(UGL_Range) = [0,0];
GVAR(SW_Range) 	= [0,0];

GVAR(HG_List) 	= [];
GVAR(UGL_List) 	= [];

#include "Functions.sqf"
#include "Settings.sqf"

if !(isServer) exitWith {};

/*
[] spawn {
	waitUntil { time > 0 };
	waitUntil { GVAR(IWB_Enabled) || GVAR(ICB_Enabled) };
	sleep 10;
	
	GVAR(CheckUnits) = true;
	while { GVAR(CheckUnits) } do {
		private _allUnits = allUnits select {
			!isPlayer _x
			&& vehicle _x == _x
			&& side _x != civilian
			&& !(_x getVariable [SVAR(Running), false])
			&& !(_x getVariable [SVAR(Disable), false])
		};
		
		{
			private _u = _x;
			
			if (GVAR(IWB_Enabled)) then {
				_u call GVAR(fnc_startIWB);
			};
			
			if (GVAR(ICB_Enabled)) then {
				_u call GVAR(fnc_startICB);			
			};
			
			sleep random [0.5,1,2];
		} forEach _allUnits;
	
		sleep GVAR(CheckUnitLoopTimeout);
	};
};
*/