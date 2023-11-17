shader_type canvas_item;


uniform int progress : hint_range(0,6,1);

uniform vec4 leftArmBoneColor : source_color = vec4(1.0);
uniform vec4 leftArmColor : source_color = vec4(1.0);

uniform vec4 rightArm : source_color = vec4(1.0);

uniform vec4 leftLeg : source_color = vec4(1.0);
uniform vec4 rightLeg : source_color = vec4(1.0);

uniform vec4 headColor : source_color = vec4(1.0);

uniform vec4 transParent = vec4(0,0,0,0);

float getDifferenceToColor(float currentDistance,vec4 color, vec4 targetColor){
	vec4 d4 = abs(color - targetColor);
	return min(currentDistance, max(max(d4.r, d4.g), d4.b));
}

bool shouldRemove(vec4 col) {
	
	float d = 1.0;
	
	if (progress >= 1) d = getDifferenceToColor(d,col,leftArmColor);
	if (progress >= 2) d = getDifferenceToColor(d,col,rightLeg);
	if (progress >= 3) d = getDifferenceToColor(d,col,leftLeg);
	if (progress >= 4) d = getDifferenceToColor(d,col,rightArm);
	if (progress >= 5) d = getDifferenceToColor(d,col,leftArmBoneColor);
	if (progress >= 6) d = getDifferenceToColor(d,col,headColor);
	
	//0.01 is the tolerance
	return d <= 0.01;
	
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	COLOR = col;
	
	if (shouldRemove(col)) COLOR = transParent;
	else if (COLOR.a != 0.0) COLOR = vec4(0,0,0,1);
	
}