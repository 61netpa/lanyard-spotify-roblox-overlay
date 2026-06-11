# Roblox Spotify Overlay

A Spotify overlay for Roblox made using Lanyard API. For this to function, you **must** join the [lanyard discord server](https://discord.gg/lanyard).

## Loading

```lua
local SpotifyOverlay = loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))();

local Overlay = SpotifyOverlay:CreateOverlay({
    DiscordID = "0";
    Mode = "HttpGet";
});
```
## CreateOverlay Configuration

`SpotifyOverlay:CreateOverlay(config)` accepts a table with the following fields:
 
| Field | Type | Default | Description |
|---|---|---|---|
| `DiscordID` | `string` | `"0"` | Your Discord user ID |
| `Mode` | `string` | `"HttpGet"` | Decides how you get the data |
| `UIConfig` | `ThemeConfig` ( { [string]: any } ) | Default theme | Optional theme table (see below) |

### Modes

**`HttpGet`**: Sends a request to the lanyard API every second. Supported by most executors.

**`Websocket`**: Connects to the lanyard API websocket. This is a bit buggy and not supported by some executors.

## Theme Configuration
All of the theme values are optional. The ones you leave will be set to the default value.

| Field | Type | Default | Description |
|---|---|---|---|
| `BorderColor` | `Color3` | `RGB(0, 0, 0)` | Outline color |
| `BorderThickness` | `number` | `2` | Outline thickness in pixels |
| `BorderTransparency` | `number` | `0` | Outline transparency (0 = opaque, 1 = invisible) |
| `BackgroundColor` | `Color3` | `RGB(0, 0, 0)` | Background fill color |
| `BackgroundTransparency` | `number` | `0.5` | Background transparency |
| `SongNameColor` | `Color3` | `RGB(255, 255, 255)` | Song name text color |
| `SongNameFont` | `Font` | Arial Bold | Song name font |
| `ArtistNameColor` | `Color3` | `RGB(255, 255, 255)` | Artist name text color |
| `ArtistNameFont` | `Font` | Arial Regular | Artist name font |
| `BarBackgroundColor` | `Color3` | `RGB(128, 128, 128)` | Progress bar track color |
| `BarColor` | `Color3` | `RGB(192, 192, 192)` | Progress bar fill color |

### Example with a full theme
```lua
local SpotifyOverlay = loadstring(game:HttpGet("https://raw.githubusercontent.com/61netpa/lanyard-spotify-roblox-overlay/refs/heads/main/main.lua"))();

local Overlay = SpotifyOverlay:CreateOverlay({
	DiscordID = "757494097375264830",
	Mode = "HttpGet",
	UIConfig = {;
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
	},
});
```
## Overlay Methods
These are the methods that can be called with the object returned by the `CreateOverlay` function.

### `Overlay:SetDiscordID(ID: string): ()`
Changes the discord ID on the overlay.
```lua
Overlay:SetDiscordID("643945264868098049");
```

### `Overlay:SetMode(Mode: string): ()`
Changes how the overlay gets the data from the API. Can be only set to `"HttpGet"` and `"Websocket"`, however Websocket might and most likely will cause issues.
```lua
Overlay:SetMode("HttpGet");
```

### `Overlay:SetTheme(ThemeTable: ThemeConfig): ()`
Replaces the current theme on the overlay. The ones you leave will be set to the default value.
```lua
Overlay:SetTheme({
	BarColor = Color3.fromRGB(123, 215, 255),
	BorderColor = Color3.fromRGB(255, 255, 255),
	BorderThickness = 1,
});
```

### `Overlay:ForceUpdateTheme(): ()`
Forcefully updates the theme on the overlay.
```lua
Overlay.UIConfig.BarColor = Color3.fromRGB(255, 0, 0);
Overlay:ForceUpdateTheme();
```

### `Overlay:Destroy(): ()`
Closes the API connection and deletes the overlay.
```lua
Overlay:Destroy();
```

## Unloading
To unload the script completely, just run `Exit` on the overlay library.
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

###### Ballin'.
