extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	velocity = Vector2(SPEED,0).rotated(rotation)
	
	move_and_slide()
	
	if get_last_slide_collision() != null:
		queue_free()
	
