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
		"Gameplay Options",	// 0
		"Misc Options",		// 1
		"Control Options"	// 2
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
				case 0:
					FlxG.switchState(new GameplayOptionsState());
				case 1:
					FlxG.switchState(new MiscOptionsState());
				case 2:
					FlxG.switchState(new KeybindState());
			}
		}

		if (controls.BACK) {
			STOptionsRewrite.Save();
			PlayerSettings.player1.controls.loadBinds();
			FlxG.switchState(new MainMenuState());
		}

		// alpha shit
		for (i in 0...textMenuItems.length) {
			grpOptionsTexts.members[i].alpha = 0.6;
			grpOptionsIndicator.members[i].alpha = 0.6;
		}

		grpOptionsTexts.members[curSelected].alpha = 1;
		grpOptionsIndicator.members[curSelected].alpha = 1;

		if (curSelected == 4)
			inputGraphic.alpha = 1;
	}
}
