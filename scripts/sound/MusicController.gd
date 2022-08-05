extends Node2D

var saveData = {
	"name": "",
	"music": "Act 2 Grimora Theme.wav",
	"volumn": -10,
	"muted": false,
	"portrait": "Cat"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var tFile = File.new()
	tFile.open("user://saveData.json", File.READ)
	if parse_json(tFile.get_as_text()):
		saveData = parse_json(tFile.get_as_text())
		
	setVolume(saveData.volumn)
	
	if saveData.muted:
		setVolume(-80)
	
func _process(delta):
	if !$Music.playing:
		var path = "%s/music/%s"
		var a
		if not File.new().file_exists(path%["res://sfx",saveData.music]):
			#https://github.com/Gianclgar/GDScriptAudioImport
			a = AudioLoader.new().loadfile(path%["user://asset/sound", saveData.music])
		else:
			a = load(path%["res://sfx",saveData.music])
			
		play(a)
	
func stop():
	$Music.stop()
	
func play(music):
	stop()
	$Music.stream = music
	$Music.play()
	
func setVolume(db):
	$Music.volume_db = db
