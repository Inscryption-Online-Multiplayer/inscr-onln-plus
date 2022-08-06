extends Node2D

var saveData


# Called when the node enters the scene tree for the first time.
func _ready():
	Save.new().createSave()
	saveData = Save.new().loadSaveFile()
	setVolume(saveData.musicSetting.volume)
	
	if saveData.musicSetting.muted:
		setVolume(-80)
	
func _process(delta):
	if !$Music.playing:
		var path = "%s/music/%s"
		var a
		if not File.new().file_exists(path%["res://sfx",saveData.musicSetting.music]):
			#https://github.com/Gianclgar/GDScriptAudioImport
			a = AudioLoader.new().loadfile(path%["user://asset/sound", saveData.musicSetting.music])
		else:
			a = load(path%["res://sfx",saveData.musicSetting.music])
			
		play(a)
	
func stop():
	$Music.stop()
	
func play(music):
	stop()
	$Music.stream = music
	$Music.play()
	
func setVolume(db):
	$Music.volume_db = db
