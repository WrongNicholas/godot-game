extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for node in get_colliding_bodies():
		if node.is_in_group("enemies"):
			node.queue_free()
		
		queue_free()
