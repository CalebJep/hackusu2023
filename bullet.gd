extends CharacterBody3D

# speed of bullets
@export var speed = 40


func _physics_process(_delta):
	move_and_slide()

func initialize(start_position, angle):
	position = start_position
	rotation = angle
	
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

# Despawn when leaves viewable area
#func _on_visible_on_screen_notifier_3d_screen_exited():
#	queue_free()
