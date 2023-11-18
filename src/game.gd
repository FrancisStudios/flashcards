extends Node3D

func _ready():
	flipUpNextCard()

func _process(delta):
	pass

func _on_back_pressed():
	if global.NEXT_SCENE_INSTRUCTIONS == global.SCENE_INSTRUCTIONS.FREEPLAY:
		global.init_next_scene("res://home.tscn")

func flipUpNextCard():
	$QuestionCard/FlipUp.play("flip_question_card")
	$QuestionCard/FlipUp.connect("animation_started", swipeOutThisCard)

func swipeOutThisCard():
	print('blin')
	$QuestionCard/FlipUp.play("swipe_out")
