# Roblox Spotify Overlay

A Spotify overlay for Roblox made using Lanyard API. For this to function, you **must** join the [lanyard discord server](https://discord.gg/lanyard).

## Configuration

The default configuration is always:
```lua
getgenv().SpotifyOverlay = {
    Enabled = true,
    DiscordID = 0,
    UI = {
        BorderColor = Color3.fromRGB(0, 0, 0),
        BorderThickness = 2,
        BorderTransparency = 0,
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        SongNameColor = Color3.fromRGB(255, 255, 255),
        SongNameFont = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        ArtistNameColor = Color3.fromRGB(255, 255, 255),
        ArtistNameFont = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BarBackgroundColor = Color3.fromRGB(128, 128, 128),
        BarColor = Color3.fromRGB(192, 192, 192)
    },
}
```
Here is an example of an configuration:
```lua
getgenv().SpotifyOverlay = {
    Enabled = true,
    DiscordID = 757494097375264830, --> You HAVE to put your Discord ID in this variable.
    UI = {
        BorderColor = Color3.fromRGB(91, 0, 91), --> Makes the borders purplish.
        BorderThickness = 3, --> Makes the border more thick.
        BorderTransparency = 0.5, --> Makes the border half transparent.
        BackgroundColor = Color3.fromRGB(4, 0, 45), --> Makes the background dark blue.
        BackgroundTransparency = 0, --> Removes the transparency from the background.
        SongNameColor = Color3.fromRGB(0, 255, 0), --> Makes the song name text green.
        SongNameFont = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        ArtistNameColor = Color3.fromRGB(129, 0, 0), --> Makes the artist name text dark red.
        ArtistNameFont = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BarBackgroundColor = Color3.fromRGB(31, 31, 31), --> Makes the bar background dark gray.
        BarColor = Color3.fromRGB(255, 255, 255) --> Makes the bar white.
    },
}
```
If you want to change a single variable after the script is loaded, you can run something like these examples:
```lua
getgenv().SpotifyOverlay.DiscordID = 643945264868098049
```
```lua
getgenv().SpotifyOverlay.UI.BarColor = Color3.fromRGB(123, 215, 255)
```
## Loading the script
To execute the script, you have to run something like this example:
```lua
getgenv().SpotifyOverlay = {
    Enabled = true,
    DiscordID = 643945264868098049,
    UI = {
        BorderColor = Color3.fromRGB(0, 0, 0),
        BorderThickness = 2,
        BorderTransparency = 0,
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        SongNameColor = Color3.fromRGB(255, 255, 255),
        SongNameFont = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        ArtistNameColor = Color3.fromRGB(255, 255, 255),
        ArtistNameFont = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BarBackgroundColor = Color3.fromRGB(128, 128, 128),
        BarColor = Color3.fromRGB(192, 192, 192)
    },
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))()
```
⚠ You **MUST** keep the UI table in the configuration while executing it, otherwise it will cause an error and break the script. This means you can **NOT** do something like this:
```lua
getgenv().SpotifyOverlay = {
    Enabled = true,
    DiscordID = 643945264868098049
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))()
```
## Unloading
To unload the script completely, just run this code:
```lua
getgenv().SpotifyOverlay:End()
```
