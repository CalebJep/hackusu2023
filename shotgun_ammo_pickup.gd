extends Area3D

@export var value = 5

func _on_body_entered(body):
	if (body.get_name() == "Character"):
		body.add_ammo("shotgun", value)
		queue_free()
