-- [[ XXPX REAL-TIME SECURITY SYSTEM ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local kick_msg = "This key cannot be used at the moment. If you want to use it again, you will need to use a new key."

-- ⚠️ ここに今の ngrok URL を貼り付けてください
local auth_url = "https://endamoebic-jayleen-cotyledonoid.ngrok-free.dev/check?key=" 

-- 認証チェック関数
local function check_auth()
    if not getgenv().XXPX_KEY then return false end
    local success, result = pcall(function()
        return game:HttpGet(auth_url .. getgenv().XXPX_KEY)
    end)
    return success and result == "OK"
end

-- 1. 起動時チェック
if not check_auth() then
    LocalPlayer:Kick(kick_msg)
    return
end

-- 2. 1分ごとの生存確認（期限が切れたら即キック）
task.spawn(function()
    while task.wait(60) do
        if not check_auth() then
            LocalPlayer:Kick(kick_msg)
            break
        end
    end
end)

-- =========================================================
-- 🛠️ ここから下がいわゆる「スクリプト本体（GUI）」です
-- =========================================================

-- UIライブラリの読み込み（綺麗なメニューを作るための部品）
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
local Window = Library:CreateWindow("XXPX Bat Lag V2") -- メニューのタイトル

-- メインタブ
local Main = Window:CreateTab("Main Features")

-- Bat Lag機能
Main:CreateButton("Bat Lag (Normal)", function()
    local tool = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
    if tool then
        for i = 1, 100 do
            tool:Activate()
        end
    else
        print("Batが見つかりませんでした")
    end
end)

-- スピード変更機能
Main:CreateSlider("WalkSpeed", 16, 250, function(v)
    LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

-- ジャンプ力変更機能
Main:CreateSlider("JumpPower", 50, 500, function(v)
    LocalPlayer.Character.Humanoid.JumpPower = v
end)

-- クレジット（あなたの名前とか）
local Credit = Window:CreateTab("Credit")
Credit:CreateLabel("Owner: YourName")
Credit:CreateButton("Copy Discord Link", function()
    setclipboard("discord.gg/あなたのサーバー")
end)

print("XXPX System: Authenticated & Loaded!")
