extends Control

var dSize = 0

onready var searchResults = get_node("%SearchContainer")
onready var deckDisplay = get_node("%DeckContainer")
onready var sideDeckDisplay = get_node("%SideDeckContainer")
onready var cardPreview = get_node("%PreviewContainer")

# Search option units
onready var searchOptions = get_node("%SearchOptions")

onready var sigil_so_1 = searchOptions.get_node("HBoxContainer/VBoxContainer2/SigilSearchA/OptionButton")
onready var sigil_so_2 = searchOptions.get_node("HBoxContainer/VBoxContainer2/SigilSearchB/OptionButton")
onready var cost_type_so = searchOptions.get_node("HBoxContainer/VBoxContainer/HBoxContainer2/CTSelect")
onready var name_so = searchOptions.get_node("HBoxContainer/VBoxContainer2/HBoxContainer3/LineEdit")

onready var attack_so_op = searchOptions.get_node("HBoxContainer/VBoxContainer/HBoxContainer3/Operator")
onready var attack_so_num = searchOptions.get_node("HBoxContainer/VBoxContainer/HBoxContainer3/LineEdit")
onready var health_so_op = searchOptions.get_node("HBoxContainer/VBoxContainer/HBoxContainer4/Operator")
onready var health_so_num = searchOptions.get_node("HBoxContainer/VBoxContainer/HBoxContainer4/LineEdit")

# Deck creation units
onready var selector_de = $HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions/VBoxContainer/DSelLine/DSel
onready var rename_de = $HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions/VBoxContainer/DNameLine/LineEdit

# Extended options
onready var sidedeck_de = $"HBoxContainer/VBoxContainer/MainArea/VBoxContainer/DeckPreview2/TabContainer/Side Deck Select/HBoxContainer/SDSel"
onready var sidedeck_container = get_node("%SideDeckContainer")
onready var sidedeck_single = get_node("%SDCardSingle")
onready var sidedeck_prefix = get_node("%PrefixType")

onready var tab_cont = get_node("%TabContainer")

var preDeck = 0
var sortState = [
	"Sort Name",
	"Sort Cost",
	"Sort Power",
	"Sort Health"
]

# Card result prefab
var cardPrefab = preload("res://packed/dbCard.tscn")

func _on_ExitButton_pressed():
	
	save_deck()
	
	visible = false
	get_node("/root/Main/TitleScreen").populate_deck_list()
	get_node("/root/Main/TitleScreen").select_deck(selector_de.selected)
	get_node("/root/Main/TitleScreen/Blocker").visible = false # close the blocker

func apply_custom_background():
	$CustomBG.texture = CardInfo.background_texture
	$HBoxContainer/CardPreview.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/DeckOptions.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/MainArea/VBoxContainer/DeckPreview.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/SearchOptions.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/MainArea/TabContainer/Cards.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/MainArea/TabContainer/Cards/VBoxContainer/ScrollContainer.theme_type_variation = "TspBg"
	$HBoxContainer/VBoxContainer/MainArea/VBoxContainer/DeckPreview2.theme_type_variation = "TspBg"

func clear_custom_background():
	$CustomBG.texture = null
	$HBoxContainer/CardPreview.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/DeckOptions.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/MainArea/VBoxContainer/DeckPreview.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/SearchOptions.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/MainArea/TabContainer/Cards.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/MainArea/TabContainer/Cards/VBoxContainer/ScrollContainer.theme_type_variation = ""
	$HBoxContainer/VBoxContainer/MainArea/VBoxContainer/DeckPreview2.theme_type_variation = ""
	

func _ready():
	
	if CardInfo.background_texture != null:
		apply_custom_background()
	
	init_search_ui()
	init_sidedeck_ui()
	search()
	
	ensure_default_deck()
	populate_deck_list()
	get_node("/root/Main/TitleScreen").populate_deck_list()
	
	load_deck()
	
	# Hide side deck options if disabled
	if not CardInfo.all_data.side_decks:
		$HBoxContainer/VBoxContainer/MainArea/VBoxContainer/DeckPreview2.visible = false
	
	# Android
	if OS.get_name() in ["Android", "HTML5"]:
		$HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions/VBoxContainer/Stoof/TestButton.visible = false
		$HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions/VBoxContainer/Stoof/ViewFolder.visible = false

	$"%LRButtonsContainer".visible = not GameOptions.options.plus.hideScroll

