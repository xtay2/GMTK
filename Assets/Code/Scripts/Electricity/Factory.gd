extends Node2D

#The Tower the energy is coming from
var previous_tower

var energy_level = 0

var is_selected = false

var power_input := Vector2(0, 32)

#Mainscene
onready var main = find_parent("Main")

#Map
onready var map = main.find_node("Map")

#Visual Management for Towers 
onready var ui = main.find_node("TowerUI")

#Punkte die Tower abdeckt
var spots := []
#Width and height of tower in tiles
var box := Vector2(3, 2)

func _ready():
	map.place_node(self)
	$EnergyRadius.initialise(self, 10)
	
func _process(_delta):
	$EnergyRadius.visible = ui.place_mode or ui.connect_mode or ui.hovering_tower == self

func update_selected():
	pass
	
func connect_to_previous(previous):
	previous_tower = previous
	
func update_energy():
	if previous_tower:
		energy_level = previous_tower.get_passed_on_energy()
	else:
		energy_level = 0
	
func break_power_start():
	previous_tower = null

func break_power_rec():
	break_power_start()
	
func is_in_range_of(presumed):
	return $EnergyRadius.possible_connections().has(presumed)


func _on_Hitbox_mouse_entered():
	ui.hovering_tower = self

func _on_Hitbox_mouse_exited():
	ui.hovering_tower = null

func has_energy():
	return energy_level > 0
