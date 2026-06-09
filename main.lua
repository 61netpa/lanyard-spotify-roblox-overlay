-- Environment

local getgenv = getgenv or function() return _G; end
local Websocket = getgenv().websocket or (getgenv().syn and getgenv().syn.websocket) or getgenv().Websocket or getgenv().WebSocket or function() end
local GetHiddenUI = getgenv().get_hidden_gui or getgenv().gethui;
local CloneReference = getgenv().cloneref or function(Instance: Instance) return Instance; end

-- Services

local GetService = game.GetService;

local UserInputService = CloneReference(GetService(game, "UserInputService"));
local TweenService = CloneReference(GetService(game, "TweenService"));
local HttpService = CloneReference(GetService(game, "HttpService"));
local Players = CloneReference(GetService(game, "Players"));
local CoreGui = CloneReference(GetService(game, "CoreGui"));

-- Variables

local SpotifyOverlay = {
	Enabled = true;
	DefaultTheme = {
		BorderColor = Color3.fromRGB(0, 0, 0);
		BorderThickness = 2;
		BorderTransparency = 0;
		BackgroundColor = Color3.fromRGB(0, 0, 0);
		BackgroundTransparency = 0.5;
		SongNameColor = Color3.fromRGB(255, 255, 255);
		SongNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		ArtistNameColor = Color3.fromRGB(255, 255, 255);
		ArtistNameFont = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		BarBackgroundColor = Color3.fromRGB(128, 128, 128);
		BarColor = Color3.fromRGB(192, 192, 192);
	};
	Functions = {};
};
local Functions = SpotifyOverlay.Functions;
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.FindFirstChildOfClass(LocalPlayer, "PlayerGui");
local Mouse = LocalPlayer.GetMouse(LocalPlayer);

local GUI = Instance.new("ScreenGui");
GUI.Name = "SpotifyOverlay";
GUI.IgnoreGuiInset = false;
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GUI.Parent = GetHiddenUI() or CoreGui or PlayerGui;
GUI.ResetOnSpawn = false;

-- Types

type ThemeConfig = {
	BorderColor: Color3?;
	BorderThickness: number?;
	BorderTransparency: number?;
	BackgroundColor: Color3?;
	BackgroundTransparency: number?;
	SongNameColor: Color3?;
	SongNameFont: Font?;
	ArtistNameColor: Color3?;
	ArtistNameFont: Font?;
	BarBackgroundColor: Color3?;
	BarColor: Color3?;
};

type OverlayConfig = {
	DiscordID: string?;
	Mode: string?;
	UIConfig: ThemeConfig?;
};

type Overlay = {
    DiscordID: string;
    Mode: string;
    UIConfig: ThemeConfig;
    SetDiscordID: (self: Overlay, Value: string) -> ();
    SetMode: (self: Overlay, Value: string) -> ();
    SetTheme: (self: Overlay, Value: ThemeConfig) -> ();
    ForceUpdateTheme: (self: Overlay) -> ();
    Destroy: (self: Overlay) -> ();
};

-- Functions

function Functions:Draggable(Instance: Instance): ()
	Instance.Active = true;
	local MoveConnection = nil;
	local EndConnection = nil;
	Instance.InputBegan.Connect(Instance.InputBegan, function(Input: InputObject)
		if (Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch) then return; end
		local ObjectPosition = Vector2.new(Mouse.X - Instance.AbsolutePosition.X, Mouse.Y - Instance.AbsolutePosition.Y);
		if (MoveConnection ~= nil) then MoveConnection:Disconnect(); MoveConnection = nil; end
		if (EndConnection ~= nil) then EndConnection:Disconnect(); EndConnection = nil; end
		MoveConnection = UserInputService.InputChanged.Connect(UserInputService.InputChanged, function(Input: InputObject)
			if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				Instance.Position = UDim2.fromOffset(Mouse.X - ObjectPosition.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X), Mouse.Y - ObjectPosition.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y));
			end
		end)
		EndConnection = UserInputService.InputEnded.Connect(UserInputService.InputEnded, function(Input: InputObject)
			if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
				if (MoveConnection ~= nil) then MoveConnection:Disconnect(); MoveConnection = nil; end
				if (EndConnection ~= nil) then EndConnection:Disconnect(); EndConnection = nil; end
			end
		end)
	end)