func init_sidedeck_ui():
	for sd in CardInfo.side_decks:
		sidedeck_de.add_item(sd)

func init_search_ui():
	var id = 2
	
	# Update sigil boxes
	for sb in [sigil_so_1, sigil_so_2]:
		sb.add_item("Any", 0)
		sb.add_item("None", 1)
		for sigil in CardInfo.all_sigils:
			sb.add_item(sigil, id)
			id += 1

func search(_arg = null):
	for card in searchResults.get_children():
		card.queue_free()
		
	var resultCount = 0
	
	var search_cards = CardInfo.all_cards
	
	if tab_cont.current_tab == 1:
		search_cards = CardInfo.side_decks[CardInfo.side_decks.keys()[sidedeck_de.selected]].cards.duplicate()
		
		for i in range(len(search_cards)):
			search_cards[i] = CardInfo.from_name(search_cards[i])
	
	for card in search_cards:
		# Don't show banned cards
		if "banned" in card and tab_cont.current_tab == 0 and not GameOptions.options.show_banned:
			continue

		# Search conditions
		
		# Name
		if not name_so.text.to_lower() in card["name"].to_lower() and name_so.text != "":
			continue
		
		# Sigils
		if sigil_so_1.text != "Any" and (not "sigils" in card or not sigil_so_1.text in card["sigils"]):
			if not (sigil_so_1.text == "None" and not "sigils" in card):
				continue
		if sigil_so_2.text != "Any" and (not "sigils" in card or not sigil_so_2.text in card["sigils"]):
			continue
		# Cost type
		if cost_type_so.selected == 1 and not "blood_cost" in card:
			continue
		if cost_type_so.selected == 2 and not "bone_cost" in card:
			continue
		if cost_type_so.selected == 3 and not "energy_cost" in card:
			continue
		if cost_type_so.selected == 4 and not "mox_cost" in card:
			continue
		
		# Attack, hp
		if attack_so_op.selected == 0 and not card.attack == int(attack_so_num.text):
			continue
		if attack_so_op.selected == 1 and not card.attack <= int(attack_so_num.text):
			continue
		if attack_so_op.selected == 2 and not card.attack >= int(attack_so_num.text) and not (card.attack < 0 and int(attack_so_num.text) == 0):
			continue
		
		if health_so_op.selected == 0 and not card.health == int(health_so_num.text):
			continue
		if health_so_op.selected == 1 and not card.health <= int(health_so_num.text):
			continue
		if health_so_op.selected == 2 and not card.health >= int(health_so_num.text):
			continue
		
		resultCount += 1
		
		var cObject = cardPrefab.instance()
		searchResults.add_child(cObject)
		cObject.from_data(card)
		cObject.modulate = cObject.HVR_COLOURS[0]
		
		if "banned" in card and tab_cont.current_tab == 0:
			cObject.get_node("BannedOverlay").visible = true
		
	$HBoxContainer/VBoxContainer/MainArea/TabContainer/Cards/VBoxContainer/PanelContainer/ResultsCount.text = str(resultCount) + "/" + str(len(CardInfo.all_cards))

func update_deck_count(var diff = 0):
	dSize += diff
	$HBoxContainer/VBoxContainer/MainArea/VBoxContainer/HBoxContainer/PanelContainer/DeckSize.text = str(dSize)

func _on_ClearButton_pressed():
	for card in deckDisplay.get_children():
		card.queue_free()
	dSize = 0
	update_deck_count()

# Deck Saving and Loading
func get_deck_object():
	
	
	
	# Side deck
#	if side_deck == 3:
#		side_deck = []
#		for card in sidedeck_container.get_children():
#			if not card.is_queued_for_deletion():
#				side_deck.append(card.card_data.name)
	
	var deck_object = {
		"cards": [],
	}
	
	if CardInfo.side_decks:
		var sd_key = CardInfo.side_decks.keys()[sidedeck_de.selected]
		var side_deck = CardInfo.side_decks[sd_key]
		deck_object["side_deck"] = sd_key
		
		if side_deck.type == "single_cat":
			deck_object.side_deck_cat = side_deck.cards.keys()[sidedeck_prefix.selected]
		
		if side_deck.type == "draft":
			deck_object.side_deck_cards = []
			for card in sidedeck_container.get_children():
				if not card.is_queued_for_deletion():
					deck_object.side_deck_cards.append(card.card_data["name"])

	for card in deckDisplay.get_children():
		if not card.is_queued_for_deletion():
			deck_object["cards"].append(card.card_data["name"])
	
	return deck_object

