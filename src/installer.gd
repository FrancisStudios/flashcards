extends Node

var PATH_PREFIX = OS.get_executable_path().get_base_dir()
var PATH_DICT = PATH_PREFIX + '/flashcards/dictionary.json'
var PATH_SETT = PATH_PREFIX + '/flashcards/settings.json'

# Returns enum status about installation
func checkInstallation():
	if FileAccess.file_exists(PATH_DICT) && FileAccess.file_exists(PATH_SETT):
		return INSTALLATION.COMPLETE
	else:
		return INSTALLATION.NOT_INSTALLED

# Installation
func install():
	# Create a folder for res
	var dir = DirAccess.open(PATH_PREFIX)
	dir.make_dir_recursive('flashcards')
	
	# Empty dictionary setup
	writeObject(PATH_DICT, { "dict": [] })
	
	# Settings setup
	writeObject(PATH_SETT, { "timer": 10 })

# Private write objects
func writeObject(path: String, object: Dictionary):
	var objectFile = FileAccess.open(path, FileAccess.WRITE)
	print(error_string(FileAccess.get_open_error()))
	var JSONStringified = JSON.stringify(object)
	objectFile.store_string(JSONStringified)

enum INSTALLATION { NOT_INSTALLED, INSTALLING, COMPLETE }
