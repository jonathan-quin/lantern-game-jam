extends Node2D

@export var lanternLight = 100.0
@export var objects = Color.WHITE
@export var background = Color.BLACK
@export var hurtProgress = 0


func _init():
	Globals.objectsColor = objects
	Globals.backgroundColor = background
	Globals.lanternLight = lanternLight
	Globals.playerHurtProgress = hurtProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Globals.objectsColor = objects
	Globals.backgroundColor = background
	Globals.lanternLight = lanternLight
	Globals.playerHurtProgress = hurtProgress
	
	
	$shaderBackground.visible = true if !Globals.debug else false
	$shaderBackground.material.set_shader_parameter( "background", Globals.backgroundColor)
	$editorBackground.visible = false
	
	#$TileMap.set_cells_terrain_connect(0,$TileMap.get_used_cells(0),0,0)
	#$TileMap.set_cells_terrain_connect(0,$TileMap.get_used_cells(0),0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Globals.objectsColor = objects
	Globals.backgroundColor = background
	Globals.lanternLight = lanternLight
	Globals.playerHurtProgress = hurtProgress
	pass
