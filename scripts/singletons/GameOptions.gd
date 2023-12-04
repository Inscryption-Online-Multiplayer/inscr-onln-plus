extends Node

# Have we done initialisation?
var past_first = false
var keyNone = 16777217
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
		"defaultDeck": 0,
		"defaultRoom": "",
		"defaultName": "",
		"deckPicScale": 1,
		"deckIconScale": 2,
		"deckPreviewScale": 2,
		"deckAlign": 0,
		"autoReady": false,
		"autoRematch": false,
		"autoDraw": true,
		"surrenderConfirm": true,
		"passConfirm": false,
		"quickSelect": false,
		"cardNumber": false,
		"quickSlot": false,
		"slotLabel": false,
		"deckList": true,
		"deckPortraitColor": false,
		"improveDeckSearch": false,
		"hideDeck": false,
		"hideRuleset": false,
		"hideDirectory": false,
		"hideDiscord": false,
		"keybind": {
			"quickHost": 72,
			"endTurn":32,
			"surrender": keyNone,
			"hammer": 16777218,
			"drawMain": 81,
			"drawSide": 69,
			"host": keyNone,
			"join": keyNone,
			"deck": keyNone,
			"ruleset": keyNone,
			"option": keyNone,
			"directory": keyNone,
		}
	}
}

var keybindName = {
	"quickHost": ["Quick Host", "Quickly host a lobby using your default info."],
	"quickTest": ["Quick Test", "Quickly open a test lobby using your default info."],
	"endTurn":["End Turn", "Hit the bell and end turn"],
	"surrender":["Surrender", "Surrender..."],
	"hammer": ["Toggle Hammer", "Toggle the hammer if possible"],
	"drawMain": ["Draw Main Deck", "Draw from main deck if possible"],
	"drawSide": ["Draw Main Deck", "Draw from side deck if possible"],
	"host":["Open Host Menu", "Press the \"Host Game\" button on the title screen"],
	"join":["Open Join Menu", "Press the \"Join Game\" button on the title screen"],
	"deck":["Open Deck Editor", "Press the \"Deck Editor\" button on the title screen"],
	"ruleset":["Open Ruleset Selector", "Press the \"Select Ruleset\" button on the title screen"],
	"option":["Open Option", "Press the \"Open Game Directory\" button on the title screen"],
	"directory":["Open Directory", "Press the \"Open Game Directory\" button on the title screen"],
}
var optionName = {
	"autoReady": ["Auto Ready", "Auto ready when entering lobby."],
	"autoRematch": ["Auto Rematch", "Auto rematch when fight end."],
	"autoDraw": ["Auto Draw", "Automatically draw card when you only have 1 deck left"],
	"surrenderConfirm": ["Surrender Confirmation", "Ask for confirmation when surrendering."],
	"passConfirm": ["Pass Confirmation", "Ask for confirmation when passing."],
	"quickSelect": ["Card Quick Select", "Select card using number keys."],
	"cardNumber":["Card Number", "Show card number on top of card. Recommend with Card Quick select."],
	"quickSlot": ["Slot Quick Select", "Select card slot using H,J,K,L"],
	"slotLabel": ["Slot Label", "Show slot label to help with Slot Quick Select."],
	"deckList": ["Deck List", "Show a list of reminaing card when clicking on a deck pile"],
	"deckPortraitColor": ["Deck List Portrait Color", "Change the color of the portrait instead of adding a background in deck list."],
	"improveDeckSearch": ["Improve Deck Search", "Use the deck list when searching for card"],
	"hideDeck":["Hide Deck Editor", "Hide the \"Deck Editor\" button on the title screen (reset to work)"],
	"hideRuleset":["Hide Ruleset", "Hide the \"Select Ruleset\" button on the title screen (reset to work)"],
	"hideDirectory":["Hide Open Directory", "Hide the \"Open Game Directory\" button on the title screen (reset to work)"],
	"hideDiscord":["Hide Discord", "Hide the \"Inscryption Multiplayer Discord\" button on the title screen (reset to work)"],
}

func read_options():
	var tFile = File.new()
	if tFile.file_exists(CardInfo.options_path):
		print("Found options.json!")
		tFile.open(CardInfo.options_path, File.READ)
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

