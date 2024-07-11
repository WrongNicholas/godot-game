extends RigidBody3D

var mouse_sensitivity := 0.0005
var twist_input := 0.0
var pitch_input := 0.0

var jump_force := Vector3.ZERO
var decend_force := Vector3.ZERO
var movement_speed := 1500.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var raycast := $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	jump_force.y = 2000.0
	decend_force.y = -4000.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(twist_pivot.basis * input * movement_speed * delta)
	
	handle_mouse_movement()
	
	if (is_grounded() && Input.is_action_just_pressed("jump")):
		apply_central_force(jump_force)
	
	if (!is_grounded() && Input.is_action_pressed("decend")):
		apply_central_force(decend_force * delta)

func is_grounded() -> bool:
	raycast.enabled = true
	return raycast.is_colliding()

func handle_mouse_movement():
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp (
		pitch_pivot.rotation.x,
		-0.5,
		0.5
	)
	
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
