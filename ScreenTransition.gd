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
