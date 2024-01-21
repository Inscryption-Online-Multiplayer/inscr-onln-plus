extends ScrollContainer


func _on_RightButton_pressed():
	scroll_vertical += rect_size.y as int


func _on_LeftButton_pressed():
	scroll_vertical -= rect_size.y as int
