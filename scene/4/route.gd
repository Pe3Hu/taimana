extends MarginContainer


#region vars
@onready var slope = $HBox/Slope
@onready var rewards = $HBox/Rewards
@onready var members = $HBox/Members
@onready var threats = $HBox/Threats

var cave = null
var camp = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cave = input_.cave
	
	init_basic_setting()


func init_basic_setting() -> void:
	camp = cave.planet.camp
	
	var input = {}
	input.proprietor = self
	input.type = "safety"
	slope.set_attributes(input)
	
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
