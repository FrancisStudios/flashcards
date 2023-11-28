extends Node

# ENVIRONMENT
var ENV = ENVIRONMENTS.PROD

# GLOBAL VARIABLES
var DICTIONARY_PATH
var DICTIONARY_FILE
var DICTIONARY
var PRECOMMIT_DICTIONARY

var SETTINGS_PATH

var NEXT_SCENE: String
var NEXT_SCENE_INSTRUCTIONS: int

var RANKED: Dictionary = { 'success': 0, 'fail': 0, 'results': [] }

# GENERAL JSON OPERATIONS

#Read up JSON dictionary:
func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		
		if parsedFile is Dictionary:
			return parsedFile
		else: 
			print('File is invalid')	
	else:
		# If file does not exist -> create new dictionary
		pass

# Write JSON dictionary but DOES NOT COMMIT TO FILE YET
func write_json_file(original: String, translation: String):
	if FileAccess.file_exists(DICTIONARY_PATH):
		var dicEntry = { "original": original, "translation": translation, "success": 0, "fail": 0 }
		DICTIONARY.append(dicEntry)
		var readyFile = { "dict": DICTIONARY }
		
		PRECOMMIT_DICTIONARY = readyFile

# Remove word from JSON dictionary - DOES NOT COMMIT
func remove_from_json_file(index):
	var dictionaryEntries: Array
	
	for dictIndex in DICTIONARY.size():
		if index != dictIndex:
			dictionaryEntries.append(DICTIONARY[dictIndex])
	
	var readyFile = { "dict": dictionaryEntries }
	
	DICTIONARY = readyFile["dict"]
	PRECOMMIT_DICTIONARY = readyFile

# Commits file changes
func commit_json_file():
	if PRECOMMIT_DICTIONARY != null && PRECOMMIT_DICTIONARY.size():
		var dataFile = FileAccess.open(DICTIONARY_PATH, FileAccess.WRITE)
		var JSONAble = JSON.stringify(PRECOMMIT_DICTIONARY)
		dataFile.store_string(JSONAble)
		PRECOMMIT_DICTIONARY = null
	
# STARS LOGIC

func get_stars(success, fail):
	var success_rate: int = int(round(float((float(success) / float((success + fail))) * 100)))
	if success_rate > 90:
		return 3
	elif success_rate > 75:
		return 2.5
	elif success_rate > 60:
		return 2
	elif success_rate > 55:
		return 1.5
	elif success_rate > 50:
		return 1
	elif success_rate > 30:
		return 0.5
	elif success_rate < 30:
		return 0
		
# STAR VARS XD - you get the joke
var STAR_00 = preload("res://imageres/ico/stars/0.png")
var STAR_05 = preload("res://imageres/ico/stars/0.5.png")
var STAR_10 = preload("res://imageres/ico/stars/1.png")
var STAR_15 = preload("res://imageres/ico/stars/1.5.png")
var STAR_20 = preload("res://imageres/ico/stars/2.png")
var STAR_25 = preload("res://imageres/ico/stars/2.5.png")
var STAR_30 = preload("res://imageres/ico/stars/3.png")

# SCENE CHANGE OPERATIONS

func init_next_scene(SCENE):
	global.NEXT_SCENE = SCENE
	get_tree().change_scene_to_file("res://src/scenes/load_screen.tscn")
	
enum SCENE_INSTRUCTIONS { LEARN, FREEPLAY, TWENTYPLAY, FIFTYPLAY, HUNDREDPLAY }
enum ENVIRONMENTS { PROD, DEV, TEST }
