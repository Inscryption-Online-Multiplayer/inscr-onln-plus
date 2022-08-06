extends Node

class_name keyBind

var data = {
	"quick_host": 32,
	"draw_main":81,
	"draw_side":69,
	"close": 16777217
}
	
func loadkeyBind():
	var data
	var tFile = File.new()
	tFile.open("user://keyBind.json", File.READ)
	
	if parse_json(tFile.get_as_text()):
		data = parse_json(tFile.get_as_text())
	
	tFile.close()
	print("loaded key bind:")
	print(data)
	print()
	return data
	
func saveKeybind(data):
	var file = File.new()
	file.open("user://keyBind.json", File.WRITE)
	file.store_string(to_json(data))
	file.close()
	print("Save key bind:")
	print(data)
	print()
	
func createKeyBindJson():

	
	var dir = Directory.new()
	dir.open("user://")

	if !dir.file_exists("keyBind.json"):
		saveKeybind(data)
		
func changeKeyBind(action, key):
	var a = loadkeyBind()
	a[action] = key
	
	saveKeybind(a)
	
func reloadKeyBind():
	#idk waht going thur my brain when writing this but the varible name is cryptic af and im not changing it now
	#i will add in all the comment later
	
	var kb = loadkeyBind() #load the keybind json file
	for act in kb: #cycle thur all the keybond action name
		
		if !InputMap.get_action_list(act).empty(): #remove the old keybind to change it
			InputMap.action_erase_event(act, InputMap.get_action_list(act)[0])
			
		var b = InputEventKey.new() #create  new keybind
		b.set_scancode(kb[act])
		InputMap.action_add_event(act,b) #putting that keybind in
			
	print("Reloaded Keybind")
	print()
