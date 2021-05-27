package;

import lime.math.ARGB;
using StringTools;

class KeybindState extends MusicBeatState
{
    // Done in order of how arrows appear in-game
    var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
    var defaultKeys:Array<String> = ["A", "S", "W", "D"];
    
    var curSelected:Int = 0;
}