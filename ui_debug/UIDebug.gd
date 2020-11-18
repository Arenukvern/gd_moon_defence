extends Control

const MENU_OVERLAY: String = 'MenuOverlay'

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
		overlayInstance.set_name(MENU_OVERLAY)
		rootNode.add_child(overlayInstance)
	else:
		if rootNode.has_node(MENU_OVERLAY) :
			get_node(MENU_OVERLAY).queue_free()
	