extends Node

class_name Save

func saveSaveFile(data):
	var file = File.new()
	file.open("user://saveData.json", File.WRITE)
	file.store_string(to_json(data))
	file.close()
	print("Saved:")
	print(data)
	print()
	
func loadSaveFile():
	var saveData
	var tFile = File.new()
	tFile.open("user://saveData.json", File.READ)

	saveData = parse_json(tFile.get_as_text())
	
	tFile.close()
	print("loaded Save:")
	print(saveData)
	print()
	
	
	return saveData

func createSave():
	var defaultSaveData = {
		"name":"",
		"pfp_client":"Default",
		"pfp_server": "Cat",
		"musicSetting":{
			"music": "Act 2 Grimora Theme.wav",
			"volume":-10,
			"muted":false
		},
		"generalSetting":{
			"showDeckEdit":true,
			"showRuleset":true,
			"showThemeEdit": true,
			"showOpenDir":true,
			"showDiscord":true
		}
	}
	
	var dir = Directory.new()
	dir.open("user://")

	if !dir.file_exists("saveData.json"):
		var file = File.new()
		file.open("user://saveData.json", File.WRITE)
		file.store_string(to_json(defaultSaveData))
		file.close()
