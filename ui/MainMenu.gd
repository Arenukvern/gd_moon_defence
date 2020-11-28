extends Control

class_name MainMenu

onready var uiState: = get_tree().get_root().get_node("/root/UIState")

func _on_ContinueButton_button_up() -> void:
	uiState.closeMainMenu()
	
func _on_ExitButton_button_up() -> void:
	get_tree().quit()

onready var windowDialog: = $'./CanvasLayer/WindowDialog'
var is_highscore_window_active: bool = false setget set_is_highscore_window_active
const HighscoreContentScene: = preload('res://ui/MaxHighscoreContent.tscn')
var _highscoreContent
func set_is_highscore_window_active(isEnable: bool):
	is_highscore_window_active = isEnable
	if isEnable:
		windowDialog.visible = true
		if not is_instance_valid(_highscoreContent):
			_highscoreContent = HighscoreContentScene.instance()
			windowDialog.add_child(_highscoreContent)
	else:
		windowDialog.visible = false
		if is_instance_valid(_highscoreContent):
			_highscoreContent.queue_free()

func _on_HighscoreButton_button_up() -> void:
	self.is_highscore_window_active = true

func _on_WindowDialog_popup_hide() -> void:
	self.is_highscore_window_active = false
	