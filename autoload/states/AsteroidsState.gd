extends Node

onready var root: Node = $'.'

onready var asteroidSpawnQuantity: = 3.0
onready var asteroidStartMaxDistance: = 300.0
const waterIcedAsteroid: = preload('res://objects/asteroid/ice_watered/IceWateredAsteroid.tscn')

func add_asteroid(target_position: Vector2 = Vector2.ZERO)->void:
	for n in range(1,asteroidSpawnQuantity):
		var waterIcedAsteroidInstance: = waterIcedAsteroid.instance()
		waterIcedAsteroidInstance.debug_target_position = target_position
		root.add_child(waterIcedAsteroidInstance)