end

function Functions:CreateInstance(ClassName: string, PropertyTable: { [string]: any }): string | Instance
	local NewInstance = ClassName;
	if (type(ClassName) == "string") then
		NewInstance = Instance.new(ClassName);
	end
	for Index, Value in pairs(PropertyTable) do
		NewInstance[Index] = Value;
	end
	return NewInstance;
end

function SpotifyOverlay:Exit(): ()
	GUI.Destroy(GUI);
	SpotifyOverlay = nil;
end

function SpotifyOverlay:CreateOverlay(ConfigTable: OverlayConfig): Overlay
	ConfigTable = ConfigTable or {};
	local Overlay: Overlay = {
		DiscordID = ConfigTable.DiscordID or "0";
		Mode = ConfigTable.Mode or "HttpGet";
		UIConfig = ConfigTable.UIConfig or SpotifyOverlay.DefaultTheme;
	} :: any;
	for Index, Value in SpotifyOverlay.DefaultTheme do
		if (Overlay.UIConfig[Index] == nil) then
			Overlay.UIConfig[Index] = Value;
		end
	end
	local AlbumURL = "";
	local GetConnection = nil;
	local OverlayHolder = Functions:CreateInstance("Frame", {
		Name = "Holder";
		Position = UDim2.fromOffset(16, 6);
		Size = UDim2.fromOffset(350, 90);
		BackgroundColor3 = Overlay.UIConfig.BackgroundColor;
		BackgroundTransparency = Overlay.UIConfig.BackgroundTransparency;
		BorderSizePixel = 0;
		Parent = GUI; 
	});
	Functions:Draggable(OverlayHolder);
	Functions:CreateInstance("UIPadding", {
		PaddingLeft = UDim.new(0, 5);
		PaddingBottom = UDim.new(0, 5);
		PaddingTop = UDim.new(0, 5);
		PaddingRight = UDim.new(0, 5);
		Parent = OverlayHolder;
	});
	Functions:CreateInstance("UICorner", {
		CornerRadius = UDim.new(0, 8);
		Parent = OverlayHolder;
	});
	local BackgroundBorder = Functions:CreateInstance("UIStroke", {
		Color = Overlay.UIConfig.BorderColor;
		Thickness = Overlay.UIConfig.BorderThickness;
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		Parent = OverlayHolder;
	});
	local SongImage = Functions:CreateInstance("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5);
		Position = UDim2.fromScale(0, 0.5);
		Size = UDim2.fromScale(1, 1);
		BackgroundTransparency = 1;
		Image = "";
		Parent = OverlayHolder;
	});
	Functions:CreateInstance("UIAspectRatioConstraint", {
		DominantAxis = Enum.DominantAxis.Height;
		Parent = SongImage;
	})
	Functions:CreateInstance("UICorner", {
		CornerRadius = UDim.new(0, 8);
		Parent = SongImage;
	});
	local InfoHolder = Functions:CreateInstance("Frame", {
		Name = "Info";
		AnchorPoint = Vector2.new(1, 0.5);
		Position = UDim2.fromScale(1, 0.5);
		Size = UDim2.new(0, 245, 1, 0);
		BackgroundTransparency = 1;
		Parent = OverlayHolder;
	});
	Functions:CreateInstance("UIListLayout", {
		Padding = UDim.new(0, 5);
		FillDirection = Enum.FillDirection.Vertical;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = InfoHolder;
	});
	local SongNameText = Functions:CreateInstance("TextLabel", {
		Name = "SongName";
		Size = UDim2.new(1, 0, 0, 25);
		BackgroundTransparency = 1;
		FontFace = Overlay.UIConfig.SongNameFont;
		Text = "SongName";
		TextColor3 = Overlay.UIConfig.SongNameColor;
		TextSize = 25;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextYAlignment = Enum.TextYAlignment.Center;
		Parent = InfoHolder;
	});
	local SongArtistText = Functions:CreateInstance("TextLabel", {
		Name = "ArtistName";
		Size = UDim2.new(1, 0, 0, 25);
		BackgroundTransparency = 1;
		FontFace = Overlay.UIConfig.ArtistNameFont;
		Text = "ArtistName";
		TextColor3 = Overlay.UIConfig.ArtistNameColor;
		TextSize = 25;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextYAlignment = Enum.TextYAlignment.Center;
		Parent = InfoHolder;
	});
	local BarFrame = Functions:CreateInstance("Frame", {
		Name = "ProgressBar";
		Size = UDim2.new(1, 0, 0, 20);
		BackgroundColor3 = Overlay.UIConfig.BarBackgroundColor;
		BorderSizePixel = 0;
        ClipsDescendants = true;
		Parent = InfoHolder;
	});
	Functions:CreateInstance("UICorner", {
		CornerRadius = UDim.new(1, 0);
		Parent = BarFrame;
	});
	local Bar = Functions:CreateInstance("Frame", {
		Name = "Bar";
		Size = UDim2.fromScale(0, 1);
		BackgroundColor3 = Overlay.UIConfig.BarColor;
		BorderSizePixel = 0;
		Parent = BarFrame;
	});
	Functions:CreateInstance("UICorner", {
		CornerRadius = UDim.new(1, 0);
		Parent = Bar;
	});
	local function UpdateOverlay(Data: { [string]: any }): ()
		SongNameText.Text = Data.song;
		SongArtistText.Text = Data.artist;
        local Success = pcall(function() -- Some executors doesn't support getcustomasset even though they have the function which breaks this completely.
		    if (getgenv().writefile and getgenv().getcustomasset and Data.album_art_url ~= AlbumURL) then
		    	AlbumURL = Data.album_art_url;
		    	local ImageData = game:HttpGet(Data.album_art_url);
		    	local ImageFile = getgenv().writefile("SpotifyOverlay.png", ImageData);
		    	local Image = getgenv().getcustomasset("SpotifyOverlay.png");
		    	task.delay(1, function()
		    		SongImage.Image = Image;
		    	end)
		    end
        end)
        if (not Success) then
            SongImage.Image = "";
        end
		local Timestamps = { Beginning = Data.timestamps["start"]; Ending = Data.timestamps["end"]; };
		local Total = Timestamps.Ending - Timestamps.Beginning;
		local Progress = (DateTime.now().UnixTimestampMillis - Timestamps.Beginning) / Total;
		local CalculatedValue = math.clamp(Progress, 0, 1);
		local Tween = TweenService.Create(TweenService, Bar, TweenInfo.new(0.5), { Size = UDim2.fromScale(CalculatedValue, 1) });
		Tween.Play(Tween);
	end
	local function OnModeChange(Mode: string): ()
		if (Mode == "HttpGet") then
			if (GetConnection ~= nil) then GetConnection.Close(GetConnection); GetConnection = nil; end
			GetConnection = task.spawn(function()
				while (SpotifyOverlay.Enabled) do
					local Success, Data = pcall(function()
						local RawData = game:HttpGet("https://api.lanyard.rest/v1/users/"..Overlay.DiscordID);
						return HttpService.JSONDecode(HttpService, RawData);
					end)
					if (type(Data) == "table" and Data.success and Data.data and Data.data.listening_to_spotify and Data.data.spotify) then
						UpdateOverlay(Data.data.spotify);
					end
					task.wait(1);
				end
			end)
		elseif (Mode == "Websocket") then
			if (GetConnection ~= nil) then task.cancel(GetConnection); GetConnection = nil; end
			GetConnection = Websocket.connect(`wss://api.lanyard.rest/socket`);
			GetConnection.OnMessage.Connect(GetConnection.OnMessage, function(RawMessage)
                local Success, Data = pcall(function() return HttpService.JSONDecode(HttpService, RawMessage); end)
                if (not Success) then return; end
                if (Data.op == 1) then
                    local HeartbeatInterval = (Data.d.heartbeat_interval or 30000) / 1000;
                    task.spawn(function()
                        while (GetConnection) do
                            task.wait(HeartbeatInterval);
                            if (not GetConnection) then break; end
                            pcall(function()
                                GetConnection.Send(GetConnection, HttpService.JSONEncode(HttpService, { op = 3 }));
                            end)
                        end
                    end)
                    local InitializePayload = HttpService.JSONEncode(HttpService, {
                        op = 2;
                        d = {
                            subscribe_to_id = Overlay.DiscordID;
                        };
                    });
                    GetConnection.Send(GetConnection, InitializePayload);
                elseif (Data.op == 0) then
                    local EventData = Data.d;
                    if (type(EventData) == "table" and EventData.listening_to_spotify and EventData.spotify) then
                        UpdateOverlay(EventData.spotify);
                    end
                end
			end)
		end
	end
    local function CleanupConnections()
		if (GetConnection == nil) then return; end
		if (Overlay.Mode == "Websocket") then
			pcall(function() GetConnection.Close(GetConnection); end)
		elseif (Overlay.Mode == "HttpGet") then
			pcall(function() task.cancel(GetConnection); end)
		end
		GetConnection = nil;
	end
	function Overlay:SetDiscordID(Value: number): ()
		Overlay.DiscordID = Value;
	end
	function Overlay:SetMode(Value: string): ()
		if (Value ~= "Websocket" or Value ~= "HttpGet" and Overlay.Mode == Value) then return; end
		Overlay.Mode = Value;
        OnModeChange(Overlay.Mode);
	end
	function Overlay:SetTheme(Value: ThemeConfig): ()
		Overlay.UIConfig = Value;
		for Index, Value in SpotifyOverlay.DefaultTheme do
			if (Overlay.UIConfig[Index] == nil) then
				Overlay.UIConfig[Index] = Value;
			end
		end
		Overlay:ForceUpdateTheme();
	end
	function Overlay:ForceUpdateTheme(): ()
		OverlayHolder.BackgroundColor3 = Overlay.UIConfig.BackgroundColor;
		OverlayHolder.BackgroundTransparency = Overlay.UIConfig.BackgroundTransparency;
		BackgroundBorder.Color = Overlay.UIConfig.BorderColor;
		BackgroundBorder.Thickness = Overlay.UIConfig.BorderThickness;
		SongNameText.TextColor3 = Overlay.UIConfig.SongNameColor;
		SongNameText.FontFace = Overlay.UIConfig.SongNameFont;
		SongArtistText.TextColor3 = Overlay.UIConfig.ArtistNameColor;
		SongArtistText.FontFace = Overlay.UIConfig.ArtistNameFont;
		BarFrame.BackgroundColor3 = Overlay.UIConfig.BarBackgroundColor;
		Bar.BackgroundColor3 = Overlay.UIConfig.BarColor;
	end
	function Overlay:Destroy(): ()
        CleanupConnections();
        GetConnection = nil;
		OverlayHolder.Destroy(OverlayHolder);
		Overlay = nil;
	end
    OverlayHolder.Destroying.Connect(OverlayHolder.Destroying, function()
        CleanupConnections();
        GetConnection = nil;
        Overlay = nil;
    end)
	OnModeChange(Overlay.Mode);
	return Overlay;
end

return SpotifyOverlay;
