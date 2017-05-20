#include "BIS_AddonInfo.hpp"
class CfgPatches
{
	class dzn_IWB
	{		
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"CBA_MAIN"};
		version = "V2";
		author[] = {"10Dozen"};
	};
};

class Extended_PostInit_EventHandlers
{
	class dzn_IWB
	{
		init = "call ('\dzn_IWB\init.sqf' call SLX_XEH_COMPILE)";
	};
};
