extends CharacterBody3D

const SPEED = 10.0
const GRAVITY: int = 5
const JUMP_VELOCITY: int = 45

var up : Vector3 = Vector3.ZERO
var right : Vector3 = Vector3.ZERO
var forward  : Vector3 = Vector3.ZERO
var input_dir: Vector2 = Vector2.ZERO  # Inputs vector: left, right, forward, back

var fall_value: float = 0.0
var move_dir: Vector3 = Vector3.ZERO  # Direction the player is moving in

@onready var model: Node3D = $Model
@onready var camera_anchor: Node3D = $Head  # Used to get move_dir
@onready var debug_label : Label = $"../CanvasLayer/Label"


func _ready() -> void:
	print(floor_max_angle)
	floor_max_angle = deg_to_rad(360.0)
	print(floor_max_angle)

func _physics_process(_delta: float):
	if is_on_floor():
		fall_value = GRAVITY
	else:
		up_direction = Vector3.UP
		fall_value += GRAVITY
	
	velocity = (move() * SPEED) + (fall_value * -up_direction)
	
	if move_and_slide() && is_on_floor():
		up_direction = get_floor_normal()
	
	debug_label.text = "on floor: %s \non wall: %s \nvelocity: %s \nmove: %s" % [
		is_on_floor(), is_on_wall(), move_dir, velocity
	]

# ================ Inherited functions
func move() -> Vector3:
	# Jump
	if Input.is_action_just_pressed("move_jump") && is_on_floor():
		fall_value = -JUMP_VELOCITY
		up_direction = Vector3.UP
	
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	move_dir = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, camera_anchor.rotation.y).normalized()
	
	# Calculate the rotation to align the feet with the terrain
	if is_on_floor() && input_dir != Vector2.ZERO:
		# Some cross product math that I do not understand c:
		up = get_floor_normal()
		forward = move_dir
		right = up.cross(forward)
		forward = up.cross(right)
		
		model.basis = Basis(right, up, forward)  # Apply the calculated rotation
		
		# Ensure the scaling factors are 1 or -1 (This stops the model's scale changing)
		# FIXME: We should be able to modify this in the basis
		#       I just don't know which parts of the basis are relevant
		model.scale.x = 1 if model.scale.x >= 0 else -1
		model.scale.y = 1 if model.scale.y >= 0 else -1
		model.scale.z = 1 if model.scale.z >= 0 else -1
	
	return move_dir
