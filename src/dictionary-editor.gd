extends Control

func _ready():
	var itemList = get_node('NinePatchRect/ItemList')
	
	for itemIndex in global.DICTIONARY.size():
		var itemText = global.DICTIONARY[itemIndex]['original'] + ' = ' +global.DICTIONARY[itemIndex]['translation']
		itemList.add_item(itemText, null, true)

func _on_back_pressed():
	get_tree().change_scene_to_file('res://src/scenes/load_screen.tscn')

# BUTTON HANDLERS
func _on_add_pressed():
	global.write_json_file($NinePatchRect/TopBar/Original.text, $NinePatchRect/TopBar/Translation.text)
	var newItem = $NinePatchRect/TopBar/Original.text + ' = ' + $NinePatchRect/TopBar/Translation.text
	get_node('NinePatchRect/ItemList').add_item(newItem, null, true)
	$NinePatchRect/TopBar/Original.text = ''
	$NinePatchRect/TopBar/Translation.text = '' 
	
func _on_remove_pressed():
	pass # Replace with function body.
