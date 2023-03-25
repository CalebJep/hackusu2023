extends CharacterBody3D

signal damaged(damage)
signal healed(healing)
signal changeWeapon()
signal changeAmmo()

# Stores bullets
@export var bullet_scene: PackedScene

# Track Health
@export var health = 10

# Define weapons
var weapons = ["pistol", "rifle", "shotgun"]
var equiped_weapon = 0

# Track ammo
@export var shotgun_ammo = 10
@export var rifle_ammo = 20

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
	if Input.is_action_just_pressed("shoot") && weapons[equiped_weapon] == "pistol":
		shoot("pistol")
	if Input.is_action_just_pressed("shoot") && weapons[equiped_weapon] == "shotgun":
		shoot("shotgun")
	if Input.is_action_pressed("shoot") && weapons[equiped_weapon] == "rifle":
		if $GunCooldown.is_stopped():
			$GunCooldown.start(0.20)
			shoot("rifle")

	# Handle Swap.
	if Input.is_action_just_pressed("swap"):
		swap_weapon()

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
	# TODO: Should probably rotate around gun instead of body for more accuracy
	# TODO: May need to take height into account
	# TODO: Finalize once player/gun model is finished
	var offset = -PI * 0.5
	var screen_pos = get_node("/root/Main/CameraPivot/Camera3D").unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var angle = screen_pos.angle_to_point(mouse_pos)
	rotation.y = -angle + offset

func shoot(gun):
	# Get the location and angle of the bullet
	var bullet_spawn_location = $GunModel/BulletSpawner.global_position
	var angle = rotation

	if gun == "pistol":
		var bullet = bullet_scene.instantiate()
		bullet.initialize("player", bullet_spawn_location, angle)
		get_node("/root/Main").add_child(bullet)
	elif gun == "rifle":
		if rifle_ammo > 0:
			var bullet = bullet_scene.instantiate()
			bullet.initialize("player", bullet_spawn_location, angle)
			get_node("/root/Main").add_child(bullet)
			rifle_ammo -= 1
	elif gun == "shotgun":
		if shotgun_ammo > 0:
			var bullet = bullet_scene.instantiate()
			bullet.initialize("player", bullet_spawn_location, Vector3(angle.x, angle.y-0.25, angle.z))
			get_node("/root/Main").add_child(bullet)
			bullet = bullet_scene.instantiate()
			bullet.initialize("player", bullet_spawn_location, Vector3(angle.x, angle.y-0.125, angle.z))
			get_node("/root/Main").add_child(bullet)
			bullet = bullet_scene.instantiate()
			bullet.initialize("player", bullet_spawn_location, Vector3(angle.x, angle.y, angle.z))
			get_node("/root/Main").add_child(bullet)
			bullet = bullet_scene.instantiate()
			bullet.initialize("player", bullet_spawn_location, Vector3(angle.x, angle.y+0.125, angle.z))
			get_node("/root/Main").add_child(bullet)
			bullet = bullet_scene.instantiate()
			bullet.initialize("player", bullet_spawn_location, Vector3(angle.x, angle.y+0.25, angle.z))
			get_node("/root/Main").add_child(bullet)
			shotgun_ammo -= 1
			
	emit_signal("changeAmmo")

	
func hit(damage):
	health -= damage
	emit_signal("damaged", damage)
	if health <= 0:
		queue_free()
		
func heal(healing):
	health += healing
	emit_signal("healed", healing)
	
func add_ammo(type, amount):
	if type == "rifle":
		rifle_ammo += amount
	elif type == "shotgun":
		shotgun_ammo += amount
	emit_signal("changeAmmo")
	
	
func swap_weapon():
	equiped_weapon += 1
	if equiped_weapon > 2:
		equiped_weapon = 0
	emit_signal("changeWeapon")
