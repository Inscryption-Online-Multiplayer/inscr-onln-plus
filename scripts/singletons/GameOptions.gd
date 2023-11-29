extends Node

# Have we done initialisation?
var past_first = false

var options = {
	"enable_accessibility_icons": false,
	"show_card_tooltips": true,
	"enable_moon_music": true,
	"save_replays": false,
	"show_enemy_advantage": false,
	"stretch_to_fill": false,
	"fullscreen": false,
	"crt_filter": false,
	"enable_music": true,
	"enable_sfx": false,
	"show_banned": false,
	"misplays": 0,
	"live_theme_update": false,
	"default_ruleset": "",
	"ruleset_editor": false,
	"vsync": true,
	"lock_fps": true,
	"test": false,
	"plus": {
		"scrollReminder": true,
		"defaultPfp": 0,
		"defaultRoom": "",
		"defaultName": "",
		"autoReady": false,
		"autoRematch": false,
		"autoDraw": true,
		"surrenderConfirm": true,
		"passConfirm": false,
		"quickSelect": false,
		"cardNumber": false,
		"quickSlot": false,
		"keybind": {
			"quickHost": 72,
			"endTurn":32,
			"hammer": 16777218,
			"drawMain": 81,
			"drawSide": 69
		}
	}
}

var keybindName = {
	"quickHost": ["Quick Host", "Quickly host a lobby using your default info."],
	"endTurn":["End Turn", "Hit the bell and end turn"],
	"hammer": ["Toggle Hammer", "Toggle the hammer if possible"],
	"drawMain": ["Draw Main Deck", "Draw from main deck is possible"],
	"drawSide": ["Draw Main Deck", "Draw from side deck is possible"],
}
var optionName = {
	"autoReady": ["Auto Ready", "Auto ready when entering lobby."],
	"autoRematch": ["Auto Rematch", "Auto rematch when fight end."],
	"autoDraw": ["Auto Draw (New)", "Automatically draw card when you only have 1 deck left"],
	"surrenderConfirm": ["Surrender Confirmation", "Ask for confirmation when surrendering."],
	"passConfirm": ["Pass Confirmation (New)", "Ask for confirmation when passing."],
	"quickSelect": ["Card Quick Select", "Select card using number keys."],
	"cardNumber":["Card Number", "Show card number on top of card. Recommend with Card Quick select."],
	"quickSlot": ["Slot Quick Select (New)", "Select card slot using H,J,K,L"]
}
func read_options():
	var tFile = File.new()
	if tFile.file_exists(CardInfo.options_path):
		print("Found options.json!")
		tFile.open(CardInfo.options_path, File.READ)
		print(options)
		if parse_json(tFile.get_as_text()):
			var nOptions = parse_json(tFile.get_as_text())
			
			if "plus" in nOptions:
				if "keybind" in nOptions.plus:
					for keybind in nOptions.plus.keybind:
						options.plus.keybind[keybind] = nOptions.plus.keybind[keybind]

				for plusOption in nOptions.plus:
					if plusOption == "keybind": continue
					options.plus[plusOption] = nOptions.plus[plusOption]
				
			# Do this to preserve defaults
			for opt in nOptions:
				if opt == "plus": continue
				options[opt] = nOptions[opt]



func save_options():
	var sFile = File.new()
	sFile.open(CardInfo.options_path, File.WRITE)
	sFile.store_line(to_json(options))
	sFile.close()


func _ready():
	var d = Directory.new()
	
	if d.file_exists(CardInfo.options_path):
		read_options()
	
	# Graphical options
	if options["stretch_to_fill"] == true:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1920, 1080))

	OS.window_fullscreen = options["fullscreen"]

func _exit_tree():
	# Save to file
	GameOptions.save_options()

