extends MarginContainer


#region vars
@onready var safety = $HBox/Safety
@onready var rewards = $HBox/Rewards
@onready var members = $HBox/Members
@onready var threats = $HBox/Threats

var cave = null
var camp = null
var hazard = null
var remnant = null
var trophy = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cave = input_.cave
	
	init_basic_setting()


func init_basic_setting() -> void:
	camp = cave.planet.camp
	camp.cave = cave
	remnant = 0
	trophy = 5
	
	var input = {}
	input.proprietor = self
	input.type = "safety"
	safety.set_attributes(input)
	
	init_couples()
	init_members()


func init_couples() -> void:
	for type in Global.arr.reward:
		add_couple("reward", type)
	
	for type in Global.arr.threat:
		add_couple("threat", type)


func add_couple(type_: String, subtype_: String) -> void:
	var input = {}
	input.proprietor = self
	input.type = type_
	input.subtype = subtype_
	input.value = 0
	
	var couple = Global.scene.couple.instantiate()
	var couples = get(type_+"s")
	couples.add_child(couple)
	couple.set_attributes(input)


func init_members() -> void:
	for chest in camp.chests.get_children():
		add_member(chest)


func add_member(chest_: MarginContainer) -> void:
	var input = {}
	input.chest = chest_
	
	var member = Global.scene.member.instantiate()
	members.add_child(member)
	member.set_attributes(input)
#endregion


func get_threat(type_: String) -> MarginContainer:
	var index = Global.arr.threat.find(type_)
	return threats.get_child(index)


func get_reward(type_: String) -> MarginContainer:
	var index = Global.arr.reward.find(type_)
	return rewards.get_child(index)


func get_couple(subtype_: String) -> Variant:
	var types = ["reward", "threat"]
	var couple = null
	
	for type in types:
		if Global.arr[type].has(subtype_):
			match type:
				"reward":
					couple = get_reward(subtype_)
				"threat":
					couple = get_threat(subtype_)
	
	return couple


func change_couple_value(subtype_: String, value_: int) -> void:
	var couple = get_couple(subtype_)
	couple.change_value(value_)
	
	if Global.arr.reward.has(subtype_):
		remnant += value_


func update_safety() -> void:
	var subtypes = {}
	subtypes.success = 0
	subtypes.failure = 0
	var debt = cave.hall.debt != null
	
	var triggers = []
	
	for type in Global.arr.threat:
		var threat = get_threat(type)
		var trigger = Global.num.threat.trigger - 1
		
		if debt and type == cave.hall.debt.mark.subtype:
			trigger -= 1
		
		var flag = threat.get_value() == trigger
		
		if flag:
			triggers.append(type)
	
	for facet in cave.hall.facets.get_children():
		var type = null
		
		if triggers.has(facet.mark.subtype):
			type = "failure"
		else:
			type = "success"
		
		subtypes[type] += 1
		
		if debt:
			#print([facet, cave.hall.debt])
			if facet == cave.hall.debt:
				subtypes[type] -= 1
			
				debt = false
	
	safety.set_subtypes(subtypes)
	var stratum = safety.stratums.get_child(0)
	hazard = stratum.probability.get_number()
	update_appraisals()


func update_appraisals() -> void:
	for member in members.get_children():
		for appraisal in Global.arr.appraisal:
			member.update_appraisal(appraisal)
