extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.cameraPosition = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Globals.cameraPosition = global_position
	pass
