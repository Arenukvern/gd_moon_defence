extends Control

onready var uiState: = get_tree().get_root().get_node("/root/UIState")

func _on_Button_button_up() -> void:
	uiState.openMainMenu()
