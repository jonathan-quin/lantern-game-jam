extends CharacterBody2D

enum MOVE_STATES {WALK,LEFTWALLCLIMB,RIGHTWALLCLIMB,DASH}

const WALLCLIMB_FALLSPEED = 30
const WALLJUMP_JUMP_FORCE = -350
const WALLJUMP_HORIZONTAL_FORCE = 300
const WALLCLIMB_GRAVITY = 350



var currentMoveStateField = MOVE_STATES.WALK
var currentMoveState: MOVE_STATES:
	get:
		return currentMoveStateField
	set(value):
		currentMoveStateField = value

const SPEED = 200.0
const BRIGHT_SPEED = 300.0

const GROUND_ACCEL = 6
const AIR_ACCEL = 3
const GROUND_STOP_ACCEL = 9
const AIR_STOP_ACCEL = 6

const JUMP_FORCE = -300.0
const DOUBLE_JUMP_FORCE = - 250
const BRIGHT_JUMP_FORCE = -450.0

#indicates if the play is allowed to jump
var canJump = false
var remainingJumps = 0
#the number of jumps the play is given when they touch the ground
const MAX_JUMPS = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000
const COYOTE_TIME = 0.1


var lanternLightLeft = 100
var dead = false
var lanternLitField = false
var lanternLit: 
	get:
		return lanternLitField
	set(value):
		if lanternLit != value and !dead:
			if !value:
				$lightAnimationPlayer.play("light_idle")
			else:
				$lightAnimationPlayer.play("light_flare")
			
		
		lanternLitField = value

func _ready():
	
	$lightAnimationPlayer.play("light_idle")
	


func _physics_process(delta):
	
	if Input.is_action_just_pressed("reload"):
		ScreenTransition.playerDie()
	
	var direction = Input.get_axis("left", "right")
	#Dani should lock their screen when they leave their laptop.
	
	lanternLit = !dead and Input.is_action_pressed("lightLantern")
	
	if lanternLit:
		lanternLightLeft -= delta * 10 #you start with 100 and lose 5 a second, you can be lit for 20.
		
	
	if lanternLightLeft <= 0 and !dead:
		dead = true
		$lightAnimationPlayer.play("fizzle")
	
	if dead:
		
		if !$lightAnimationPlayer.is_playing():
			
			ScreenTransition.playerDie()
		
		
		
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		
		return
	
	if currentMoveState == MOVE_STATES.WALK:
		
		
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
			if remainingJumps == 2:
				velocity.y = BRIGHT_JUMP_FORCE if lanternLit else JUMP_FORCE
			else:
				velocity.y = DOUBLE_JUMP_FORCE
				$doubleJumpParticles.restart()
			
			remainingJumps -= 1
			if remainingJumps <= 0:
				canJump = false
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		var currentAccel = (GROUND_ACCEL if is_on_floor() else AIR_ACCEL) * delta
		var currentStopAccel = (GROUND_STOP_ACCEL if is_on_floor() else AIR_STOP_ACCEL) * delta
		
		var currentSpeed = BRIGHT_SPEED if lanternLit else SPEED
		
		if direction:
			velocity.x = lerp(velocity.x,direction * currentSpeed,currentAccel)
			setFlipH(direction < 0)
			$AnimatedSprite2D.play("run")
		else:
			velocity.x = lerp(velocity.x,0.0,currentStopAccel)
			$AnimatedSprite2D.play("idle")
		
		if is_on_wall_only() and $wallChecks/touchingWall.is_colliding() and !$wallChecks/touchingFloor.is_colliding():
			if get_last_slide_collision().get_normal() == Vector2.RIGHT and velocity.x < 0:
				currentMoveState = MOVE_STATES.RIGHTWALLCLIMB
			if get_last_slide_collision().get_normal() == Vector2.LEFT and velocity.x > 0:
				currentMoveState = MOVE_STATES.LEFTWALLCLIMB
			
		
	elif currentMoveState == MOVE_STATES.LEFTWALLCLIMB or currentMoveState == MOVE_STATES.RIGHTWALLCLIMB:
		
		setFlipH(true if currentMoveState == MOVE_STATES.LEFTWALLCLIMB else false)
		
		$AnimatedSprite2D.play("wall slide")
		
		if !$wallChecks/touchingWall.is_colliding() or $wallChecks/touchingFloor.is_colliding():
			currentMoveState = MOVE_STATES.WALK
		
		velocity.y += gravity * delta
		if velocity.y > WALLCLIMB_FALLSPEED:
			velocity.y = WALLCLIMB_FALLSPEED
		
		var currentAccel = GROUND_ACCEL * delta
		if direction:
			velocity.x = lerp(velocity.x,direction * SPEED,currentAccel)
		
		
		
		remainingJumps = 2
		canJump = true
		
		if Input.is_action_just_pressed("up") and canJump:
			velocity.y = WALLJUMP_JUMP_FORCE
			
			
			velocity.x = -WALLJUMP_HORIZONTAL_FORCE if currentMoveState == MOVE_STATES.LEFTWALLCLIMB else WALLJUMP_HORIZONTAL_FORCE
			
			remainingJumps -= 1
			if remainingJumps <= 0:
				canJump = false
		
		pass
	
	
	move_and_slide()
	

func setFlipH(flipH):
	$AnimatedSprite2D.flip_h = flipH
	
	var value = -1 if flipH else 1
	for child in $invertableStuff.get_children():
		child.position.x = abs(child.position.x )* value
	

var health = 100
func takeDamage(amount):
	health -= amount
	
	if health <= 0:
		ScreenTransition.playerDie()
	

func _on_coyote_time_timeout():
	
	if currentMoveState == MOVE_STATES.WALK:
		if remainingJumps > 1:
			remainingJumps -= 1
	pass # Replace with function body.
