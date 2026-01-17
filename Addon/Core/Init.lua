-- DOC UI Installer - Core/Init.lua
-- Main addon initialization

-- Create addon namespace
DOCUI = DOCUI or {}
DOCUI.VERSION = "1.0.0"

-- Initialize database with defaults
local function InitializeDatabase()
    if not DOCUIDB then
        DOCUIDB = {}
    end

    if DOCUIDB.hasRunBefore == nil then
        DOCUIDB.hasRunBefore = false
    end

    if DOCUIDB.showOnLogin == nil then
        DOCUIDB.showOnLogin = true
    end

    if not DOCUIDB.installedProfiles then
        DOCUIDB.installedProfiles = {}
    end

    if not DOCUIDB.logs then
        DOCUIDB.logs = {}
    end
end

-- Event frame for ADDON_LOADED and PLAYER_ENTERING_WORLD
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local playerEnteredWorld = false

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "DOCUI" then
        -- Initialize database
        InitializeDatabase()

        -- Register slash command
        SLASH_DOCUI1 = "/docui"
        SlashCmdList["DOCUI"] = function(msg)
            DOCUI:OpenInstaller()
        end

        self:UnregisterEvent("ADDON_LOADED")
    end

    if event == "PLAYER_ENTERING_WORLD" and not playerEnteredWorld then
        playerEnteredWorld = true

        -- Check if should auto-open on first run
        if not DOCUIDB.hasRunBefore and DOCUIDB.showOnLogin then
            C_Timer.After(2, function()
                DOCUI:OpenInstaller()
            end)
        end

        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)
