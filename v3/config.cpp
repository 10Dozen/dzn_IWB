class CfgPatches
{
	class dzn_CENA
	{		
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
	};
};

class Extended_PostInit_EventHandlers
{
	class dzn_CENA
	{
		init = "call ('\dzn_CENA\init.sqf' call SLX_XEH_COMPILE)";
	};
};
