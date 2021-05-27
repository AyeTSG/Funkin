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

		menuBG.color = 0x7a58b0;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		// Options title
		var optionsTitle:FlxSprite = new FlxSprite();

		optionsTitle.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		optionsTitle.animation.addByPrefix('title', "options white", 15);
		optionsTitle.animation.play('title');
		optionsTitle.x = 345;
		optionsTitle.y = 100;
		add(optionsTitle);

		optionsTitle.scrollFactor.set();
		optionsTitle.antialiasing = true;

		// Options menu text
		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(16, 350 + (i * 70), textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.screenCenter(X);

			optionText.alpha = 0.5;
			
			grpOptionsTexts.add(optionText);
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
		}

		grpOptionsTexts.members[curSelected].alpha = 1;

		if (curSelected == 4)
			inputGraphic.alpha = 1;
	}
}
