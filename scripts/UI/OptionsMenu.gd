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

# change keybind when pressed
func changeKeybind(pressed):
	$loading.visible = pressed
	$Blocker.visible = pressed

# update the keybind list
func updateKeybind():
	keybindButtonList = []
	for n in $TabContainer/Plus/VBoxContainer/keybind.get_children():
		if n is Button: continue
		$TabContainer/Plus/VBoxContainer/keybind.remove_child(n)
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
		$TabContainer/Plus/VBoxContainer/keybind.add_child(hBox)

func updatePlusToggle():
	for option in $TabContainer/Plus/VBoxContainer/option.get_children():
		# if the option is not in the option list skip it
		if not option.name in GameOptions.options.plus:
			continue
		# don't override stuff if it didn't change
		var old_val = GameOptions.options.plus[option.name]
				
		if old_val != option.pressed:
			continue
		
		# save it
		GameOptions.options.plus[option.name] = not option.pressed
		
func updatePlus():
	# setting the pic in the option menu
	$TabContainer/Plus/VBoxContainer/pfp/defaultPic._select_int(GameOptions.options.plus.defaultPfp)
	$TabContainer/Plus/VBoxContainer/pfp/picPreview.texture = load("res://gfx/portraits/" + $TabContainer/Plus/VBoxContainer/pfp/defaultPic.get_item_text(GameOptions.options.plus.defaultPfp) + ".png")
	
	# setting room name and username
	$TabContainer/Plus/VBoxContainer/room/roomLine.text = GameOptions.options.plus.defaultRoom
	$TabContainer/Plus/VBoxContainer/name/nameLine.text = GameOptions.options.plus.defaultName
	
	updateKeybind()
	
	for option in GameOptions.optionName:
		if option == "scrollReminder": continue
		var button = CheckButton.new()
		button.name = option
		button.pressed = not GameOptions.options.plus[option]
		button.text = GameOptions.optionName[option][0]
		button.hint_tooltip = GameOptions.optionName[option][1]
		button.connect("pressed", self, "updatePlusToggle")
		$TabContainer/Plus/VBoxContainer/option.add_child(button)

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
	$TabContainer/Plus/VBoxContainer/scrollReminder.visible = GameOptions.options.plus.scrollReminder

# Update when a pfp option is select
func _on_defaultPic_item_selected(index):
	$TabContainer/Plus/VBoxContainer/pfp/picPreview.texture = load("res://gfx/portraits/" + $TabContainer/Plus/VBoxContainer/pfp/defaultPic.get_item_text(index) + ".png")
	GameOptions.options.plus.defaultPfp = index

func _on_defaultDeck_item_selected(index):
	GameOptions.options.plus.defaultDeck = index

func _on_roomLine_text_changed(new_text):
	GameOptions.options.plus.defaultRoom = new_text
	
func _on_nameLine_text_changed(new_text):
	GameOptions.options.plus.defaultName = new_text

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
	$TabContainer/Plus/VBoxContainer/scrollReminder.visible = false

func collapse(node: Node):
	for sibling in node.get_parent().get_children():
		if sibling == node: continue
		sibling.visible = not sibling.visible

func _on_keybindButton_pressed():
	collapse($TabContainer/Plus/VBoxContainer/keybind/keybindButton)

func _on_optionButton_pressed():
	collapse($TabContainer/Plus/VBoxContainer/option/optionButton)


func plusSearch(new_text):
	for optionCat in [$TabContainer/Plus/VBoxContainer/keybind, $TabContainer/Plus/VBoxContainer/option]:
		for child in optionCat.get_children():
			var text
			if child is HBoxContainer:
				text = child.get_child(0).text
			elif child is CheckButton:
				text = child.text
			else: continue
			child.visible = new_text.to_lower() in text.to_lower() or new_text == ""
