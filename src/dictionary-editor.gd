extends Control

var SELECTED_ITEM = null

func _ready():
	var itemList = get_node('NinePatchRect/ItemList')
	
	for itemIndex in global.DICTIONARY.size():
		var itemText = global.DICTIONARY[itemIndex]['original'] + ' = ' +global.DICTIONARY[itemIndex]['translation']
		itemList.add_item(itemText, null, true)

func _on_back_pressed():
	SELECTED_ITEM = null
	global.commit_json_file() # If no modifs commit obj will be null
	get_tree().change_scene_to_file('res://src/scenes/load_screen.tscn')

# BUTTON HANDLERS
func _on_add_pressed():
	SELECTED_ITEM = null
	global.write_json_file($NinePatchRect/TopBar/Original.text, $NinePatchRect/TopBar/Translation.text)
	var newItem = $NinePatchRect/TopBar/Original.text + ' = ' + $NinePatchRect/TopBar/Translation.text
	get_node('NinePatchRect/ItemList').add_item(newItem, null, true)
	$NinePatchRect/TopBar/Original.text = ''
	$NinePatchRect/TopBar/Translation.text = '' 
	
func _on_remove_pressed():
	if SELECTED_ITEM != null:
		global.remove_from_json_file(SELECTED_ITEM)
		get_node('NinePatchRect/ItemList').remove_item(SELECTED_ITEM)
		
func _on_item_list_item_selected(index):
	SELECTED_ITEM = index;
