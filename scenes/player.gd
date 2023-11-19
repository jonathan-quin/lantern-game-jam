extends CharacterBody2D

enum MOVE_STATES {WALK,LEFTWALLCLIMB,RIGHTWALLCLIMB,DASH}

const WALLCLIMB_FALLSPEED = 30
const WALLJUMP_JUMP_FORCE = -350
const WALLJUMP_HORIZONTAL_FORCE = 300
const WALLCLIMB_GRAVITY = 350

const DASH_SPEED = 450
const DASH_DISTANCE = 100
const DASH_COOLDOWN = 0.1
var timeUntilNextDash = 0.1
var canDash = false
var dashDir = 1 #always 1 or -1
var dashStartPos = Vector2.ZERO


var currentMoveStateField = MOVE_STATES.WALK
var currentMoveState: MOVE_STATES:
	get:
		return currentMoveStateField
	set(value):
		currentMoveStateField = value

const SPEED = 150.0
const BRIGHT_SPEED = 250.0

const GROUND_ACCEL = 6
const AIR_ACCEL = 3
const GROUND_STOP_ACCEL = 9
const AIR_STOP_ACCEL = 6

const JUMP_FORCE = -320.0
const DOUBLE_JUMP_FORCE = - 300
const BRIGHT_JUMP_FORCE = -365.0

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
	lanternLightLeft = Globals.lanternLight
	$lightAnimationPlayer.play("light_idle")
	$CanvasLayer/lightLeftIndicator.color = Globals.objectsColor
	$AnimatedSprite2D.material.set_shader_parameter( "progress", Globals.playerHurtProgress)
	


func _physics_process(delta):
	
	$CanvasLayer/lightLeftIndicator.visible = true
	$CanvasLayer/lightLeftIndicator.color = Globals.objectsColor
	$AnimatedSprite2D.material.set_shader_parameter( "progress", Globals.playerHurtProgress)
	
	$AnimatedSprite2D.material.set_shader_parameter( "progress", Globals.playerHurtProgress)
	
	if Input.is_action_just_pressed("reload"):
		ScreenTransition.playerDie()
	
	
	#Dani should lock their screen when they leave their laptop.
	
	lanternLit = !dead and Input.is_action_pressed("lightLantern")
	
	var particlesAmount = int(lanternLightLeft/4.0) + 1
	if $invertableStuff/CPUParticles2D.amount != particlesAmount:
		$invertableStuff/CPUParticles2D.amount = max(1, particlesAmount) 
	
	$CanvasLayer/lightLeftIndicator.size.x = lerp($CanvasLayer/lightLeftIndicator.size.x,lanternLightLeft * 5.0,5.0 * delta)
	
	lanternLightLeft -= delta
	if lanternLit:
		lanternLightLeft -= delta * 10 #you start with 100 and lose 5 a second, you can be lit for 20.
		
	
	if get_last_slide_collision() != null and get_last_slide_collision().get_collider().is_in_group("spikes"):
		takeDamage(100)
	
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
	
	handleMovement(delta)
	
	
	

func handleMovement(delta):
	
	var direction = Input.get_axis("left", "right")
	
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
			
			if timeUntilNextDash <= 0:
				canDash = true
			else:
				timeUntilNextDash -= delta
		
		
		
		# Handle Jump.
		if Input.is_action_just_pressed("up") and canJump:
			if remainingJumps == 2:
				velocity.y = BRIGHT_JUMP_FORCE if lanternLit else JUMP_FORCE
				$jumpNoise.play(0.18)
			else:
				velocity.y = DOUBLE_JUMP_FORCE
				lanternLightLeft -= 10
				$doubleJumpParticles.restart()
				$doubleJump.play()
			
			remainingJumps -= 1
			if remainingJumps <= 0:
				canJump = false
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		var currentAccel = (GROUND_ACCEL if is_on_floor() else AIR_ACCEL) * delta
		var currentStopAccel = (GROUND_STOP_ACCEL if is_on_floor() else AIR_STOP_ACCEL) * delta
		
		var currentSpeed = BRIGHT_SPEED if lanternLit else SPEED
		
		if direction:
			
			if currentSpeed == BRIGHT_SPEED:
				$whispering.volume_db = 0
			else:
				$whispering.volume_db = -8
			
			velocity.x = lerp(velocity.x,direction * currentSpeed,currentAccel)
			setFlipH(direction < 0)
			$AnimatedSprite2D.play("run")
		else:
			$whispering.volume_db = -12
			velocity.x = lerp(velocity.x,0.0,currentStopAccel)
			$AnimatedSprite2D.play("idle")
		
		if is_on_wall_only() and $wallChecks/touchingWall.is_colliding() and !$wallChecks/touchingFloor.is_colliding():
			if get_last_slide_collision().get_normal() == Vector2.RIGHT and velocity.x < 0:
				currentMoveState = MOVE_STATES.RIGHTWALLCLIMB
			if get_last_slide_collision().get_normal() == Vector2.LEFT and velocity.x > 0:
				currentMoveState = MOVE_STATES.LEFTWALLCLIMB
		
		tryToDash(sign(direction) if direction != 0 else (-1 if $AnimatedSprite2D.flip_h else 1))
		
		move_and_slide()
		
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
			
			$jumpNoise.play(0.18)
			velocity.x = -WALLJUMP_HORIZONTAL_FORCE if currentMoveState == MOVE_STATES.LEFTWALLCLIMB else WALLJUMP_HORIZONTAL_FORCE
			
			currentMoveState = MOVE_STATES.WALK
			
			remainingJumps -= 1
			if remainingJumps <= 0:
				canJump = false
		else:
			tryToDash(-1 if currentMoveState == MOVE_STATES.LEFTWALLCLIMB else 1)
		
		
		move_and_slide()
		
		pass
	elif currentMoveState == MOVE_STATES.DASH:
		$dashParticles.emitting = true
		$AnimatedSprite2D.play("dash")
		
		var dashVel = Vector2(DASH_SPEED * sign(dashDir),0)
		velocity = dashVel
		
		if move_and_slide():
			if velocity.move_toward(dashVel,1) != dashVel:
				currentMoveState = MOVE_STATES.WALK
			
		
		if global_position.distance_to(dashStartPos) > DASH_DISTANCE:
			currentMoveState = MOVE_STATES.WALK
		
		
		if currentMoveState == MOVE_STATES.WALK:
			velocity.x = sign(velocity.x) * SPEED
			$dashParticles.emitting = false
		
		timeUntilNextDash = DASH_COOLDOWN
		
		pass


func tryToDash(dir):
	
	if !Input.is_action_just_pressed("dash") or  !canDash:
		return
	
	lanternLightLeft -= 5
	canDash = false
	
	dashDir = sign(dir)
	currentMoveState = MOVE_STATES.DASH
	dashStartPos = global_position
	
	$dashNoise.play()
	
	pass


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
