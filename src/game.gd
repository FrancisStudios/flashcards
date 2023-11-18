extends Node3D

func _ready():
	start_card_procedure()

func _process(delta):
	print($Timer.time_left)
	pass

func _on_back_pressed():
	if global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY:
		global.init_next_scene("res://home.tscn")

func start_card_procedure():
	$Timer.start(6.5)
	flipUpNextCard()
	pass
	
func flipUpNextCard():
	$QuestionCard/FlipUp.play("flip_question_card")
	$QuestionCard/FlipUp.queue("swipe_out")
	$QuestionCard/FlipUp.queue("flip_question_card")
	$QuestionCard/FlipUp.connect("animation_finished", swipeOutThisCard)

func swipeOutThisCard():
	print('blin')
	print($Timer.time_left)
	$Timer.stop()
