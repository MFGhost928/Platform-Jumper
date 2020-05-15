extends Node2D


func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()


func _process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()

func _on_TextureButton_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")
