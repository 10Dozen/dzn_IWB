/*
	author: 10Dozen
	description: Process fired event
	input: ARRAY - Fired EventHandler data
	returns: none
	exmple:
		_firedEH call dzn_IWCB_fnc_firedEH;
*/

#include "..\macro.hpp"

params [
	"_unit"
	, "_weapon"
	, "_muzzle"
	, "_mode"
	, "_ammo"
	, "_magazine"
	, "_proj"
	, "_gunner"
];

private _originalVelocity = velocityModelSpace _proj;


// ===================================
// 	Underbarrel Grenade
//	Adds dispersion to UGL shots to make them inaccurate
// ===================================
if ( _magazine in GVAR(UGL_List) ) exitWith {
	XC_Log = [];
	XC_Log pushBack format ["UGL Started"];
	
	private _yWeighted = [];
	private _xMultiplier = 0;
	
	switch (GVAR(UGL_Accuracy)) do {
		case 0: {
			_xMultiplier = 15;
			_yWeighted = [1,2,2,3,3,4,3];			
		};
		case 1: {
			_yWeighted = [1,2,3,4,3,2,1];
			_xMultiplier = 2;
		};
		case 2: {
			_yWeighted = [3,4,3,3,2,2,1];
			_xMultiplier = 1.25;
		};	
	};
	
	XC_Log pushBack format ["Accuracy modification: X: %1, Y: %2", _xMultiplier, _yWeighted];

	private _xDisp = random (_xMultiplier) * selectRandom[1,-1];
	private _yDisp = ([0,3,5,7,10,12,15] selectRandomWeighted _yWeighted) * selectRandom[1,-1]; 
	
	XC_Log pushBack format ["Dispersionn: XDisp: %1, YDisp: %2", _xDisp, _yDisp];
	XC_Log pushBack format ["Result:[%1, %2, %3]", (_originalVelocity select 0) + _xDisp, (_originalVelocity select 1) + _yDisp, (_originalVelocity select 2)];
	
	_proj setVelocityModelSpace [
		(_originalVelocity select 0) + _xDisp
		, (_originalVelocity select 1) + _yDisp
		, (_originalVelocity select 2)
	];
	
	/*
	[
		"UGL Started"
		,"Accuracy modification: X: 4, Y: [1,2,2,3,3,4,3]"
		,"Dispersionn: XDisp: 2.07959, YDisp: -15"
		,"Result:[2.07959, 65, 3.8147e-006]"
	]
	*/
};


// ===================================
// 	Hand Grenade 
//	Change thrown grenade trajectory to parabolic (over obstacles) and dependent on target distance
// ===================================
if ( _magazine in (GVAR(HG_List) apply {_x select 0}) ) exitWith {
	
	if (isNil { _unit getVariable SVAR(HG_TargetRange) }) exitWith {						
		_unit addMagazine _magazine;
		deleteVehicle _proj;
	};
	
	private _dist = _unit getVariable [SVAR(HG_TargetRange), 25];
	private _velocity = [];
	
	private _xDisp = 1;
	private _yDisp = 1;
	private _yMultiplier = 1;
	private _yDistance = 1;
	
	switch (GVAR(HG_Accuracy)) do {
		case 0: {
			_yMultiplier = 1.5;			
		};
		case 1: {
			_yMultiplier = 1;
		};
		case 2: {
			_yMultiplier = 0.75;
		};	
	};
	
	if (_dist < 16) then {
		_xDisp = random [-3,0,3];
		_yDisp = 8 + _yMultiplier * random [-0.25, 0, 0.75];
	} else {				
		if (_dist < 23) then {
			_xDisp = random [-4,0,4];
			_yDisp = 10 + _yMultiplier * random [-0.25, 0, 1];
		} else {
			if (_dist < 30) then {
				_xDisp = random [-5,0,5];
				_yDisp = 12 + _yMultiplier * random [-1.25, 0, 1.25];
			} else {
				_xDisp = random [-6,0,6];
				_yDisp = 16 + _yMultiplier * random [-1.25, 0, 1.5];
			};
		};
	};
	
	_velocity = [_xDisp, _yDisp, 10 + (random 0.15)];
	
	_proj setVelocity ((_proj modelToWorldVisual _velocity) vectorDiff (_proj modelToWorldVisual [0,0,0]));
	_unit setVariable [SVAR(HG_TargetRange), nil, true];
	
	// Play Grenade warning sound
	_unit remoteExec [SVAR(fnc_sayLocal), 0];
};


// ===================================
// 	Suppressed
// 	Affect each shot with massive weapon sway
// ===================================
if (_unit getVariable [SVAR(ICB_Suppressed), false]) exitWith {
	_proj setVelocityModelSpace [
		(_originalVelocity select 0) + random(45)*selectRandom [1,-1]
		, (_originalVelocity select 1) 
		, (_originalVelocity select 2) + random(10)*selectRandom [1,-1]
	];
};


// ===================================
// 	Blind firing
//	Check and affect each shot sway if there are obstacles between unit and target (e.g. firing through bushes)
// ===================================
private _intersectObjects = lineIntersectsObjs [
	eyePos _unit
	, ATLtoASL ((assignedTarget _unit) modelToWorld ((assignedTarget _unit)  selectionPosition "pelvis"))
	, objNull
	, _unit
	, false
	, 32
];
	
if !(_intersectObjects isEqualTo []) then {
	private _d = _unit distance (_intersectObjects select 0);					
	private _multiplier = switch (true) do {
		case (_d < 50): { 60 };
		case (_d < 100): { 45 };
		case (_d > 100): { 30 };					
	};

	_proj setVelocityModelSpace [
		(_originalVelocity select 0) + random(_multiplier)*selectRandom [1,-1]
		, (_originalVelocity select 1) 
		, (_originalVelocity select 2) + random(10)*selectRandom [1,-1]
	];
};