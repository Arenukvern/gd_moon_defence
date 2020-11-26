extends Node

class_name HealthDamageSystem

var componentsDict: Dictionary = {}

func initSystem(componentsArray: Array)->void:
	for component in componentsArray:
		if component is BaseResourceComponent:
			componentsDict = DictionaryHelper.pushObjectToDictionary(componentsDict,component, component.id)
		else:
			print('Wrong init HealthDamageSystem: component is not Base Component!')
			
func addResource(resourceComponent: BaseResourceComponent)->void:
	componentsDict = DictionaryHelper.pushObjectToDictionary(componentsDict,resourceComponent, resourceComponent.id)

var health: float = 0.0 setget ,get_health
func get_health()->float:
	var _health = 0
	for component in componentsDict.values():
		if component is BaseResourceComponent:
			_health += component.current_health
		else:
			print('Wrong get_health HealthDamageSystem: component is not Base Component!')
	return _health

func add_random_damage(health_points: float)->void:
	var componentsMaxDamage = round(health_points / componentsDict.size())
	for component in componentsDict.values():
		if component is BaseResourceComponent and component.current_health > 0:
			randomize()
			var damageOfComponent = rand_range(1, componentsMaxDamage)
			component.current_health -= damageOfComponent
			if component.current_health < 0:
				component.current_health = 0
		else:
			print('Wrong get_health HealthDamageSystem: component is not Base Component!')

func recover_component(componentsArray: Array)->void:
	for component in componentsArray:
		if component is BaseResourceComponent:
			var isExists = componentsDict.has(component.id)
			if isExists:
				var existedComponent: = componentsDict.get(component.id) as BaseResourceComponent
				existedComponent.current_health += component.current_health
				if existedComponent.current_health > existedComponent.origin_health:
					existedComponent.current_health = existedComponent.origin_health
		else:
			print('Wrong init HealthDamageSystem: component is not Base Component!')








