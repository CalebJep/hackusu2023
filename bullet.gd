extends CharacterBody3D

# speed of bullets
@export var speed = 40
@export var damage = 1

func _physics_process(delta):
	var target = move_and_collide(velocity * delta)
	
	# When hitting a target
	if target:
		$CollisionShape3D.disabled = true
		set_physics_process(false)
		hide()
		if target.get_collider().has_method("hit"):
			target.get_collider().hit(damage)
			$HitBody.play() 
			await $HitBody.finished
		else:
			$HitWall.play() 
			await $HitWall.finished
		queue_free()

func initialize(source, start_position, angle):
	# Set as player or enemy bullet
	if source == "player":
		set_collision_layer_value(4, true)
		set_collision_mask_value(2, true)
	elif source == "enemy":
		set_collision_layer_value(5, true)
		set_collision_mask_value(1, true)
		
	# set location and move data
	position = start_position
	rotation = angle
	
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

# Despawn when leaves viewable area
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
