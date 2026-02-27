-- [[ PHANTOM VISION | FULL PROJECT 2026 ]] --

-- 1. НАСТРОЙКИ (Вставь свою ссылку сюда)
local WorkinkLink = "ВСТАВЬ_ССЫЛКУ_ОТ_WORKINK" -- Твоя ссылка из Work.ink
local SECRET_SALT = "PHANTOM_2026_AUTO" -- Секретное слово (как на GitHub)
local MenuBind = Enum.KeyCode.RightControl -- Бинд на меню [cite: 2026-02-27]

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- 2. СИСТЕМА ПРОВЕРКИ КЛЮЧА
local function GetCurrentKey()
    local success, result = pcall(function() 
        return game:HttpGet("http://worldtimeapi.org/api/timezone/Etc/UTC") 
    end)
    local date = success and HttpService:JSONDecode(result).datetime:sub(1, 10) or os.date("!%Y-%m-%d")
    local hash = 0
    local combined = date .. SECRET_SALT
    for i = 1, #combined do
        hash = (hash * 31 + string.byte(combined, i)) % 100000
    end
    return "PV-" .. hash
end

-- 3. ОСНОВНОЕ МЕНЮ (ПОЯВИТСЯ ПОСЛЕ ВВОДА КЛЮЧА)
function StartPhantom()
    local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 250)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", Frame)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(180, 100, 255)
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "PHANTOM VISION | MENU"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.BackgroundTransparency = 1

    -- Кнопка Speed
    local SpeedBtn = Instance.new("TextButton", Frame)
    SpeedBtn.Size = UDim2.new(0.8, 0, 0, 40)
    SpeedBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
    SpeedBtn.Text = "Ускорение (Speed)"
    SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SpeedBtn.TextColor3 = Color3.new(1,1,1)
    SpeedBtn.MouseButton1Click:Connect(function()
        player.Character.Humanoid.WalkSpeed = 100
    end)

    -- Кнопка Jump
    local JumpBtn = Instance.new("TextButton", Frame)
    JumpBtn.Size = UDim2.new(0.8, 0, 0, 40)
    JumpBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    JumpBtn.Text = "Высокий прыжок"
    JumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    JumpBtn.TextColor3 = Color3.new(1,1,1)
    JumpBtn.MouseButton1Click:Connect(function()
        player.Character.Humanoid.JumpPower = 150
    end)

    -- БИНД НА ОТКРЫТИЕ/ЗАКРЫТИЕ (RightControl) [cite: 2026-02-27]
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == MenuBind then
            Frame.Visible = not Frame.Visible
        end
    end)
end

-- 4. ИНТЕРФЕЙС ЛОАДЕРА (ОКНО КЛЮЧА)
local KeyGui = Instance.new("ScreenGui", player.PlayerGui)
local Main = Instance.new("Frame", KeyGui)
Main.Size = UDim2.new(0, 350, 0, 260)
Main.Position = UDim2.new(0.5, -175, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(180, 100, 255)

local KeyInput = Instance.new("TextBox", Main)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyInput.PlaceholderText = "Введите ключ..."
KeyInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput)

local ActBtn = Instance.new("TextButton", Main)
ActBtn.Size = UDim2.new(0.8, 0, 0, 45)
ActBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
ActBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
ActBtn.Text = "АКТИВИРОВАТЬ"
ActBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ActBtn)

local GetBtn = Instance.new("TextButton", Main)
GetBtn.Size = UDim2.new(0.8, 0, 0, 30)
GetBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
GetBtn.Text = "ПОЛУЧИТЬ КЛЮЧ (Work.ink)"
GetBtn.BackgroundTransparency = 1
GetBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6)

-- ЛОГИКА КНОПОК
GetBtn.MouseButton1Click:Connect(function()
    setclipboard(WorkinkLink)
    GetBtn.Text = "ССЫЛКА СКОПИРОВАНА!"
    task.wait(2)
    GetBtn.Text = "ПОЛУЧИТЬ КЛЮЧ (Work.ink)"
end)

ActBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == GetCurrentKey() then
        KeyGui:Destroy()
        StartPhantom()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "НЕВЕРНЫЙ КЛЮЧ!"
    end
end)
