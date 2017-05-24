call compile preProcessFileLineNumbers "\dzn_CENA\settings.sqf";

if (!dzn_CENA_Enabled) exitWith {};

call compile preProcessFileLineNumbers "\dzn_CENA\fn\common.sqf";
call compile preProcessFileLineNumbers "\dzn_CENA\fn\IWB.sqf";

if !(isServer) exitWith {};

publicVariable "dzn_CENA_UGLRoundsList";
publicVariable "dzn_CENA_HGList";

[] spawn {
	waitUntil { time > 10 };
	
	dzn_CENA_CheckUnits = true;
	while { dzn_CENA_Enabled } do {
		private _allUnits = allUnits select { 
			!(_x getVariable ["CENA_Running",false])
			&& vehicle _x == _x
			&& !isPlayer _x
			&& side _x != civilian
		};
		
		{
			_x setVariable ["CENA_Running",true];
			_x execFSM "\dzn_IWB\IWB.fsm";				
			sleep 1;
		} forEach _allUnits;
			
		sleep dzn_CENA_CheckUnitLoopTimeout;	
	};
};
