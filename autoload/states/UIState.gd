extends Node

class_name UIState

signal debug_menu_state_updated(enabled)

const signal_name_debug_menu_state_updated: = 'debug_menu_state_updated'
const signal_func_name_debug_menu_state_updated: = "_on_%s" % signal_name_debug_menu_state_updated

var isDebugMenuOpen:= false setget set_isDebugMenuOpen

func set_isDebugMenuOpen(value: bool) -> void:
	isDebugMenuOpen = value
	emit_signal(signal_name_debug_menu_state_updated,value)
