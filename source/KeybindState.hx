package;

import flixel.addons.plugin.taskManager.FlxTask;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import haxe.display.Display.Keyword;
import flixel.text.FlxText;
import flixel.FlxSprite;
import lime.math.ARGB;
using StringTools;

class KeybindState extends MusicBeatState
{
    var keyText:Array<String> = ["Left", "Down", "Up", "Right"];    // WHY DOES THIS SHIT COUNT 1, 2, 3, 4?????
    var defaultKeys:Array<String> = ["A", "S", "W", "D"];
    var keyBlacklist:Array<String> = ["ENTER", "BACKSPACE", "ESCAPE", "C", "R"];
    var keys:Array<String>;

    var curSelected:Int = 0;
    var grpKeyDisplays:FlxTypedGroup<FlxText>;

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

        grpKeyDisplays = new FlxTypedGroup<FlxText>();
        add(grpKeyDisplays);

        for (i in 0...4)
        {
            var keyDisplay = new FlxText(10, 20 + (i * 70), " ");
            keyDisplay.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            keyDisplay.ID = i;
            keyDisplay.x += 30;
            keyDisplay.alpha = 0.5;

            grpKeyDisplays.add(keyDisplay);
        }
        
        // TODO: ADD SELECTION INDICATOR GRAPHICS
        // (Just waiting for TSG on this one)


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


        // Change alpha for selected item
        for (i in 0...4)
        {
            grpKeyDisplays.members[i].alpha = 0.5;
        }

        grpKeyDisplays.members[curSelected].alpha = 1;

        super.update(elapsed);
    }

    function txtUpdate()
    {
        for (i in 0...4)
        {
            grpKeyDisplays.members[i].text = keyText[i] + ": " + keys[i];
        }
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