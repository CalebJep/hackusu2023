extends Area3D

@export var value = 10

func _on_body_entered(body):
	if (body.get_name() == "Character"):
		body.add_ammo("rifle", value)
		queue_free()
