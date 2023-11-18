extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$shaderBackground.visible = true if !Globals.debug else false
	$editorBackground.visible = false
	
	#$TileMap.set_cells_terrain_connect(0,$TileMap.get_used_cells(0),0,0)
	#$TileMap.set_cells_terrain_connect(0,$TileMap.get_used_cells(0),0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
