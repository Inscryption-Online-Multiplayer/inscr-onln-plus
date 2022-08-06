extends Button

var waiting = false
var act
var key
func _input(event):
	if waiting:
		if event is InputEventMouseButton:
			waiting = false
			pressed = false
			text = key
			
		elif !(event is InputEventMouseMotion):
			var kb = keyBind.new()
			key = event.scancode
			kb.changeKeyBind(act, key)
			waiting = false
			pressed = false
			text = OS.get_scancode_string(key)
			
			kb.reloadKeyBind()
			

		
func _toggled(button_pressed):
	if button_pressed:
		if text == "reset":
			pass
		else:
			waiting = true
			text = "Press Any Key"
			
func _pressed():
	if name == "reset":
		var kb = keyBind.new()
		kb.changeKeyBind(act, kb.data[act])
		kb.reloadKeyBind()
		load("res://scripts/Plus/ControlTab.gd").new().reload()
