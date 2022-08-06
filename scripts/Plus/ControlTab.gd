extends Tabs

func _ready():
	reload()

static func reload():
	var kb = keyBind.new().loadkeyBind()
	
	# for child in $VBoxContainer.get_children():
	#	if not child.name in ["Label", "Spacer", "Button"]:
		#	child.get_parent().remove_child(child)
			
	for act in kb:
		
		var hBox = HBoxContainer.new()
		var label = Label.new()
		var btn = Button.new()
		var resetBtn = Button.new()
		
		hBox.name = act
		
		label.text = act.capitalize()
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)

		btn.text = OS.get_scancode_string(kb[act])
		btn.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		btn.toggle_mode = true
		btn.set_script(load("res://scripts/Plus/Button.gd"))
		btn.act = act
		btn.key = OS.get_scancode_string(kb[act])
		
		resetBtn.name = "reset"
		resetBtn.text = "reset"
		resetBtn.set_script(load("res://scripts/Plus/Button.gd"))
		resetBtn.act = act
		
		
		hBox.add_child(label)
		hBox.add_child(btn)
		hBox.add_child(resetBtn)
		
		get_node("VBoxContainer").add_child_below_node($VBoxContainer/Label,hBox)


func _on_Close_pressed():
	get_parent().visible = false
