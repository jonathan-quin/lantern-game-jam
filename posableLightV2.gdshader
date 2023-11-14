shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float posX : hint_range(-10000,100000);
uniform float posY : hint_range(-10000,100000);

uniform int enabled : hint_range(0,1,1);

uniform float fullyLitRange : hint_range(0,500);
uniform float falloffRange : hint_range(0,500);

uniform vec4 objects : source_color = vec4(1.0);
uniform vec4 sourceObjects : source_color = vec4(1.0);

const float SCREEN_WIDTH = 512.0;
const float SCREEN_HEIGHT = 288.0;

float map(float input_start, float input_end, float output_start, float output_end, float input )
{
	return output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start);
}

float daniWave(float input){
	return input/2.0 - float(int(input/2.0));
}

//between 0 and 1
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * (43758.5453123) );
}


float lengthOfVec2 (vec2 vec){
	return sqrt((vec.x * vec.x) + (vec.y * vec.y));
}

void fragment() {
	
	if (enabled != 0)
	{
		
		vec4 ogColor = texture(screen_texture,SCREEN_UV,0.0);
		
		//COLOR = background;
		COLOR = vec4(0,0,0,0);
		
		if (ogColor == sourceObjects){
			
			vec2 difference = (vec2(0.5 * SCREEN_WIDTH,0.5 * SCREEN_HEIGHT) + vec2(posX,posY)) - (SCREEN_UV * vec2(SCREEN_WIDTH,SCREEN_HEIGHT));
			
			//multiplied by the sqrt of 2 for some reason. Don't ask.
			float distanceToMid = lengthOfVec2(difference);// * 1.4142271f ;
			//this distance is in pixels.
			
			/*float newVal = 1.0;
			
			if (distanceToMid > fullyLitRange){
				newVal = 0.5;
			}*/
			
			float entireRange = falloffRange + fullyLitRange;
			float newVal = map(fullyLitRange,entireRange,1,0,distanceToMid);
			
			newVal = min(1.0,newVal);
			
			//the lower newVal is, the better lit the area is
			if (random(UV) < newVal){
				
				COLOR = objects;
			}
			
			/*COLOR = vec4(newVal,newVal,newVal,1.0);
			
			if (newVal < 1.0){
				COLOR = vec4(newVal*0.5,newVal*0.5,newVal*0.5,1.0);
			}*/
			
		} 
	} 
	// Place fragment code here.
}