extends MarginContainer


#region vars
@onready var bg = $BG
@onready var facets = $BG/Facets
@onready var timer = $Timer

var proprietor = null
var type = null
var tween = null
var pace = null
var tick = null
var time = null
var counter = 0
var window = 1
var skip = true
var anchor = null
var temp = true
var crushs = 0
var debt = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	time = Time.get_unix_time_from_system()
	anchor = Vector2(0, -Global.vec.size.facet.y)
	
	init_facets()
	shuffle_facets()
	update_size()
	reset()
	#skip_animation()


func init_facets() -> void:
	match type:
		"hall":
			for _type in proprietor.threats:
				for _i in proprietor.threats[_type]:
					add_facet(_type, 1)
			
			for value in proprietor.golds:
				for _i in proprietor.golds[value]:
					add_facet("gold", value)
			
			for value in proprietor.relics:
				for _i in proprietor.relics[value]:
					add_facet("relic", value)


func add_facet(subtype_: String, value_: int) -> void:
	var input = {}
	input.dice = self
	input.type = "facet"
	
	#for _type in Global.arr:
		#if input.type == "facet":
			#if Global.arr[_type].has(subtype_):
				#input.type = _type
		#else:
			#break
	
	input.subtype = subtype_
	input.value = value_
	
	var facet = Global.scene.facet.instantiate()
	facets.add_child(facet)
	facet.set_attributes(input)


func update_size() -> void:
	var vector = Global.vec.size.facet#Vector2(facets.get_child(0).size)
	#vector.y *= window
	custom_minimum_size = vector
	size = vector


func roll() -> void:
	reset()
	
	if skip:
		skip_animation()
		proprietor.dice_stopped(self)
	else:
		timer.start()


func reset() -> void:
	if debt != null:
		debt.crush()
		debt = null
	
	shuffle_facets()
	pace = 30
	tick = 0
	facets.position = Vector2(anchor)
	facets.size = Vector2()
	#var facet = facets.get_child(facets.get_child_count() - 1)
	#print(facet.position)
	#flip_to_facet(facet)


func shuffle_facets() -> void:
	var temps = []
	
	for facet in facets.get_children():
		facets.remove_child(facet)
		temps.append(facet)
	
	temps.shuffle()
	
	for facet in temps:
		facets.add_child(facet)


func decelerate_spin() -> void:
	tick += 1
	var limit = {}
	limit.min = 1.0
	limit.max = max(limit.min, 10.0 - tick * 0.15)
	#start 100 min 1.0 max 10.0 step 0.1 stop 10 = 2.2 sec
	Global.rng.randomize()
	var gap = Global.rng.randf_range(limit.min, limit.max)
	pace -= gap
	var optimal = 0.1
	timer.wait_time = max(min(optimal, 1.0 / pace), optimal)


func _on_timer_timeout():
	var _time = 1.0 / pace
	
	if pace >= 1.5:
		tween = create_tween()
		#var start = Vector2(0, (-0.5 + crushs * 0.5) * Global.vec.size.facet.y)
		
		tween.tween_property(facets, "position", Vector2(), _time).from(anchor)
		tween.tween_callback(pop_up)
		decelerate_spin()
	else:
		#print("end at", Time.get_unix_time_from_system() - time)
		proprietor.dice_stopped(self)


func pop_up() -> void:
	var facet = facets.get_child(facets.get_child_count() - 1)
	facets.move_child(facet, 0)
	
	if !skip:
		facets.position = anchor
		timer.start()


func skip_animation() -> void:
	var facet = facets.get_children().pick_random()
	flip_to_facet(facet)


func flip_to_facet(facet_: MarginContainer) -> void:
	var index = facet_.get_index()
	var step = 1 - index
	
	if step < 0:
		step = facets.get_child_count() - index + 1
	
	for _j in step:
		pop_up()
	
	#print([facet_.mark.subtype, facet_.power.get_number(), facet_.get_index()])
	return


func get_current_facet() -> MarginContainer:
	var facet = facets.get_child(1)
	return facet


func crush() -> void:
	proprietor.dices.remove_child(self)
	queue_free()
#endregion


func set_as_major() -> void:
	var facet = facets.get_child(1)
	facet.set_subtype("major")
