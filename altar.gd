extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var activated = false
func _on_area_2d_body_entered(body):
	
	if !body.is_in_group("player") or activated:
		return
	
	$AnimationPlayer.play("activate")
	activated = true
	
	await  $AnimationPlayer.animation_finished
	ScreenTransition.goToNextLevel()
	
	
	pass # Replace with function body.
