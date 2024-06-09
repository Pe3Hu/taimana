extends MarginContainer


#region vars
@onready var route = $HBox/Route
@onready var hall = $HBox/Hall

var planet = null
var threats = {}
var golds = {}
var relics = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_threats()
	init_rewards()
	init_hall()
	init_route()


func init_threats() -> void:
	for type in Global.arr.threat:
		threats[type] = int(Global.num.threat.count)


func init_rewards() -> void:
	for type in Global.arr.reward:
		var rewards = get(type+"s")
		
		for _i in Global.num[type].count:
			var value = 0
			
			match type:
				"gold":
					Global.rng.randomize()
					value = Global.rng.randi_range(Global.num.gold.min, Global.num.gold.max)
				"relic":
					value = Global.num.relic.gold
			
			if !rewards.has(value):
				rewards[value] = 0
			
			rewards[value] += 1


func init_hall() -> void:
	var input = {}
	input.proprietor = self
	input.type = "hall"
	hall.set_attributes(input)
	#hall.skip = false


func init_route() -> void:
	var input = {}
	input.cave = self
	route.set_attributes(input)
	route.update_safety()
#endregion


func dice_stopped(dice_: MarginContainer) -> void:
	var facet = dice_.get_current_facet()
	var subtype = facet.mark.subtype
	var value = facet.power.get_number()
	route.change_couple_value(subtype, value)
	
	match subtype:
		"gold":
			var n = route.members.get_child_count()
			var ballast = value % n
			var treasure = (value - ballast) / n
			
			if treasure > 0:
				for member in route.members.get_children():
					member.change_gold(treasure)
				
				value = -treasure * n
				route.change_couple_value(subtype, value)
	
	dice_.debt = facet
	route.update_safety()