func get_card_count(cDat):
	var res = 0

	for card in deckDisplay.get_children():
		if card.card_data == cDat:
			res += 1
	
	return res

func get_sd_card_count(cDat):
	var res = 0

	for card in sideDeckDisplay.get_children():
		if card.card_data == cDat:
			res += 1
	
	return res

func get_card_id(card_data):
	return CardInfo.all_cards.find(card_data)

# UI for deck save
func save_deck(_arg = null):
	var sFile = File.new()
	var json = get_deck_object()
	json.format = CardInfo.all_data.ruleset
	
	sFile.open(CardInfo.deck_path + selector_de.text + ".deck", File.WRITE)
	sFile.store_line(to_json(json))
	sFile.close()

	sFile.open(CardInfo.deck_backup_path + selector_de.text + ".deck", File.WRITE)
	sFile.store_line(to_json(json))
	sFile.close()
	
func save_deck_as(_arg = null):
	if rename_de.text == "":
		return

	var dTest : Directory = Directory.new()
	if not dTest.file_exists(CardInfo.deck_path + rename_de.text + ".deck"):
		selector_de.add_item(rename_de.text, selector_de.get_item_count())	
	
	var sFile: File = File.new()
	var json = get_deck_object()
	print(json)
	json.format = CardInfo.all_data.ruleset
	
	sFile.open(CardInfo.deck_path + rename_de.text + ".deck", File.WRITE)
	sFile.store_line(to_json(json))
	sFile.close()

	sFile.open(CardInfo.deck_backup_path + rename_de.text + ".deck", File.WRITE)
	sFile.store_line(to_json(json))
	sFile.close()
	
	for item in range(selector_de.get_item_count()):
		if selector_de.get_item_text(item) == rename_de.text:
			selector_de.select(item)

	load_deck()

func ensure_default_deck():
	var fTest = Directory.new()
	var defDeck = File.new()
	
	fTest.open(OS.get_user_data_dir())
	
	if not fTest.dir_exists(CardInfo.deck_path):
		print("Creating deck directory! Error code: ", fTest.make_dir_recursive(CardInfo.deck_path))
	
	if not fTest.dir_exists(CardInfo.deck_backup_path):
		print("Creating deck backup directory! Error code: ", fTest.make_dir_recursive(CardInfo.deck_backup_path))
	
	if not defDeck.file_exists(CardInfo.deck_path + "default.deck"):
		defDeck.open(CardInfo.deck_path + "default.deck", File.WRITE)
		defDeck.store_line("{\"cards\": [], \"side_deck\": 0}\n")

func load_deck(_index=null, force = false):
	
	print("Loading deck ", selector_de.text, "...")

	var dFile = File.new()
	dFile.open(CardInfo.deck_path + selector_de.text + ".deck", File.READ)
	
	for eCard in deckDisplay.get_children():
		eCard.queue_free()
		dSize = 0
	
	var rdj = dFile.get_as_text()
	
	# New-ish
	var parse_result = JSON.parse(rdj)
	
	if parse_result.error != 0:
		dFile.open(CardInfo.deck_path + selector_de.text + ".deck", File.WRITE)
		dFile.store_line('{"cards": [], "format": %s, "side_deck": 0}\n' % [CardInfo.all_data.ruleset])
		
		dFile.open(CardInfo.deck_path + selector_de.text + ".deck", File.READ)
		rdj = dFile.get_as_text()
		
		$Error.show()
		$Error/PanelContainer/VBoxContainer/Label.text = "Failed to parse deck %s at line %d with error:\n\"%s\"" % [selector_de.text, parse_result.error_line, parse_result.error_string]
		
		parse_result = JSON.parse(rdj)
	
	var dj = parse_result.result
	
	if ("format" in dj):
		if (dj.format != CardInfo.all_data.ruleset) and (not force) and GameOptions.options.plus.deckWarning:
			$warning.visible = true
			return
	
	for card in dj["cards"]:
		var nCard = cardPrefab.instance()
		
		var cdat = CardInfo.from_name(card)
		
		if not cdat:
			continue
		
		if "banned" in cdat:
			continue
