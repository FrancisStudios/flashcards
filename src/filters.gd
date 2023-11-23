extends Node

# RETURNS LEARNED WORDS 
# (which has a higher successrating than treshold)
func filter_learned_words(dictionary):
	var TRESHOLD: float = 2.5 # TRESHOLD OF STARS
	var NUMERIC_TRESHOLD: int = 10 #AT LEAST THIS MANY SUCCESS
	var RETURN: Array = []
	
	for index in dictionary.size():
		var wordStars = global.get_stars(dictionary[index]['success'], dictionary[index]['fail'])
		if (wordStars >= TRESHOLD) && (dictionary[index]['success'] >= NUMERIC_TRESHOLD):
			RETURN.append(dictionary[index])
	
	return RETURN

# RETURNS SMALLEST SHOWRATE WORD FROM DICTIONARY
func get_least_showrate(DICTIONARY):
	var leastShown
	var smallest: int
	
	# Init with first item
	leastShown = DICTIONARY[0]
	smallest = (DICTIONARY[0]['success'] + DICTIONARY[0]['fail'])
	
	# Search loop
	for dictionaryItem in DICTIONARY:
		var showRate = (dictionaryItem['success'] + dictionaryItem['fail'])
		if  showRate <= smallest:
			leastShown = dictionaryItem
			smallest = showRate
	
	return leastShown
	
	
# RETURNS LEAST SUCCESSRATE
func get_least_successrate(DICTIONARY):
	var leastSuccessrate
	var smallest: int
	var divider
	
	# Init with first item
	leastSuccessrate = DICTIONARY[0]
	divider = (DICTIONARY[0]['success'] + DICTIONARY[0]['fail'])
	
	if divider == 0:
		smallest = 100
	else:
		smallest = int(round(float((float((DICTIONARY[0]['success']) / float(divider)) * 100))))
	
	# Search loop
	for dictionaryItem in DICTIONARY:
		divider = (dictionaryItem['success'] + dictionaryItem['fail'])
		
		if divider == 0 || dictionaryItem['success'] == 0:
			pass
		else:
			var successRate = int(round(float((float((dictionaryItem['success']) / float(divider)) * 100))))
			if successRate <= smallest:
				leastSuccessrate = dictionaryItem
				smallest = successRate
	
	return leastSuccessrate
