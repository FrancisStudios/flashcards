extends Node

# RETURNS LEARNED WORDS 
# (which has a higher successrating than treshold)
func filter_learned_words(dictionary):
	var TRESHOLD: float = 2.5 # TRESHOLD OF STARS
	var RETURN: Array = []
	
	for index in dictionary.size():
		var wordStars = global.get_stars(dictionary[index]['success'], dictionary[index]['fail'])
		if wordStars >= TRESHOLD:
			RETURN.append(dictionary[index])
	
	return RETURN