#			nCard.get_node("BannedOverlay").visible = true
		
		if "rare" in cdat:
			var found = false
			for child in deckDisplay.get_children():
				if child.is_queued_for_deletion():
					continue
				
				if child.card_data.name == cdat.name:
					found = true
					break
			if found:
				continue
		
		else:
			var found = 0
			for child in deckDisplay.get_children():
				if child.is_queued_for_deletion():
					continue
				
				if child.card_data.name == cdat.name:
					found += 1
			if found >= CardInfo.all_data.max_commons_main:
				continue
		
		nCard.from_data(cdat)
		nCard.name = cdat.name # set card name so later can be search
		deckDisplay.add_child(nCard)
		nCard.modulate = nCard.HVR_COLOURS[0]
		dSize += 1
	
	# Draw sd
	
	if CardInfo.side_decks:
		if not "side_deck" in dj or not dj.side_deck in CardInfo.side_decks:
			dj.side_deck = CardInfo.side_decks.keys()[0]
		
		sidedeck_de.select(CardInfo.side_decks.keys().find(dj["side_deck"]))
		# Simulate a selection because I'm lazy
		_on_SDSel_item_selected(sidedeck_de.selected)
		
		# Select correct category
		match CardInfo.side_decks[dj["side_deck"]].type:
			"single_cat":
				sidedeck_prefix.select(CardInfo.side_decks[dj["side_deck"]].cards.keys().find(dj["side_deck_cat"]))
			"draft":
				for card in sidedeck_container.get_children():
					card.queue_free()

				var added = {}
				
				if not "side_deck_cards" in dj:
					draw_sidedeck(dj["side_deck"])
					update_deck_count()
					return
				
				for card in dj["side_deck_cards"]:

					if not card in added:
						added[card] = 1
					else:
						added[card] += 1

					if added[card] > CardInfo.all_data.max_commons_side:
						continue

					if "rare" in CardInfo.from_name(card) and added[card] > 1:
						continue

					var nCard = cardPrefab.instance()
					nCard.from_data(CardInfo.from_name(card))
					sidedeck_container.add_child(nCard)
					nCard.modulate = nCard.HVR_COLOURS[0]
				
		# Redraw
		draw_sidedeck(dj["side_deck"])
	
	update_deck_count()

func populate_deck_list():
	
	print("Populating deck list...")
	
	var prevSelected = "default"
	
	if selector_de.selected >= 0:
		prevSelected = selector_de.get_item_text(selector_de.selected)

	selector_de.clear()
	
	var dTest = Directory.new()
	dTest.open(CardInfo.deck_path)
	dTest.list_dir_begin()
	var fName = dTest.get_next()
	while fName != "":
		if not dTest.current_is_dir() and fName.ends_with(".deck"):
			selector_de.add_item(fName.split(".deck")[0])
		fName = dTest.get_next()
	
	# Re-select deck
	for item_idx in range(selector_de.get_item_count()):
		if selector_de.get_item_text(item_idx) == prevSelected:
			selector_de.select(item_idx)


func _on_SDSel_item_selected(index):
	
	var key = CardInfo.side_decks.keys()[index]
	var side_deck = CardInfo.side_decks[key]
	
	# Just switched to a new category, we can update prefixes
	if CardInfo.side_decks[key].type == "single_cat":

		sidedeck_prefix.clear()

		for prefix in side_deck.cards:
			sidedeck_prefix.add_item(prefix)
		
	draw_sidedeck(key)


func _on_PrefixType_item_selected(_index):
	var key = CardInfo.side_decks.keys()[sidedeck_de.selected]
	draw_sidedeck(key)
	
