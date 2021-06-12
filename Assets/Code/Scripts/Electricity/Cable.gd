extends Line2D

var end_tower

func initialise(startpos, endpos, tower):
	visible = true
	set_point_position(0, startpos)
	set_point_position(1, endpos)
	end_tower = tower

func shrink():
	visible = false
	
func connect_to_tower(endpos, end):
	visible = true
	set_point_position(1, endpos)
	end_tower = end

func connect_to_towers(startpos, endpos, end):
	visible = true
	set_point_position(0, startpos)
	set_point_position(1, endpos)
	end_tower = end
