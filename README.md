# Roblox Spotify Overlay

A Spotify overlay for Roblox made using Lanyard API. For this to function, you **must** join the [lanyard discord server](https://discord.gg/lanyard).

## Usage

To start using it, use the CreateOverlay function on the library. Here's an example with the default config:
```lua
local SpotifyOverlay = loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))();

local Overlay: Overlay = SpotifyOverlay:CreateOverlay({
    DiscordID: string = "0";
    Mode: string = "HttpGet";
    UIConfig: ThemeConfig = {
        BorderColor: Color3 = Color3.fromRGB(0, 0, 0);
		BorderThickness: number = 2;
		BorderTransparency: number = 0;
		BackgroundColor: Color3 = Color3.fromRGB(0, 0, 0);
		BackgroundTransparency: number = 0.5;
		SongNameColor: Color3 = Color3.fromRGB(255, 255, 255);
		SongNameFont: Font = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		ArtistNameColor: Color3 = Color3.fromRGB(255, 255, 255);
		ArtistNameFont: Font = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		BarBackgroundColor: Color3 = Color3.fromRGB(128, 128, 128);
		BarColor: Color3 = Color3.fromRGB(192, 192, 192);
    };
});
```
## Configuration

Here is an example of an configuration:
```lua
local SpotifyOverlay = loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))();

local Overlay = SpotifyOverlay:CreateOverlay({
    DiscordID = "757494097375264830" --> This HAS to be in a string. Turning this into integer or number will cause it to break.
    Mode = "HttpGet"; --> "HttpGet", "Websocket" (Remember that Websocket might and will cause issues, also it's not supported by some executors.
    UIConfig = {
        BorderColor = Color3.fromRGB(91, 0, 91), --> Makes the borders purplish.
        BorderThickness = 3, --> Makes the border more thick.
        BorderTransparency = 0.5, --> Makes the border half transparent.
        BackgroundColor = Color3.fromRGB(4, 0, 45), --> Makes the background dark blue.
        BackgroundTransparency = 0, --> Removes the transparency from the background.
        SongNameColor = Color3.fromRGB(0, 255, 0), --> Makes the song name text green.
        SongNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        ArtistNameColor = Color3.fromRGB(129, 0, 0), --> Makes the artist name text dark red.
        ArtistNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        BarBackgroundColor = Color3.fromRGB(31, 31, 31), --> Makes the bar background dark gray.
        BarColor = Color3.fromRGB(255, 255, 255) --> Makes the bar white.
    } 
});
```
If you want to change the DiscordID on the overlay, you can do:
```lua
Overlay:SetDiscordID("4984256246513");
```
If you want to change the mode on the overlay, you can do:
```lua
Overlay:SetMode("HttpGet");
```
If you want to change the Theme on the overlay, you can do:
```lua
Overlay:SetTheme({
    BorderColor = Color3.fromRGB(91, 0, 91), --> Makes the borders purplish.
    BorderThickness = 3, --> Makes the border more thick.
    BorderTransparency = 0.5, --> Makes the border half transparent.
    BackgroundColor = Color3.fromRGB(4, 0, 45), --> Makes the background dark blue.
    BackgroundTransparency = 0, --> Removes the transparency from the background.
    SongNameColor = Color3.fromRGB(0, 255, 0), --> Makes the song name text green.
    SongNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    ArtistNameColor = Color3.fromRGB(129, 0, 0), --> Makes the artist name text dark red.
    ArtistNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    BarBackgroundColor = Color3.fromRGB(31, 31, 31), --> Makes the bar background dark gray.
    BarColor = Color3.fromRGB(255, 255, 255) --> Makes the bar white.
});
```
If you want to delete an overlay, you can do:
```lua
Overlay:Destroy();
```
You can also change the default theming by changing the `DefaultTheme` in the module.
```lua
local SpotifyOverlay = loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))();

SpotifyOverlay.DefaultConfig = {
    BorderColor = Color3.fromRGB(91, 0, 91), --> Makes the borders purplish.
    BorderThickness = 3, --> Makes the border more thick.
    BorderTransparency = 0.5, --> Makes the border half transparent.
    BackgroundColor = Color3.fromRGB(4, 0, 45), --> Makes the background dark blue.
    BackgroundTransparency = 0, --> Removes the transparency from the background.
    SongNameColor = Color3.fromRGB(0, 255, 0), --> Makes the song name text green.
    SongNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    ArtistNameColor = Color3.fromRGB(129, 0, 0), --> Makes the artist name text dark red.
    ArtistNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    BarBackgroundColor = Color3.fromRGB(31, 31, 31), --> Makes the bar background dark gray.
    BarColor = Color3.fromRGB(255, 255, 255) --> Makes the bar white.
}
```

## Unloading
To unload the script completely, just run the following code:
```lua
SpotifyOverlay:Exit();
```

## An Example That Uses Most Of The Functions:
```lua
local SpotifyOverlay = loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))();

local Overlay = SpotifyOverlay:CreateOverlay({ DiscordID = "757494097375264830", Mode = "HttpGet" });

task.wait(3);

Overlay:SetTheme({
    BorderColor = Color3.fromRGB(91, 0, 91), --> Makes the borders purplish.
    BorderThickness = 3, --> Makes the border more thick.
    BorderTransparency = 0.5, --> Makes the border half transparent.
    BackgroundColor = Color3.fromRGB(4, 0, 45), --> Makes the background dark blue.
    BackgroundTransparency = 0, --> Removes the transparency from the background.
    SongNameColor = Color3.fromRGB(0, 255, 0), --> Makes the song name text green.
    SongNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    ArtistNameColor = Color3.fromRGB(129, 0, 0), --> Makes the artist name text dark red.
    ArtistNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    BarBackgroundColor = Color3.fromRGB(31, 31, 31), --> Makes the bar background dark gray.
    BarColor = Color3.fromRGB(255, 255, 255) --> Makes the bar white.
});

task.wait(2);

Overlay:SetTheme(SpotifyOverlay.DefaultTheme);

task.wait(3);

Overlay:Destroy();

task.wait(5);

SpotifyOverlay:Exit();
```

###### Im bad at making documentations.
