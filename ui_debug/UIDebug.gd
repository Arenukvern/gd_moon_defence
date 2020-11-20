extends Control

const MENU_OVERLAY: String = 'MenuOverlay'

onready var uiState: = $"/root/UIState"
onready var rootNode: = $'.'
const overlayScene: = preload("res://ui_debug/UIDebugMenuOverlay.tscn")

func _ready() -> void:
	uiState.connect(
		uiState.signal_name_debug_menu_state_updated, 
		self, 
		uiState.signal_func_name_debug_menu_state_updated
	)

func _on_debug_menu_state_updated(enabled: bool) -> void:
	if enabled:		
		var overlayInstance: = overlayScene.instance()
		overlayInstance.set_name(MENU_OVERLAY)
		rootNode.add_child(overlayInstance)
	else:
		if rootNode.has_node(MENU_OVERLAY) :
			get_node(MENU_OVERLAY).queue_free()
	