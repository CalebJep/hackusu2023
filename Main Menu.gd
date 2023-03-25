extends Control

signal start_game


func _on_start_button_pressed():
	hide()
	emit_signal("start_game")


func _on_instructions_button_pressed():
	hide()
	get_node("/root/Main/Instructions").show()


func _on_quit_button_pressed():
	get_tree().quit()

func _on_button_pressed():
	get_node("/root/Main/Instructions").hide()
	show()
