extends Control

var DICTIONARY_PATH = "res://dictionaries/dict.json"
var DICTIONARY_FILE = global.load_json_file(DICTIONARY_PATH)
var DICTIONARY: Array = DICTIONARY_FILE['dict']

var allWordCountLabel: Label

func _ready():
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
	pass # Replace with function body.

func _on_settings_pressed():
	pass # Replace with function body.

func _on_learn_pressed():
	pass # Replace with function body.

func _on_freeplay_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.FREEPLAY
	global.init_next_scene("res://src/scenes/playdeck.tscn")
	
func _on_20_pressed():
	global.NEXT_SCENE_INSTRUCTIONS = global.SCENE_INSTRUCTIONS.TWENTYPLAY
	global.init_next_scene("res://src/scenes/playdeck.tscn")

func _on_50_pressed():
	pass # Replace with function body.

func _on_100_pressed():
	pass # Replace with function body.

# Disable buttons if the correct number of words are not entered
func disable_not_available_card_buttons():
	if DICTIONARY.size() < 100: get_node("ParentLayout/Launch Cards/HBoxContainer/100").disabled = true
	if DICTIONARY.size() < 50: get_node("ParentLayout/Launch Cards/HBoxContainer/50").disabled = true
	if DICTIONARY.size() < 20: get_node("ParentLayout/Launch Cards/HBoxContainer/20").disabled = true
	
