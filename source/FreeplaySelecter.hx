import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.*;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;

class FreeplaySelecter extends MusicBeatState{
    var _curIcon:FlxSprite;
    var _curSelected:Int = 0;
    public static var _curPack:Int;
    var camFollow:FlxObject;
    var prevcamfollow:FlxObject;
    var cameraSprite:FlxCamera;

    var icons:Array<FlxSprite> = [];
    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
    public static var _sections:Array<String> = [
        'main',
        'extras'
    ];
   /* var _initFreeplayColors:Array<FlxColor> = [
        0x8f0047,
        0x008f00,
        0x33252c,
        0xd46904,

    ];*/ // scrapped due to 

    override function create(){

        bg.color = 0xdb63ff;
        bg.scrollFactor.set();
        add(bg);
        for(i in 0..._sections.length){
            _curIcon = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/${_sections[i]}'));
            _curIcon.x = (1000 * i + 1) + (512 - _curIcon.width);
            _curIcon.y = (FlxG.height /2) - 256;
            _curIcon.scale.set(1.5, 1.5);
            icons.push(_curIcon);
            add(_curIcon);
            
        }
        camFollow = new FlxObject(0,0,1,1);
        camFollow.setPosition(icons[_curPack].x + 128, icons[_curPack].y + 256);
        FlxG.camera.follow(camFollow, LOCKON, 0.04);
        FlxG.camera.focusOn(camFollow.getPosition());

        if(prevcamfollow != null){
            camFollow = prevcamfollow;
            prevcamfollow = null;
        }

        add(camFollow);
        Highscore.load();
        changeSection();

        super.create();

    }
    override function update(elapsed:Float){
        if(controls.UI_RIGHT_P){
            changeSection(1);
        }
        if(controls.UI_LEFT_P){
            changeSection(-1);
        }
        if(controls.BACK){
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
        if(controls.ACCEPT){
            FlxG.sound.play(Paths.sound('confirmMenu'));

            
            FlxTween.tween(icons[_curPack], {'scale.x': 10, 'scale.y': 10, alpha:0}, 2, {ease:FlxEase.expoIn});     
            FlxTween.tween(bg, {'scale.x': 0, 'scale.y': 0, alpha:0}, 2, {ease:FlxEase.expoIn});
            new flixel.util.FlxTimer().start(2, func ->{
                FlxTransitionableState.skipNextTransIn = true;
                MusicBeatState.switchState(new FreeplayState());
            });
        }
        _curPack = _curSelected;
    }
    function changeSection(shit:Int = 0){
        _curSelected += shit;
        if(_curSelected < 0){
            _curSelected = _sections.length -1;
        }
        if(_curSelected >= _sections.length){
            _curSelected = 0;
        }

        FlxG.sound.play(Paths.sound('scrollMenu'));
        camFollow.x = icons[_curSelected].x + 128;
    }
}