extends Node3D

@export var time : float = 4.0
var timer : float = 0.0

var enemy_scene = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func spawn_enemy(pos: Vector3) -> void:
	var enemy := enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= time:
		timer = 0.0
		spawn_enemy($pos1.global_position)
		spawn_enemy($pos2.global_position)
		spawn_enemy($pos3.global_position)
		spawn_enemy($pos4.global_position)
