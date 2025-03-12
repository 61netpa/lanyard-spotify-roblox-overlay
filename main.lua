if getgenv().SpotifyOverlayRunning then
    return
end

getgenv().SpotifyOverlayRunning = true

local Config = getgenv().SpotifyOverlay
local UIConfig = Config.UI
local Connections = Config.Connections
local GetHiddenUI = get_hidden_gui or gethui

local DragToggle = nil
local DragStart = nil
local StartPos = nil

local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local OverlayGui = Instance.new("ScreenGui")
if GetHiddenUI then
    OverlayGui.Parent = GetHiddenUI
else
    OverlayGui.Parent = CoreGui
end
OverlayGui.Enabled = true
OverlayGui.ResetOnSpawn = false
OverlayGui.IgnoreGuiInset = false

local Background = Instance.new("Frame")
Background.Parent = OverlayGui
Background.Visible = true
Background.Active = true
Background.BorderSizePixel = 0
Background.BackgroundTransparency = UIConfig.BackgroundTransparency
Background.BackgroundColor3 = UIConfig.BackgroundColor
Background.Size = UDim2.fromScale(0.209, 0.093)
Background.Position = UDim2.fromScale(0.006, 0.011)

local BackgroundCorner = Instance.new("UICorner")
BackgroundCorner.Parent = Background
BackgroundCorner.CornerRadius = UDim.new(0, 8)

local BackgroundBorder = Instance.new("UIStroke")
BackgroundBorder.Parent = Background
BackgroundBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BackgroundBorder.Thickness = UIConfig.BorderThickness

local SongImage = Instance.new("ImageLabel")
SongImage.Parent = Background
SongImage.Position = UDim2.new(0.0175, 0, 0.05, 0)
SongImage.Size = UDim2.new(0.225, 0, 0.9, 0)
SongImage.BackgroundTransparency = 1
SongImage.BorderSizePixel = 0
SongImage.Image = ""

local ImageCorner = Instance.new("UICorner")
ImageCorner.Parent = SongImage
ImageCorner.CornerRadius = UDim.new(0, 8)

local SongName = Instance.new("TextLabel")
SongName.Parent = Background
SongName.BackgroundTransparency = 1
SongName.ClipsDescendants = true
SongName.BorderSizePixel = 0
SongName.Text = "SongName"
SongName.Size = UDim2.new(0.715, 0, 0.32, 0)
SongName.Position = UDim2.new(0.26, 0, 0.12, 0)
SongName.TextSize = 25
SongName.TextColor3 = UIConfig.SongNameColor
SongName.FontFace = UIConfig.SongNameFont

local SongNameTextScaler = Instance.new("UITextSizeConstraint")
SongNameTextScaler.Parent = SongName
SongNameTextScaler.MaxTextSize = 25

local ArtistName = Instance.new("TextLabel")
ArtistName.Parent = Background
ArtistName.BackgroundTransparency = 1
ArtistName.ClipsDescendants = true
ArtistName.BorderSizePixel = 0
ArtistName.Text = "SongName"
ArtistName.Size = UDim2.new(0.715, 0, 0.32, 0)
ArtistName.Position = UDim2.new(0.26, 0, 0.35, 0)
ArtistName.TextSize = 18
ArtistName.TextColor3 = UIConfig.ArtistNameColor
ArtistName.FontFace = UIConfig.ArtistName

local ArtistNameTextScaler = Instance.new("UITextSizeConstraint")
ArtistNameTextScaler.Parent = ArtistName
ArtistNameTextScaler.MaxTextSize = 18

local BarBackground = Instance.new("CanvasGroup")
BarBackground.Parent = Background
BarBackground.BorderSizePixel = 0
BarBackground.BackgroundColor3 = UIConfig.BarBackgroundColor
BarBackground.Size = UDim2.new(0.715, 0, 0.15, 0)
BarBackground.Position = UDim2.new(0.26, 0, 0.73, 0)

local BarBackgroundCorner = Instance.new("UICorner")
BarBackgroundCorner.Parent = BarBackground
BarBackgroundCorner.CornerRadius = UDim.new(0, 8)

local Bar = Instance.new("Frame")
Bar.Parent = BarBackground
Bar.BorderSizePixel = 0
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.Position = UDim2.new(0, 0, 0, 0)
Bar.BackgroundColor3 = BarColor

local BarCorner = Instance.new("UICorner")
BarCorner.Parent = Bar
BarCorner.CornerRadius = UDim.new(0, 8)

function Config:End()
    for _, v in next, Connections do
        v:Disconnect()
        v = nil
    end
    getgenv().SpotifyOverlayRunning = false
    OverlayGui:Destroy()
    getgenv().SpotifyOverlay = nil
end

function UpdateInput(Input)
    local Delta = Input.Position - DragStart
    local Pos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    TweenService:Create(Background, TweenInfo.new(0.1), { Position = Pos }):Play()
end

Connections.InputBegan = Background.InputBegan:Connect(function(Input)
    if Input.UserInputType == (Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) then
        DragToggle = true
        DragStart = Input.Position
        StartPos = Background.Position
        Connections.Changed = Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                DragToggle = false
            end
        end)
    end
end)

Connections.InputChanged = UserInputService.InputChanged:Connect(function(Input)
    if Input.UserInputType == (Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
        if DragToggle then
            UpdateInput(Input)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if getgenv().SpotifyOverlayRunning and getgenv().SpotifyOverlay then
            local success, data = pcall(function()
                local get = game:HttpGet("https://api.lanyard.rest/v1/users/"..Config.DiscordID)
                return HttpService:JSONDecode(get)
            end)
            if type(data) == "table" and data.success and data.data and data.data.listening_to_spotify and data.data.spotify then
                local SpotifyResult = data.data.spotify
                SongName.Text = SpotifyResult.song
                ArtistName.Text = SpotifyResult.artist
                if writefile and getcustomasset then
                    local ImageURL = game:HttpGet(SpotifyResult.album_art_url)
                    local Image = writefile("SpotifyOverlay", ImageURL)
                    local ImageAsset = getcustomasset("SpotifyOverlay")
                    task.spawn(function()
                        task.wait(1)
                        SongImage.Image = ImageAsset
                    end)
                else
                    SongImage.Image = "rbxassetid://78980954752956"
                end
                local timestamps = {
                    start = v["start"],
                    ["end"] = v["end"]
                }
                local total = timestamps["end"] - timestamps.start
                local progress = (DateTime.now().UnixTimestampMillis - timestamps.start) / total
                local result = math.clamp(progress, 0, 1)
                TweenService:Create(CompletedProgressBar, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { Size = UDim2.new(result, 0, 1, 0) }):Play()
            elseif data.data and not data.data.listening_to_spotify and not data.data.spotify then
                print("User is not listening to Spotify or Spotify activity is not visible on the profile")
            else
                print("API returned: ".. data)
            end
        else
            break
        end
    end
end)
