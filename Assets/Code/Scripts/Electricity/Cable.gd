extends Line2D

var end_tower

func initialise(startpos, endpos, tower):
	set_point_position(0, startpos)
	set_point_position(1, endpos)
	end_tower = tower

func shrink():
	visible = false
	
func connect_to_tower(end):
	visible = true
	set_point_position(1, Vector2(end.global_position.x - global_position.x + end.power_input.x, end.global_position.y - global_position.y + end.power_input.y))
	end_tower = end
