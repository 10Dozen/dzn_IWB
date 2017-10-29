/*
 *	Infantry Weapon Behavior
 *	v.3
 */

dzn_iwb_UGLAttackRange		= [35, 325];
dzn_iwb_HGAttackRange		= [15, 35];
dzn_iwb_SWAttackRange		= [35, 500];

// CBA Settings

["dzn_iwb_Enabled", "CHECKBOX", "Enabled", "Infantry Weapon Behavior", true, true] call CBA_Settings_fnc_init;
["dzn_iwb_SpecialAttackChance", "SLIDER", "Overall Attack chance", "Infantry Weapon Behavior", [1, 100, 60, 0], true] call CBA_Settings_fnc_init;

// UGL Attack
["dzn_iwb_UGLAttackAllowed", "CHECKBOX", "UGL Attack allowed", "Infantry Weapon Behavior", true, true] call CBA_Settings_fnc_init;
["dzn_iwb_UGLAttackChance", "SLIDER", "UGL Attack chance (Overall*UGL)", "Infantry Weapon Behavior", [1,100,100,0], true] call CBA_Settings_fnc_init;
["dzn_iwb_UGLAttackRangeMin", "SLIDER", "UGL Attack range (min)", "Infantry Weapon Behavior", [20, 400, 35, 0], true, {
	dzn_iwb_UGLAttackRange = [_this, dzn_iwb_UGLAttackRange select 1];
}] call CBA_Settings_fnc_init;
["dzn_iwb_UGLAttackRangeMax", "SLIDER", "UGL Attack range (max)", "Infantry Weapon Behavior", [20, 400, 325, 0], true, {
	dzn_iwb_UGLAttackRange = [dzn_iwb_UGLAttackRange select 0, _this];
}] call CBA_Settings_fnc_init;
["dzn_iwb_UGLRoundsList", "EDITBOX", "UGL Rounds list", "Infantry Weapon Behavior", '["1Rnd_HE_Grenade_shell","3Rnd_HE_Grenade_shell","rhs_VOG25","rhs_VOG25P","rhs_VG40TB","rhs_mag_M441_HE","rhs_mag_M433_HEDP","rhs_mag_m4009","rhs_mag_m576","CUP_1Rnd_HE_GP25_M","CUP_1Rnd_HE_M203","CUP_1Rnd_HEDP_M203"]', true, { dzn_iwb_UGLRoundsList = call compile _this; }] call CBA_Settings_fnc_init;

// HG Attack 
["dzn_iwb_HGAttackAllowed", "CHECKBOX", "Hand Grenade Attack allowed", "Infantry Weapon Behavior", true, true, {}] call CBA_Settings_fnc_init;
["dzn_iwb_HGAttackChance", "SLIDER", "Hand Grenade Attack chacnce (Overall*HG)", "Infantry Weapon Behavior", [1,100,100,0], true] call CBA_Settings_fnc_init;
["dzn_iwb_HGAttackRangeMin", "SLIDER", "Hand Grenade Attack range (min)", "Infantry Weapon Behavior", [15, 50, 15, 0], true, {
	dzn_iwb_HGAttackRange = [_this, dzn_iwb_HGAttackRange select 1];
}] call CBA_Settings_fnc_init;
["dzn_iwb_HGAttackRangeMax", "SLIDER", "Hand Grenade Attack range (max)", "Infantry Weapon Behavior", [15, 50, 35, 0], true, {
	dzn_iwb_HGAttackRange = [dzn_iwb_HGAttackRange select 0, _this];
}] call CBA_Settings_fnc_init;
["dzn_iwb_HGList", "EDITBOX", "Hand Grenade Rounds list", "Infantry Weapon Behavior", '[["ACE_M14","ACE_M14Muzzle"],["CUP_HandGrenade_L109A1_HE","HandGrenadeMuzzle"],["HandGrenade","HandGrenadeMuzzle"],["CUP_HandGrenade_M67","HandGrenadeMuzzle"],["CUP_HandGrenade_L109A2_HE","HandGrenadeMuzzle"],["CUP_HandGrenade_RGD5","HandGrenadeMuzzle"],["CUP_HandGrenade_RGO","HandGrenadeMuzzle"],["MiniGrenade","MiniGrenadeMuzzle"],["rhs_mag_rgd5","Rhs_Throw_Grenade"],["rhs_mag_rgn","Rhs_Throw_RgnGrenade"],["rhs_mag_rgo","Rhs_Throw_RgoGrenade"],["rhs_mag_fakel","Rhs_Throw_Flash_fakel"],["rhs_mag_fakels","Rhs_Throw_Flash_fakels"],["rhs_mag_zarya2","Rhs_Throw_Flash_zarya2"],["rhs_mag_plamyam","Rhs_Throw_Flash_plamyam"],["rhs_mag_mk84","Rhsusf_Throw_Flash"],["rhs_mag_m67","Rhsusf_Throw_Grenade"],["rhs_mag_mk3a2","Rhsusf_Throw_Grenade"],["rhs_mag_m69","Rhsusf_Throw_Grenade"],["rhs_mag_an_m14_th3","Rhsusf_Throw_Incendenary"],["rhs_mag_m7a3_cs","Rhsusf_Throw_CS"],["ACE_M84","ACE_M84Muzzle"]]', true, { dzn_iwb_HGList = call compile _this; }] call CBA_Settings_fnc_init;

// Suppresive attack
["dzn_iwb_SWAttackAllowed", "CHECKBOX", "Suppress Attack allowed", "Infantry Weapon Behavior", true, true] call CBA_Settings_fnc_init;
["dzn_iwb_SWAttackChance", "SLIDER", "Suppress Attack chacnce", "Infantry Weapon Behavior", [1,100,100,0], true] call CBA_Settings_fnc_init;
["dzn_iwb_SWAttackRangeMin", "SLIDER", "Suppress Attack range (min)", "Infantry Weapon Behavior", [10, 600, 35, 0], true, {
	dzn_iwb_SWAttackRange = [ _this, dzn_iwb_SWAttackRange select 1];
}] call CBA_Settings_fnc_init;
["dzn_iwb_SWAttackRangeMax", "SLIDER", "Suppress Attack range (max)", "Infantry Weapon Behavior", [10, 600, 500, 0], true, {
	dzn_iwb_SWAttackRange = [dzn_iwb_SWAttackRange select 0, _this];
}] call CBA_Settings_fnc_init;

// Timers
["dzn_iwb_CheckUnitLoopTimeout", "SLIDER", "New unit check timeout (sec)", "Infantry Weapon Behavior", [1, 600, 45, 0], true] call CBA_Settings_fnc_init;
["dzn_iwb_SpecialAttackLongTimeout", "SLIDER", "Attack check timeout (sec)", "Infantry Weapon Behavior", [1, 600, 40, 0], true] call CBA_Settings_fnc_init;
["dzn_iwb_SpecialAttackShortTimeout", "SLIDER", "(Approx.) Attack repreat timeout (sec)", "Infantry Weapon Behavior", [1, 600, 15, 0], true] call CBA_Settings_fnc_init;


// ICB CBA Settings
["dzn_icb_Enabled", "CHECKBOX", "Enabled", "Infantry Combat Behavior", true, true] call CBA_Settings_fnc_init;
["dzn_icb_AllowSkillAffected", "CHECKBOX", "(Suppression) Allow skill penalty", "Infantry Combat Behavior", true, true] call CBA_Settings_fnc_init;
["dzn_icb_AllowFindCover", "CHECKBOX", "(Suppression) Force move to cover", "Infantry Combat Behavior", true, true] call CBA_Settings_fnc_init;
