extends Node3D

@export var turret_scene: PackedScene
@export var melee_scene: PackedScene
@export var health_scene: PackedScene
@export var rifle_scene: PackedScene
@export var shotgun_scene: PackedScene
@export var goal_scene: PackedScene

func _on_main_menu_start_game():
	var turrets = get_tree().get_nodes_in_group("TurretSpawn")
	for spawn in turrets:
		var turret = turret_scene.instantiate()
		turret.position = spawn.position
		add_child(turret)
		
	var melees = get_tree().get_nodes_in_group("MeleeSpawn")
	for spawn in melees:
		var melee = melee_scene.instantiate()
		melee.position = spawn.position
		add_child(melee)
		
	var healths = get_tree().get_nodes_in_group("HealthSpawn")
	for spawn in healths:
		var health = health_scene.instantiate()
		health.position = spawn.position
		add_child(health)
		
	var rifles = get_tree().get_nodes_in_group("RifleSpawn")
	for spawn in rifles:
		var rifle = rifle_scene.instantiate()
		rifle.position = spawn.position
		add_child(rifle)
		
	var shotguns = get_tree().get_nodes_in_group("ShotgunSpawn")
	for spawn in shotguns:
		var shotgun = shotgun_scene.instantiate()
		shotgun.position = spawn.position
		add_child(shotgun)

		
		
	var goals = get_tree().get_nodes_in_group("VictorySpawn")
	for spawn in goals:
		var goal = goal_scene.instantiate()
		goal.connect("victory", Callable(self, "_on_goal_victory"))
		goal.position = spawn.position
		add_child(goal)
	
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


func _on_goal_victory():
	$"Victory".show()
	get_tree().call_group("enemy", "set_physics_process", "false")
	$Character.set_physics_process(false)
	$StartCamera.current = true
	$Character.position = $Spawns/PlayerSpawn.position
	$Character.hide()
	$Character/CollisionShape3D.disabled = true
	
	
	await get_tree().create_timer(3).timeout
	
	$"Victory".hide()
	$UI.hide()
	$"Main Menu".show()
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("pickup", "queue_free")
