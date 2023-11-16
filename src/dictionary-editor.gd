extends Control

func _ready():
	var itemList = get_node('NinePatchRect/ItemList')
	print(global.DICTIONARY)
	for itemIndex in global.DICTIONARY.size():
		var itemText = global.DICTIONARY[itemIndex]['original'] + ' = ' +global.DICTIONARY[itemIndex]['translation']
		itemList.add_item(itemText, null, true)

 
func _on_back_pressed():
	get_tree().change_scene_to_file("res://src/scenes/load_screen.tscn")
