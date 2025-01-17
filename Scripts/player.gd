extends CharacterBody2D


func _physics_process(delta: float) -> void:
	var velo : Vector2 = get_global_mouse_position() - global_position
	velocity = velo *100
	move_and_slide()
