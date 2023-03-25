extends Area3D

@export var value = 2



func _on_body_entered(body):
	if (body.get_name() == "Character"):
		body.heal(value)
		queue_free()
