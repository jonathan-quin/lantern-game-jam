extends Node2D

@export var timeIn = 0.1;
@export var timeOut = 0.3;
@export var timeOffset = 1.0;

var waiting = load("res://WaitingSpikes.png")
var extended = load("res://ExtendedSpikes.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Offset.start(timeOffset)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $AnimatedSprite2D.animation == StringName("out"):
		for body in $damageArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				body.takeDamage(100)
	





func _on_offset_timeout():
	_on_frame_changer_timeout()
	pass # Replace with function body.


func _on_frame_changer_timeout():
	if $AnimatedSprite2D.animation == StringName("in"):
		$AnimatedSprite2D.play("out")
		$frameChanger.start(timeOut)
		$SpikeTrapExtendingSound.play()
		$damageArea/CollisionShape2D.disabled = true
	else:
		$AnimatedSprite2D.play("in")
		$frameChanger.start(timeIn)
		$SpikeTrapRetreatingSound.play()
		$damageArea/CollisionShape2D.disabled = false
	pass # Replace with function body.
