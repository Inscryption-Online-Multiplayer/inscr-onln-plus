extends Node

class_name Save

func saveSaveFile(data):
	var file = File.new()
	file.open("user://saveData.json", File.WRITE)
	file.store_string(to_json(data))
	file.close()
	print("Saved:")
	print(data)
	
func loadSaveFile():
	var saveData
	var tFile = File.new()
	tFile.open("user://saveData.json", File.READ)
	
	if parse_json(tFile.get_as_text()):
		saveData = parse_json(tFile.get_as_text())
	
	tFile.close()
	print("loaded Save:")
	print(saveData)
	
	return saveData
