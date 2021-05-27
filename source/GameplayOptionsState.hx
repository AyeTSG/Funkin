package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class GameplayOptionsState extends MusicBeatState
{
    // Basically has the same format as the original OptionsMenu state
    var curSelected:Int = 0;
    var inputGraphic:FlxSprite;

    var grpOptionsTxt:FlxTypedGroup<Alphabet>;
    var grpOptionsIndicator:FlxTypedGroup<FlxSprite>;

    var menuItems:Array<String> = [
        "Extra Dialogue",   // 0
        "Lyrics",           // 1
        "Unknown Icons",    // 2
        "Instrumental Mode",// 3
        "Downscroll"        // 4
    ];


    override function create()
    {
        // Set menu background
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
        menuBG.color = 0x7a58b0;
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        add(menuBG);

        // Entry texts
        grpOptionsTxt = new FlxTypedGroup<Alphabet>();
        add(grpOptionsTxt);

        for (i in 0...menuItems.length)
        {
            var optionTxt:Alphabet = new Alphabet(16, 20 + (i * 70), menuItems[i], true);
            optionTxt.ID = i;
            optionTxt.x += 70;
            optionTxt.alpha = 0.5;
            grpOptionsTxt.add(optionTxt);
        }


        // Enabled/Disabled indicators
        grpOptionsIndicator = new FlxTypedGroup<FlxSprite>();
        add(grpOptionsIndicator);

        for (i in 0...menuItems.length)
        {
            var optionIndicator:FlxSprite = new FlxSprite(16, 20 + (i * 70));
            optionIndicator.ID = i;
            
            // Create animations for the indicators
            optionIndicator.frames = Paths.getSparrowAtlas('st_ui_assets');
            optionIndicator.animation.addByPrefix("true", "checkmark", 24, false);
            optionIndicator.animation.addByPrefix("false", "xmark", 24, false);

            // default anim true
            optionIndicator.animation.play("true");
            
            optionIndicator.scale.x = 0.4;
            optionIndicator.scale.y = 0.4;

            optionIndicator.x -= 88;
            optionIndicator.y -= 26;
            optionIndicator.alpha = 0.5;
            
            grpOptionsIndicator.add(optionIndicator);
        }


        super.create(); // LET THERE BE LIGHT!

    }


    override function update(elapsed:Float)
    {
        super.update(elapsed);

        // Menu control handling
        if (controls.UP_P) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            curSelected -= 1;
        }

        if (controls.DOWN_P) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            curSelected += 1;
        }

        if (curSelected < 0)
            curSelected = menuItems.length - 1;

        if (curSelected >= menuItems.length)
            curSelected = 0;

        // Now THIS is why I decided to make categories
        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            switch(curSelected) {
                case 0:
                    if (STOptionsRewrite._variables.extraDialogue) {
                        STOptionsRewrite._variables.extraDialogue = false;
                    } else {
                        STOptionsRewrite._variables.extraDialogue = true;
                    }

                case 1:
                    if (STOptionsRewrite._variables.lyrics) {
                        STOptionsRewrite._variables.lyrics = false;
                    } else {
                        STOptionsRewrite._variables.lyrics = true;
                    }

                case 2:
                    if (STOptionsRewrite._variables.unknownIcons) {
                        STOptionsRewrite._variables.unknownIcons = false;
                    } else {
                        STOptionsRewrite._variables.unknownIcons = true;
                    }
                case 3:
                    if (STOptionsRewrite._variables.instMode) {
                        STOptionsRewrite._variables.instMode = false;
                    } else {
                        STOptionsRewrite._variables.instMode = true;
                    }
                case 4:
                    if (STOptionsRewrite._variables.downscroll) {
                        STOptionsRewrite._variables.downscroll = false;
                    } else {
                        STOptionsRewrite._variables.downscroll = true;
                    }
            }
        }

        if (controls.BACK) {
            FlxG.switchState(new OptionsMenu());
        }


        // Update indicator graphics
        if (STOptionsRewrite._variables.extraDialogue)
            grpOptionsIndicator.members[0].animation.play("true");
        else
            grpOptionsIndicator.members[0].animation.play("false");

        if (STOptionsRewrite._variables.lyrics)
            grpOptionsIndicator.members[1].animation.play("true");
        else
            grpOptionsIndicator.members[1].animation.play("false");

        if (STOptionsRewrite._variables.unknownIcons)
            grpOptionsIndicator.members[2].animation.play("true");
        else
            grpOptionsIndicator.members[2].animation.play("false");

        if (STOptionsRewrite._variables.instMode)
            grpOptionsIndicator.members[3].animation.play("true");
        else
            grpOptionsIndicator.members[3].animation.play("false");

        if (STOptionsRewrite._variables.downscroll)
            grpOptionsIndicator.members[4].animation.play("true");
        else
            grpOptionsIndicator.members[4].animation.play("false");

        // Change alpha when selecting an item
        for (i in 0...menuItems.length) {
            grpOptionsTxt.members[i].alpha = 0.5;
            grpOptionsIndicator.members[i].alpha = 0.5;
        }

        grpOptionsIndicator.members[curSelected].alpha = 1;
        grpOptionsTxt.members[curSelected].alpha = 1;
    }



}