extends Node

onready var root: Node = $'.'

onready var asteroidSpawnQuantity: = 3.0
onready var asteroidStartMaxDistance: = 300.0
const waterIcedAsteroid: = preload('res://objects/asteroid/ice_watered/IceWateredAsteroid.tscn')

func add_asteroid()->void:
	for n in range(1,asteroidSpawnQuantity):
		var waterIcedAsteroidInstance: = waterIcedAsteroid.instance()
		root.add_child(waterIcedAsteroidInstance)