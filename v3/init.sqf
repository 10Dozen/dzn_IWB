/*
 *	Infantry Weapon Behavior
 *	v.3
 */

call compile preProcessFileLineNumbers "\dzn_IWB\IWB Functions.sqf";
call compile preProcessFileLineNumbers "\dzn_IWB\ICB Functions.sqf";

if !(isServer) exitWith {};

[] spawn {
	waitUntil { time > 0 };
	
	sleep 10;
	
	dzn_iwb_CheckUnits = true;
	addMissionEventHandler ["EachFrame", {
		if !(dzn_iwb_CheckUnits && dzn_iwb_Enabled) exitWith {};
		
		dzn_iwb_CheckUnits = false; 
		[] spawn {
			private _allUnits = allUnits select { 
				!(_x getVariable ["IWB_Running",false])
				&& !(_x getVariable ["IWB_Disable",false])
				&& vehicle _x == _x
				&& !isPlayer _x
				&& side _x != civilian
			};
			
			{
				_x call dzn_fnc_iwb_EnableUnit;
				_x execFSM "\dzn_IWB\IWB.fsm";
				
				sleep 1;
			} forEach _allUnits;
			
			sleep dzn_iwb_CheckUnitLoopTimeout;
			dzn_iwb_CheckUnits = true;
		};
	}];
};
