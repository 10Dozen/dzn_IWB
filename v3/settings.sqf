/*
 *	Combat Enhanced AI (CENA)
 *	v.3
 */

dzn_CENA_Enabled 				= profileNamespace getVariable ["CENA_Enabled", true];

if (!dzn_CENA_Enabled) exitWith {};

dzn_CENA_CheckUnitLoopTimeout 		= profileNamespace getVariable ["CENA_UnitCheckTimeout", 45];
dzn_CENA_SpecialAttackChance 		= profileNamespace getVariable ["CENA_AttackChance", 80];
dzn_CENA_SpecialAttackLongTimeout 		= profileNamespace getVariable ["CENA_LongTimer", 40];
dzn_CENA_SpecialAttackShortTimeout		= profileNamespace getVariable ["CENA_ShortTimer", 10];

// Underbarrel Grenade Launcher
dzn_CENA_UGLAttackRange 			= profileNamespace getVariable ["CENA_UGLAttackRange", [35, 325]];
dzn_CENA_UGLRoundsList 			= profileNamespace getVariable ["CENA_UGLRoundsList", [
	"1Rnd_HE_Grenade_shell","3Rnd_HE_Grenade_shell"
	,"rhs_VOG25","rhs_VOG25P","rhs_VG40TB","rhs_mag_M441_HE","rhs_mag_M433_HEDP","rhs_mag_m4009","rhs_mag_m576"
	,"CUP_1Rnd_HE_GP25_M","CUP_1Rnd_HE_M203","CUP_1Rnd_HEDP_M203"
]];

// Hand Grenades
dzn_CENA_HGAttackRange 			= profileNamespace getVariable ["CENA_HGAttackRange", [10, 40]];
dzn_CENA_HGList 				= profileNamespace getVariable ["CENA_HGList", [
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
dzn_CENA_MGAttackRange 			= profileNamespace getVariable ["CENA_HGAttackRange", [35, 500]];
