extends Node2D

var startMusic = load("res://sfx/music/Act 2 Grimora Theme.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	play(startMusic)

func stop():
	$Music.stop()
	
func play(music):
	stop()
	$Music.stream = music
	$Music.play()
	
func setVolume(db):
	$Music.volume_db = db
