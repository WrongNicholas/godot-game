extends Node3D

@onready var mesh = $MeshInstance3D
@onready var collider = $Area3D/CollisionShape3D

var min_radius = 1.0
@export var max_radius = 15.0

@export var explosion_time = 0.2
@export var explosion_remaining_time = .4
var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if (timer < explosion_time):
		var temp_scale = (1 - (explosion_time - timer)/explosion_time) * max_radius
		mesh.scale.x = temp_scale
		mesh.scale.y = temp_scale
		mesh.scale.z = temp_scale
		collider.scale.x = temp_scale
		collider.scale.y = temp_scale
		collider.scale.z = temp_scale
		
#	for node in get_colliding_bodies():
#		if node.is_in_group("enemies"):
#			node.queue_free()

	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.queue_free()
	
	if timer >= explosion_time + explosion_remaining_time:
		queue_free()
