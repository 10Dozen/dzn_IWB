/*
 *	Infantry Weapon Behavior
 *	v.1
 */
 

if !(isServer) exitWith {};

dzn_iwb_Enabled = profileNamespace getVariable ["IWB_Enabled", true];
if (!dzn_iwb_Enabled) exitWith {};

dzn_iwb_CheckUnitLoopTimeout 		= profileNamespace getVariable ["IWB_UnitCheckTimeout", 45];

dzn_iwb_SpecialAttackChance 		= profileNamespace getVariable ["IWB_AttackChance", 90];
dzn_iwb_SpecialAttackLongTimeout 	= profileNamespace getVariable ["IWB_LongTimer", 40];
dzn_iwb_SpecialAttackShortTimeout	= profileNamespace getVariable ["IWB_ShortTimer", 5];

dzn_iwb_UGLAttackRange = profileNamespace getVariable ["IWB_UGLAttackRange", [25, 300]];

dzn_iwb_UGLRoundsList = profileNamespace getVariable ["IWB_UGLRoundsList", [
	"1Rnd_HE_Grenade_shell"
	,"3Rnd_HE_Grenade_shell"

	,"rhs_VOG25"
	,"rhs_VOG25P"
	,"rhs_VG40TB"
	,"rhs_mag_M441_HE"
	,"rhs_mag_M433_HEDP"
	,"rhs_mag_m4009"
	,"rhs_mag_m576"
	
	
	,"CUP_1Rnd_HE_GP25_M"
	,"CUP_1Rnd_HE_M203"
	,"CUP_1Rnd_HEDP_M203"
]];

call compile preProcessFileLineNumbers "\dzn_IWB\fn.sqf";

publicVariable "dzn_iwb_UGLRoundsList";
publicVariable "dzn_fnc_iwb_GetUnitCombatAttributes";
publicVariable "dzn_fnc_iwb_UGLAttack";

[] spawn {
	waitUntil { time > 0 };
	
	sleep 10;
	
	dzn_iwb_CheckUnits = true;
	dzn_fnc_iwb_CheckUnits = {
		private _allUnits = allUnits select { 
			!(_x getVariable ["IWB_Running",false])
			&& !isPlayer _x
			&& side _x != civilian
		};	
		
		{
			_x setVariable ["IWB_Running",true];
			_x execFSM "\dzn_IWB\IWB.fsm";
			
			sleep 1;
		} forEach _allUnits;
		
		sleep dzn_iwb_CheckUnitLoopTimeout;
		dzn_iwb_CheckUnits = true;
	};
	
	addMissionEventHandler ["EachFrame", {
		if !(dzn_iwb_CheckUnits) exitWith {};
		
		dzn_iwb_CheckUnits = false; 
		[] spawn dzn_fnc_iwb_CheckUnits;
	}];
};
