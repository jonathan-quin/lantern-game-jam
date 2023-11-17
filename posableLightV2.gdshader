shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

//position relative to camera.
uniform float posX : hint_range(-10000,100000);
uniform float posY : hint_range(-10000,100000);

uniform int enabled : hint_range(0,1,1);

uniform float fullyLitRange : hint_range(0,500);
uniform float falloffRange : hint_range(0,500);
uniform float falloffCurve : hint_range(0.0, 1.0);

uniform vec4 objects : source_color = vec4(1.0);
uniform vec4 sourceObjects : source_color = vec4(1.0);

const float SCREEN_WIDTH = 512.0;
const float SCREEN_HEIGHT = 288.0;

float fmod(float x, float y) {
	return sign(x) * (abs(x) - y * floor(abs(x) / y));
}

//between 0 and 1
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233) + vec2(fmod(TIME * 200.0,20),fmod(TIME,50)))) * (43758.5453123));
}

//between 0 and 1
float random2 (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233) + vec2(fmod(TIME * 654.54,23.54),fmod(TIME*54.43,565.43)))) * (43758.5453123));
}

float lengthOfVec2 (vec2 vec){
	return sqrt((vec.x * vec.x) + (vec.y * vec.y));
}

void fragment() {
	
	if (enabled != 0)
	{
		
		vec4 ogColor = texture(screen_texture,SCREEN_UV,0.0);
		
		//pixels are transparent until they aren't
		COLOR = vec4(0,0,0,0);
		
		vec2 difference = (vec2(0.5 * SCREEN_WIDTH,0.5 * SCREEN_HEIGHT) + vec2(posX,posY)) - (SCREEN_UV * vec2(SCREEN_WIDTH,SCREEN_HEIGHT));
		float distanceToMid = lengthOfVec2(difference);
		
		if (ogColor == sourceObjects){
			
			
			
			float entireRange = falloffRange + fullyLitRange;
			float newVal = 0.0;
			
			if (distanceToMid < fullyLitRange){
				newVal = 1.0;
			} else if (distanceToMid > entireRange){
				newVal = 0.0;
			} else {
				float distanceIntoFalloff = distanceToMid - fullyLitRange;
				
				newVal = 1.0 + -pow(distanceIntoFalloff/falloffRange,falloffCurve);
			}
			
			//the lower newVal is, the better lit the area is
			if (random(UV) < newVal){
				
				COLOR = objects;
			}
		}else{
			
			float entireRange = falloffRange + fullyLitRange;
			
			float newVal = 1.0 - distanceToMid/entireRange;
			newVal *= 0.03;
			
			if (distanceToMid < entireRange && random(UV) < newVal && random2(UV) < newVal){
				COLOR = objects;
			}
		}
		 
	} 
	// Place fragment code here.
}
