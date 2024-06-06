extends MarginContainer


#region vars
@onready var chests = $Chests

var planet = null
var cave = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_chests()


func init_chests() -> void:
	for god in planet.gods:
		add_chest(god)


func add_chest(god_: MarginContainer) -> void:
	var input = {}
	input.camp = self
	input.god = god_
	
	var chest = Global.scene.chest.instantiate()
	chests.add_child(chest)
	chest.set_attributes(input)
#endregion
