extends Control
onready var optionBox =  get_node("Rows/BgMusicSelect/OptionButton")
onready var slider = get_node("Rows/Volume/HSlider")
onready var mute = get_node("Rows/Mute/CheckBox")

func _ready():
	reload()
	var saveData = Save.new().loadSaveFile()
	slider.value = saveData.musicSetting.volume
	mute.pressed = saveData.musicSetting.muted
	optionBox.text = saveData.musicSetting.music
	
		
func _on_Close_pressed():
	get_parent().visible = false

func _on_Save_pressed():
	var save = Save.new()
	var saveData = save.loadSaveFile()
	
	var path = "%s/music/%s"
	var a
	if not File.new().file_exists(path%["res://sfx",optionBox.text]):
		#https://github.com/Gianclgar/GDScriptAudioImport
		a = AudioLoader.new().loadfile(path%["user://asset/sound", optionBox.text])
	else:
		a = load(path%["res://sfx",optionBox.text])
		
	MusicController.setVolume(slider.value)
	
	if mute.pressed:
		MusicController.setVolume(-80)
	
	
	MusicController.play(a)

	saveData.musicSetting.muted = mute.pressed
	saveData.musicSetting.volume = slider.value
	saveData.musicSetting.music = optionBox.text
	
	save.saveSaveFile(saveData)

func reload():
	optionBox.clear()
	
	optionBox.add_item("Act 2 Grimora Theme.wav")
	optionBox.add_item("Act 2 Mag Theme.wav")
	optionBox.add_item("Royal Phase 3 Theme.wav")
	optionBox.add_item("Trapper And Trader theme.wav")
	optionBox.add_item("P03's Favorite Song.mp3")
	
	#https://docs.godotengine.org/en/stable/classes/class_file.html
	var dir = Directory.new()
	var path = "user://asset/sound/music"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".wav") or file_name.ends_with(".mp3"):
				optionBox.add_item(file_name)
			file_name = dir.get_next()
				
	else:
		print("An error occurred when trying to access the path.")

func _on_ReloadBtn_pressed():
	reload()

func _on_Button_pressed():
	OS.shell_open("file://%s/asset/sound/music"%[OS.get_user_data_dir()])
