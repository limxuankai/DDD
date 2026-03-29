extends Node2D

func _ready():
	$music.play()

func _process(delta):
	var time = $music.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	print("Current position: ", time)
