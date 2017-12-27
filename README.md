# dzn_IWB
Arma 3 Infantry Weapon Behaviour tweak

## v1
- UGL Attack

## v2
Task:
  - Do not check cahced units
  - Add Hand Grenade sequence
  - Add Supressive fire sequence
  - Add move to cover behavior
  - Locality in MP / Headless

## v3
- UGL dispersion added
- Target selection fixed (only current hostiles sides are used)
- ACE compatibility (surrendered, handcuffed) 
- CBA_Settings compatible


## v4
Task:
  - Refactor
  - Add UGL dispersion
  - Reveal targets between groups

Bugs/Features:
  - Suppress attack: Remeber last target and if no new targets and target alive and in range -> use as new target

Diagnostic:
- T3 call BIS_fnc_enemyTargets
- [T3,100] spawn BIS_fnc_traceBullets;
- T3 call dzn_fnc_iwb_GetUnitCombatAttributes
- format ["UGL: %1 | HG: %2 | MG: %3", V getVariable "IWB_UGL", V getVariable "IWB_HG", V getVariable "IWB_SW"]
