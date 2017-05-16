/*
 *	Infantry Weapon Behavior
 *	v.2
 */


if !(isServer) exitWith {
	call compile preProcessFileLineNumbers "/dzn_IWB/fn.sqf";
};

dzn_iwb_Enabled 				= profileNamespace getVariable ["IWB_Enabled", true];

if (!dzn_iwb_Enabled) exitWith {};

dzn_iwb_CheckUnitLoopTimeout 		= profileNamespace getVariable ["IWB_UnitCheckTimeout", 45];
dzn_iwb_SpecialAttackChance 		= profileNamespace getVariable ["IWB_AttackChance", 90];
dzn_iwb_SpecialAttackLongTimeout 		= profileNamespace getVariable ["IWB_LongTimer", 40];
dzn_iwb_SpecialAttackShortTimeout		= profileNamespace getVariable ["IWB_ShortTimer", 5];

// Underbarrel Grenade Launcher
dzn_iwb_UGLAttackRange = profileNamespace getVariable ["IWB_UGLAttackRange", [25, 325]];
dzn_iwb_UGLRoundsList = profileNamespace getVariable ["IWB_UGLRoundsList", [
	"1Rnd_HE_Grenade_shell","3Rnd_HE_Grenade_shell"
	,"rhs_VOG25","rhs_VOG25P","rhs_VG40TB","rhs_mag_M441_HE","rhs_mag_M433_HEDP","rhs_mag_m4009","rhs_mag_m576"
	,"CUP_1Rnd_HE_GP25_M","CUP_1Rnd_HE_M203","CUP_1Rnd_HEDP_M203"
]];

// Hand Grenades
dzn_iwb_HGAttackRange = profileNamespace getVariable ["IWB_HGAttackRange", [10, 40]];
dzn_iwb_HGList = profileNamespace getVariable ["IWB_HGList", [
	["ACE_M14","ACE_M14Muzzle"]
	,["CUP_HandGrenade_L109A1_HE","HandGrenadeMuzzle"]
	,["HandGrenade","HandGrenadeMuzzle"]
	,["CUP_HandGrenade_M67","HandGrenadeMuzzle"]
	,["CUP_HandGrenade_L109A2_HE","HandGrenadeMuzzle"]
	,["CUP_HandGrenade_RGD5","HandGrenadeMuzzle"]
	,["CUP_HandGrenade_RGO","HandGrenadeMuzzle"]
	,["MiniGrenade","MiniGrenadeMuzzle"]
	,["rhs_mag_rgd5","Rhs_Throw_Grenade"]
	,["rhs_mag_rgn","Rhs_Throw_RgnGrenade"]
	,["rhs_mag_rgo","Rhs_Throw_RgoGrenade"]
	,["rhs_mag_fakel","Rhs_Throw_Flash_fakel"]
	,["rhs_mag_fakels","Rhs_Throw_Flash_fakels"]
	,["rhs_mag_zarya2","Rhs_Throw_Flash_zarya2"]
	,["rhs_mag_plamyam","Rhs_Throw_Flash_plamyam"]
	,["rhs_mag_mk84","Rhsusf_Throw_Flash"]
	,["rhs_mag_m67","Rhsusf_Throw_Grenade"]
	,["rhs_mag_mk3a2","Rhsusf_Throw_Grenade"]
	,["rhs_mag_m69","Rhsusf_Throw_Grenade"]
	,["rhs_mag_an_m14_th3","Rhsusf_Throw_Incendenary"]
	,["rhs_mag_m7a3_cs","Rhsusf_Throw_CS"]
	,["ACE_M84","ACE_M84Muzzle"]
]];

// Support weapon (MGs)
dzn_iwb_SWAttackRange = profileNamespace getVariable ["IWB_HGAttackRange", [5, 500]];


call compile preProcessFileLineNumbers "/dzn_IWB/fn.sqf";

publicVariable "dzn_iwb_UGLRoundsList";
publicVariable "dzn_iwb_HGList";

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
			_x execFSM "/dzn_IWB/IWB.fsm";
			
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
