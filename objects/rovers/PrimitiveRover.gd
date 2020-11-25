extends Droid

export var max_speed: = 100.0
onready var root: = $'.'
onready var massNode: Label = $'mass'
var _total_moved_distance: = 0.0


# LOADING SECTION
var total_rover_mass_kg: = 0.0 setget ,get_total_rover_mass_kg
func get_total_rover_mass_kg()->float:
	return mass_kg + self.objects_loaded_mass_kg
var objects_loaded: Array = []
var objects_loaded_mass_kg:= 0.0 setget ,get_objects_loaded_mass_kg
func get_objects_loaded_mass_kg()->float:
	if objects_loaded.size() <= 0: 
		massNode.text = String(0)
		return 0.0
	else:
		var total_mass_kg = 0.0
		for objectLoaded in objects_loaded:
			if is_instance_valid(objectLoaded) :
				if objectLoaded is Asteroid:
					total_mass_kg += objectLoaded.mass
				elif objectLoaded is Droid:
					total_mass_kg += objectLoaded.mass_kg
		massNode.text = String(total_mass_kg)
		return total_mass_kg

var loading_mass_capacity_kg_max: = 400.0
var loading_mass_capacity_kg_left: = 0.0 setget ,get_loading_mass_capacity_kg_left
func get_loading_mass_capacity_kg_left()->float:
	if objects_loaded.size() <= 0: 
		return loading_mass_capacity_kg_max
	else:
		return loading_mass_capacity_kg_max - self.objects_loaded_mass_kg

export var fuel_consumption_coeff := 0.01
var fuel_consumption := 0.0 setget , get_fuel_consumption
func get_fuel_consumption()->float:
	return (self.total_rover_mass_kg * fuel_consumption_coeff)

func _ready() -> void:
	mass_kg = 300.0
	initial_position = global_position
	target_global_position = initial_position
	platform_global_position = initial_position

func _physics_process(delta: float) -> void:
	
	if self.is_in_movement and not debug_is_fuel_infinite and fuel_left > 0 :
		move_rover()
	
	if self.is_droid_in_platform:
		_refuel_droid()
		if objects_loaded.size()>0:
			objects_loaded.clear()

var is_selected: = false setget set_is_selected
const _selectionScene = preload('res://objects/rovers/RoverSelection.tscn') 
var _selectionInstance 

func set_is_selected(isSelect: bool)->void:
	is_selected = isSelect
	if isSelect:
		if is_instance_valid(_selectionInstance):
			_selectionInstance.queue_free()
		_selectionInstance = _selectionScene.instance()
		root.add_child(_selectionInstance)
		self.are_all_waypoints_shown = true
		self.is_rover_actions_active = true
	elif is_instance_valid(_selectionInstance):
		_selectionInstance.queue_free()
		self.are_all_waypoints_shown = false
		self.is_rover_actions_active = false

var is_mouse_hovered: bool = false
func _on_PrimitiveRover_mouse_entered() -> void:
	is_mouse_hovered =true

func _on_PrimitiveRover_mouse_exited() -> void:
	is_mouse_hovered =false

func _on_PrimitiveRover_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var isLeftClick = InputHelper.isLeftClick(event)
	if isLeftClick:
		self.is_selected = not self.is_selected

func _input(event: InputEvent) -> void:
	var isLeftClick = InputHelper.isLeftClick(event)
	if isLeftClick and not is_mouse_hovered and is_selected:
		selectFollowMeWaypoint(event.position)
		return
	var isRightClick = InputHelper.isRightClick(event)
	if isRightClick and is_selected:
		self.is_selected = false

func selectFollowMeWaypoint(position: Vector2)->void:
	target_global_position.x = position.x
	self.are_all_waypoints_shown = true

func move_rover()->void:
#	calculate distance to eat fuel
	_recalculate_distances_and_eat_fuel()
	
	_velocity = Steering.follow(
		_velocity,
		global_position,
		target_global_position,
		max_speed
	)
	_velocity = move_and_slide(_velocity)


# recalculates already made distance and distance left
# before fuel will go out
func _recalculate_distances_and_eat_fuel()->void:
	var dx: float = global_position.x - _previous_global_position.x
	var dy: float = global_position.y - _previous_global_position.y
	var distance: float = round(sqrt(dx*dx + dy*dy))
	if distance == 0: return
	fuel_left -= distance * self.fuel_consumption
	_total_moved_distance += distance
	_previous_global_position = global_position


export var are_all_waypoints_shown: bool = false setget set_are_all_waypoints_shown
func set_are_all_waypoints_shown(isEnable: bool)->void:
	are_all_waypoints_shown= isEnable
	clear_all_waypoints()
	if isEnable:
		for waypoint in self.waypoints_array:
			var selection: Node = waypoint.waypoint_scene.instance()
			selection.global_position = waypoint.global_position
			projectRoot.add_child(selection)
			_waypoints_selections_array.push_back(selection)

