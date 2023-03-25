extends CharacterBody3D

@export var speed = 2.5
@export var damage = 2

# Track Health
@export var health = 2

func _physics_process(delta):
	# Go to player
	var player =  get_node("/root/Main/Character")
	if player:
		var target = player.transform.origin
		look_at(target, Vector3.UP)

		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
	
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
