package;

import flixel.FlxG;
import flixel.util.FlxColor;
import haxe.display.Display.Keyword;
import flixel.text.FlxText;
import flixel.FlxSprite;
import lime.math.ARGB;
using StringTools;

class KeybindState extends MusicBeatState
{
    // Done in order of how arrows appear in-game
    var keyDisplay:FlxText;
    //                             0       1      2     3
    var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
    var defaultKeys:Array<String> = ["A", "S", "W", "D"];
    var keyBlacklist:Array<String> = ["ENTER", "BACKSPACE", "ESCAPE", "C", "R"];
    var keys:Array<String>;

    var curSelected:Int = 0;

    var tempKey:String = "";
    var state:String = "select";

    override function create()
    {
        keys = [
            STOptionsRewrite._variables.leftBind,
            STOptionsRewrite._variables.downBind,
            STOptionsRewrite._variables.upBind,
            STOptionsRewrite._variables.rightBind
        ];

        // Set menu BG
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.color = 0xFFea71fd;
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);


        // TODO: Add FNF styled font as opposed to VCR-OSD
        keyDisplay = new FlxText(0, 0, 1280, "", 72);
        keyDisplay.scrollFactor.set(0, 0);
        keyDisplay.setFormat(Paths.font('vcr.ttf'), 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(keyDisplay);
    }

    override function update(elapsed:Float) 
    {
        txtUpdate();

        switch(state)
        {
            case "select":
                // Control handling
                if (controls.UP_P)
                {
                    FlxG.sound.play(Paths.sound("scrollMenu"));
                    curSelected -= 1;
                }

                if (controls.DOWN_P)
                {
                    FlxG.sound.play(Paths.sound("scrollMenu"));
                    curSelected += 1;
                }


                if (curSelected > 3)
                    curSelected = 0;
                if (curSelected < 0)
                    curSelected = 3;
                

                if (controls.ACCEPT)
                {
                    FlxG.sound.play(Paths.sound("scrollMenu"));
                    state = "input";
                }

                if (controls.BACK)
                {
                    save();
                    FlxG.switchState(new OptionsMenu());
                }
            case "input":
                tempKey = keys[curSelected];
                keys[curSelected] = "...";
                state = "waiting";
            case "waiting":

                
                if(FlxG.keys.justPressed.ESCAPE)
                {
                    keys[curSelected] = tempKey;
                    state = "select";
                }
                else if(FlxG.keys.justPressed.ENTER)
                {
                    addKey(defaultKeys[curSelected]);
                    state = "select";
                }
                else if(FlxG.keys.justPressed.ANY)
                {
                    addKey(FlxG.keys.getIsDown()[0].ID.toString());
                    state = "select";
                }
            
            default:
                state = "select";
        }

        super.update(elapsed);
    }

    function txtUpdate()
    {
        // Borrowed from FNF HD
        keyDisplay.text = "\n\n";

        for (i in 0...3)
        {
            var txtStart = (i == curSelected) ? ">" : " ";
            keyDisplay.text += txtStart + keyText[i] + ": " + ((keys[i] != keyText[i]) ? (keys[i] + " + ") : "") + keyText[i] + " ARROW\n";
        }

        keyDisplay.screenCenter();
    }

    function save()
    {
        STOptionsRewrite._variables.upBind = keys[2];
        STOptionsRewrite._variables.downBind = keys[1];
        STOptionsRewrite._variables.leftBind = keys[0];
        STOptionsRewrite._variables.rightBind = keys[3];
        PlayerSettings.player1.controls.loadBinds();
    }

    function addKey(key:String)
    {
        var shouldReturn:Bool = true;
        var notAllowed:Array<String> = [];

        // Prevent certain keys from being bound
        for (x in keys)
        {
            if (x != tempKey)
                notAllowed.push(x);
        }

        for (x in keyBlacklist)
        {
            notAllowed.push(x);
        }

        

        for (x in notAllowed)
        {
            if (x == key)
                shouldReturn = false;
        }

        // Set keys based on key input
        if (shouldReturn)
        {
            keys[curSelected] = key;
            FlxG.sound.play(Paths.sound("scrollMenu"));
        } else {
            keys[curSelected] = tempKey;
            trace("FAILED TO REBIND KEY!");
        }



    }
}