extends Node2D

@export var timeIn = 0.1;
@export var timeOut = 0.3;
@export var timeOffset = 1;

var waiting = load("res://WaitingSpikes.png")
var extended = load("res://ExtendedSpikes.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaitingSpikes.texture.set_frame_duration(0,timeIn)
	$WaitingSpikes.texture.set_frame_duration(1,timeOut)
	$WaitingSpikes.texture.current_frame = 0
	$Offset.start(timeOffset)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Offset.is_stopped():
		if $WaitingSpikes.texture.current_frame == 0:
			for body in $damageArea.get_overlapping_bodies():
				if body.is_in_group("player"):
					body.takeDamage(100)
	
	var startingVal = $damageArea/CollisionShape2D.disabled
	$damageArea/CollisionShape2D.disabled = $WaitingSpikes.texture.current_frame == 0
	if $damageArea/CollisionShape2D.disabled != startingVal and $WaitingSpikes.texture.speed_scale == 1:
		if $WaitingSpikes.texture.current_frame == 0:
			$SpikeTrapExtendingSound.play()
		else: 
			$SpikeTrapRetreatingSound.play()
	
	pass





func _on_offset_timeout():
	$WaitingSpikes.texture.speed_scale = 1
	pass # Replace with function body.
