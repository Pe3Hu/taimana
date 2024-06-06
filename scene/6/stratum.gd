extends Polygon2D


#region vars
var slope = null
var type = null
var values = null
var total = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	slope = input_.slope
	type = input_.type
	values = input_.values
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_vertexs()
	color = Global.color.result[type]


func init_vertexs() -> void:
	var lengths = Vector2(slope.size)
	total = values.back() - values.front() 
	
	match slope.orientation:
		"vertical":
			lengths.y = float(lengths.y) / slope.total * total
			position.y = float(values.front() - 1) / slope.total * slope.size.y
		"horizontal":
			lengths.x = lengths.x / slope.total * total
			position.x = float(values.front() - 1) / slope.total * slope.size.y
	
	var vertexs = []
	
	for direction in Global.dict.direction.zero:
		var vertex = Vector2(direction) * lengths
		vertexs.append(vertex)
	
	set_polygon(vertexs)
#endregion
