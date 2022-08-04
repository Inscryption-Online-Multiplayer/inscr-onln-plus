# Inscryption Multiplayer [Godot]

## From the original project

A LAN Multiplayer fangame replicating the gameplay of Inscryption's act 2 made in the godot engine by 107zxz.

Available at https://107zxz.itch.io/inscryption-multiplayer-godot

Source code is available under MIT license for anyone to use

This project is just a fork of the original one with a few customization feature and prob some quality of life one. This fork doesn't change any game play feature just aesthetic. Everything is client side meaning only you can see these changes and you can use this fork to play with normal version of the game

# Feature:

<!-- no toc -->

- [How to change card portrait](#how-to-change-card-portrait)
- [How to change sigil texture](#how-to-change-sigil-texture)
- [How to add Custom music](#how-to-add-custom-music)

### How to change card portrait

Just click on the "Open Game Directory" button and it should bring up the game folder. Now you just need to make a folder a call asset then texture inside, and inside another one call pixport. And inside that pixport folder is where you gonna put all the card texture. Card texture is 41x28 pixels, and it support color. The card portrait file name will need to match whatever texture it supplying for. For example if I want to make a texture for 49er then I will make a file name 49er.png in the pixport folder (texture/pixport/49er, everything is case sensitive). If no file supply then it gonna use the default art

### How to change sigil texture

It should be the same as changing portrait, the only diffent is it in the folder sigils instead of potrait. Sigil texture is 16x16, and it support color. So if I want to change the Airborne sigil then I put the texture in asset/texture/sigils with the name Airborne.png (everything is case sensitive). If no file supply then it gonna use the default art.

### How to add Custom music

Same as portrait and sigils. You open the game file create a folder name asset if you haven't. Create a folder name sound in it and another music inside of sound. Then you will put you music file there, the file name will be the option name in the game. It support both .wave and .mp3 (haven't test .mp3 but i should work. .ogg is weird godot don;t seem to be able to load it)

#### TODO

- Asset pack
- put all the cosmetic button/setting in to one button 
- Custom pfp
- Multiple Theme select
- Remember name and quick host
- Ability to load gif for texture (load gif for card portrait and sigil texture)
- ~~Add in a rick roll~~
