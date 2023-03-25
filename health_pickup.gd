extends Area3D

@export var value = 2

signal victory

func _on_body_entered(body):
	if (body.get_name() == "Character"):
		emit_signal("victory")
		$Pickup.play()
