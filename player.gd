extends CharacterBody3D


const SPEED = 15.0
const JUMP_VELOCITY = 9.0

@onready var bullet_origin = $BulletOrigin
var bullet_scene = preload("res://bullet.tscn")
var bomb_scene = preload("res://bomb.tscn")

@onready var pivot = $CameraOrigin
@export var sens = 0.5

@export var fire_rate = 0.1
var fire_timer = 0.0

@export var bomb_rate = 4.0
var bomb_timer = 0.0

@onready var label = $UserInterface/Label

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	if (Input.is_action_pressed("shoot")):
		if fire_timer <= 0:
			shoot()
			fire_timer = fire_rate
	fire_timer -= delta
	
	if (Input.is_action_pressed("throw")):
		if bomb_timer <= 0:
			throw_bomb()
			bomb_timer = bomb_rate
	bomb_timer -= delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemies"):
			die()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func die():
	if get_tree():
		get_tree().reload_current_scene()
	
func shoot():
	var bullet := bullet_scene.instantiate()
	
	var forward = -$CameraOrigin/SpringArm3D/Camera3D.get_global_transform().basis.z.normalized()
	var bullet_speed = 50.0
	bullet.linear_velocity = forward * bullet_speed
	
	get_parent().add_child(bullet)
	bullet.position = bullet_origin.global_position

func throw_bomb():
	var bomb = bomb_scene.instantiate()
	var forward = -$CameraOrigin/SpringArm3D/Camera3D.get_global_transform().basis.z.normalized()
	var bomb_speed = 20.0
	bomb.linear_velocity = forward * bomb_speed
	
	get_parent().add_child(bomb)
	bomb.position = bullet_origin.global_position
