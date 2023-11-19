@tool

extends Node2D

@export var rpm = 2.0
@export var length = 25.0
@export var startingRot = 25.0
@export var bladeSizeModifier = 2.0


const BLADEROTSPEED = 0.02 * 360

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.is_editor_hint():
		$display.visible = false
	
	$rotatable.rotation = deg_to_rad(startingRot)
	$display.visible = false
	#$SpikeBall.rect_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for body in $rotatable/BigSawblade/playerDetect.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.takeDamage(100)
	
	$rotatable/Arm.size.x = length
	$rotatable/BigSawblade.position.x = length
	
	$rotatable.rotation += deg_to_rad(rpm * 360/60 * delta)
	$rotatable.rotation = fmod( $rotatable.rotation, 2.0 * PI)
	$rotatable/BigSawblade.rotation += BLADEROTSPEED * delta
	$rotatable/BigSawblade.rotation = fmod( $rotatable/BigSawblade.rotation, 2.0 * PI)
	
	$rotatable/BigSawblade.scale = Vector2.ONE * 0.05 * bladeSizeModifier
	
	#how we show the display in the editor
	if Engine.is_editor_hint():
		$display.visible = true
		$display.rotation = deg_to_rad(startingRot)
		$display.size.x = length
		
	
	pass
