extends Control

onready var pfp = get_node("./VBoxContainer/CustomPortrait/OptionButton")

func _ready():
	reload()
	
func reload():
	pfp.clear()
	
	pfp.add_item("Default")
	
	var dir = Directory.new()
	var path = "user://asset/texture/pfps"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png") or file_name.ends_with(".jpeg"):
				pfp.add_item(file_name)
			file_name = dir.get_next()
				
	else:
		print("An error occurred when trying to access the path.")
	pass

func _on_reload_pressed():
	reload()


func _on_Save_pressed():
	var save = Save.new().loadSaveFile()
	save.pfp_client = pfp.text
	Save.new().saveSaveFile(save)


func _on_OpenDir_pressed():
	OS.shell_open("file://%s/asset/texture"%[OS.get_user_data_dir()])


func _on_Close_pressed():
	get_parent().visible = false
