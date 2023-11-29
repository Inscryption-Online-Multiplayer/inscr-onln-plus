extends Button

func collapse():
	for sibling in get_parent().get_children():
		if sibling == self: continue
		sibling.visible = not sibling.visible
