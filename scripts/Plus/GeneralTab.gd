extends Tabs

var save = Save.new().loadSaveFile()

onready var deckToggle = get_node("VBoxContainer/DeckEditorToggle/CheckBox")
onready var rulesetToggle = get_node("VBoxContainer/RuleSetToggle/CheckBox")
onready var themeToggle = get_node("VBoxContainer/ThemeToggle/CheckBox")
onready var openDirToggle = get_node("VBoxContainer/OpenDirToggle/CheckBox")
onready var discordToggle = get_node("VBoxContainer/DiscordToggle/CheckBox")

func _ready():
	deckToggle.pressed = save.generalSetting.showDeckEdit
	rulesetToggle.pressed = save.generalSetting.showRuleset
	themeToggle.pressed = save.generalSetting.showThemeEdit
	openDirToggle.pressed = save.generalSetting.showOpenDir
	discordToggle.pressed = save.generalSetting.showDiscord
	
	reload()
	
func reload():
	get_node("/root/Main/TitleScreen/Menu/VBoxContainer/DeckEditorBtn").visible = deckToggle.pressed
	get_node("/root/Main/TitleScreen/Menu/VBoxContainer/SelectVersionBtn").visible = rulesetToggle.pressed
	get_node("/root/Main/TitleScreen/Menu/VBoxContainer/ThemeEditorBtn").visible = themeToggle.pressed
	get_node("/root/Main/TitleScreen/Menu/VBoxContainer/LogFolder").visible = openDirToggle.pressed
	get_node("/root/Main/TitleScreen/Menu/VBoxContainer/DiscordBtn").visible = discordToggle.pressed
	


func _on_Save_pressed():
	save.generalSetting.showDeckEdit = deckToggle.pressed
	save.generalSetting.showRuleset = rulesetToggle.pressed
	save.generalSetting.showThemeEdit = themeToggle.pressed
	save.generalSetting.showOpenDir = openDirToggle.pressed
	save.generalSetting.showDiscord = discordToggle.pressed
	
	Save.new().saveSaveFile(save)
	
	reload()


func _on_Close_pressed():
	get_parent().visible = false

