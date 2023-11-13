shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


uniform vec4 background : source_color = vec4(1.0);


void fragment() {
	
	vec4 ogColor = texture(screen_texture,SCREEN_UV,0.0);
	
	
	COLOR = background;
	
	
	// Place fragment code here.
}

