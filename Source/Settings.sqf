#include "macro.hpp"

private _add = {
	params ["_var","_type","_val",["_exp", "No Expression"],["_subcat", ""]];	
	
	private _arr = [
		format["dzn_IWCB_%1",_var]
		,_type
		, [localize format["STR_IWCB_%1",_var], localize format ["STR_IWCB_%1_desc",_var]]
		, if (_subcat == "") then {
			"dzn IWCB / Infantry Weapon and Combat Behavior"
		} else {
			["dzn IWCB / Infantry Weapon and Combat Behavior", _subcat]
		}
		,_val
		,true
	];
	
	if !(typename _exp == "STRING" && { _exp == "No Expression" }) then { _arr pushBack _exp; };
	_arr call CBA_Settings_fnc_init;
};


#define	CAT_NOEX(X)		"No Expression", X
#define	IWB_GENERAL_CAT		"Infantry Weapon Behavior"
#define	IWB_HG_CAT		localize "STR_IWCB_IWB_HG_Category"
#define	IWB_UGL_CAT		localize "STR_IWCB_IWB_UGL_Category"
#define	IWB_SW_CAT		localize "STR_IWCB_IWB_SW_Category"
#define	IWB_T_CAT			localize "STR_IWCB_IWB_Timers_Category"
#define	ICB_GENERAL_CAT		"Infantry Combat Behavior"
#define	ACCURACY_LIST		[[0,1,2], [localize "STR_IWCB_IWB_Low", localize "STR_IWCB_IWB_Average", localize "STR_IWCB_IWB_High"], 1]


#define	IWB_HG_LIST \
HandGrenade\
, MiniGrenade\
, ACE_M14\
, ACE_M84\
, CUP_HandGrenade_L109A1_HE\
, CUP_HandGrenade_M67\
, CUP_HandGrenade_L109A2_HE\
, CUP_HandGrenade_RGD5\
, CUP_HandGrenade_RGO\
, rhs_mag_rgd5\
, rhs_mag_rgn\
, rhs_mag_rgo\
, rhs_mag_fakel\
, rhs_mag_fakels\
, rhs_mag_zarya2\
, rhs_mag_plamyam\
, rhs_mag_mk84\
, rhs_mag_m67\
, rhs_mag_mk3a2\
, rhs_mag_m69\
, rhs_mag_an_m14_th3\
, rhs_mag_m7a3_cs

#define	IWB_UGL_LIST \
1Rnd_HE_Grenade_shell\
, 3Rnd_HE_Grenade_shell\
, rhs_VOG25\
, rhs_VOG25P\
, rhs_VG40TB\
, rhs_mag_M441_HE\
, rhs_mag_M433_HEDP\
, rhs_mag_m4009\
, rhs_mag_m576\
, CUP_1Rnd_HE_GP25_M\
, CUP_1Rnd_HE_M203\
, CUP_1Rnd_HEDP_M203


// --------------------------------------------
// 	IWB Section
// --------------------------------------------
[
	"IWB_Enabled"
	, "CHECKBOX"
	, true
	, CAT_NOEX(IWB_GENERAL_CAT)
] call _add;

[
	"IWB_SpecialAttackChance"
	, "SLIDER"
	, [0,100,60,0]
	, CAT_NOEX(IWB_GENERAL_CAT)
] call _add;

// --------------------------------------------
// 	IWB - Hand Grenade section
// --------------------------------------------
[
	"HG_Allowed"
	, "CHECKBOX"
	, true
	, CAT_NOEX(IWB_HG_CAT)
] call _add;

[
	"HG_Chance"
	, "SLIDER"
	, [0,100,100,0]
	, CAT_NOEX(IWB_HG_CAT)
] call _add;

[
	"HG_RangeSetting"
	, "EDITBOX"
	, "15-35"
	, { [SVAR(HG_Range), _this] call GVAR(fnc_updateRangedValues); }
	, IWB_HG_CAT
] call _add;

[
	"HG_Accuracy"
	, "LIST"
	, ACCURACY_LIST
	, CAT_NOEX(IWB_HG_CAT)
] call _add;

[
	"HG_ListSetting"
	, "EDITBOX"
	, QUOTE(IWB_HG_LIST)
	, { GVAR(HG_List) = (_this splitString ", ") call GVAR(fnc_getHGList); }
	, IWB_HG_CAT
] call _add;

// --------------------------------------------
// 	IWB - Underbarrel Grenade Launcher section
// --------------------------------------------
[
	"UGL_Allowed"
	, "CHECKBOX"
	, true
	, CAT_NOEX(IWB_UGL_CAT)
] call _add;

[
	"UGL_Chance"
	, "SLIDER"
	, [0,100,100,0]
	, CAT_NOEX(IWB_UGL_CAT)
] call _add;

[
	"UGL_RangeSetting"
	, "EDITBOX"
	, "35-350"
	, { [SVAR(UGL_Range), _this] call GVAR(fnc_updateRangedValues); }
	, IWB_UGL_CAT
] call _add;

[
	"UGL_Accuracy"
	, "LIST"
	, ACCURACY_LIST
	, CAT_NOEX(IWB_UGL_CAT)
] call _add;

[
	"UGL_ListSetting"
	, "EDITBOX"
	, QUOTE(IWB_UGL_LIST)
	, { GVAR(UGL_List) = _this splitString ", ";  }
	, IWB_UGL_CAT
] call _add;

// --------------------------------------------
// 	IWB - Suppres Weapons section
// --------------------------------------------
[
	"SW_Allowed"
	, "CHECKBOX"
	, true
	, CAT_NOEX(IWB_SW_CAT)
] call _add;

[
	"SW_Chance"
	, "SLIDER"
	, [0,100,100,0]
	, CAT_NOEX(IWB_SW_CAT)
] call _add;

[
	"SW_RangeSetting"
	, "EDITBOX"
	, "35-500"
	, { [SVAR(SW_Range), _this] call GVAR(fnc_updateRangedValues); }
	, IWB_SW_CAT
] call _add;



// --------------------------------------------
// 	ICB Section
// --------------------------------------------
[
	"ICB_Enabled"
	, "CHECKBOX"
	, true
	, CAT_NOEX(ICB_GENERAL_CAT)
] call _add;

[
	"ICB_AllowSuppressed"
	, "CHECKBOX"
	, true
	, CAT_NOEX(ICB_GENERAL_CAT)
] call _add;

[
	"ICB_AllowFindCover"
	, "CHECKBOX"
	, true
	, CAT_NOEX(ICB_GENERAL_CAT)
] call _add;


// --------------------------------------------
// 	 Timers
// --------------------------------------------
[
	"CheckUnitLoopTimeout"
	, "SLIDER"
	, [1,600,45,0]
	, CAT_NOEX(IWB_T_CAT)
] call _add;

[
	"IWB_SpecialAttackLongTimeout"
	, "SLIDER"
	, [1,600,40,0]
	, CAT_NOEX(IWB_T_CAT)
] call _add;

[
	"IWB_SpecialAttackShortTimeout"
	, "SLIDER"
	, [1,600,15,0]
	, CAT_NOEX(IWB_T_CAT)
] call _add;
