extends Panel

@onready var character = get_node("/root/Main/Character")

# Called when the node enters the scene tree for the first time.
func _ready():
	select_weapon(character.weapons[character.equiped_weapon])
	$Info/Rifle/RifleAmmo.text = str(character.rifle_ammo)
	$Info/Shotgun/ShotgunAmmo.text = str(character.shotgun_ammo)


func _on_character_change_weapon():
	select_weapon(character.weapons[character.equiped_weapon])

func select_weapon(weapon):
	if weapon == "pistol":
		$Selections/PistolSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0.89803922176361)
		$Selections/RifleSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0)
		$Selections/ShotgunSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0)
	elif weapon == "rifle":
		$Selections/PistolSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0)
		$Selections/RifleSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0.89803922176361)
		$Selections/ShotgunSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0)
	elif weapon == "shotgun":
		$Selections/PistolSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0)
		$Selections/RifleSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0)
		$Selections/ShotgunSelect.color = Color(0.54509806632996, 0.15686275064945, 0.15686275064945, 0.89803922176361)

func _on_character_change_ammo():
	$Info/Rifle/RifleAmmo.text = str(character.rifle_ammo)
	$Info/Shotgun/ShotgunAmmo.text = str(character.shotgun_ammo)
