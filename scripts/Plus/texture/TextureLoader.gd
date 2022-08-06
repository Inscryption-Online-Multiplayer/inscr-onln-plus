extends Node

class_name TextureLoader

func load_texture(userPath, gamePath):
	var path = userPath
	var tex = ImageTexture.new()
	if not File.new().file_exists(path):
		tex = load(gamePath)
		#print("loaded User path")
	else:
		var img = Image.new()
		img.load(path)
		tex.create_from_image(img,0)
		#print("loaded Game path")
		
	return tex
