extends Node

func hover():
	$"../../../../../Card".draw_from_data(CardInfo.from_name(name))

func _ready():
	connect("mouse_entered", self, "hover")
