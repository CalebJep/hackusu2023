extends Panel

@onready var character = get_node("/root/Main/Character")

# Called when the node enters the scene tree for the first time.
func _ready():
	select_weapon(character.weapons[character.equiped_weapon])
	$RifleAmmo.text = str(character.rifle_ammo)
	$ShotgunAmmo.text = str(character.shotgun_ammo)


func _on_character_change_weapon():
	select_weapon(character.weapons[character.equiped_weapon])

func select_weapon(weapon):
	if weapon == "pistol":
		$PistolSelect.show()
		$RifleSelect.hide()
		$ShotgunSelect.hide()
	elif weapon == "rifle":
		$PistolSelect.hide()
		$RifleSelect.show()
		$ShotgunSelect.hide()
	elif weapon == "shotgun":
		$PistolSelect.hide()
		$RifleSelect.hide()
		$ShotgunSelect.show()

func _on_character_change_ammo():
	$RifleAmmo.text = str(character.rifle_ammo)
	$ShotgunAmmo.text = str(character.shotgun_ammo)