func draw_sidedeck(key):
	var side_deck = CardInfo.side_decks[key]
	
	sidedeck_single.visible = false
	sidedeck_prefix.visible = false
	tab_cont.tabs_visible = false
	tab_cont.current_tab = 0
	
	match side_deck.type:
		"single":
			sidedeck_single.visible = true
			sidedeck_single.from_data(CardInfo.from_name( CardInfo.side_decks[key].card ))
		"single_cat":
			side_deck = side_deck.cards[side_deck.cards.keys()[sidedeck_prefix.selected]]
			sidedeck_single.visible = true
			sidedeck_prefix.visible = true
			sidedeck_single.from_data(CardInfo.from_name(side_deck.card))
		"draft":
			tab_cont.tabs_visible = true
			validate_draft_side()

func validate_draft_side():
	
	var valid_side_cards = CardInfo.all_data.side_decks[sidedeck_de.get_item_text(sidedeck_de.selected)].cards
	
	for sCard in sidedeck_container.get_children():
		var current_data = sCard.card_data
		
		if not current_data.name in valid_side_cards:
			sCard.queue_free()

class CardSorter:
	static func cost(a, b):
		var aCard = CardInfo.from_name(a)
		var bCard = CardInfo.from_name(b)
		
		var costName = ["mox_cost", "energy_cost", "bone_cost", "blood_cost"]
		
		var aCost = -1
		var bCost = -1
		
		for i in costName.size():
			if costName[i] in aCard:
				aCost = i
			if costName[i] in bCard:
				bCost = i
			if aCost != -1 and bCost != -1:
				break
		
		if aCost == bCost:
			if aCost == -1 and bCost == -1:
				return true
			
			a = aCard[costName[aCost]] if aCost != 0 else aCard[costName[aCost]].size()
			b = bCard[costName[bCost]] if bCost != 0 else bCard[costName[bCost]].size()
			
			return a > b
		else:
			return aCost > bCost
	
	static func health(a, b):
		return CardInfo.from_name(a).health > CardInfo.from_name(b).health
	
	static func attack(a, b):
		return CardInfo.from_name(a).attack > CardInfo.from_name(b).attack

func sort(index):
	var cardList = get_deck_object()["cards"]

	for eCard in deckDisplay.get_children():
		eCard.queue_free()
	
	if index == 0:
		cardList.sort()
	elif index == 1:
		cardList.sort_custom(CardSorter, "cost")
	elif index == 2:
		cardList.sort_custom(CardSorter, "health")
	elif index == 3:
		cardList.sort_custom(CardSorter, "attack")
	
	for card in cardList:
		var nCard = cardPrefab.instance()
		nCard.from_data(CardInfo.from_name(card))
		deckDisplay.add_child(nCard)
		nCard.modulate = nCard.HVR_COLOURS[0]
		dSize += 1
		
func _on_ShuffleButton_pressed():
	var cardList = get_deck_object()["cards"]

	for eCard in deckDisplay.get_children():
		eCard.queue_free()
	
	
	cardList.shuffle()
	
	for card in cardList:
		var nCard = cardPrefab.instance()
		nCard.from_data(CardInfo.from_name(card))
		deckDisplay.add_child(nCard)
		nCard.modulate = nCard.HVR_COLOURS[0]
		dSize += 1

func _on_ViewFolder_pressed():
	OS.shell_open("file://" + OS.get_user_data_dir() + "/decks")


func _on_TestButton_pressed():
	save_deck()
	
	# Set deck in lobby thing
	get_node("/root/Main/TitleScreen/InLobby/Rows/DeckOptions/Deck").select($HBoxContainer/VBoxContainer/DeckOptions/HBoxContainer/DeckOptions/VBoxContainer/DSelLine/DSel.selected)
	
	# Exit to menu and host
	visible = false
	get_node("/root/Main/TitleScreen").debug_host()
	OS.execute(OS.get_executable_path(), ["join"], false)


func _exit_tree():
	save_deck()




func _on_TabContainer_tab_changed(_tab):
	search()


func _on_DelBtn_pressed():
	
	var current_deck = CardInfo.deck_path + selector_de.text + ".deck"
	
	selector_de.select((selector_de.selected + 1) % selector_de.get_item_count())
	load_deck()
	
	
	var dir = Directory.new()
	dir.remove(current_deck)
	
	ensure_default_deck()
	populate_deck_list()

func _on_JsonButton_pressed():
	$JsonFromMenu.show_modal()


