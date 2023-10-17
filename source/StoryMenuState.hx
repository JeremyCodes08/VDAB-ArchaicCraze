package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import WeekData;

using StringTools;


class StoryMenuState extends MusicBeatState // rewrite of the story menu, fuck you!
{

	// hardcore

	public static var week:String = 'stupid'; // pussy
	//var weekSelected:String = 'None';
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	var menuItems:FlxTypedGroup<FlxSprite>;
	var stupid:Bool = false;
	var curSelected:Int;
	var tex = Paths.getSparrowAtlas('story/storymenu');
	var weeks:Array<String> =[
		'turbi_week',
		'nanambi_week',
		'noleaks'
	];
	var weeksTitles:Array<String> =[
		'Turbi Week',
		'Nanambi Week',
		'No Leaks'
	];
	var bg:FlxSprite;
	var text1:FlxText;
	var text2:FlxText;

	var text3:FlxText;

	var timeShown:Int = 0;
	override function create(){
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0x3700ff;
		add(bg);
		FlxG.mouse.visible = true;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for(i in 0...weeks.length){
			var menuItem:FlxSprite = new FlxSprite((i * 476), 100);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', weeks[i]);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		timeShown = 0;
		text1 = new FlxText(0, FlxG.height - 44, FlxG.width, 'Use your mouse to select a week.', 20);
		text1.setFormat(Fonts.font, 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text1);


		text2 = new FlxText(0, FlxG.height - 84, FlxG.width, 40);
		text2.setFormat(Fonts.font, 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text2);
		super.create();
	}
	var laText:String;
	var lol:Bool = false;
	override function update(elapsed:Float){ // more advanced
		text2.text = laText;
		menuItems.forEach(function(spr:FlxSprite){// stupid
			if(FlxG.mouse.overlaps(spr)){
				laText = weeksTitles[curSelected];
				spr.alpha = 1;
				curSelected = spr.ID;
				if(FlxG.mouse.justPressed && !stupid){
					selectShit();
				}

			}
			else if (!FlxG.mouse.overlaps(spr)){
				spr.alpha = 0.6;
			}
		});
		
		if(controls.BACK){
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
			FlxG.mouse.visible = false;
		}// basic
		super.update(elapsed);
	}
  // probably worked my ass off to do all this
	function goTo2Song(song1:String, song2:String, sprite:FlxSprite){ // loader for 2 song week
		FlxG.mouse.visible = false;
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('titleShoot'));
		FlxFlicker.flicker(sprite, 1, 0.06, false, false, function(flick:FlxFlicker){
			menuItems.forEach(function(spr:FlxSprite){
				FlxTween.tween(spr, {y: -1280}, 0.4, {ease:FlxEase.expoIn, onComplete: function(tween:FlxTween){
					spr.kill();
				}});
			});
			FlxTween.tween(bg, {angle:45}, 0.8, {ease:FlxEase.expoIn});
			FlxTween.tween(bg, {alpha:0}, 0.8, {ease:FlxEase.expoIn});
			FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease:FlxEase.expoIn});
			PlayState.storyPlaylist = [song1, song2];
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], PlayState.storyPlaylist[0]);
			PlayState.isStoryMode = true;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			PlayState.storyDifficulty = 2;
		});
		new FlxTimer().start(2, tmr -> {
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}

	function goTo3Song(song1:String, song2:String, song3:String, sprite:FlxSprite){ // loader for 3 song week
		FlxG.mouse.visible = false;
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('titleShoot'));
		FlxFlicker.flicker(sprite, 1, 0.06, false, false, function(flick:FlxFlicker){
			menuItems.forEach(function(spr:FlxSprite){
				FlxTween.tween(spr, {y: -1280}, 0.4, {ease:FlxEase.expoIn, onComplete: function(tween:FlxTween){
					spr.kill();
				}});
			});
			FlxTween.tween(bg, {angle:45}, 0.8, {ease:FlxEase.expoIn});
			FlxTween.tween(bg, {alpha:0}, 0.8, {ease:FlxEase.expoIn});
			FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease:FlxEase.expoIn});
			PlayState.storyPlaylist = [song1, song2, song3];
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], PlayState.storyPlaylist[0]);
			PlayState.isStoryMode = true;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			PlayState.storyDifficulty = 2;
		});
		new FlxTimer().start(2, tmr -> {
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}

	function selectShit(){
		menuItems.forEach(function(spr:FlxSprite){
			if(curSelected == spr.ID){
				var weekSelected:String = weeks[curSelected];			
				switch(weekSelected){
					case 'nanambi_week':
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						goTo2Song('opposition', 'secret-shit', spr);
						week = "Nanambi Week";
				}
			}
		});
	}

}