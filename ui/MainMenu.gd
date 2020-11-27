extends Control

signal main_menu_change
const signal_name_main_menu_change: = 'main_menu_change'
const signal_func_name_main_menu_change: = "_on_%s" % signal_name_main_menu_change


func _on_ContinueButton_button_up() -> void:
	emit_signal(signal_name_main_menu_change, false)


func _on_ExitButton_button_up() -> void:
	get_tree().quit()
