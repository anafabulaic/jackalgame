extends ColorRect

signal fade_done

func set_fade(fade: float) -> void:
	material.set_shader_parameter("intensity", fade)
	
func fade_out(seconds: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, seconds)
	tween.tween_callback(fade_done.emit)
	
func fade_in(seconds: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(set_fade, 0.0, 1.0, seconds)
	tween.tween_callback(fade_done.emit)
