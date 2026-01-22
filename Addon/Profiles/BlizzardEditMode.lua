-- DOC UI Installer - Profiles/BlizzardEditMode.lua
-- Blizzard Edit Mode Layout Data

DOCUI = DOCUI or {}
DOCUI.Profiles = DOCUI.Profiles or {}

-- DPS 1440p Layout for Blizzard Edit Mode
DOCUI.Profiles.BlizzardEditMode = {
    name = "DPS 1440p",
    description = "Complete UI layout optimized for 1440p displays using Blizzard's built-in Edit Mode",
    resolution = "1440p",

    -- Layout data (Blizzard Edit Mode import string)
    -- This string can be imported via Edit Mode -> Import Layout
    layoutData = [[2 43 0 0 0 0 0 UIParent 999.0 -1395.0 -1 ##$$%/&('%)$+$,$ 0 1 0 0 0 UIParent 999.0 -1347.7 -1 ##$$%/&('%(#,$ 0 2 0 0 0 UIParent 999.3 -1300.6 -1 ##$$%/&('%(#,$ 0 3 0 5 5 UIParent -2.0 40.3 -1 #$$$%/&('%(#,$ 0 4 0 6 6 UIParent 483.0 62.0 -1 #$$%%-&&'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 0 0 0 UIParent 401.7 -1110.1 -1 ##$$%/&('%(#,$ 0 7 0 0 0 UIParent 401.7 -1404.1 -1 ##$$%/&('%(#,$ 0 10 0 7 7 UIParent -363.8 112.9 -1 ##$$&('% 0 11 0 7 7 UIParent 0.1 134.2 -1 ##$$&''%,# 0 12 0 4 4 UIParent -524.4 -272.2 -1 ##$$&('% 1 -1 0 7 7 UIParent -1.0 308.4 -1 #%$#%# 2 -1 0 2 2 UIParent -11.1 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 530.3 -725.1 -1 $#3/ 3 1 0 0 0 UIParent 1245.0 -725.3 -1 %$3/ 3 2 0 5 5 UIParent -372.9 -220.9 -1 %#&$3# 3 3 0 0 0 UIParent 570.0 -532.0 -1 '$(#)#-W.=/#1#3# 3 4 0 0 0 UIParent 3.0 -588.4 -1 ,#-=.7/#0&1$2( 3 5 0 2 2 UIParent -399.3 -279.6 -1 &$*$3' 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4& 3 7 0 4 4 UIParent -456.9 -220.0 -1 3# 4 -1 0 7 7 UIParent -2.5 171.6 -1 # 5 -1 0 7 7 UIParent 0.1 179.4 -1 # 6 0 0 2 2 UIParent -260.0 -4.2 -1 ##$#%#&.(()( 6 1 0 2 2 UIParent -261.3 -146.3 -1 ##$#%#'+(()( 7 -1 0 3 3 UIParent -0.0 158.0 -1 # 8 -1 0 6 6 UIParent 10.9 34.8 -1 #&$s%$&s 9 -1 0 7 7 UIParent 307.1 103.3 -1 # 10 -1 0 4 4 UIParent -434.1 276.1 -1 # 11 -1 0 8 8 UIParent -318.5 1.8 -1 # 12 -1 0 5 5 UIParent -54.5 -53.6 -1 #K$#%# 13 -1 0 0 0 UIParent 2.1 -4.8 -1 ##$#%&&( 14 -1 0 7 7 UIParent 376.1 4.1 -1 ##$$%$ 15 0 0 1 1 UIParent -12.9 -14.7 -1 # 15 1 0 1 1 UIParent -12.5 -37.4 -1 # 16 -1 0 7 7 UIParent 269.0 151.3 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 0 0 0 UIParent 1073.0 -925.0 -1 ##$+%$&('%(-($)#+$,$-$ 20 1 0 0 0 UIParent 1089.2 -976.0 -1 ##$-%$&*'%(-($)#+$,$-$ 20 2 0 7 7 UIParent 0.0 562.0 -1 ##$$%$&('%(-($)#+$,$-$ 20 3 0 7 7 UIParent -363.0 522.0 -1 #$$$%#&)'((-($)#*#+$,$-$]],

    -- How to import:
    -- Press ESC → Edit Mode → Import Layout → Paste the string above
    importInstructions = "To import this layout: Press ESC → Edit Mode → Import Layout → Paste the provided string"
}

-- Programmatic Import Function
-- This attempts to import the layout directly without manual copy-paste
function DOCUI.Profiles.BlizzardEditMode:Import()
    -- Check if Edit Mode APIs are available
    if not C_EditMode then
        return false, "Edit Mode API not available. Make sure you're on retail (11.0+)."
    end

    -- Check if Blizzard_PlayerChoice is loaded (required for Edit Mode)
    if not C_AddOns.IsAddOnLoaded("Blizzard_PlayerChoice") then
        return false, "Blizzard_PlayerChoice not loaded yet. Try /reload first."
    end

    -- Method: Use EditModeManagerFrame:ImportLayout()
    -- Based on debug, this is the only available import method
    if not (EditModeManagerFrame and EditModeManagerFrame.ImportLayout) then
        return false, "EditModeManagerFrame:ImportLayout not available. Use manual import."
    end

    -- First, try to ensure Edit Mode is initialized
    if not EditModeManagerFrame:IsShown() then
        print("[DOC UI] Edit Mode not open. Trying to open it first...")
        -- Try to show Edit Mode
        if EditModeManagerFrame.Show then
            EditModeManagerFrame:Show()
        end
    end

    print("[DOC UI] Attempting import via EditModeManagerFrame:ImportLayout()...")
    print("[DOC UI] Import string length:", string.len(self.layoutData))

    local success, result = pcall(function()
        -- Call ImportLayout with our layout string
        return EditModeManagerFrame:ImportLayout(self.layoutData)
    end)

    if not success then
        print("[DOC UI] ERROR calling ImportLayout:", result)
        return false, "Import failed: " .. tostring(result)
    end

    print("[DOC UI] ImportLayout returned:", tostring(result))

    -- Wait a moment for the import to process, then verify
    C_Timer.After(1, function()
        local data = C_EditMode.GetLayouts()
        print("[DOC UI] Checking layouts after import...")
        if data and data.layouts then
            print("[DOC UI] Total layouts now:", #data.layouts)
            for i, layout in ipairs(data.layouts) do
                print(string.format("  %d: %s", i, layout.layoutName or "Unnamed"))
            end
        end

        if self:LayoutExists() then
            print("[DOC UI] SUCCESS: Layout 'DOC UI - DPS 1440p' found!")
        else
            print("[DOC UI] WARNING: Layout still not found!")
            print("[DOC UI] ImportLayout may require manual confirmation or doesn't work with strings.")
            print("[DOC UI] Please use the Manual Import method instead.")
        end
    end)

    return true, "Import attempted. Check chat for results in 1 second..."
end

-- Helper function to check if our layout already exists
function DOCUI.Profiles.BlizzardEditMode:LayoutExists()
    if not C_EditMode or not C_EditMode.GetLayouts then
        return false
    end

    local success, data = pcall(function()
        return C_EditMode.GetLayouts()
    end)

    if not success or not data or not data.layouts then
        return false
    end

    -- Check if "DOC UI" layout exists
    for _, layout in ipairs(data.layouts) do
        if layout.layoutName and layout.layoutName == "DOC UI - DPS 1440p" then
            return true
        end
    end

    return false
end
