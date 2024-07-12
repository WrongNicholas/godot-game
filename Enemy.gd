extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 7.0

func _ready() -> void:
	set_physics_process(false)
	call_deferred("dump_first_physics_frame")
	
func dump_first_physics_frame() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location
	
