shader_type canvas_item;

float fmod(float x, float y) {
	return sign(x) * (abs(x) - y * floor(abs(x) / y));
}

//between 0 and 1
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233) + vec2(fmod(TIME * 200.0,20),fmod(TIME,50)))) * (43758.5453123));
}

void fragment() {
	
	if (texture(TEXTURE,UV).a != 0.0 && random(UV) > 0.8){
		COLOR = vec4(0,0,0,1);
	}
	else{
		COLOR = vec4(0,0,0,0);
	}
	// Place fragment code here.
}
