--// CommandBarLib
local CommandBarLib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Default config
CommandBarLib.Config = {
    BlurSize = 24,
    AutoHideTime = 3, -- seconds of idle to auto-close
    CommandColor = Color3.fromRGB(255,255,255), -- white
    BackgroundColor = Color3.fromRGB(20,20,20),
    ButtonColor = Color3.fromRGB(30,30,30),
    SuggestionColor = Color3.fromRGB(15,15,15)
}

--// Create CommandBar
function CommandBarLib:Create(commandsTable)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CommandBarGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Blur & Fog
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local fog = Instance.new("Frame")
    fog.Size = UDim2.new(1,0,1,0)
    fog.BackgroundColor3 = Color3.new(0,0,0)
    fog.BackgroundTransparency = 1
    fog.Parent = screenGui

    -- Command Frame
    local cmdFrame = Instance.new("Frame")
    cmdFrame.Size = UDim2.new(0,500,0,45)
    cmdFrame.Position = UDim2.new(0.5,0,0.4,0)
    cmdFrame.AnchorPoint = Vector2.new(0.5,0.5)
    cmdFrame.BackgroundColor3 = CommandBarLib.Config.BackgroundColor
    cmdFrame.BorderSizePixel = 0
    cmdFrame.Visible = false
    cmdFrame.Parent = screenGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0,10)
    uicorner.Parent = cmdFrame

    local uistroke = Instance.new("UIStroke")
    uistroke.Thickness = 2
    uistroke.Color = CommandBarLib.Config.CommandColor
    uistroke.Parent = cmdFrame

    -- TextBox
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1,-20,1,-10)
    textBox.Position = UDim2.new(0,10,0,5)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = CommandBarLib.Config.CommandColor
    textBox.PlaceholderText = "Enter command..."
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 20
    textBox.Parent = cmdFrame

    -- Suggestion Frame
    local suggestFrame = Instance.new("Frame")
    suggestFrame.Size = UDim2.new(1,0,0,25)
    suggestFrame.Position = UDim2.new(0,0,-1.8,0)
    suggestFrame.BackgroundColor3 = CommandBarLib.Config.SuggestionColor
    suggestFrame.BackgroundTransparency = 0.6
    suggestFrame.BorderSizePixel = 0
    suggestFrame.Visible = false
    suggestFrame.Parent = cmdFrame

    local suggestText = Instance.new("TextLabel")
    suggestText.Size = UDim2.new(1,-10,1,-2)
    suggestText.Position = UDim2.new(0,5,0,1)
    suggestText.BackgroundTransparency = 1
    suggestText.TextColor3 = CommandBarLib.Config.CommandColor
    suggestText.TextXAlignment = Enum.TextXAlignment.Left
    suggestText.TextYAlignment = Enum.TextYAlignment.Top
    suggestText.Font = Enum.Font.Code
    suggestText.TextSize = 18
    suggestText.TextWrapped = true
    suggestText.Text = ""
    suggestText.Parent = suggestFrame

    -- CMD Button
    local cmdButton = Instance.new("TextButton")
    cmdButton.Size = UDim2.new(0,60,0,60)
    cmdButton.Position = UDim2.new(0.9,0,0.9,0)
    cmdButton.AnchorPoint = Vector2.new(0.5,0.5)
    cmdButton.Text = "CMD"
    cmdButton.Font = Enum.Font.Code
    cmdButton.TextSize = 20
    cmdButton.TextColor3 = CommandBarLib.Config.CommandColor
    cmdButton.BackgroundColor3 = CommandBarLib.Config.ButtonColor
    cmdButton.BorderSizePixel = 0
    cmdButton.Parent = screenGui
    cmdButton.Active = true
    cmdButton.Draggable = true

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0,10)
    buttonCorner.Parent = cmdButton

    --// Notification Function
    local function notify(title,msg,imgId)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 80)
        notif.Position = UDim2.new(0.5, 0, 0, -100)
        notif.AnchorPoint = Vector2.new(0.5, 0)
        notif.BackgroundColor3 = CommandBarLib.Config.SuggestionColor
        notif.BorderSizePixel = 0
        notif.ZIndex = 10
        notif.Parent = screenGui

        local uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(0, 10)
        uicorner.Parent = notif

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = CommandBarLib.Config.CommandColor
        stroke.Parent = notif

        -- Image
        if imgId then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0,25,0,25)
            icon.Position = UDim2.new(0,5,0,5)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://"..imgId
            icon.Parent = notif
        end

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -40, 0, 25)
        titleLabel.Position = UDim2.new(0, 35, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.Code
        titleLabel.TextSize = 20
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextColor3 = CommandBarLib.Config.CommandColor
        titleLabel.Text = title or ""
        titleLabel.ZIndex = 11
        titleLabel.Parent = notif

        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -10, 0, 50)
        msgLabel.Position = UDim2.new(0, 5, 0, 25)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Font = Enum.Font.Code
        msgLabel.TextSize = 18
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextWrapped = true
        msgLabel.TextColor3 = CommandBarLib.Config.CommandColor
        msgLabel.Text = msg or ""
        msgLabel.ZIndex = 11
        msgLabel.Parent = notif

        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.1, 0)}):Play()
        delay(3, function()
            TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, -0.2, 0)}):Play()
            wait(0.5)
            notif:Destroy()
        end)
    end

    -- Show / Hide
    local function showCmd()
        cmdFrame.Visible = true
        TweenService:Create(fog,TweenInfo.new(0.5),{BackgroundTransparency=0.5}):Play()
        TweenService:Create(blur,TweenInfo.new(0.5),{Size=CommandBarLib.Config.BlurSize}):Play()
        TweenService:Create(cmdFrame,TweenInfo.new(0.3),{Position=UDim2.new(0.5,0,0.5,0)}):Play()
        textBox:CaptureFocus()
    end

    local function hideCmd()
        TweenService:Create(fog,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        TweenService:Create(blur,TweenInfo.new(0.5),{Size=0}):Play()
        TweenService:Create(cmdFrame,TweenInfo.new(0.3),{Position=UDim2.new(0.5,0,0.4,0)}):Play()
        wait(0.3)
        cmdFrame.Visible = false
        suggestFrame.Visible = false
    end

    cmdButton.MouseButton1Click:Connect(showCmd)

    -- Auto-suggestions
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = textBox.Text:lower()
        local list = {}
        for cmd,example in pairs(commandsTable) do
            if cmd:sub(1,#txt) == txt and txt ~= "" then
                table.insert(list, example)
            end
        end
        if #list > 0 then
            suggestFrame.Visible = true
            suggestText.Text = table.concat(list, "\n")
            suggestFrame.Size = UDim2.new(1,0,0,#list*20)
        else
            suggestFrame.Visible = false
        end
    end)

    -- Execute command
    textBox.FocusLost:Connect(function(enter)
        if enter then
            local inputText = textBox.Text
            textBox.Text = ""
            hideCmd()
            local cmd, arg = inputText:match("^(%S+)%s*(.*)$")
            if cmd and commandsTable[cmd:lower()] then
                commandsTable[cmd:lower()](arg)
            end
        end
    end)

    -- Auto-hide after idle
    local lastTypingTime = tick()
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        lastTypingTime = tick()
    end)
    textBox.Focused:Connect(function()
        lastTypingTime = tick()
    end)
    RunService.Heartbeat:Connect(function()
        if textBox:IsFocused() and tick() - lastTypingTime >= CommandBarLib.Config.AutoHideTime then
            textBox:ReleaseFocus()
            hideCmd()
        end
    end)

    -- Initial notification
    notify("Welcome","Lucent Mobile CMD",10709783474)
end

return CommandBarLib
