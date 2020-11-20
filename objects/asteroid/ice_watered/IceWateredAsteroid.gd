extends Asteroid

func _ready() -> void:
	_health_current = health_max
	randomize()
	var start_distance_surface_edge = rand_range( 1, AsteroidsState.asteroidStartMaxDistance)
	randomize()
	var start_x_position: = rand_range( -10,  _screen_dimension.x)
	global_position = Vector2(start_x_position, - start_distance_surface_edge)
	randomize()
	var target_x_position: = rand_range( 1,  _screen_dimension.x)
	target_global_position = Vector2(target_x_position,_screen_dimension.y)
	randomize()
	mass = rand_range( 1,  mass_max)
	
func _physics_process(delta: float) -> void:
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD :
		return
	_velocity = Steering.follow(
		_velocity,
		global_position,
		target_global_position,
		max_speed,
		mass
	)
	_velocity = move_and_slide(_velocity)
	_sprite.rotation = _velocity.angle()
	

func reduce_health(points: float) -> void:
	var new_health = _health_current - points
	if new_health <= 0:
		queue_free()
	else:
		_health_current = new_health
