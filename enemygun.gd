extends CharacterBody3D

# Stores bullets
@export var bullet_scene: PackedScene

# Track Health
@export var health = 1

# Make the ai not aimbots
@export var inaccuracy = 1.0
var current_inaccuracy = randf_range(-0.08, 0.08)

func _physics_process(delta):
	# Look at player
	var player =  get_node("/root/Main/Character")
	if player:
		current_inaccuracy += randf_range(-0.0035, 0.0035) * inaccuracy
		current_inaccuracy = clamp(current_inaccuracy, -0.08, 0.08)
		var target = player.transform.origin
		look_at(target, Vector3.UP)
		rotate_y(current_inaccuracy)

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	# Create a bullet instance and add it to the scene.
	var bullet = bullet_scene.instantiate()
	
	# Get the location and angle of the bullet
	var bullet_spawn_location = $GunModel/BulletSpawner.global_position
	var angle = rotation
	
	bullet.initialize("enemy", bullet_spawn_location, angle)
	get_node("/root/Main").add_child(bullet)
	
