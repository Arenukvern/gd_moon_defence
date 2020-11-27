extends Control

class_name MainMenu

onready var uiState: = get_tree().get_root().get_node("/root/UIState")

func _on_ContinueButton_button_up() -> void:
	uiState.closeMainMenu()
	
func _on_ExitButton_button_up() -> void:
	get_tree().quit()
