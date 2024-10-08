// *******************************************************
// Spring the trap when the trap's trigger is fired.
// *******************************************************
params ["_wireTrap", "_mace", "_ropeTopObject", "_maceSphere"];
private _trapPosition = getPos _wireTrap;
private _trapDirection = getDir _wireTrap;

private _unit = nearestObject [_trapPosition, 'Man'];
playSound3D ["a3\sounds_f\air\sfx\sl_rope_break.wss", _wireTrap, false, _wireTrap, 4];
deleteVehicle _wireTrap;
// *******************************************************
// Delete cosmetic rope and attach swing rope.  Then detach mace from original position to start the swing
// *******************************************************
private _secondRope = ropeCreate [_mace, [0, 0, .1], _ropeTopObject, [0, 0, -.5], _mace distance _ropeTopObject];
detach _mace;
_maceSphere attachTo [_mace, [0, 0, 0]];
private _directionTo = ([_maceSphere, _ropeTopObject] call BIS_fnc_dirTo);
_mace setDir _directionTo;

// *******************************************************
// stabilizes mace swing and plays creaking noise
// *******************************************************
[[_mace, _ropeTopObject], "functions\traps\swinging\colsog_fn_controlMaceSwing.sqf"] remoteExec ["execVM", 0, true];

// *******************************************************
// Units react to springing of trap
// *******************************************************
uiSleep 1.5;

// *******************************************************
// sound FX and accelerate swing when mace lower (waiting so it won't just pile drive into the ground)
// *******************************************************
_sound = "a3\sounds_f\characters\movements\bush_004.wss";
playSound3D [_sound, _mace, false, getPosASL _mace, 3.5];
waitUntil {_mace distance2D _trapPosition < 3};
playSound3D [_sound, _mace, false, getPosASL _mace, 3.5];
// *******************************************************
// Deal with victims of mace
// *******************************************************
[[_unit, _mace, _trapDirection, _trapPosition], "functions\traps\colsog_fn_maceVictims.sqf"] remoteExec ["execVM", 0, true];
uiSleep 4;

// *******************************************************
// After initial swing make mace heavier so hangs closer to the ground (to counter retarded rope elasticity).
// *******************************************************
private _future = time + 10;
waitUntil {!alive _unit or _trapPosition distance _unit > 3 or !(vehicle _unit == _unit) or time > _future};
[[_mace], "functions\traps\swinging\colsog_fn_endMaceSwinging.sqf"] remoteExec ["execVM", 0, true];
