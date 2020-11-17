extends Node

onready var root: Node = $'.'

func add_asteroid()->void:
	var waterIcedAsteroid: = preload('res://objects/asteroid/ice_watered/IceWateredAsteroid.tscn')
	var waterIcedAsteroidInstance: = waterIcedAsteroid.instance()
	root.add_child(waterIcedAsteroidInstance)