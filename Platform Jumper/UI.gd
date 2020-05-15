extends CanvasLayer



export(StreamTexture) var redBar : = preload("res://Images/bar/bar_red_200.png")
export(StreamTexture) var yellowBar : = preload("res://Images/bar/bar_yellow_200.png")
export(StreamTexture) var greenBar : = preload("res://Images/bar/bar_green_200.png")


onready var labelScore : = $HBoxContainer/Score
onready var _healthBar : = $CenterContainer/healthBar




func _on_Player_health_updated(percentage : float) -> void:
	if percentage < 0:
		percentage = 0
	if percentage < 0.3:
		_healthBar.texture_progress = redBar
	elif percentage < 0.6:
		_healthBar.texture_progress = yellowBar
	else:
		_healthBar.texture_progress = greenBar
	_healthBar.value = percentage * _healthBar.max_value
	pass # Replace with function body.


func _on_Player_pie_collection(score : int) -> void:
	labelScore.text = 'Pie:' + str(score)+'/3' 
	pass # Replace with function body.
