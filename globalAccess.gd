extends Node

# GLOBAL VARIABLES
var DICTIONARY_FILE
var DICTIONARY


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

#Write into JSON dictionary
func write_json_file(original: String, translation: String):
	if FileAccess.file_exists(DICTIONARY_FILE):
		var dataFile = FileAccess.open(DICTIONARY_FILE, FileAccess.WRITE)
		
	else:
		print('Invalid file')


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
