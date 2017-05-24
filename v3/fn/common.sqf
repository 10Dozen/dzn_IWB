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

dzn_fnc_CENA_ToggleHandGrenadeEH = {
	params ["_u", "_add"];
	private _eh = -1;
	
	if (!local _u) exitWith {
		_this remoteExec ["dzn_fnc_CENA_ToggleHandGrenadeEH", _u];
	};
	
	if (_add) then {
		_eh = _u addEventHandler [
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
		_u setVariable ["CENA_FireEH", _eh];
	} else {
		_u removeEventHandler ["Fired", _u getVariable ["CENA_FireEH",-1]];
		_u setVariable ["CENA_FireEH", nil];
	};
};
