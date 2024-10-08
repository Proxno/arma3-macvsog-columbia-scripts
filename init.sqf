//
// init.sqf
// Executes at mission start
// No parameters are passed to this script

// init COLSOG Zeus Custom Modules
execVM "functions\init_colsog_zeus.sqf";

// ACRE BABEL config
f_available_languages = [
["en", "English"],
["vn", "Vietnamese"]
];
{
    _x call acre_api_fnc_babelAddLanguageType;
} forEach f_available_languages;

[] spawn {
    if (!hasInterface) exitWith {};
    if (player != player) then {waitUntil {player == player};};
    if (!alive player) then {waitUntil {alive player};};

    _languagesPlayerSpeaks = player getVariable ["f_languages", []];

    switch (playerside) do {
    case west: {
            if (_languagesPlayerSpeaks isEqualTo []) then {_languagesPlayerSpeaks = ["en"];};   // Have the MACVSOG team able to talk and understand each other (using English)
        };
    case east: {
            if (_languagesPlayerSpeaks isEqualTo []) then {_languagesPlayerSpeaks = ["vn"];};
        };
    case independent: {
            if (_languagesPlayerSpeaks isEqualTo []) then {_languagesPlayerSpeaks = ["vn"];};
        };
    case civilian: {
            if (_languagesPlayerSpeaks isEqualTo []) then {_languagesPlayerSpeaks = ["vn"];};
        };
    };
    _languagesPlayerSpeaks call acre_api_fnc_babelSetSpokenLanguages;
};

// The bellow lines are only executed by ZEUS.
// When someone controls a unit (zeus), this event handler will be triggered.
["unit", {
    params ["_player"];
    switch ((getNumber (configFile >> "CfgVehicles" >> (typeOf _player) >> "side"))) do {
        case 0: { ["vn"] call acre_api_fnc_babelSetSpokenLanguages; };          // OPFOR
        case 1: { ["en"] call acre_api_fnc_babelSetSpokenLanguages; };          // BLUFOR
        case 2: { ["vn"] call acre_api_fnc_babelSetSpokenLanguages; };          // INDEP
        case 3: { ["vn"] call acre_api_fnc_babelSetSpokenLanguages; };          // CIVIL
    };
}, true] call CBA_fnc_addPlayerEventHandler;

// init removeThrowables on Opfor units
execVM "functions\init_colsog_removeThrowables.sqf";

// init convertMedicKit on killed units
execVM "functions\colsog_fn_firstAidConvertAce.sqf";