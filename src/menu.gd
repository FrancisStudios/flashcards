extends Control

var DICTIONARY_PATH
var DICTIONARY_FILE
var DICTIONARY: Array 

var SETTINGS_PATH

var allWordCountLabel: Label

func _ready():
	# Select environment
	match global.ENV:
		global.ENVIRONMENTS.PROD:
			if installer.checkInstallation() == installer.INSTALLATION.COMPLETE:
				# If it's already installed
				DICTIONARY_PATH = "./flashcards/dictionary.json"
				SETTINGS_PATH = "./flashcards/settings.json"
				DICTIONARY_FILE = global.load_json_file(DICTIONARY_PATH)
				DICTIONARY = DICTIONARY_FILE['dict']
				
			elif installer.checkInstallation() == installer.INSTALLATION.NOT_INSTALLED:
				# Install new
				installer.install()
				DICTIONARY_PATH = installer.PATH_DICT
				SETTINGS_PATH = "./flashcards/settings.json"
				DICTIONARY_FILE = global.load_json_file(DICTIONARY_PATH)
				DICTIONARY = DICTIONARY_FILE['dict']
		
		global.ENVIRONMENTS.DEV: # Use res:// resource bundle
			DICTIONARY_PATH = "res://dictionaries/dict.json"
			SETTINGS_PATH = "res://dictionaries/settings.json"
			DICTIONARY_FILE = global.load_json_file(DICTIONARY_PATH)
			DICTIONARY = DICTIONARY_FILE['dict']
	
	# Set all values in globals domain
	global.DICTIONARY_PATH = DICTIONARY_PATH
	global.DICTIONARY_FILE = DICTIONARY_FILE
	global.DICTIONARY = DICTIONARY
	global.SETTINGS_PATH = SETTINGS_PATH
	
	# Set number of learned words (learned:=overshoots treshold)
	var learned_words: Array = filters.filter_learned_words(DICTIONARY)
	allWordCountLabel = get_node('ParentLayout/Words Count Display/NumberOfWords')
	allWordCountLabel.text = str(learned_words.size())
	
	# Set global dict values
	global.DICTIONARY_PATH = DICTIONARY_PATH 
	global.DICTIONARY_FILE = DICTIONARY_FILE 
	global.DICTIONARY = DICTIONARY 
	
	disable_not_available_card_buttons()

func _on_dict_config_pressed():
	get_tree().change_scene_to_file("res://src/scenes/dic_editor.tscn")

func _on_about_pressed():
	global.init_next_scene("res://src/scenes/about.tscn")

func _on_settings_pressed():
	global.init_next_scene("res://src/scenes/settings.tscn")

func _on_learn_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.LEARN
	global.init_next_scene("res://src/scenes/playdeck.tscn")

func _on_freeplay_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.FREEPLAY
	global.init_next_scene("res://src/scenes/playdeck.tscn")
	
func _on_20_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.TWENTYPLAY
	global.init_next_scene("res://src/scenes/playdeck.tscn")

func _on_50_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.FIFTYPLAY
	global.init_next_scene("res://src/scenes/playdeck.tscn")
	
func _on_100_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.HUNDREDPLAY
	global.init_next_scene("res://src/scenes/playdeck.tscn")

# Disable buttons if the correct number of words are not entered
func disable_not_available_card_buttons():
	if DICTIONARY.size() < 100: get_node("ParentLayout/Launch Cards/HBoxContainer/100").disabled = true
	if DICTIONARY.size() < 50: get_node("ParentLayout/Launch Cards/HBoxContainer/50").disabled = true
	if DICTIONARY.size() < 20: get_node("ParentLayout/Launch Cards/HBoxContainer/20").disabled = true
	if DICTIONARY.size() == 0: 
		$"ParentLayout/Launch Cards/HBoxContainer/Freeplay".disabled = true
		$"ParentLayout/Launch Cards/HBoxContainer/Learn".disabled = true
