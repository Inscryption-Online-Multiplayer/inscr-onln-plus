extends WindowDialog

func update_options():
	for cat in $TabContainer.get_children():
		for opt in cat.get_children():
			if opt.name in GameOptions.options:
				
				var old_val = GameOptions.options[opt.name]
				
				if old_val != opt.pressed:
					continue
					
				GameOptions.options[opt.name] = not opt.pressed
				
				# Reload deck editor
				if opt.name in ["enable_accessibility_icons", "show_card_tooltips", "show_banned"]:
					get_node("/root/Main/DeckEdit").search()
				
				# Stretch screen
				if opt.name == "stretch_to_fill":
			#		get_viewport().size = OS.window_size
					if GameOptions.options.stretch_to_fill:
						get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1920, 1080))
					else:
						get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1920, 1080))
					
				elif opt.name == "fullscreen":
					OS.window_fullscreen = GameOptions.options.fullscreen
				
				elif opt.name == "crt_filter":
					get_node("/root/Main/Scanlines").visible = GameOptions.options.crt_filter

				elif opt.name == "enable_sfx":
					AudioServer.set_bus_mute(2, not GameOptions.options.enable_sfx)
				elif opt.name == "enable_music":
					AudioServer.set_bus_mute(1, not GameOptions.options.enable_music)
				
				elif opt.name == "vsync":
					OS.vsync_enabled = GameOptions.options.vsync
					
				elif opt.name == "lock_fps":
					Engine.target_fps = 60 if GameOptions.options.lock_fps else 0

var keybindButtonList = []
const toggleButton = preload("res://packed/Plus/plusToggleButton.tscn")

# change keybind when pressed
func changeKeybind(pressed):
	$loading.visible = pressed
	$Blocker.visible = pressed

# update the keybind list
func updateKeybind():
	keybindButtonList = []
	for n in $TabContainer/Plus/ScrollContainer/VBoxContainer/keybind.get_children():
		if n is Button: continue
		$TabContainer/Plus/ScrollContainer/VBoxContainer/keybind.remove_child(n)
		n.queue_free()
	
	for keybindName in GameOptions.options.plus.keybind:
		var keybindCode = GameOptions.options.plus.keybind[keybindName]
		InputMap.action_erase_events(keybindName)
		if keybindCode != KEY_ESCAPE:
			var event = InputEventKey.new()
			event.scancode = keybindCode
			InputMap.action_add_event(keybindName, event)
		
		# adding the button in the setting menu
		var hBox = HBoxContainer.new()
		var keybindLabel = Label.new()
		var keybindButton = Button.new()
		
		keybindLabel.size_flags_horizontal = SIZE_EXPAND_FILL
		keybindLabel.text = GameOptions.keybindName[keybindName][0]
		
		keybindButton.size_flags_horizontal = SIZE_EXPAND_FILL
		keybindButton.text = "NONE" if keybindCode == KEY_ESCAPE else OS.get_scancode_string(GameOptions.options.plus.keybind[keybindName])
		keybindButton.toggle_mode = true
		keybindButton.name = keybindName
		keybindButton.hint_tooltip = GameOptions.keybindName[keybindName][1]
		keybindButton.connect("toggled", self, "changeKeybind")
		
		hBox.add_child(keybindLabel)
		hBox.add_child(keybindButton)
		
		keybindButtonList.append(keybindButton)
		$TabContainer/Plus/ScrollContainer/VBoxContainer/keybind.add_child(hBox)

func updatePlus():
	updateKeybind() # make all the keybind button
	
	# make all toggle option button
	for option in GameOptions.optionName:
		if option == "scrollReminder": continue
		var button = toggleButton.instance()
		button.setName(option)
		$TabContainer/Plus/ScrollContainer/VBoxContainer/toggle.add_child(button)
		
	# music stuff
	var dir = Directory.new()
	if dir.open("user://plus/music") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".wav") or file_name.ends_with(".mp3"):
				$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/musicSelect/musicSelect.add_item(file_name)
			file_name = dir.get_next()
			
	# music stuff
	if dir.open("user://plus/theme") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/themeSelect/themeSelect.add_item(file_name)
			file_name = dir.get_next()
			
	# setting the pic in the option menu
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/pfp/defaultPic._select_int(GameOptions.options.plus.defaultPfp)
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/pfp/picPreview.texture = load("res://gfx/portraits/" + $TabContainer/Plus/ScrollContainer/VBoxContainer/misc/pfp/defaultPic.get_item_text(GameOptions.options.plus.defaultPfp) + ".png")
	
	# setting room name and username and other manual thing
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/room/roomLine.text = GameOptions.options.plus.defaultRoom
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/name/nameLine.text = GameOptions.options.plus.defaultName
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/deckPicScale/picScale.value = GameOptions.options.plus.deckPicScale
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/deckIconScale/iconScale.value = GameOptions.options.plus.deckIconScale
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/deckPreviewScale/previewScale.value = GameOptions.options.plus.deckPreviewScale
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/deckNameAlign/deckNameAlign._select_int(GameOptions.options.plus.deckAlign) 
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/musicSelect/musicSelect._select_int(GameOptions.options.plus.music[0])
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/themeSelect/themeSelect._select_int(GameOptions.options.plus.theme[0])


