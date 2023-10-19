package; // shoutout to TheLeerName for the basic effect code :)

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.addons.display.FlxRuntimeShader;

using StringTools;

class ChromaEffect extends BaseEffect {
	public function new() {
		shader = new FlxRuntimeShader("
        #pragma header

        uniform float iTime;

        void main() {
            vec2 uv = openfl_TextureCoordv;

            float amount = 0.0;
            amount = (1.0 + sin(iTime*6.0)) * 0.5;
            amount *= 1.0 + sin(iTime*16.0) * 0.5;
            amount *= 1.0 + sin(iTime*19.0) * 0.5;
            amount *= 1.0 + sin(iTime*27.0) * 0.5;
            amount = pow(amount, 3.0);
            amount *= 0.05;

            gl_FragColor.r =  flixel_texture2D(bitmap, vec2(uv.x + amount, uv.y)).r;
            gl_FragColor.ga = flixel_texture2D(bitmap, uv).ga;
            gl_FragColor.b =  flixel_texture2D(bitmap, vec2(uv.x - amount, uv.y)).b;

            gl_FragColor.rgb *= (1.0 - amount * 0.5);
        }
		");
		super();
	}
}
class WavyBG extends BaseEffect{
    public function new(){
        shader = new FlxRuntimeShader('#pragma header

        #define round(a) floor(a + 0.5)
        #define texture flixel_texture2D
        #define iResolution openfl_TextureSize
        uniform float iTime;
        #define iChannel0 bitmap
        uniform sampler2D iChannel1;
        uniform sampler2D iChannel2;
        uniform sampler2D iChannel3;
        
        void main()
        {
            float frequency = 20.0;
            float amplitude = 0.15;
            
            vec2 texCoord = openfl_TextureCoordv;
            
            vec2 pulse = sin(iTime - frequency * texCoord);
            float dist = 2.0 * length(texCoord.y - 1.0);
            
            vec2 newCoord = texCoord + amplitude * vec2(1.0, pulse.x); // y-axis only; 
            
            vec2 interpCoord = mix(newCoord, texCoord, dist);
            
            gl_FragColor = texture(iChannel0, interpCoord);
        }');
        super();
    }
}
class AltEffect extends BaseEffect {
	public function new() {
		shader = new FlxRuntimeShader("
			#pragma header
            #define round(a) floor(a + 0.5)
#define texture flixel_texture2D
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

float random2d(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float randomRange (in vec2 seed, in float min, in float max) {
		return min + random2d(seed) * (max - min);
}

// return 1 if v inside 1d range
float insideRange(float v, float bottom, float top) {
   return step(bottom, v) - step(top, v);
}

//inputs
float AMT = 0.4; //0 - 1 glitch amount
float SPEED = 0.5; //0 - 1 speed
   
void main()
{
    
    float time = floor(iTime * SPEED * 60.0);    
	vec2 uv = openfl_TextureCoordv;
    
    //copy orig
    vec3 outCol = texture(iChannel0, uv).rgb;
    
    //randomly offset slices horizontally
    float maxOffset = AMT/2.0;
    for (float i = 0.0; i < 10.0 * AMT; i += 1.0) {
        float sliceY = random2d(vec2(time , 2345.0 + float(i)));
        float sliceH = random2d(vec2(time , 9035.0 + float(i))) * 0.25;
        float hOffset = randomRange(vec2(time , 9625.0 + float(i)), -maxOffset, maxOffset);
        vec2 uvOff = uv;
        uvOff.x += hOffset;
        if (insideRange(uv.y, sliceY, fract(sliceY+sliceH)) == 1.0 ){
        	outCol = texture(iChannel0, uvOff).rgb;
        }
    }
    
    //do slight offset on one entire channel
    float maxColOffset = AMT/6.0;
    float rnd = random2d(vec2(time , 9545.0));
    vec2 colOffset = vec2(randomRange(vec2(time , 9545.0),-maxColOffset,maxColOffset), 
                       randomRange(vec2(time , 7205.0),-maxColOffset,maxColOffset));
    if (rnd < 0.33){
        outCol.r = texture(iChannel0, uv).r;
        
    }else if (rnd < 0.66){
        outCol.g = texture(iChannel0, uv).g;
        
    } else{
        outCol.b = texture(iChannel0, uv).b;  
    }
       
	gl_FragColor = vec4(outCol,texture(iChannel0, uv).a);
}");
		super();
	}
}

/*class OppositionEffect extends BaseEffect { // scrappin' this cuz it feels unoriginal + its stolen code from official dave and bambi respoitory
	public function new() {
		shader = new FlxRuntimeShader("
			#pragma header

			#define RATE 0.75
			uniform float iTime;

			float rand(vec2 co) {
				return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) * 2.0 - 1.0;
			}

			float offset(float blocks, vec2 uv) {
				float shaderTime = iTime*RATE;
				return rand(vec2(shaderTime, floor(uv.y * blocks)));
			}

			void main() {
				vec2 uv = openfl_TextureCoordv;
				gl_FragColor = vec4(
					flixel_texture2D(bitmap, uv + vec2(offset(64.0, uv) * 0.03, 0.0)).r,
					flixel_texture2D(bitmap, uv + vec2(offset(64.0, uv) * 0.03 * 0.16666666, 0.0)).g,
					flixel_texture2D(bitmap, uv + vec2(offset(64.0, uv) * 0.03, 0.0)).b,
					flixel_texture2D(bitmap, uv).a
				);
			}
		");
		super();
	}
}*/

class ExtraBrightness extends BaseEffect{
    public function new(){
        shader = new FlxRuntimeShader('
        #pragma header

#define round(a) floor(a + 0.5)
#define texture flixel_texture2D
#define iResolution openfl_TextureSize
uniform float iTime;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

mat4 brightnessMatrix( float brightness )
{
    return mat4( 1, 0, 0, 0,
                 0, 1, 0, 0,
                 0, 0, 1, 0,
                 brightness, brightness, brightness, 1 );
}

mat4 contrastMatrix( float contrast )
{
	float t = ( 1.0 - contrast ) / 2.0;
    
    return mat4( contrast, 0, 0, 0,
                 0, contrast, 0, 0,
                 0, 0, contrast, 0,
                 t, t, t, 1 );

}

mat4 saturationMatrix( float saturation )
{
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    
    float oneMinusSat = 1.0 - saturation;
    
    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3( saturation, 0, 0 );
    
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0, saturation, 0 );
    
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0, saturation );
    
    return mat4( red,     0,
                 green,   0,
                 blue,    0,
                 0, 0, 0, 1 );
}

const float brightness = 0.15;
const float contrast = 1.2;
const float saturation = 1.5;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec4 color = texture(iChannel0, fragCoord/iResolution.xy);
    
	fragColor = brightnessMatrix( brightness ) *
        		contrastMatrix( contrast ) * 
        		saturationMatrix( saturation ) *
        		color;
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}');
  super();
    }
}

/**
 * btw u will get null object reference if you try to create instance from this class, to avoid it:
 * 1. extend your class by it
 * 2. set `shader` value to `new FlxRuntimeShader()` before calling `super()`
 * 3. use your shader <3
 * 
 * Psych Engine 0.6.3 / 0.7.X compatible btw
 * @author TheLeerName
 */
class BaseEffect extends FlxBasic { // shoutout to TheLeerName
	public var shader(default, null):FlxRuntimeShader;
	public function new() {
		super();
		shader.data.iTime.value = [0];
		FlxG.state.add(this);
		shaderCoordsFix();
	}
	override function update(elapsed:Float) {
		super.update(elapsed);
		if (shader.data.iTime != null) shader.data.iTime.value[0] += elapsed;
	}

	function shaderCoordsFix() {
		if (Type.getClassFields(Main).contains('resetSpriteCache')) // it already in engine in 0.7 and later lol
			return;

		var func = (w, h) -> {
			if (FlxG.cameras != null) for (cam in FlxG.cameras.list)
				@:privateAccess if (cam != null && cam._filters != null) {
					cam.flashSprite.__cacheBitmap = null;
					cam.flashSprite.__cacheBitmapData = null;
				}

			@:privateAccess if (FlxG.game != null) {
				FlxG.game.__cacheBitmap = null;
				FlxG.game.__cacheBitmapData = null;
			}
		}
		if (!FlxG.signals.gameResized.has(func))
			FlxG.signals.gameResized.add(func);
	}
}