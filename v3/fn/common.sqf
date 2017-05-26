dzn_fnc_CENA_setLongTimeout = {
	_this setVariable ["CENA_LongTimeoutDone", false];
	_this spawn {
		sleep dzn_CENA_SpecialAttackLongTimeout;
		_this setVariable ["CENA_LongTimeoutDone", true];
	};
};

dzn_fnc_CENA_setShortTimeout = {
	_this setVariable ["CENA_ShortTimeoutDone", false];
	_this spawn {
		sleep dzn_CENA_SpecialAttackShortTimeout;
		_this setVariable ["CENA_ShortTimeoutDone", true];
	};
};

dzn_fnc_CENA_getShortTimeoutDone = { _this getVariable ["CENA_ShortTimeoutDone",false] };

dzn_fnc_CENA_getLongTimeoutDone = { _this getVariable ["CENA_LongTimeoutDone",false] };

dzn_fnc_CENA_CheckUnitProcessable = {
	simulationEnabled _this		
	|| vehicle _this == _this
	|| side _this != civilian
	|| !(_this getVariable ["dzn_dynai_isCached", false])
	|| !(_this getVariable ["ACE_isUnconscious", false])
	|| !(_this getVariable ["ACE_isSurrendering", false])
	|| !(_this getVariable ["ACE_isHandcuffed", false])
};

dzn_fnc_CENA_GetUnitCombatAttributes = {
	private _u = _this;
	private _hasUGL = false;
	private _hasGrenades = false;
	private _hasSupportWeapon = false;
	
	private _muzzles = (getArray(configFile >> "cfgWeapons" >> primaryWeapon _u >> "muzzles")) - ["SAFE"];
	if ( 
		count _muzzles > 1 
		&& count (primaryWeaponMagazine _u) > 1 
		&& { (primaryWeaponMagazine _u select 1) in dzn_iwb_UGLRoundsList }
	) then { 
		_hasUGL = true;
	};
	
	private _mags = itemsWithMagazines _u;	
	{ 
		if ((_x select 0) in _mags) exitWith { 
			_u setVariable ["CENA_HGMuzzle", _x select 1, true];
			_hasGrenades = true;
		};
	} forEach dzn_iwb_HGList;
	
	_hasSupportWeapon = getNumber (configFile >> "CfgMagazines" >> currentMagazine _u >> "count") > 30;

	_u setVariable ["CENA_UGL", _hasUGL, true];
	_u setVariable ["CENA_HG", _hasGrenades, true];
	_u setVariable ["CENA_MG", _hasSupportWeapon, true];
};

dzn_fnc_CENA_SetHandGrenadeEH = {
	private _u = _this;	
	if (!local _u) exitWith { _u remoteExec ["dzn_fnc_CENA_ToggleHandGrenadeEH", _u]; };
	
	private _eh = _u addEventHandler [
		"Fired"
		, {
			params["_u","","","","","_round","_proj"];
			if !(_round in (dzn_CENA_HGList apply {_x select 0})) exitWith {
				// Other (UGL)
			};
			
			// Hand Grenades
			private _dist = _u getVariable ["CENA_HG_TargetRange", 15];
			private _velocity = [];
			
			if (_dist < 16) then {
				_velocity = [0,8 + random [-0.75, 0, 0.75] ,10];
			} else {				
				if (_dist < 23) then {
					_velocity = [0,10 + random [-1, 0, 1],10]
				} else {
					if (_dist < 30) then {
						_velocity = [0,12 + random [-1.25, 0, 1.25],10]
					} else {
						_velocity = [0,16 + random [-1.25, 0, 1.5],10]
					};
				};
			};
			
			_proj setVelocity ((_proj modelToWorldVisual _velocity) vectorDiff (_proj modelToWorldVisual [0,0,0]));
		}
	];
	
	[_u, _eh] spawn {
		waitUntil { sleep 10; !alive (_this select 0)};		
		(_this select 0) removeEventHandler ["Fired", (_this select 1)];
	};
};

dzn_fnc_CENA_SetSuppressionAttributes =  {
	private _u = _this;
	
	if (side _u == civilian) exitWith {};	
	if (!local _u) exitWith { _u remoteExec ["dzn_fnc_CENA_SetSuppressionHandler",_u]; };
	
	_u setVariable ["CENA_Cover", objNull];
	_u setVariable ["CENA_Skills", [_u skill "aimingAccuracy", _u skill "aimingShake", _u skill "aimingSpeed", _u skill "reloadSpeed"]];
};
