extends Node

class_name BaseResourceFactory

static func getWaterIce(mass: float)->BaseResourceComponent:
	var unknownResourse: = _instance_resource(
		BaseResourcesState.ComponentsTypes.WATER_ICE,
		'Water ice',
		mass
	)
	return unknownResourse

static func getTitanium(mass: float)->BaseResourceComponent:
	var unknownResourse: = _instance_resource(
		BaseResourcesState.ComponentsTypes.TITANIUM,
		'Titanium',
		mass
	)
	return unknownResourse
 
static func getOxygen(mass: float)->BaseResourceComponent:
	var unknownResourse: = _instance_resource(
		BaseResourcesState.ComponentsTypes.OXYGEN,
		'Oxygen',
		mass
	)
	return unknownResourse

static func getGlass(mass: float)->BaseResourceComponent:
	var unknownResourse: = _instance_resource(
		BaseResourcesState.ComponentsTypes.GLASS,
		'Glass',
		mass
	)
	return unknownResourse

static func getSilica(mass: float)->BaseResourceComponent:
	var unknownResourse: = _instance_resource(
		BaseResourcesState.ComponentsTypes.SILICA,
		'Silica',
		mass
	)
	return unknownResourse

static func _instance_resource(id: float, name: String, mass: float)->BaseResourceComponent:
	var unknownResourse: = BaseResourceComponent.new()
	unknownResourse.id = id
	unknownResourse.resource_name = name
	unknownResourse = _set_health(unknownResourse, mass)
	return unknownResourse
	
static func _set_health(resourceComponent: BaseResourceComponent, mass: float)->BaseResourceComponent:
	randomize()
	var max_health : float = 1000
	if mass != null and mass != 0:
		max_health = mass
	resourceComponent.origin_health = rand_range(1, mass)
	resourceComponent.current_health = resourceComponent.origin_health
	return resourceComponent