func _on_JsonFromMenu_id_pressed(id):
	match id:
		0: # From file
			$FromFile.show_modal()
		1: # From URL
			$FromURL.show()
		2: # From Text
			$FromJSON.show()
		3: # Copy Deck
			OS.clipboard = to_json(get_deck_object())


func _on_JSONLoadBtn_pressed():
	var sFile = File.new()
	sFile.open(CardInfo.deck_path + selector_de.text + ".deck", File.WRITE)
	sFile.store_line($FromJSON/PanelContainer/VBoxContainer/TextEdit.text)
	sFile.close()

	sFile.open(CardInfo.deck_backup_path + selector_de.text + ".deck", File.WRITE)
	sFile.store_line($FromJSON/PanelContainer/VBoxContainer/TextEdit.text)
	sFile.close()
	
	load_deck()


func _on_URLDownloadBtn_pressed():
	$DeckDownloader.download_file = CardInfo.deck_path + selector_de.text + ".deck"
	var err = $DeckDownloader.request($FromURL/PanelContainer/VBoxContainer/LineEdit.text)
	if err == 0:
		$Status.show()
		$FromURL.hide()
	else:
		$Error/PanelContainer/VBoxContainer/Label.text = "Error parsing URL"
		$Error.show()
		$Status.hide()

func _on_DeckDownloader_request_completed(_result, response_code, _headers, _body):
	$FromURL.hide()
	$Status.hide()
	
	if response_code == 200:
		load_deck()
	else:
		$Error.show()
		$Error/PanelContainer/VBoxContainer/Label.text = "Download failed: response code %d" % response_code

func _on_FromFile_file_selected(path):
	
	var lFile = File.new()
	lFile.open(path, File.READ)
	var deckContents = lFile.get_as_text()
	lFile.close()
	
	var sFile = File.new()
	sFile.open(CardInfo.deck_path + selector_de.text + ".deck", File.WRITE)
	sFile.store_line(deckContents)
	sFile.close()

	sFile.open(CardInfo.deck_backup_path + selector_de.text + ".deck", File.WRITE)
	sFile.store_line(deckContents)
	sFile.close()
	
	load_deck()

func avg(nums: Array):
	if (nums.size() <= 0): return 0
	
	var sum = 0
	for num in nums:
		sum += num
	
	return sum / nums.size()
	
func updateStats():
	var deckList = get_deck_object()
	var costCount = {
		"blood": [],
		"bone": [],
		"energy": [],
		"mox": [],
		"free": []
	}
	for cName in deckList.cards:
		var card = CardInfo.from_name(cName)
		var free = true
		for cost in costCount: if (cost + "_cost") in card: 
			free = false
			costCount[cost].append(card[cost + "_cost"])
		
		if free: costCount.free.append(1)
		
	var costLabel = $"HBoxContainer/VBoxContainer/MainArea/TabContainer/Deck Statistics/VBoxContainer/cost"
	costLabel.text = ""
	for cost in costCount:
		costLabel.text += "%s cost amount: %s (%s%%)\n" % [cost, costCount[cost].size(), stepify((costCount[cost].size() as float / deckList.cards.size()) * 100, 0.01) ]
		if (cost != "mox") and (cost != "free"): costLabel.text += "%s cost average: %s\n" % [cost, stepify(avg(costCount[cost]), 0.01)]
		costLabel.text += "\n"

func _on_load_pressed():
	load_deck(null, true)
	$warning.visible = false

func _on_backup_pressed():
	var file = File.new()
	file.open(CardInfo.deck_path + selector_de.text + ".deck", File.READ)
	var data = file.get_as_text()
	file.close()
	var backupName = selector_de.text + "-backup"

	file.open(CardInfo.deck_path + backupName + ".deck", File.WRITE)
	file.store_line(data)
	file.close()
	
	selector_de.add_item(backupName)
	
	for i in range(selector_de.get_item_count()):
		if (selector_de.get_item_text(i) == backupName):
			selector_de.select(i)
			break
			

	load_deck(null, true)
	$warning.visible = false
	
func _on_no_pressed():
	selector_de.select(preDeck)
	load_deck()
	$warning.visible = false

func _updatePre():
	preDeck = selector_de.selected

func _on_searchDeck_text_changed(new_text): 
	for child in deckDisplay.get_children(): 
		child.visible = new_text.to_lower() in child.name.to_lower() if new_text != "" else true
