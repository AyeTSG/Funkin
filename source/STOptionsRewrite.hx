package;

import sys.FileSystem;
import haxe.Json;
import sys.io.File;

// Hey, alot of this is based on Mic'd Up's implementation of options
// so credits to them i guess

// The custom keybinds system is based off of FNF HD's implementation
// https://github.com/Smokey555/FNF-HD-Open-Source

// variables type
typedef Variables = {
    var STVersion:String;
    var customIntro:Bool;
    var disableFNFVersionCheck:Bool;
    var debug:Bool;
    var discordRPC:Bool;
    var extraDialogue:Bool;
    var extraSongs:Bool;
    var fixMonsterIconFreeplay:Bool;
    var fixScoreLayout:Bool;
    var fixWeek6CountSounds:Bool;
    var hideOptionsMenu:Bool;
    var instMode:Bool;
    var logNG:Bool;
    var lyrics:Bool;
    var makeSpacesConsistent:Bool;
    var monsterIntro:Bool;
    var noticeEnabled:Bool;
    var outlinePauseInfo:Bool;
    var outlineScore:Bool;
    var songIndicator:Bool;
    var startWHP2Invis:Bool;
    var unknownIcons:Bool;
    var updatedInputSystem:Bool;
    var missCounter:Bool;
    var accuracyMeter:Bool;
    var downscroll:Bool;
    var cameraMovement:Bool;
    var backgroundMovement:Bool;
    // Controls
    var upBind:String;
    var downBind:String;
    var leftBind:String;
    var rightBind:String;
}

class STOptionsRewrite
{
    public static var _variables:Variables;

    // save to config.json
    public static function Save():Void
    {
        File.saveContent(('config.json'), Json.stringify(_variables));
    }

    // load from config.json
    public static function Load():Void
    {
        // Generates the config file if it doesn't exist
        if (!FileSystem.exists('config.json'))
        {
            _variables = {
                STVersion: "3.1.0",
                customIntro: true,
                debug: false,
                disableFNFVersionCheck: true,
                discordRPC: true,
                extraDialogue: true,
                extraSongs: true,
                fixMonsterIconFreeplay: true,
                fixScoreLayout: true,
                fixWeek6CountSounds: true,
                hideOptionsMenu: false,
                instMode: false,
                logNG: true,
                lyrics: true,
                makeSpacesConsistent: true,
                monsterIntro: true,
                noticeEnabled: false,
                outlinePauseInfo: true,
                outlineScore: true,
                songIndicator: true,
                startWHP2Invis: true,
                unknownIcons: true,
                updatedInputSystem: true,
                missCounter: true,
                accuracyMeter: true,
                downscroll: false,
                cameraMovement: true,
                backgroundMovement: true,
                upBind: "W",
                downBind: "S",
                leftBind: "A",
                rightBind: "D"
            };

            // save defaults to file
            Save();
        } else {
            // load current values
            var data:String = File.getContent('config.json');
            _variables = Json.parse(data);
        }

        // Regenerate config when we're out of date.
        // This WILL reset everything to default values.
        if (checkSTVersion() == false)
            {
                _variables = {
                    STVersion: "3.1.0",
                    customIntro: true,
                    debug: false,
                    disableFNFVersionCheck: true,
                    discordRPC: true,
                    extraDialogue: true,
                    extraSongs: true,
                    fixMonsterIconFreeplay: true,
                    fixScoreLayout: true,
                    fixWeek6CountSounds: true,
                    hideOptionsMenu: false,
                    instMode: false,
                    logNG: true,
                    lyrics: true,
                    makeSpacesConsistent: true,
                    monsterIntro: true,
                    noticeEnabled: false,
                    outlinePauseInfo: true,
                    outlineScore: true,
                    songIndicator: true,
                    startWHP2Invis: true,
                    unknownIcons: true,
                    updatedInputSystem: true,
                    missCounter: true,
                    accuracyMeter: true,
                    downscroll: false,
                    cameraMovement: true,
                    backgroundMovement: true,
                    upBind: "W",
                    downBind: "S",
                    leftBind: "A",
                    rightBind: "D"
                };
    
                Save();
    
                trace("Reset config.json");
            }
    }

    // Check for an outdated config
    // Returns true if the version is up to date
    // Returns false if there is no version or if we're out of date
    public static function checkSTVersion()
    {  
        // Don't ask why I check it up against the MainMenuState, I was out of ideas.
        if (_variables.STVersion != MainMenuState.smallThingsVersion
            || _variables.STVersion == null) {
                trace(_variables.STVersion);
                trace("Config.json out of date! Regenerating..");
                return false;
            } else {
                trace(_variables.STVersion);
                trace("Config.json is up to date!");
                return true;
            }
    }
}