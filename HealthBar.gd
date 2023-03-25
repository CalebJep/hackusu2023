extends ProgressBar

@onready var character = get_node("/root/Main/Character")

func _ready():
	value = character.health
	max_value = character.health

func _on_character_damaged(damage):
	value = character.health

func _on_character_healed(healing):
	value = character.health
