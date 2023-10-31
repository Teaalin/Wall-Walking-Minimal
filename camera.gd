extends Node3D

const CAM_TILT_MIN: float = deg_to_rad(-70)
const CAM_TILT_MAX: float = deg_to_rad(100)
const CAM_SENSITIVITY_H: float = 0.5
const CAM_SENSITIVITY_V: float = 0.3

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotation.y += (deg_to_rad(-event.relative.x * CAM_SENSITIVITY_H))
		rotation.x += (deg_to_rad(-event.relative.y * CAM_SENSITIVITY_V))
		rotation.x = clampf(rotation.x, CAM_TILT_MIN, CAM_TILT_MAX)
