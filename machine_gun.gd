extends Node2D

@onready var range = $range

var bulletPath = preload('res://bullet.tscn')

enum GUN_STATES {WAITING, REVVING, SHOOTING}
var state = GUN_STATES.WAITING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if state == GUN_STATES.WAITING:
		$Fireing.stop()
		
		if range.is_colliding() and $Timer.is_stopped():
			$Timer.start(2)
			$MachineStartUp.play()
			state = GUN_STATES.REVVING
	elif state == GUN_STATES.REVVING:
		pass
	elif state == GUN_STATES.SHOOTING:
		if $Timer.is_stopped():
			$MachineStartUp.stop()
			$Timer.start(5)
		
		
		
		shoot(delta)
		#code for creating the bullets
		
		pass
	


func _on_timer_timeout():
	if state == GUN_STATES.REVVING:
		$Fireing.play(0.0);
		state = GUN_STATES.SHOOTING
	elif state == GUN_STATES.SHOOTING:
		state = GUN_STATES.WAITING
	
	$Timer.stop()
	
	pass # Replace with function body.

var timeUntilNextShot = 0
var fireRate = 15.0 # shots per second
func shoot(delta):
	
	print(timeUntilNextShot)
	
	if timeUntilNextShot > 0:
		timeUntilNextShot -= delta
		return
	
	timeUntilNextShot = 1.0 / fireRate
	
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	
	bullet.position = $Marker2D.global_position
	bullet.rotation = $Marker2D.global_rotation + deg_to_rad(randf_range(-2,2))
