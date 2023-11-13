shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float value : hint_range(-1,2);
uniform float falloff : hint_range(0,20);

uniform vec4 background : source_color = vec4(1.0);
uniform vec4 objects : source_color = vec4(1.0);

uniform vec4 sourceObjects : source_color = vec4(1.0);

float daniWave(float input){
	return input/2.0 - float(int(input/2.0));
}

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * (43758.5453123 + daniWave(TIME * 10.0)));
}


float lengthOfVec2 (vec2 vec){
	return sqrt(vec.r * vec.r + vec.g * vec.g);
}

void fragment() {
	vec4 ogColor = texture(screen_texture,SCREEN_UV,0.0);
	
	COLOR = background;
	
	if (ogColor == sourceObjects){
		
		vec2 difference = vec2(0.5,0.5) - SCREEN_UV;
		difference.y *= 9.0/16.0;
		
		float distanceToMid = lengthOfVec2(difference) * 1.4142271f;
		
		float newVal = pow(distanceToMid * (1.0 + falloff),2) + (sin(TIME * 1.0) * 0.03) - value;
		
		
		
		if (random(UV) > newVal){
			COLOR = objects;
		}
		
	} 
	
	// Place fragment code here.
}
