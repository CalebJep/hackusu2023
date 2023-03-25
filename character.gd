extends CharacterBody3D

signal damaged(damage)
signal healed(healing)

# Stores bullets
@export var bullet_scene: PackedScene

# Track Healtha
@export var health = 10

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle Shoot.
	if Input.is_action_pressed("shoot"):
		if $GunCooldown.is_stopped():
			shoot()
			$GunCooldown.start(0.25)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Rotate to face mouse
	var offset = -PI * 0.5
	var screen_pos = get_node("/root/Main/CameraPivot/Camera3D").unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var angle = screen_pos.angle_to_point(mouse_pos)
	rotation.y = -angle + offset

func shoot():
	# Create a bullet instance and add it to the scene.
	var bullet = bullet_scene.instantiate()
	
	# Get the location and angle of the bullet
	var bullet_spawn_location = $GunModel/BulletSpawner.global_position
	var angle = rotation
	
	get_node("/root/Main").add_child(bullet)
	bullet.initialize("player", bullet_spawn_location, angle)
	
func hit(damage):
	health -= damage
	emit_signal("damaged", damage)
	if health <= 0:
		queue_free()
		
func heal(healing):
	health += healing
	emit_signal("healed", healing)
