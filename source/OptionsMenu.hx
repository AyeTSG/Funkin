/*
	!!!TODO: OPTION SCROLLING LIKE FREEPLAY!
*/

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsMenu extends MusicBeatState
{
	// var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	// var selector:FlxSprite = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
	var grpOptionsTexts:FlxTypedGroup<Alphabet>;
	var grpOptionsIndicator:FlxTypedGroup<FlxSprite>;

	var inputGraphic:FlxSprite;

	// TODO: Add better array for Small Thing's options.
	var textMenuItems:Array<String> = [
		'Debug Mode',			// 0
		'Discord RPC',			// 1
		'Extra Dialogue', 		// 2
		'Input Mode',			// 3
		'Instrumental Mode',	// 4
		'Lyrics',				// 5
		'Song Indicator',		// 6
		'Unknown Icons',		// 7
		'Downscroll'			// 8
	];

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		// controlsStrings = CoolUtil.coolTextFile(Paths.txt('controls'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);


		// Options menu text
		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(16, 20 + (i * 70), textMenuItems[i], true);
			optionText.ID = i;

			optionText.x += 70;

			optionText.alpha = 0.5;
			
			grpOptionsTexts.add(optionText);
		}
		
		// Options menu indicators
		grpOptionsIndicator = new FlxTypedGroup<FlxSprite>();
		add(grpOptionsIndicator);

		for (i in 0...textMenuItems.length)
		{
			var optionIndicator:FlxSprite = new FlxSprite(16, 20 + (i * 70));
			optionIndicator.ID = i;

			optionIndicator.frames = Paths.getSparrowAtlas('st_ui_assets');
			optionIndicator.animation.addByPrefix("true", "checkmark", 24, false);
			optionIndicator.animation.addByPrefix("false", "xmark", 24, false);
			optionIndicator.antialiasing = true;

			// default anim true
			optionIndicator.animation.play("true");

			optionIndicator.scale.x = 0.4;
			optionIndicator.scale.y = 0.4;

			/*
			optionIndicator.x = optionIndicator.x - (optionIndicator.width / 2);
			*/
			optionIndicator.x -= 88;
			optionIndicator.y -= 26;

			optionIndicator.alpha = 0.6;

			grpOptionsIndicator.add(optionIndicator);
		}

		// input mode graphic
		inputGraphic = new FlxSprite(grpOptionsTexts.members[3].x, grpOptionsTexts.members[3].y);
		inputGraphic.frames = Paths.getSparrowAtlas('st_ui_assets');
		inputGraphic.animation.addByPrefix("wasd", "wasd", 24, false);
		inputGraphic.animation.addByPrefix("dfjk", "dfjk", 24, false);
		inputGraphic.antialiasing = true;
		inputGraphic.animation.play("wasd"); // default anim, will get changed later
		inputGraphic.scale.x = 0.75;
		inputGraphic.scale.y = 0.75;
		inputGraphic.x += 592;
		inputGraphic.y += -12;
		inputGraphic.alpha = 0.6;

		add(inputGraphic);

		super.create();

		// Yaknow what, fuck you! *un-substates your menu*
		// openSubState(new OptionsSubState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected -= 1;
		}

		if (controls.DOWN_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected += 1;
		}

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		if (controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'));
			
			switch (curSelected) {
				// I didn't wanna do this all manually, but, well, here we are.
				case 0:
					if (STOptionsRewrite._variables.debug == false) {
						STOptionsRewrite._variables.debug = true;
					} else {
						STOptionsRewrite._variables.debug = false;
					}
				case 1:
					if (STOptionsRewrite._variables.discordRPC == false) {
						STOptionsRewrite._variables.discordRPC = true;
					} else {
						STOptionsRewrite._variables.discordRPC = false;
					}
				case 2:
					if (STOptionsRewrite._variables.extraDialogue == false) {
						STOptionsRewrite._variables.extraDialogue = true;
					} else {
						STOptionsRewrite._variables.extraDialogue = false;
					}
				case 3:
					if (STOptionsRewrite._variables.inputMode == 0) {
						//grpOptionsTexts.members[4].text = "Input Mode DFJK";
						inputGraphic.animation.play("dfjk");
						STOptionsRewrite._variables.inputMode = 1;
					} else {
						//grpOptionsTexts.members[4].text = "Input Mode WASD";
						inputGraphic.animation.play("wasd");
						STOptionsRewrite._variables.inputMode = 0;
					}
				case 4:
					if (STOptionsRewrite._variables.instMode == false) {
						STOptionsRewrite._variables.instMode = true;
					} else {
						STOptionsRewrite._variables.instMode = false;
					}
				case 5:
					if (STOptionsRewrite._variables.lyrics == false) {
						STOptionsRewrite._variables.lyrics = true;
					} else {
						STOptionsRewrite._variables.lyrics = false;
					}
				case 6:
					if (STOptionsRewrite._variables.songIndicator == false) {
						STOptionsRewrite._variables.songIndicator = true;
					} else {
						STOptionsRewrite._variables.songIndicator = false;
					}
				case 7:
					if (STOptionsRewrite._variables.unknownIcons == false) {
						STOptionsRewrite._variables.unknownIcons = true;
					} else {
						STOptionsRewrite._variables.unknownIcons = false;
					}
				case 8:
					if (STOptionsRewrite._variables.downscroll == false)
						STOptionsRewrite._variables.downscroll = true;
					else
						STOptionsRewrite._variables.downscroll = false;
			}
		}

		if (controls.BACK) {
			STOptionsRewrite.Save();
			PlayerSettings.player1.controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
			FlxG.switchState(new MainMenuState());
		}

		// graphic updaters
		if (STOptionsRewrite._variables.debug == false) {
			grpOptionsIndicator.members[0].animation.play("false");
		} else {
			grpOptionsIndicator.members[0].animation.play("true");
		}

		if (STOptionsRewrite._variables.discordRPC == false) {
			grpOptionsIndicator.members[1].animation.play("false");
		} else {
			grpOptionsIndicator.members[1].animation.play("true");
		}

		if (STOptionsRewrite._variables.extraDialogue == false) {
			grpOptionsIndicator.members[2].animation.play("false");
		} else {
			grpOptionsIndicator.members[2].animation.play("true");
		}

		if (STOptionsRewrite._variables.inputMode == 0) {
			inputGraphic.animation.play("wasd");
		} else {
			inputGraphic.animation.play("dfjk");
		}

		if (STOptionsRewrite._variables.instMode == false) {
			grpOptionsIndicator.members[4].animation.play("false");
		} else {
			grpOptionsIndicator.members[4].animation.play("true");
		}

		if (STOptionsRewrite._variables.lyrics == false) {
			grpOptionsIndicator.members[5].animation.play("false");
		} else {
			grpOptionsIndicator.members[5].animation.play("true");
		}

		if (STOptionsRewrite._variables.songIndicator == false) {
			grpOptionsIndicator.members[6].animation.play("false");
		} else {
			grpOptionsIndicator.members[6].animation.play("true");
		}

		if (STOptionsRewrite._variables.unknownIcons == false) {
			grpOptionsIndicator.members[7].animation.play("false");
		} else {
			grpOptionsIndicator.members[7].animation.play("true");
		}

		if (STOptionsRewrite._variables.downscroll == false)
			grpOptionsIndicator.members[8].animation.play("false");
		else
			grpOptionsIndicator.members[8].animation.play("true");

		// alpha shit
		for (i in 0...textMenuItems.length) {
			grpOptionsTexts.members[i].alpha = 0.6;
			grpOptionsIndicator.members[i].alpha = 0.6;
			inputGraphic.alpha = 0.6;
		}

		grpOptionsTexts.members[curSelected].alpha = 1;
		grpOptionsIndicator.members[curSelected].alpha = 1;

		if (curSelected == 3)
			inputGraphic.alpha = 1;
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
