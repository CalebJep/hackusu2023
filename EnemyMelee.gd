extends CharacterBody3D

@export var speed = 2.5
@export var damage = 2

# Track Health
@export var health = 2

var player

func _ready():
	player = get_node("/root/Main/Character")
	$CollisionShape3D.disabled = true
	set_physics_process(false)

func _physics_process(delta):
	# Go to player
	if player:
		var target = player.transform.origin
		look_at(target, Vector3.UP)
		
		# check for visibility
		if player:
			var EnemyToPlayer = player.global_position - global_position
			$RayCast3D.global_rotation = Vector3.ZERO
			$RayCast3D.target_position = EnemyToPlayer
			
		if $RayCast3D.is_colliding() && $RayCast3D.get_collider() == player:
			velocity = Vector3.FORWARD * speed
			velocity = velocity.rotated(Vector3.UP, rotation.y)
		else:
			velocity = Vector3.ZERO
	
	var target = move_and_collide(velocity * delta)
	
	# When hitting a target
	if target:
		if target.get_collider().has_method("hit"):
			if $HitCooldown.is_stopped():
				$HitCooldown.start(1)
				target.get_collider().hit(damage)

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()

# Disable when off screen
func _on_visible_on_screen_notifier_3d_screen_entered():
	$CollisionShape3D.disabled = false
	set_physics_process(true)

func _on_visible_on_screen_notifier_3d_screen_exited():
	$CollisionShape3D.disabled = true
	set_physics_process(false)
