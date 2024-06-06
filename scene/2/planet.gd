extends MarginContainer


#region var
@onready var hbox = $HBox
@onready var cave = $HBox/Cave
@onready var camp = $HBox/Camp

var universe = null
var gods = []
var loser = null
var totems = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func add_god(god_: MarginContainer) -> void:
	god_.pantheon.gods.remove_child(god_)
	hbox.add_child(god_)
	
	if gods.is_empty():
		hbox.move_child(god_, 0)
	
	gods.append(god_)
	god_.planet = self
#endregion


func start_race() -> void:
	totems.append_array(Global.arr.totem)
	init_gods_opponents()
	
	var input = {}
	input.planet = self
	camp.set_attributes(input)
	cave.set_attributes(input)


func init_gods_opponents() -> void:
	for _i in gods.size():
		var god = gods[_i]
		
		for _j in range(_i + 1, gods.size(), 1):
			var opponent = gods[_j]
			
			if god.pantheon != opponent.pantheon:
				god.opponents.append(opponent)
				opponent.opponents.append(god)
