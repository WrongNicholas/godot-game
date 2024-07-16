extends RigidBody3D

@onready var explosion_scene = preload("res://explosion.tscn")

func _ready():
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta):
	for node in get_colliding_bodies():
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		explosion.position = global_position
		queue_free()