# Update the option to the correct value
func update_controls():
	for cat in $TabContainer.get_children():
		for opt in cat.get_children():
			if cat.name == "Plus": continue
			if opt.name in GameOptions.options:
				opt.pressed = not GameOptions.options[opt.name]

# bind the update option to each button pressed
func connect_signals():
	for cat in $TabContainer.get_children():
		# special handle for plus stuff
		if cat.name == "Plus": continue
		for opt in cat.get_children():
			if opt.name in GameOptions.options:
				opt.connect("pressed", self, "update_options")

func _ready():
	update_controls()
	connect_signals()
	
	# Apply options
	get_node("/root/Main/Scanlines").visible = GameOptions.options.crt_filter
	AudioServer.set_bus_mute(1, not GameOptions.options.enable_music)
	AudioServer.set_bus_mute(2, not GameOptions.options.enable_sfx)
	
	updatePlus()
	$TabContainer/Plus/ScrollContainer/VBoxContainer/scrollReminder.visible = GameOptions.options.plus.scrollReminder

# Update when a pfp option is select
func _on_defaultPic_item_selected(index):
	$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/pfp/picPreview.texture = load("res://gfx/portraits/" + $TabContainer/Plus/ScrollContainer/VBoxContainer/misc/pfp/defaultPic.get_item_text(index) + ".png")
	GameOptions.options.plus.defaultPfp = index
	
func _on_deckNameAlign_item_selected(index):
	GameOptions.options.plus.deckAlign = index

func _on_defaultDeck_item_selected(index):
	GameOptions.options.plus.defaultDeck = index

func _on_roomLine_text_changed(new_text):
	GameOptions.options.plus.defaultRoom = new_text
	
func _on_nameLine_text_changed(new_text):
	GameOptions.options.plus.defaultName = new_text

func _on_picScale_value_changed(value):
	GameOptions.options.plus.deckPicScale = value

func _on_iconScale_value_changed(value):
	GameOptions.options.plus.deckIconScale = value

func _on_previewScale_value_changed(value):
	GameOptions.options.plus.deckPreviewScale = value
	
func _on_musicSelect_item_selected(index):
	GameOptions.options.plus.music = [
		index, 
		$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/musicSelect/musicSelect.get_item_text(index)
	]
	
	# update music player with new music
	if GameOptions.options.plus.muteMusic:
		var music = $"../music"
		var audio_loader = AudioLoader.new()
		music.set_stream(audio_loader.loadfile(
			CardInfo.data_path + "/plus/music/%s" % GameOptions.options.plus.music[1]
			)
		)
		music.volume_db = 1
		music.pitch_scale = 1
		music.play()

func _on_themeSelect_item_selected(index):
	GameOptions.options.plus.theme = [
		index, 
		$TabContainer/Plus/ScrollContainer/VBoxContainer/misc/themeSelect/themeSelect.get_item_text(index)
	]
	var file = File.new()
	if file.file_exists(CardInfo.data_path + "/plus/theme/%s" % GameOptions.options.plus.theme[1]):
		file.open(
			CardInfo.data_path + "/plus/theme/%s" % GameOptions.options.plus.theme[1], 
			File.READ
		)
		var json = parse_json(file.get_as_text())
		if json:
			$"../ThemeEditor".theme_data = json
	$"../ThemeEditor".apply_theme()
	

func _on_OptionsBtn_pressed():
	popup()
	$"../TitleScreen/Blocker".visible = true

func _on_Options_popup_hide():
	$"../TitleScreen/Blocker".visible = false

func _input(event):
	if event is InputEventMouse: return
	
	var currentButton: Button = null
	for button in keybindButtonList:
		if button.pressed:
			currentButton = button
			break
	
	if currentButton:
		GameOptions.options.plus.keybind[currentButton.name] = event.scancode
		
		InputMap.action_erase_events(currentButton.name)
		if event.scancode != KEY_ESCAPE:
			InputMap.action_add_event(currentButton.name, event)
		
		currentButton.pressed = false
		currentButton.text =  "NONE" if event.scancode == KEY_ESCAPE else OS.get_scancode_string(event.scancode)

func goodbyeReminder():
	GameOptions.options.plus.scrollReminder = false
	$TabContainer/Plus/ScrollContainer/VBoxContainer/scrollReminder.visible = false

func plusSearch(new_text):
	for optionCat in $TabContainer/Plus/ScrollContainer/VBoxContainer.get_children():
		if not optionCat is VBoxContainer: continue
		for child in optionCat.get_children():
			var text
			if child is HBoxContainer:
				text = child.get_child(0).text
			elif child is CheckButton:
				text = child.text
			else: continue
			child.visible = new_text.to_lower() in text.to_lower() or new_text == ""
