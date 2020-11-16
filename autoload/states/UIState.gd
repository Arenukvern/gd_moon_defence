extends Node

class_name UIState

signal debug_menu_state_updated(enabled)

const debug_menu_state_updated_signal_name: = 'debug_menu_state_updated'
const on_debug_menu_state_updated_func_name: = "_on_%s" % debug_menu_state_updated_signal_name

var isDebugMenuOpen:= false setget set_isDebugMenuOpen

func set_isDebugMenuOpen(value: bool) -> void:
	isDebugMenuOpen = value
	emit_signal(debug_menu_state_updated_signal_name,value)
