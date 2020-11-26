extends KinematicBody2D

class_name Asteroid

export var max_speed:= 300.0
export var DISTANCE_THRESHOLD: = 3.0
export var mass: = 30.0
export var mass_max: = 300.0

# !!! must be filled with base resourse components !!!
var health_damage_system: HealthDamageSystem = HealthDamageSystem.new()
func reduce_health(points: float) -> void:
	health_damage_system.add_random_damage(points)
	if health_damage_system.health <= 0:
		queue_free()

onready var _screen_dimension = OS.get_window_size()
onready var _sprite = $body

var _velocity:= Vector2.ZERO
var target_global_position: = Vector2.ZERO

func collides_check()->void:
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if 'health_damage_system' in collision.collider:
			collision.collider.reduce_health(mass * 0.2)



