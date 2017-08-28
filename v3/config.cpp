class CfgPatches
{
	class dzn_IWB
	{		
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
	};
};

class Extended_PreInit_EventHandlers
{
	IWBSettings = call compile preprocessFileLineNumbers "\dzn_IWB\XEH_preInit.sqf";
};
class Extended_PostInit_EventHandlers
{
	class dzn_IWB
	{
		init = "call ('\dzn_IWB\init.sqf' call SLX_XEH_COMPILE)";
	};
};
