extends Control

var SETTINGS: Dictionary
var SETTINGS_PATH: String = "res://dictionaries/settings.json"

func _ready():
	SETTINGS = global.load_json_file("res://dictionaries/settings.json")
	
	#load values
	$Layout/TimerSettings/Seconds.value = SETTINGS['timer']
	
func _process(delta):
	pass

func write_settings():
	var newTimerValue: int = $Layout/TimerSettings/Seconds.value
	
	# File process
	var dataFile = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	
	var SAVES_OBJECT: Dictionary = {
		'timer': newTimerValue
	}
	
	var JSONAble = JSON.stringify(SAVES_OBJECT)
	dataFile.store_string(JSONAble)
	
	# Return
	global.init_next_scene("res://home.tscn")

# DICTIONARY FILE DIALOG BUTTONS
func _on_load_pressed():
	$Layout/DictionarySettings/OpenFileDialog.visible = true
	
func _on_export_pressed():
	$Layout/DictionarySettings/ExportFileDialog.visible = true
	
# DICTIONARY FILE DIALOG FILE SELECTED HOOKS
func _on_open_file_dialog_file_selected(path):
	var extension = path.split('.')[path.split('.').size()-1]
	var LOADED_JSON = global.load_json_file(path)
	
	if extension == 'json':
		if LOADED_JSON.has('dict'):
			global.DICTIONARY_FILE = LOADED_JSON
			global.DICTIONARY = global.DICTIONARY_FILE['dict']
			global.PRECOMMIT_DICTIONARY = { 'dict': global.DICTIONARY }
			global.commit_json_file()
			$Layout/JSONSuccess.text = 'Successful loading. New dictionary is ready!'
		else:
			$Layout/JSONError.text = 'Error: Invalid dictionary format'
	else:
		$Layout/JSONError.text = 'Error: Only JSON format supported'

func _on_export_file_dialog_dir_selected(dir):
	print(dir) 
		
# WRAP-UP BUTTONS
func _on_save_pressed():
	write_settings()

func _on_cancel_pressed():
	global.init_next_scene("res://home.tscn")

