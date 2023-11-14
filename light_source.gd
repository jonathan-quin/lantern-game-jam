@tool

extends Node2D

@export var fullLitRadius = 100
#falloff is added to full lit
@export var fallOffRadius = 50

#1 being completely linear, 0 being instant
@export var fallOffCurve = 1

var lightShader

# Called when the node enters the scene tree for the first time.
func _ready():
	lightShader = $lightShader
	
	#if the script is not running in the editor
	if not Engine.is_editor_hint():
		lightShader.material.set_shader_parameter( "enabled", 1)
		$fullyLit.visible = false
		$partialLit.visible = false
	else: #if we are in the editor
		lightShader.material.set_shader_parameter( "enabled", 0)
		$fullyLit.visible = true
		$partialLit.visible = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint(): #runs while editor is open.
		
		$fullyLit.scale = Vector2.ONE * fullLitRadius
		$partialLit.scale = Vector2.ONE * (fullLitRadius + fallOffRadius)
		lightShader.material.set_shader_parameter( "fullyLitRange", fullLitRadius)
		lightShader.material.set_shader_parameter( "falloffRange", fallOffRadius)
		pass
	else:
		setGlobalPosition(global_position)
		lightShader.material.set_shader_parameter( "fullyLitRange", fullLitRadius)
		lightShader.material.set_shader_parameter( "falloffRange", fallOffRadius)
		pass

func setGlobalPosition(globalPos):
	
	var difference = globalPos - Globals.cameraPosition
	
	lightShader.material.set_shader_parameter ( "posX", (difference.x))
	lightShader.material.set_shader_parameter ( "posY", (difference.y))
	

