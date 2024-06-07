extends Line2D


#region vars
var slope = null
var value = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	slope = input_.slope
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_vertexs()


func init_vertexs() -> void:
	var vertex = Vector2()
	add_point(vertex)
	
	vertex = Vector2(slope.size)
	
	match slope.orientation:
		"vertical":
			vertex.y = 0
		"horizontal":
			vertex.x = 0
	
	add_point(vertex)


func roll_value() -> void:
	Global.rng.randomize()
	value = Global.rng.randi_range(slope.values.begin, slope.values.end)
	
	match slope.orientation:
		"vertical":
			position.y = float(value) / slope.values.end * slope.size.y
		"horizontal":
			position.x = float(value) / slope.values.end * slope.size.x
#endregion

