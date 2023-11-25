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
	
# WRAP-UP BUTTONS
func _on_save_pressed():
	write_settings()

func _on_cancel_pressed():
	global.init_next_scene("res://home.tscn")
