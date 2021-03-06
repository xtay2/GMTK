extends Control

export(Array, AudioStream) var music_wave

onready var main = find_parent("Main")

signal on_upgrade()
signal on_select_powerline()
signal on_select_tower_type(name)

var paused = false
var max_enemy_count = 0

func _ready():
	update_buttons()

func update_enemy_info(wave, enemy_count):
	if main.wave != wave:
		main.wave = wave

	$EnemyStateInfo/Wave.text = "%s" % main.wave
		
	var music = music_wave[(wave - 1) % music_wave.size()]
	if music != $MusicPlayer.stream:
		$MusicPlayer.stream = music
		$MusicPlayer.play(0)

func _on_Upgrade_pressed():
	emit_signal("on_upgrade")


func _on_tower_selected(name):
	emit_signal("on_select_tower_type", name)


func _input(event):  # For the case we need it
	if event.is_action_pressed("pause") and paused:
		paused = false
		get_tree().paused = false
	elif event.is_action_pressed("pause") and not paused:
		paused = true
		get_tree().paused = true
		

func _on_powerline_selected(_extra_arg_0):
	emit_signal("toggle_connetion_mode")


func update_buttons():
	for i in range(4):
		var button = find_node("Speed" + String(i))
		button.pressed = i == main.speed_factor
	if main.speed_factor > 0:
		Engine.time_scale = main.speed_factor


func _on_Speed0_pressed():
	main.speed_factor = 0
	main.pause_game()
	update_buttons()


func _on_Speed1_pressed():
	main.speed_factor = 1
	update_buttons()
	get_tree().paused = false



func _on_Speed2_pressed():
	main.speed_factor = 2
	update_buttons()
	get_tree().paused = false


func _on_Speed3_pressed():
	main.speed_factor = 3
	update_buttons()
	get_tree().paused = false


