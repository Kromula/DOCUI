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

    -- Debug: Check what APIs are available
    print("[DOC UI Debug] Checking Edit Mode APIs...")
    print("  C_EditMode.ImportLayout:", C_EditMode.ImportLayout and "exists" or "nil")
    print("  C_EditMode.GetLayouts:", C_EditMode.GetLayouts and "exists" or "nil")
    print("  C_EditMode.SaveLayouts:", C_EditMode.SaveLayouts and "exists" or "nil")

    -- Method 1: Try using the import dialog directly
    if EditModeManagerFrame then
        print("  EditModeManagerFrame: exists")

        -- Try to access the import dialog
        local dialog = EditModeManagerFrame.importLayoutDialog
        if dialog then
            print("  importLayoutDialog: exists")

            -- Try to set the import string and trigger import
            local success, err = pcall(function()
                -- Set the import string in the edit box
                if dialog.editBox then
                    dialog.editBox:SetText(self.layoutData)
                end

                -- Try to call the import function
                if dialog.ImportLayout then
                    dialog:ImportLayout()
                elseif dialog.AcceptButton and dialog.AcceptButton:GetScript("OnClick") then
                    dialog.AcceptButton:GetScript("OnClick")(dialog.AcceptButton)
                end
            end)

            if success then
                -- Check if layout actually exists now
                C_Timer.After(0.5, function()
                    if self:LayoutExists() then
                        print("[DOC UI] Layout verified in Edit Mode!")
                    else
                        print("[DOC UI] WARNING: Import appeared to succeed but layout not found!")
                    end
                end)
                return true, "Layout import attempted - checking..."
            else
                print("[DOC UI Debug] Import dialog method failed:", err)
            end
        else
            print("  importLayoutDialog: nil")
        end
    end

    -- Method 2: Check if C_EditMode has GetLayouts/SaveLayouts
    -- This would require converting our import string to layout structure
    if C_EditMode.GetLayouts and C_EditMode.SaveLayouts then
        print("[DOC UI Debug] GetLayouts/SaveLayouts exist - but we need layout structure, not string")
        -- TODO: Implement string-to-structure conversion
        return false, "Import string format not supported. Use manual import."
    end

    -- If all methods fail
    return false, "Automatic import not available. Please use manual copy-paste method."
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
