extends CharacterBody2D


const SPEED = 600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	velocity = Vector2(SPEED,0).rotated(rotation)
	
	move_and_slide()
	
	var lastCollision = get_last_slide_collision()
	if lastCollision != null:
		if lastCollision.get_collider().is_in_group("player"):
			lastCollision.get_collider().takeDamage(50)
		
		queue_free()
	
