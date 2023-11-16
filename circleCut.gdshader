shader_type canvas_item;

uniform float value : hint_range(-1,2);

const float SCREEN_WIDTH = 512.0;
const float SCREEN_HEIGHT = 288.0;





float lengthOfVec2 (vec2 vec){
	return sqrt(vec.r * vec.r + vec.g * vec.g);
}

void fragment() {
	
	vec4 ogColor = texture(TEXTURE,UV,0.0);
	
	//COLOR = background;
	COLOR = vec4(0,0,0,0);
	
	
	vec2 difference = (vec2(0.5,0.5)) - UV;
	difference.y *= 9.0/16.0;
	
	if (lengthOfVec2(difference) < value) COLOR = vec4(1,1,1,1);
	else COLOR = vec4(1,1,1,0);
	
	}
