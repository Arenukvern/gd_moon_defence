extends Button

onready var root: Node = $'.'

func _on_SpawnAsteroids_button_up() -> void:
	var waterIcedAsteroid: = preload('res://objects/asteroid/ice_watered/IceWateredAsteroid.tscn')
	var waterIcedAsteroidInstance: = waterIcedAsteroid.instance()
	root.add_child(waterIcedAsteroidInstance)
