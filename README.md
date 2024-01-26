Original README:

> Inscryption Multiplayer [Godot]
>
> A LAN Multiplayer fangame replicating the gameplay of Inscryption's act 2 made in the godot engine.
>
> Available at https://107zxz.itch.io/inscryption-multiplayer-godot
>
> Source code is available under the GPL license for anyone to use.
>
> Source was formerly available under MIT license, but this led to forks being distributed over discord as executables without visible source code, and I really don't want this project to be yet another discord virus factory. I also want this game's code to be a resource for people who want to make their own fangames (even though it is super spaghetti).

# Inscryption Online Multiplayer Plus (IMF+)

[![Plus Latest][plus-badge]][plus-link]
[![Pres Latest][pres-badge]][pres-link]

**IMF+** is a fork of the original IMF that include some QoL feature. The fork is compatible with IMF, this mean every feature is client side and you should be able to connect to a vanilla client with no problem, if there is a problem please report it.

> [!NOTE]
> IMF+ have 2 type of release [`Pres`][pres-link] and [`Plus`][plus-link].
>
> -   [`Plus`][plus-link] is the release and staple version of IMF+, have fewer bug and update less often.
> -   [`Pres`][pres-link] is the pre-release version of IMF+ with unstable features that may mess with your config and bugs are expected.
>
> IMF+ release follow the version number like so: `Main.Major.Minor`. A new `Main` version usually happen everytime the IMF or vanilla client update, `Major` is every `Plus` release and `Minor` is every `Pres` release. Versions also may include a letter to indicate a hotfix for major bug that slip by.

> [!IMPORTANT]
> List here is sync with the latest [`Pres`][pres-link] version. [`Plus`][plus-link] version may not have these feature yet. Feature mark with a :test_tube: are [`Pres`][pres-link] feature. Check out latest [`Pres`][pres-link] to have access to all these features.

## Feature

List of noteable feature scroll down to [Option](#option) the view the full list of option.

> [!NOTE]
> To learn more about the feature follow their header link or scroll down to [Option](#option)

-   Default Room name, Username, Profile Picture, Deck
-   Auto Rematch, Ready, Draw
-   Quick Card and Slot Select
-   Enable and Disable any menu button
-   [Multiple theme support](#theme-and-music)
-   [Music](#theme-and-music)
-   [Keybind](#keybind)
-   ~~New and improve Deck List~~ Merged with `IMF` pending update

## Option

> [!WARNING]
> Most of these option require the game to restart before working
> If you are un sure restart the game after making some changes to your option

-   **Auto Draw:** Automatically draw card when 1 deck is left.
-   **Auto Ready:** Automatically press `Ready` when joining lobby.
-   **Auto Rematch:** Automatically press `Rematch` when game end.
-   **Card Quick Select:** Select Card in hand using the number key (`0`, `1`, `2`, etc.) to play card.
-   **Slot Quick Select:** Select Slot using `h`, `j`, `k`, `l` to play and activate card.
-   **Default Deck:** Automatically select default Deck.
-   **Default Profile Picture:** Automatically select default Profile Picture.
-   **Default Room name:** Automatically fill in default Room Name.
-   **Default Username:** Automatically fill in default Username.
-   **Hide Deck Editor:** Hide the `Deck Editor` button on the title screen.
-   **Hide Discord:** Hide the `Discord` button on the title screen.
-   **Hide Open Directory:** Hide the `Open Directory` button on the title screen.
-   **Hide Ruleset:** Hide the `Ruleset` button on the title screen.
-   **End Turn Confirmation:** Ask for confirmation when ending turn.
-   **Surrender Confirmation:** Ask for confirmation when surrendering.
-   **Improve Deck Search**: Improve deck search UI using Deck List.
-   **Deck List**: A Deck list to view what left in the deck.
-   **Deck List Pic Scale**: Scale of the portrait preview in Deck List.
-   **Deck List Icon Scale**: Scale of the accessibility icon in Deck List.
-   **Deck List Preview Scale**: Scale of the card preview in Deck List.
-   **Deck List Portrait Color**: Change the portrait color in Deck List to match card color.
-   **Deck List Name Align**: Change where the card name align in Deck List.

## Theme and Music

Here is an example of what it should look like:

```
...Godot/user_appdata/Inscry_Mult_GD/
└── plus/
    ├── theme/
    │   ├── theme.json <- this is your theme file
    │   └── another_theme.json
    └── music/
        ├── song.wav <- song wav file
        └── rick_roll.mp3 <- mp3 file are also supported
```

### Adding theme:

To add theme option to the theme selector. Make a `plus/theme` folder in your Game Directory (Access using the `Game Directory` button) and drop your `theme.json` into that folder. Here what it should look like:

```
...Godot/user_appdata/Inscry_Mult_GD/
└── plus/
    └── theme/
        ├── theme.json <- this is your theme.json file
        └── another_theme.json <- another theme.json with a different name
```

### Adding music:

To add music option to the music selector. Make a `plus/music` folder in your Game Directory (Access using the `Game Directory` button) and drop your `music.wav` or `music.mp3` into that folder. Here what it should look like:

```
...Godot/user_appdata/Inscry_Mult_GD/
└── plus/
    └── music/
        ├── song.wav <- song wav file
        └── another_song.mp3 <- song mp3 file
```

## Keybind

This is a list of keybind that Plus currently have:

-   **Draw Main Deck**: Draw from your main deck if possible
-   **Draw Side Deck**: Draw from your side deck if possible
-   **End Turn**: End your turn if possible
-   **Toggle Hammer**: Toggle the hammer if possible
-   **Quick Host**: Quickly host a room using the default info
-   **Quick Test**: Quicky test a deck using the default info.
-   **Open Deck Editor**: Open the Deck Editor using the menu button
-   **Open Game Directory**: Open the Game Directory using the menu button
-   **Open Host Menu**: Open the Host menu using the menu button
-   **Open Join Menu**: Open the Join menu using the menu button
-   **Open Option**: Open the Option menu using the menu button
-   **Open Ruleset Selector**: Open the Ruleset Selector using the menu button

## Todo

-   Deck profile
-   Format version warning
-   Format version chooser

[plus-badge]: https://flat.badgen.net/github/release/Mouthless-Stoat/inscr-onln-plus/stable?label=Latest%20Plus
[plus-link]: https://github.com/Mouthless-Stoat/inscr-onln-plus/releases/latest
[pres-badge]: https://flat.badgen.net/github/release/Mouthless-Stoat/inscr-onln-plus?label=Latest%20Pres
[pres-link]: https://github.com/Mouthless-Stoat/inscr-onln-plus/releases/tag/1.1.6
