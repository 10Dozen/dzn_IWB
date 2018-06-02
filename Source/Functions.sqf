#include "macro.hpp"
#define PATH                    "functions\"
#define COMPILE_FUNCTION(X)     GVAR(X) = compile preprocessFileLineNumbers format ["%1%2.sqf", PATH, #X]

COMPILE_FUNCTION(fnc_updateRangedValues);
COMPILE_FUNCTION(fnc_getHGList);

COMPILE_FUNCTION(fnc_startIWB);
COMPILE_FUNCTION(fnc_prepareFSM);
COMPILE_FUNCTION(fnc_toggleFiredEH);
COMPILE_FUNCTION(fnc_firedEH);
COMPILE_FUNCTION(fnc_getUnitCombatAttributes);
COMPILE_FUNCTION(fnc_selectAttackAndTarget);
COMPILE_FUNCTION(fnc_getTargets);
COMPILE_FUNCTION(fnc_runAttackSequenceRemote);
COMPILE_FUNCTION(fnc_attackByUGL);
COMPILE_FUNCTION(fnc_attackByHG);
COMPILE_FUNCTION(fnc_attackBySW);
COMPILE_FUNCTION(fnc_selectSuppressPos);
COMPILE_FUNCTION(fnc_sayLocal);
COMPILE_FUNCTION(fnc_toggleForUnit);

COMPILE_FUNCTION(fnc_startICB);
COMPILE_FUNCTION(fnc_findCover);
COMPILE_FUNCTION(fnc_provideSuppressEffect);
COMPILE_FUNCTION(fnc_setSkillAffected);