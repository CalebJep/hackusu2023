extends CharacterBody3D

# Stores bullets
@export var bullet_scene: PackedScene

# Track Health
@export var health = 1

# Make the ai not aimbots
@export var inaccuracy = 1.0
var current_inaccuracy = randf_range(-0.08, 0.08)

var player

func _ready():
	player = get_node("/root/Main/Character")
	$CollisionShape3D.disabled = true
	set_physics_process(false)


func _physics_process(delta):
	if player:
		# Look at player
		current_inaccuracy += randf_range(-0.0035, 0.0035) * inaccuracy
		current_inaccuracy = clamp(current_inaccuracy, -0.08, 0.08)
		var target = player.transform.origin
		look_at(target, Vector3.UP)
		rotate_y(current_inaccuracy)
	
		# Check if player is visible
		if player:
			var EnemyToPlayer = player.global_position - global_position
			$GunModel/BulletSpawner/RayCast3D.global_rotation = Vector3.ZERO
			$GunModel/BulletSpawner/RayCast3D.target_position = EnemyToPlayer
			
		if $GunModel/BulletSpawner/RayCast3D.is_colliding() && $GunModel/BulletSpawner/RayCast3D.get_collider() == player:
			if $ShootTimer.is_stopped():
				$ShootTimer.start()

		else:
			$ShootTimer.stop()

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_shoot_timer_timeout():
	if is_physics_processing():
		shoot()

func shoot():
	# Create a bullet instance and add it to the scene.
	var bullet = bullet_scene.instantiate()
	
	# Get the location and angle of the bullet
	var bullet_spawn_location = $GunModel/BulletSpawner.global_position
	var angle = rotation
	
	bullet.initialize("enemy", bullet_spawn_location, angle)
	get_node("/root/Main").add_child(bullet)
	$FireShot.play()
	
func _on_visible_on_screen_notifier_3d_screen_entered():
	$CollisionShape3D.disabled = false
	set_physics_process(true)

func _on_visible_on_screen_notifier_3d_screen_exited():
	$CollisionShape3D.disabled = true
	set_physics_process(false)
