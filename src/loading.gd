extends Control

var PROGRESS = []
var sceneName
var sceneLoadStatus = 0

func _ready():
	sceneName = global.NEXT_SCENE
	ResourceLoader.load_threaded_request(sceneName)

# Loads a scene in a threaded manner
func _process(delta):
	sceneLoadStatus = ResourceLoader.load_threaded_get_status(sceneName, PROGRESS)
	$Bg/Progress.text = str(floor(PROGRESS[0]*100)) + "%"
	
	if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
		
