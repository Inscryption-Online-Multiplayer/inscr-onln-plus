extends CheckButton

func updateOption():
	GameOptions.options.plus[name] = not pressed

func setName(n):
	name = n
	pressed = not GameOptions.options.plus[name]
	text = GameOptions.optionName[name][0]
	hint_tooltip = GameOptions.optionName[name][1]
