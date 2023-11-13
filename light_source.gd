extends Node2D


var lightShader

# Called when the node enters the scene tree for the first time.
func _ready():
	lightShader = $lightShader
	lightShader.material.set_shader_parameter( "enabled", 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setGlobalPosition(global_position)
	pass

func setGlobalPosition(globalPos):
	
	var difference = globalPos - Globals.cameraPosition
	
	lightShader.material.set_shader_parameter ( "posX", (difference.x))
	lightShader.material.set_shader_parameter ( "posY", (difference.y))
	

