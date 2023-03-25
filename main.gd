extends Node3D

@export var turret_scene: PackedScene
@export var melee_scene: PackedScene
@export var health_scene: PackedScene
@export var rifle_scene: PackedScene
@export var shotgun_scene: PackedScene

func _on_main_menu_start_game():	
	var turret = turret_scene.instantiate()
	turret.position = $Spawns/TurretSpawn.position
	add_child(turret)
	
	var melee = melee_scene.instantiate()
	melee.position = $Spawns/MeleeSpawn.position
	add_child(melee)
	
	var health = health_scene.instantiate()
	health.position = $Spawns/HealthSpawn.position
	add_child(health)
	
	var rifle = rifle_scene.instantiate()
	rifle.position = $Spawns/RifleSpawn.position
	add_child(rifle)

	var shotgun = shotgun_scene.instantiate()
	shotgun.position = $Spawns/ShotgunSpawn.position
	add_child(shotgun)
	
	
	$UI.show()
	$Character.initialize($Spawns/PlayerSpawn.position)
	$CameraPivot/Camera3D.current = true


func _on_character_died():
	$"GameOver".show()
	get_tree().call_group("enemy", "set_physics_process", "false")
	
	await get_tree().create_timer(3).timeout
	$"GameOver".hide()
	$UI.hide()
	$"Main Menu".show()
	$StartCamera.current = true
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("pickup", "queue_free")
