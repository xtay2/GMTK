extends Node2D

#The Tower the energy is coming from#
export(Texture) var activ_texture
export(Texture) var passiv_texture


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

var production_level = 0

func _ready():
	set_level(production_level)
	map.place_node(self)
	$EnergyRadius.initialise(self, 10)
	
func _process(delta):
	$EnergyRadius.visible = ui.place_mode or ui.connect_mode or ui.hovering_tower == self
	if has_energy() and (production_level < 4 and $ProgressBar.value != $ProgressBar.max_value):
		$Sprite.texture = activ_texture
		$ProgressBar.value += energy_level * delta
		if $ProgressBar.value == $ProgressBar.max_value:
			set_level(production_level + 1)
	else:
		$Sprite.texture = passiv_texture
		$ProgressBar.value -= 100 * delta + 1
		if $ProgressBar.value == $ProgressBar.min_value:
			set_level(0)

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
	update_energy()
	return energy_level > 0

func set_level(level):
	production_level = level
	$ProgressBar.max_value = (production_level + 1) * 1000
	$ProgressBar.value = 0
	for i in range(0, 4):
		var power_rod = find_node("Level" + String(i))
		if i < production_level:
			power_rod.play()
		else:
			power_rod.stop()
			power_rod.frame = 0
