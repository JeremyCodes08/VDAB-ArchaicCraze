import flixel.*;
import flixel.addons.transition.FlxTransitionableState;
class FirstTimeCheck extends FlxState{
    
    override function create(){
        
        if(FlxG.save.data.flashing == null && !FlashingState.leftState){
            FlxTransitionableState.skipNextTransIn = true;
	    	FlxTransitionableState.skipNextTransOut = true;
	    	MusicBeatState.switchState(new FlashingState());
        }
       else{
        FlxG.switchState(new TitleState());
       }
    }

}