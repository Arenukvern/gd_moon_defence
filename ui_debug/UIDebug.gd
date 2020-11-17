extends Control


onready var uiState: = $"/root/UIState"
onready var rootNode: = $'.'

func _ready() -> void:
	uiState.connect(
		uiState.debug_menu_state_updated_signal_name, 
		self, 
		uiState.on_debug_menu_state_updated_func_name
	)

func _on_debug_menu_state_updated(enabled: bool) -> void:
	if enabled:
		var overlayScene: = preload("res://ui_debug/UIDebugMenuOverlay.tscn")
		var overlayInstance: = overlayScene.instance()
		overlayInstance.set_name('MenuOverlay')
		var screen_dimension: = OS.get_window_size()
		var windowHeight: = screen_dimension.y
		rootNode.add_child(overlayInstance)
	else:
		rootNode.remove_child($'MenuOverlay'.queue_free())
	