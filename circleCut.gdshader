shader_type canvas_item;

uniform float value : hint_range(-1,2);

const float SCREEN_WIDTH = 512.0;
const float SCREEN_HEIGHT = 288.0;


uniform vec4 color : source_color = vec4(1.0);


float lengthOfVec2 (vec2 vec){
	return sqrt(vec.r * vec.r + vec.g * vec.g);
}

void fragment() {
	
	vec4 ogColor = texture(TEXTURE,UV);
	
	//COLOR = background;
	COLOR = vec4(0,0,0,0);
	
	
	vec2 difference = (vec2(0.5,0.5)) - UV;
	difference.y *= 9.0/16.0;
	
	if (lengthOfVec2(difference) < value) COLOR = color;
	
	}
