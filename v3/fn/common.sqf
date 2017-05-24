 dzn_fnc_IWB_setLongTimeout = {
	_this setVariable ["IWB_LongTimeoutDone", false];
	_this spawn {
		sleep dzn_iwb_SpecialAttackLongTimeout;
		_this setVariable ["IWB_LongTimeoutDone", true];
	};
};

dzn_fnc_IWB_setShortTimeout = {
	_this setVariable ["IWB_ShortTimeoutDone", false];
	_this spawn {
		sleep dzn_iwb_SpecialAttackShortTimeout;
		_this setVariable ["IWB_ShortTimeoutDone", true];
	};
};

dzn_fnc_IWB_getShortTimeoutDone = { _this getVariable ["IWB_ShortTimeoutDone",false] };
dzn_fnc_IWB_getLongTimeoutDone = { _this getVariable ["IWB_LongTimeoutDone",false] };
dzn_fnc_IWB_ToggleHandGrenadeEH = {
	params ["_u", "_add"];
	private _eh = -1;
	
	if (!local _u) exitWith {
		_this remoteExec ["dzn_fnc_IWB_ToggleHandGrenadeEH", _u];
	};
	
	if (_add) then {
		_eh = _u addEventHandler [
			"Fired"
			, {
				if !( (_this select 5) in (dzn_iwb_HGList apply {_x select 0}) ) exitWith {};
				
				private _proj = _this select 6;
				private _dist = (_this select 0) getVariable ["IWB_HG_TargetRange", 15];
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
		_u setVariable ["IWB_FireEH", _eh];
	} else {
		_u removeEventHandler ["Fired", _u getVariable ["IWB_FireEH",-1]];
		_u setVariable ["IWB_FireEH", nil];
	};
};
