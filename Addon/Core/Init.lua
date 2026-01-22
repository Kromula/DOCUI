-- DOC UI Installer - Core/Init.lua
-- Main addon initialization

-- Create addon namespace
DOCUI = DOCUI or {}
DOCUI.VERSION = "0.0.5"

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

        -- Register slash commands
        SLASH_DOCUI1 = "/docui"
        SlashCmdList["DOCUI"] = function(msg)
            if msg == "debug" then
                DOCUI:DebugEditMode()
            elseif msg == "testimport" then
                DOCUI:TestImport()
            else
                DOCUI:OpenInstaller()
            end
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

-- Debug function to diagnose Edit Mode APIs
function DOCUI:DebugEditMode()
    print("=== DOC UI Edit Mode Debug ===")

    -- Check C_EditMode APIs
    print("\n[C_EditMode APIs]")
    if C_EditMode then
        print("  C_EditMode: EXISTS")
        print("  - GetLayouts:", C_EditMode.GetLayouts and "YES" or "NO")
        print("  - SaveLayouts:", C_EditMode.SaveLayouts and "YES" or "NO")
        print("  - SetActiveLayout:", C_EditMode.SetActiveLayout and "YES" or "NO")
        print("  - ImportLayout:", C_EditMode.ImportLayout and "YES" or "NO")

        -- Try to get layouts
        if C_EditMode.GetLayouts then
            local success, data = pcall(C_EditMode.GetLayouts)
            if success and data then
                print("\n[Existing Layouts]")
                print("  Active Layout:", data.activeLayout or "nil")
                if data.layouts then
                    print("  Total Layouts:", #data.layouts)
                    for i, layout in ipairs(data.layouts) do
                        print(string.format("    %d: %s (type %s)", i, layout.layoutName or "Unnamed", layout.layoutType or "?"))
                    end
                end
            else
                print("  ERROR calling GetLayouts():", data)
            end
        end
    else
        print("  C_EditMode: NOT AVAILABLE")
    end

    -- Check EditModeManagerFrame
    print("\n[EditModeManagerFrame]")
    if EditModeManagerFrame then
        print("  EditModeManagerFrame: EXISTS")
        print("  - ImportLayout:", EditModeManagerFrame.ImportLayout and "YES" or "NO")
        print("  - importLayoutDialog:", EditModeManagerFrame.importLayoutDialog and "EXISTS" or "NIL")

        if EditModeManagerFrame.importLayoutDialog then
            local dialog = EditModeManagerFrame.importLayoutDialog
            print("    - editBox:", dialog.editBox and "EXISTS" or "NIL")
            print("    - AcceptButton:", dialog.AcceptButton and "EXISTS" or "NIL")
            print("    - ImportLayout:", dialog.ImportLayout and "EXISTS" or "NIL")
        end
    else
        print("  EditModeManagerFrame: NOT AVAILABLE")
    end

    -- Check if Blizzard_PlayerChoice is loaded
    print("\n[Dependencies]")
    print("  Blizzard_PlayerChoice:", C_AddOns.IsAddOnLoaded("Blizzard_PlayerChoice") and "LOADED" or "NOT LOADED")

    -- Check if our layout exists
    print("\n[DOC UI Layout Status]")
    if DOCUI.Profiles and DOCUI.Profiles.BlizzardEditMode then
        local exists = DOCUI.Profiles.BlizzardEditMode:LayoutExists()
        print("  Layout 'DOC UI - DPS 1440p':", exists and "FOUND" or "NOT FOUND")
    else
        print("  Profile not loaded yet")
    end

    print("\n=== End Debug ===")
end

-- Test import function
function DOCUI:TestImport()
    if not DOCUI.Profiles or not DOCUI.Profiles.BlizzardEditMode then
        print("ERROR: BlizzardEditMode profile not loaded")
        return
    end

    print("=== Testing Import ===")
    local success, message = DOCUI.Profiles.BlizzardEditMode:Import()
    print("Result:", success and "SUCCESS" or "FAILED")
    print("Message:", message)
end

-- Extract layout structure after manual import
function DOCUI:ExtractLayout(layoutName)
    if not C_EditMode or not C_EditMode.GetLayouts then
        print("ERROR: C_EditMode.GetLayouts not available")
        return
    end

    local data = C_EditMode.GetLayouts()
    if not data or not data.layouts then
        print("ERROR: No layouts found")
        return
    end

    -- Find the layout by name
    for i, layout in ipairs(data.layouts) do
        if layout.layoutName == layoutName then
            print("=== Found Layout: " .. layoutName .. " ===")
            print("Index:", i)
            print("Type:", layout.layoutType)
            print("Systems:", layout.systems and #layout.systems or 0)

            -- Print the layout structure (this is what we need for programmatic import)
            print("\n--- Layout Structure ---")
            print("Copy this into your addon code:")
            print("\n```lua")
            print("local layout = " .. DOCUI:TableToString(layout, 1))
            print("```")

            return layout
        end
    end

    print("ERROR: Layout '" .. layoutName .. "' not found")
    print("Available layouts:")
    for i, layout in ipairs(data.layouts) do
        print("  " .. i .. ": " .. (layout.layoutName or "Unnamed"))
    end
end

-- Helper to convert table to string for debugging
function DOCUI:TableToString(tbl, indent)
    if type(tbl) ~= "table" then
        if type(tbl) == "string" then
            return string.format("%q", tbl)
        else
            return tostring(tbl)
        end
    end

    local result = "{\n"
    indent = indent or 1
    local indentStr = string.rep("  ", indent)

    for k, v in pairs(tbl) do
        result = result .. indentStr
        if type(k) == "number" then
            result = result .. "[" .. k .. "] = "
        else
            result = result .. k .. " = "
        end

        result = result .. DOCUI:TableToString(v, indent + 1) .. ",\n"
    end

    result = result .. string.rep("  ", indent - 1) .. "}"
    return result
end
