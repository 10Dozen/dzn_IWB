
class CfgPatches
{
	class dzn_IWB
	{		
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
		version = "3.3";
	};
};

class Extended_PreInit_EventHandlers
{
	IWBSettings = call compile preprocessFileLineNumbers "\dzn_IWB\Settings.sqf";
};
class Extended_PostInit_EventHandlers
{
	class dzn_IWB
	{
		init = "call ('\dzn_IWB\Init.sqf' call SLX_XEH_COMPILE)";
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
};
