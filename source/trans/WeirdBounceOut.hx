package transition.data;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

/**
    Transition animation made to test the new transition system.
**/
class WeirdBounceOut extends BasicTransition{

    var blockThing:FlxSprite;
    var time:Float;

    override public function new(_time:Float){
        
        super();

        time = _time;

        blockThing = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blockThing.x -= blockThing.width;
        block2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        block2.x -= blockThing.width;
        add(blockThing);

    }

    override public function play(){
        FlxTween.tween(blockThing, {x: 0}, time, {ease: FlxEase.quartOut, onComplete: function(tween){
            end();
        }});
        FlxTween.tween(block2, {x: - FlxG.width}, time, {ease: FlxEase.quartOut, startDelay: 0.2, onComplete: function(tween){
            end();
        }});
    }

}