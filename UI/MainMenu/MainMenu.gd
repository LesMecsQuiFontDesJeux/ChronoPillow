class_name MainMenu
extends Control

func _ready() -> void:
	$Buttons/VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	set_visible(false)
	GameManager.start_game()
	set_process_input(false)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	$Buttons.set_visible(false)
	$Credits.set_visible(true)
	$Credits/Back.grab_focus()

func _on_back_pressed() -> void:
	$Buttons.set_visible(true)
	$Credits.set_visible(false)
	$Buttons/VBoxContainer/Play.grab_focus()

func win() -> void:
	set_visible(true)
	set_process_input(true)
	$Medal.set_visible(true)
	$Buttons/VBoxContainer/Play.grab_focus()
