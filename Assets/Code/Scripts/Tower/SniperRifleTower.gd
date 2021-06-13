extends Node2D

onready var tower : Tower = $Tower

export(Texture) var aktiv_texture 
export(Texture) var passiv_texture 

#Mainscene
onready var main = find_parent("Main")

#Map
onready var map = main.find_node("Map")

#Visual Management for Towers 
onready var ui = main.find_node("TowerUI")

#Punkte die Tower abdeckt
var spots := []
#Width and height of tower in tiles
var box := Vector2(1, 1)

func _ready():
	map.place_node(self)
	#Energieleitung
	cable = cable_class.instance()
	add_child(cable)
	cable.initialise(power_input, power_input, null)
	$EnergyRadius.initialise(self, 10)

func _process(_delta):
	if tower.target and tower.energie_consumption < energy_level:
		$Turret_Gun.look_at(tower.target)
	$EnergyRadius.visible = ui.place_mode or ui.connect_mode or ui.hovering_tower == self
	if not is_on_r():
		$Turret_Gun.flip_v = true
	else:
		$Turret_Gun.flip_v = false

func _physics_process(_delta):
	if tower.target and tower.energie_consumption < energy_level:
		$Turret_Gun/Gun.shoot(tower.target)
	if tower.energie_consumption < energy_level:
		$Turret_Gun.texture = aktiv_texture
	else:
		$Turret_Gun.texture = passiv_texture

func is_on_r():
	return $Turret_Gun.global_rotation_degrees >= -90 and $Turret_Gun.global_rotation_degrees < 90

func _on_AnimatedSprite_animation_finished():
	$Turret_Gun/Gun/AnimatedSprite.frame = 0
	$Turret_Gun/Gun/AnimatedSprite.visible = false


func _on_Gun_has_shoot():
	$Turret_Gun/Gun/AnimatedSprite.visible = true
	$Turret_Gun/Gun/AnimatedSprite.scale = Vector2.ONE * rand_range(2, 2.5)
	$Turret_Gun/Gun/AnimatedSprite.play("flash")

#--------------------------------------------------ENERGY-----------------------------------------
#The Tower the energy is coming from
var previous_tower

#The Tower the energy is going to
var next_tower

var energy_level = 0
var energy_loss = 10

var is_selected = false

onready var power_input = find_node("Tower").position

var cable_class = preload("res://Assets/Code/Scenes/Electricity/Cable.tscn")

var cable

func _on_Hitbox_mouse_entered():
	ui.hovering_tower = self

func _on_Hitbox_mouse_exited():
	ui.hovering_tower = null

func has_energy():
	update_energy()
	return (energy_level - energy_loss) > 0

func update_selected():
	if is_selected: 
		$TowerBase.modulate = ui.SELECTED_COLOR
		$Turret_Gun.modulate = ui.SELECTED_COLOR
	else:
		$TowerBase.modulate = Color.white
		$Turret_Gun.modulate = Color.white

func connect_to_next(next):
	next_tower = next
	cable.connect_to_tower(next_tower)
	
func connect_to_previous(previous):
	previous_tower = previous
	
func update_energy():
	if previous_tower:
		energy_level = previous_tower.get_passed_on_energy()
	else:
		energy_level = 0
		break_power_start()
	if next_tower:
		next_tower.update_energy()

#Sagt den nächsten Türmen wie viel Energy sie haben
func get_passed_on_energy():
	return energy_level - energy_loss
	
func remove_cable():
	cable.shrink()
	
func power_breakdown():
	if next_tower:
		next_tower.power_breakdown()
		next_tower = null
		next_tower.previous_tower = null
	remove_cable()
	energy_level = 0
	
func break_power_start():
	if next_tower:
		next_tower.break_power_rec()
	next_tower = null
	remove_cable()
	
func break_power_rec():
	previous_tower = null
	energy_level = 0
	break_power_start()

func is_in_range_of(presumed):
	return $EnergyRadius.possible_connections().has(presumed)

func has_next_tower():
	return next_tower != null
	
func cut_next():
	next_tower = null


