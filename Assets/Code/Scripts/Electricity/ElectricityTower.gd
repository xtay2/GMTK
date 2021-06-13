extends Node2D

#The Tower the energy is coming from
var previous_tower

#The Tower the energy is going to
var next_towers := []

var is_selected = false

#Mainscene
onready var main = find_parent("Main")

#Map
onready var map = main.find_node("Map")

#Visual Management for Towers 
onready var ui = find_parent("TowerUI")

onready var power_input = $EnergyRadius.position

var cable_class = preload("res://Assets/Code/Scenes/Electricity/Cable.tscn")

var cable

var energy_level = 0

var energy_loss = 10

#Punkte die Tower abdeckt
var spots := []
#Width and height of tower in tiles
var box := Vector2(1, 1)

export(Texture) var aktiv_texture 
export(Texture) var passiv_texture 

onready var tower : Tower = $Tower

	
func _process(_delta):
	if tower.target:
		$Turret_Gun.look_at(tower.target)
	
	if not is_on_r():
		$Turret_Gun.flip_v = true
	else:
		$Turret_Gun.flip_v = false
#	$Turret_Gun.look_at(tower.enemy_que.front().global_position)

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
	$Turret_Gun/Gun/AnimatedSprite.scale = Vector2.ONE * rand_range(1, 1.5)
	$Turret_Gun/Gun/AnimatedSprite.play("flash")



func _ready():
	cable = cable_class.instance()
	add_child(cable)
	cable.initialise(Vector2(0, 6), Vector2(0, 6), null)
	$Socket.modulate = ui.PLACEMENT_COLOR
	$Texture.modulate = ui.PLACEMENT_COLOR
	$EnergyRadius.initialise(self, 10)

func connect_to_next(next):
	if next_towers.empty():
		next_towers.append(next)
		cable.connect_to_tower(next)
	
func connect_to_previous(previous):
	previous_tower = previous
	

func _process(_delta):
	update_energy()
	if ui and ui.place_mode and ui.last_tower == self:
		position_this()
	if !previous_tower:
		next_towers.clear()
	$EnergyRadius.visible = ui.place_mode or ui.connect_mode or ui.hovering_tower == self

func place_this():
	$Socket.texture = load("res://Assets/Graphics/Towers/ElectricityTower/Extention_Pylon_Off.png")
	$Texture.play("off")
	update_selected()
	map.place_node(self)

func update_selected():
	if is_selected: 
		$Socket.modulate = ui.SELECTED_COLOR
		$Texture.modulate = ui.SELECTED_COLOR
	else:
		$Socket.modulate = Color.white
		$Texture.modulate = Color.white

func has_energy():
	update_energy()
	return (energy_level - energy_loss) > 0

func is_in_range_of(presumed):
	return $EnergyRadius.possible_connections().has(presumed)


func removeTower():
	if previous_tower:
		if previous_tower.name == "Reactor":
			previous_tower.remove_next(self)
		else:
			previous_tower.cut_next()
			previous_tower.remove_cable()
			break_power_start()
			previous_tower.cut_next()
			previous_tower.remove_cable()
	break_power_start()
	ui.placed_towers -= 1
	map.remove_node(self)
	queue_free()

func remove_cable():
	cable.shrink()

func break_power_start():
	if !next_towers.empty() and next_towers[0]:
		next_towers[0].break_power_rec()
	next_towers.clear()
	remove_cable()
	
func break_power_rec():
	previous_tower = null
	energy_level = 0
	$Socket.texture = load("res://Assets/Graphics/Towers/ElectricityTower/Extention_Pylon_Off.png")
	$Texture.play("off")
	break_power_start()
	
func get_all_previous_nodes():
	var list = []
	var prev = self
	while prev != "Reactor":
		list.append(prev)
		prev = prev.previous_tower
	return list


func update_energy():
	if previous_tower:
		energy_level = previous_tower.get_passed_on_energy()
		if energy_level > 0:
			$Socket.texture = load("res://Assets/Graphics/Towers/ElectricityTower/Extention_Pylon_On.png")
			$Texture.play("on")
		else:
			energy_level = 0
			break_power_start()
	if $EnergyHUD.visible:
		$EnergyHUD.text = String(energy_level) + "V"
	for next in next_towers:
		next.update_energy()

#Sagt den nächsten Türmen wie viel Energy sie haben
func get_passed_on_energy():
	return energy_level - energy_loss


func _on_Hitbox_mouse_entered():
	ui.hovering_tower = self
	$EnergyHUD.visible = true


func _on_Hitbox_mouse_exited():
	ui.hovering_tower = null
	$EnergyHUD.visible = false

func position_this():
	map.update_spot(self, get_global_mouse_position())

func has_next_tower():
	return !next_towers.empty()

func cut_next():
	next_towers.clear()