func clear_all_waypoints():
	for selection in _waypoints_selections_array:
		if is_instance_valid(selection):
			selection.queue_free()
	_waypoints_selections_array.clear()

var _waypoints_selections_array: Array = []

onready var targetWaypoint = WaypointGd.new()

var waypoints_array: Array = [] setget ,get_waypoints_array
func get_waypoints_array()-> Array:
	platformWaypoint.global_position = platform_global_position
	platformWaypoint.waypoint_scene = WaypointFactory.purple
	targetWaypoint.global_position = target_global_position
	targetWaypoint.waypoint_scene = WaypointFactory.yellow
	return [platformWaypoint, targetWaypoint]

# ROVER ACTIONS
var is_rover_actions_active: bool = false setget set_is_rover_actions_active
const RoverActionsScene:= preload('res://objects/rovers/RoverActions.tscn')
var _rover_actions: RoverActions

func set_is_rover_actions_active(isActive: bool)->void:
	is_rover_actions_active = isActive
	if isActive:
		close_rover_actions()
		_rover_actions = RoverActionsScene.instance() as RoverActions
		connect_rover_actions()
		root.add_child(_rover_actions)
	else:
		close_rover_actions()

func close_rover_actions()->void:
	if is_instance_valid(_rover_actions) and _rover_actions is RoverActions:
		_rover_actions.close_actions()
		_rover_actions.queue_free()

func connect_rover_actions()->void:
	_rover_actions.connect(
		_rover_actions.signal_name_rover_actions_load,
		self,
		_rover_actions.signal_func_name_rover_actions_load
	)
	_rover_actions.connect(
		_rover_actions.signal_name_rover_actions_to_base,
		self,
		_rover_actions.signal_func_name_rover_actions_to_base
	)

onready var droidsFactory:DroidsFactory = preload('res://objects/droids/DroidsFactory.gd').new()
onready var asteroidsFactory:AsteroidsFactory = preload('res://objects/asteroid/AsteroidFactory.gd').new()
#	load droids and asteroids that collides
#	with the rover
func _on_rover_actions_load()->void:
#	loading droids
	for droid in rover_collision_droids.values():
		var id = droid.get_instance_id()
		var droidClone = droidsFactory.primitiveDroid.instance()
		droidClone.mass_kg = droid.mass_kg
		droidClone._total_flying_distance = droid._total_flying_distance
		rover_collision_droids = removeObjectFromDictionary(rover_collision_droids,droid)
		loadObjectToRover(droid.mass_kg, droid, droidClone)
#	loading asteroids
	for asteroid in rover_collision_asteroids.values():
		var id = asteroid.get_instance_id()
		var asteroidClone = asteroidsFactory.iceWateredAsteroid.instance()
		asteroidClone.mass = asteroid.mass
		rover_collision_asteroids = removeObjectFromDictionary(rover_collision_asteroids,asteroid)
		loadObjectToRover(asteroid.mass, asteroid, asteroidClone)
	

func loadObjectToRover(object_mass_kg: float, originalObject, objectInstance)->void:
#	first we check mass - is it available and not excided limit
	if object_mass_kg <= self.loading_mass_capacity_kg_left:	
#	then load to rover
		objects_loaded.push_back(objectInstance)
#	then clean up
	originalObject.queue_free()

func _on_rover_actions_to_base()->void:
	target_global_position = platform_global_position
	self.are_all_waypoints_shown = true
	
func _refuel_droid() -> void:
	if fuel_left == fuel_capacity: return

	if fuel_left > fuel_capacity:
		fuel_left = fuel_capacity
	else:
		fuel_left += refueling_consumption

var rover_collision_droids: Dictionary = {}
var rover_collision_asteroids: Dictionary = {}

func _on_RoverCollisionSensor_body_entered(body: PhysicsBody2D) -> void:
	if body is PrimitiveDroid:
		rover_collision_droids = pushObjectToDictionary(rover_collision_droids,body)
	elif body is Asteroid:
		rover_collision_asteroids = pushObjectToDictionary(rover_collision_asteroids,body)

func pushObjectToDictionary(dictionary: Dictionary, body: PhysicsBody2D)->Dictionary:
	var id = body.get_instance_id()
	var isObjectExists: = dictionary.has(id)
	if not isObjectExists:
		dictionary[id] = body
	return dictionary

func _on_RoverCollisionSensor_body_exited(body: PhysicsBody2D) -> void:
	if body is Droid:
		rover_collision_droids = removeObjectFromDictionary(rover_collision_droids,body)
	elif body is Asteroid:
		rover_collision_asteroids = removeObjectFromDictionary(rover_collision_asteroids,body)

func removeObjectFromDictionary(dictionary: Dictionary, body: PhysicsBody2D)->Dictionary:
	var id = body.get_instance_id()
	var isObjectExists: = dictionary.has(id)
	if isObjectExists:
		dictionary.erase(id)
	return dictionary


