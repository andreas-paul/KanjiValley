extends Control

onready var jlpt5 = _base.jlpt5
onready var keys = jlpt5.keys()
onready var word

var ReadingScene = preload("res://Reading.tscn")

signal correct_translation
signal wrong_translation

func _ready():	
	_generate_kanji()
	$CenterContainer/VBoxContainer/Kanji.text = str(_base.character)
	$CenterContainer/VBoxContainer/Input.grab_focus()
	
func _generate_kanji():
	randomize()
	_base.character = keys[randi() % keys.size()]
	_base.meaning = jlpt5[_base.character]['meanings']	
	_base.reading = jlpt5[_base.character]['readings_on']	
		
func _check_translation(response, kanji_character):		
	for i in range(len(_base.meaning)):
		_base.meaning[i] = _base.meaning[i].to_lower()
	if (response in _base.meaning) or _base._distance(response, _base.meaning):		
		emit_signal("correct_translation")
	else:		
		emit_signal("wrong_translation")

func _on_Input_text_entered(new_text):
	print('Entered')
	new_text = new_text.to_lower()	
	_check_translation(new_text, _base.character)
#	
func _on_Translate_correct_translation():
	queue_free()
	get_tree().get_root().add_child(ReadingScene.instance())

func _on_Translate_wrong_translation():
	$CenterContainer/VBoxContainer/Input/ColorRect/AnimationPlayer.play("Flash")	

func _on_ReturnToStart_pressed():
	queue_free()
	var _discard = get_tree().change_scene("res://StartMenu.tscn")

func _set_input_empty():
	$CenterContainer/VBoxContainer/Input.text = ''

