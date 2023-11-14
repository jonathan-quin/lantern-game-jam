extends CharacterBody2D

enum MOVE_STATES {WALK,LEFTWALLCLIMB,RIGHTWALLCLIMB,DASH}


var currentMoveState = MOVE_STATES.WALK

const SPEED = 300.0
const BRIGHT_SPEED = 600.0

const GROUND_ACCEL = 6
const AIR_ACCEL = 3
const GROUND_STOP_ACCEL = 9
const AIR_STOP_ACCEL = 6

const JUMP_FORCE = -300.0
const BRIGHT_JUMP_FORCE = -450.0

#indicates if the play is allowed to jump
var canJump = false
var remainingJumps = 0
#the number of jumps the play is given when they touch the ground
const MAX_JUMPS = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000
const COYOTE_TIME = 0.1

func _ready():
	
	$lightAnimationPlayer.play("light_idle")
	


func _physics_process(delta):
	
	var direction = Input.get_axis("left", "right")
	
	match  currentMoveState:
		MOVE_STATES.WALK:
			$AnimatedSprite2D.play("run")
			
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta
				if !$coyoteTime.is_stopped():
					$coyoteTime.start()
			else:
				$coyoteTime.wait_time = COYOTE_TIME
				canJump = true
				remainingJumps = MAX_JUMPS
			
			
			
			# Handle Jump.
			if Input.is_action_just_pressed("up") and canJump:
				velocity.y = JUMP_FORCE
				
				remainingJumps -= 1
				if remainingJumps <= 0:
					canJump = false
			
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.

			
			var currentAccel = (GROUND_ACCEL if is_on_floor() else AIR_ACCEL) * delta
			var currentStopAccel = (GROUND_STOP_ACCEL if is_on_floor() else AIR_STOP_ACCEL) * delta
			if direction:
				velocity.x = lerp(velocity.x,direction * SPEED,currentAccel)
			else:
				velocity.x = lerp(velocity.x,0.0,currentStopAccel)
			
			if is_on_wall_only():
				if get_last_slide_collision().get_normal() == Vector2.RIGHT and velocity.x > 0:
					currentMoveState = MOVE_STATES.LEFTWALLCLIMB
				if get_last_slide_collision().get_normal() == Vector2.LEFT and velocity.x < 0:
					currentMoveState = MOVE_STATES.LEFTWALLCLIMB
				
			
		MOVE_STATES.LEFTWALLCLIMB or MOVE_STATES.RIGHTWALLCLIMB:
			
			$AnimatedSprite2D.play("wall slide")
			
			if (not is_on_wall_only()) or is_on_ceiling():
				currentMoveState = MOVE_STATES.WALK
			
			var currentAccel = GROUND_ACCEL * delta
			if direction:
				velocity.x = lerp(velocity.x,direction * SPEED,currentAccel)
			
			print(velocity)
			
			remainingJumps = 2
			
			if Input.is_action_just_pressed("up") and canJump:
				velocity.y = JUMP_FORCE
				
				
				velocity.x += 500 if currentMoveState == MOVE_STATES.LEFTWALLCLIMB else -500
				
				remainingJumps -= 1
				if remainingJumps <= 0:
					canJump = false
			
			pass
	
	
	
	move_and_slide()
	

func setFlipH(flipH):
	$AnimatedSprite2D.flip_h = flipH
	
	
	

func _on_coyote_time_timeout():
	
	if currentMoveState == MOVE_STATES.WALK:
		if remainingJumps > 1:
			remainingJumps -= 1
	pass # Replace with function body.
