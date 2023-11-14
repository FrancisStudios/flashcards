extends Node
#
# GENERAL JSON OPERATIONS
#
var LOADED_DICTIONARY = {}
var dict_file_path = ''

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
