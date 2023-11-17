shader_type canvas_item;


uniform int progress : hint_range(0,1,1);

uniform vec4 leftArmBoneColor : source_color = vec4(1.0);
uniform vec4 leftArmColor : source_color = vec4(1.0);

uniform vec4 rightArm : source_color = vec4(1.0);

uniform vec4 leftLeg : source_color = vec4(1.0);
uniform vec4 rightLeg : source_color = vec4(1.0);

uniform vec4 transParent = vec4(0,0,0,0);

bool shouldRemove(vec4 col) {
	
	vec4 d4 = abs(col - leftArmColor);
	float d = max(max(d4.r, d4.g), d4.b);
	
	if(d <= 0.01) {
		return true;
	}
	
	return false;
	
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	COLOR = col;
	
	if (shouldRemove(col)) COLOR = transParent;
	
	
}