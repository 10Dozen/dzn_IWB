class CfgPatches
{
	class dzn_IWCB
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
		version = "1";
	};
};

class Extended_PreInit_EventHandlers
{
	class dzn_IWCB
	{
		init = "call ('\dzn_IWCB\Init.sqf' call SLX_XEH_COMPILE)";
	};
};

class CfgSounds
{
	sounds[] = {};
	
	class kambula
	{
		name = "";
		sound[] = {"\dzn_IWB\sound\kambula.wss", 20, 1};
		titles[] = {0,""};
	};
}