extends Node2D

#Colors for placing and moving
const PLACEMENT_COLOR = Color(0.129412, 0.878431, 0.862745)
const SELECTED_COLOR = Color(0.517647, 0.8, 0.301961)


#Tower Counter
var max_towers = 5
onready var placed_towers = get_tree().get_nodes_in_group("electricity").size()

#Class imports
var tower_class = preload("res://Assets/Code/Scenes/Electricity/ElectricityTower.tscn")
var splitter_class = preload("res://Assets/Code/Scenes/Electricity/ElectricitySplitter.tscn")
var reactor_class = preload("res://Assets/Code/Scenes/Electricity/Reactor.tscn")

#Modes
var place_mode = false
var connect_mode = false

#Tower that was placed last
var last_tower = null

#Tower that were selected last
var selected_towers = {"Tower1" : null, "Tower2" : null}

#The Tower or Reactor the Mouse is hovering over
var hovering_tower

signal play(audio)

func _ready():
	$TowerCount.text = String(placed_towers) + "|" + String(max_towers)

func _input(event):
		#Init Placemode 
		if event.is_action_pressed("one") and !place_mode and !connect_mode and placed_towers < max_towers:
			place_tower(tower_class)
		if event.is_action_pressed("two") and !place_mode and !connect_mode and placed_towers < max_towers:
			place_tower(splitter_class)
		
		if place_mode and event.is_action_pressed("right_click"):
			last_tower.removeTower()
			place_mode = false
			return
			
		#Init Connectmode
		elif event.is_action_pressed("shift") and !place_mode:
			start_connect_mode()
			return
		#End Connectmode
		elif event.is_action_released("shift") and connect_mode:
			end_connection_mode()
			return
		#Confirm Placement
		if event.is_action_pressed("left_click") and place_mode:
			emit_signal("play", "place_tower")
			last_tower.place_this()
			place_mode = false
			$TowerCount.text = String(placed_towers) + "|" + String(max_towers)
			return
		#Select Tower
		elif connect_mode and event.is_action_pressed("left_click") and hovering_tower != null:
			emit_signal("play", "connect")
			select()
		#Remove Tower
		if event.is_action_pressed("right_click") and !place_mode and !connect_mode and hovering_tower:
			if "Electricity" in hovering_tower.name:
				hovering_tower.removeTower()
				hovering_tower = null
				$TowerCount.text = String(placed_towers) + "|" + String(max_towers)
				return
		#Remove connections and select
		elif event.is_action_pressed("right_click") and !place_mode and connect_mode and hovering_tower:
			if hovering_tower.name != "Reactor" and !("Splitter" in hovering_tower.name) and hovering_tower.has_next_tower():
				hovering_tower.break_power_start()
				hovering_tower.remove_cable()
				end_connection_mode()
				start_connect_mode()
				select()
				return
		#Connect wenn in Connectmode
		if connect_mode and event.is_action_pressed("left_click") and selected_towers.Tower1 != null and selected_towers.Tower2 != null:
			emit_signal("play", "connect")
			if selected_towers.Tower1.name == "Reactor":
				selected_towers.Tower1.add_next(selected_towers.Tower2)
			else:
				if "Tower" in selected_towers.Tower1.name:
					selected_towers.Tower1.break_power_start()
				selected_towers.Tower1.connect_to_next(selected_towers.Tower2)
			selected_towers.Tower2.connect_to_previous(selected_towers.Tower1)
			step_connection_mode()
			if selected_towers.Tower1:
				selected_towers.Tower1.update_energy()
				if !selected_towers.Tower1.has_energy():
					end_connection_mode()

#Füge Tower am Anfang im place mode hinzu
func place_tower(class_instance):
	if !place_mode and !connect_mode and placed_towers < max_towers:
		last_tower = class_instance.instance()
		add_child(last_tower)
		place_mode = true
		placed_towers += 1

#Wähle Tower aus
func select():
	if selected_towers.Tower1 == null:
		if hovering_tower.has_energy() and not ("Factory" in hovering_tower.name):
			selected_towers.Tower1 = hovering_tower
			selected_towers.Tower1.is_selected = true
			selected_towers.Tower1.update_selected()
			
	elif selected_towers.Tower2 == null and hovering_tower.name != "Reactor":
		if !hovering_tower.previous_tower and selected_towers.Tower1.has_energy() and selected_towers.Tower1.is_in_range_of(hovering_tower):
			selected_towers.Tower2 = hovering_tower
			selected_towers.Tower2.is_selected = true
			selected_towers.Tower2.update_selected()

#Beende Connectmode für beide Tower
func end_connection_mode():
	if selected_towers.Tower1 != null:
		selected_towers.Tower1.is_selected = false
		selected_towers.Tower1.update_selected()

	if selected_towers.Tower2 != null:
		selected_towers.Tower2.is_selected = false
		selected_towers.Tower2.update_selected()
	selected_towers = {"Tower1" : null, "Tower2" : null}
	connect_mode = false
	$EditModeOverlay.visible = false

#Setze den alten Tower 2 auf den neuen Tower 1
func step_connection_mode():
	if selected_towers.Tower1 != null:
		selected_towers.Tower1.is_selected = false
		selected_towers.Tower1.update_selected()
		if selected_towers.Tower2 != null and not ("Factory" in selected_towers.Tower2.name) :
			selected_towers.Tower1 = selected_towers.Tower2
			selected_towers.Tower2.is_selected = false
			selected_towers.Tower2.update_selected()
			selected_towers.Tower2 = null
			selected_towers.Tower1.is_selected = true
			selected_towers.Tower1.update_selected()

func start_connect_mode():
	$EditModeOverlay.visible = true
	connect_mode = true


func _on_select_tower_type(name):
	var t_class = null
	match name:
		"splitter":
			t_class = splitter_class
		"router":
			t_class = tower_class
	if t_class == null:
		printerr("No tower type named %s. Check UI -> TurretUI" % name)
		return
	place_tower(t_class)
