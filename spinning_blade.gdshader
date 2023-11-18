shader_type canvas_item;

void fragment() {
	if (texture(TEXTURE,UV).a != 0.0) COLOR = vec4(0,0,0,1);
	// Place fragment code here.
}
