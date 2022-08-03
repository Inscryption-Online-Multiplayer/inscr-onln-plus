extends Control
onready var optionBox =  get_node("SelectionBox/Rows/HBoxContainer2/OptionButton")
onready var slider = get_node("SelectionBox/Rows/Volumn/HSlider")

func _ready():
	optionBox.add_item("Act 2 Grimora Theme.wav")
	optionBox.add_item("Act 2 Mag Theme.wav")
	optionBox.add_item("Royal Phase 3 Theme.wav")
	optionBox.add_item("Trapper And Trader theme.wav")
	
	#https://docs.godotengine.org/en/stable/classes/class_file.html
	var dir = Directory.new()
	var path = "user://asset/sound/music"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".wav") or file_name.ends_with(".mp3"):
				optionBox.add_item(file_name, 1)
			file_name = dir.get_next()
				
	else:
		print("An error occurred when trying to access the path.")
		
	
func _on_Close_pressed():
	visible = false

func _on_Save_pressed():
	var path = "%s/music/%s"
	var a
	if not File.new().file_exists(path%["res://sfx",optionBox.text]):
		#https://github.com/Gianclgar/GDScriptAudioImport
		a = AudioLoader.new().loadfile(path%["user://asset/sound", optionBox.text])
	else:
		a = load(path%["res://sfx",optionBox.text])
		
	MusicController.setVolume(slider.value)
	
	MusicController.play(a)
