extends Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_mouse_capture"):
		if Input.mouse_mode:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
