# dzn_IWB
Arma 3 Infantry Weapon Behaviour tweak

## v3.3
- HandGrenade: AI don't throw greandes inside buildings (like hangars)
- HandGrenade: Voice notification on throw
- HandGrenade fixes

## v3.2
- UGL dispersion added
- Target selection fixed (only current hostiles sides are used)
- ACE compatibility (surrendered, handcuffed) 
- CBA_Settings compatible
- Add UGL dispersion



Diagnostic:
- T3 call BIS_fnc_enemyTargets
- [T3,100] spawn BIS_fnc_traceBullets;
- T3 call dzn_fnc_iwb_GetUnitCombatAttributes
- format ["UGL: %1 | HG: %2 | MG: %3", V getVariable "IWB_UGL", V getVariable "IWB_HG", V getVariable "IWB_SW"]

## v2
Task:
  - Do not check cahced units
  - Add Hand Grenade sequence
  - Add Supressive fire sequence
  - Add move to cover behavior
  - Locality in MP / Headless

## v1
- UGL Attack
