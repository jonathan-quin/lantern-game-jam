extends CanvasLayer

func change_scene(target: String) -> void:  # change screen animation
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('dissolve')

func playerDie() -> void:  # change screen animation
	get_tree().paused = true
	$AnimationPlayer.play("die_animation")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
	$AnimationPlayer.play_backwards("die_animation")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false


var currentLevel = 0

var levels = [
	"res://levels/level1Tutorial.tscn",
	"res://levels/level2movementTutorial.tscn",
	"res://levels/level3WallMechanics.tscn"
	
	
	
	
]

func goToNextLevel():
	
	if currentLevel < levels.size() - 1:
		currentLevel += 1
	
	
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().paused = true
	get_tree().change_scene_to_file(levels[currentLevel])
	$AnimationPlayer.play_backwards('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	
	
	

