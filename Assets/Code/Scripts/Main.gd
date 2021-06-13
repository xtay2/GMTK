extends Node2D

var speed_factor = 1

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func pause_game():
	get_tree().paused = true
