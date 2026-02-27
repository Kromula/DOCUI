-- DOC UI Installer
-- Streamlined installer system

DOCUI = DOCUI or {}
DOCUI.Installer = {}

-- Constants
local FRAME_WIDTH = 600
local FRAME_HEIGHT = 450
local STEP_FRAME_WIDTH = 200
local DOC_BLUE = {0.12, 0.58, 0.89} -- #1e95e3
local HIGHLIGHT_COLOR = {0, 0.8, 1} -- Brighter blue for highlights

-- Local references
local installerFrame
local currentPage = 0
local maxPage = 0

-- Apply dark themed backdrop
local function ApplyBackdrop(frame)
    if not frame.SetBackdrop then
        Mixin(frame, BackdropTemplateMixin)
    end

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        tileSize = 0,
        edgeSize = 1,
        insets = {left = 1, right = 1, top = 1, bottom = 1}
    })

    -- Dark background
    frame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    -- Darker border
    frame:SetBackdropBorderColor(0, 0, 0, 1)
end

-- Style buttons with DOC UI theme
local function StyleButton(button)
    if not button.bg then
        button.bg = button:CreateTexture(nil, "BACKGROUND")
        button.bg:SetAllPoints()
        button.bg:SetColorTexture(0.15, 0.15, 0.15, 0.9)
    end

    if not button.highlight then
        button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
        button.highlight:SetAllPoints()
        button.highlight:SetColorTexture(1, 1, 1, 0.1)
        button:SetHighlightTexture(button.highlight)
    end

    if not button.text then
        button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        button.text:SetPoint("CENTER")
        button.text:SetJustifyH("CENTER")

        button.SetText = function(self, text)
            self.text:SetText(text)
        end
    end
end

-- Layout option buttons dynamically
local function LayoutOptionButtons()
    local visibleButtons = {}
    local numButtons = 0

    local options = {
        installerFrame.Option1,
        installerFrame.Option2,
        installerFrame.Option3,
        installerFrame.Option4,
        installerFrame.Option5,
        installerFrame.Option6,
        installerFrame.Option7,
        installerFrame.Option8
    }

    for _, option in ipairs(options) do
        if option:IsShown() then
            numButtons = numButtons + 1
            visibleButtons[numButtons] = option
        end
    end

    if numButtons == 0 then return end

    local spacing = 8
    local buttonWidth = 160
    local buttonHeight = 32
    local rowSpacing = 8
    local maxButtonsPerRow = 3

    -- Determine if we need multiple rows
    if numButtons <= maxButtonsPerRow then
        -- Single row layout
        local totalWidth = (numButtons * buttonWidth) + ((numButtons - 1) * spacing)
        local startX = -(totalWidth / 2) + (buttonWidth / 2)

        for i = 1, numButtons do
            local button = visibleButtons[i]
            button:ClearAllPoints()
            local offsetX = startX + ((i - 1) * (buttonWidth + spacing))
            button:SetPoint("BOTTOM", installerFrame, "BOTTOM", offsetX, 70)
        end
    else
        -- Two row layout
        local row1Count = math.ceil(numButtons / 2)
        local row2Count = numButtons - row1Count

        -- Position first row
        local row1Width = (row1Count * buttonWidth) + ((row1Count - 1) * spacing)
        local row1StartX = -(row1Width / 2) + (buttonWidth / 2)

        for i = 1, row1Count do
            local button = visibleButtons[i]
            button:ClearAllPoints()
            local offsetX = row1StartX + ((i - 1) * (buttonWidth + spacing))
            button:SetPoint("BOTTOM", installerFrame, "BOTTOM", offsetX, 70 + buttonHeight + rowSpacing)
        end

        -- Position second row
        local row2Width = (row2Count * buttonWidth) + ((row2Count - 1) * spacing)
        local row2StartX = -(row2Width / 2) + (buttonWidth / 2)

        for i = 1, row2Count do
            local button = visibleButtons[row1Count + i]
            button:ClearAllPoints()
            local offsetX = row2StartX + ((i - 1) * (buttonWidth + spacing))
            button:SetPoint("BOTTOM", installerFrame, "BOTTOM", offsetX, 70)
        end
    end
end

-- Reset frame for new page
local function ResetPage()
    installerFrame.Next:Enable()
    installerFrame.Prev:Enable()

    local options = {
        installerFrame.Option1,
        installerFrame.Option2,
        installerFrame.Option3,
        installerFrame.Option4,
        installerFrame.Option5,
        installerFrame.Option6,
        installerFrame.Option7,
        installerFrame.Option8
    }

    for _, option in ipairs(options) do
        option:Hide()
        option:SetScript("OnClick", nil)
        option:SetText("")
        option:ClearAllPoints()
        option:SetSize(160, 32)

        -- Reset button colors to default
        if option.bg then
            option.bg:SetColorTexture(0.15, 0.15, 0.15, 0.9)
        end
        if option.text then
            option.text:SetTextColor(1, 1, 1)
        end
    end

    installerFrame.SubTitle:SetText("")
    installerFrame.Desc1:SetText("")
    installerFrame.Desc2:SetText("")
    installerFrame.Desc3:SetText("")

    -- Hide credits frame if it exists
    if installerFrame.CreditsFrame then
        installerFrame.CreditsFrame:Hide()
    end
end

-- Update progress bar
local function UpdateProgressBar()
    local progress = currentPage / maxPage
    installerFrame.StatusBar:SetValue(currentPage)

    -- Color transition: Blue -> Cyan -> Green
    local r, g, b
    if progress < 0.5 then
        r = DOC_BLUE[1]
        g = DOC_BLUE[2] + (progress * 0.4)
        b = DOC_BLUE[3]
    else
        r = DOC_BLUE[1] - ((progress - 0.5) * 0.12)
        g = DOC_BLUE[2] + ((progress - 0.5) * 0.4)
        b = DOC_BLUE[3] - ((progress - 0.5) * 0.4)
    end

    installerFrame.StatusBar:SetStatusBarColor(r, g, b)
    installerFrame.StatusBar.text:SetFormattedText("%d / %d", currentPage, maxPage)
end

-- Update step list highlighting
local function UpdateStepList()
    if not installerFrame.stepFrame then return end

    local buttons = installerFrame.stepFrame.buttons
    local stepTitles = installerFrame.StepTitles

    for i = 1, #buttons do
        local button = buttons[i]
        local isActive = (i == currentPage)

        local text = button.text
        text:SetText(stepTitles[i])

        if isActive then
            text:SetTextColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3])
            button.bg:SetColorTexture(0.1, 0.3, 0.4, 0.6)
        else
            text:SetTextColor(0.8, 0.8, 0.8)
            button.bg:SetColorTexture(0.2, 0.2, 0.2, 0.4)
        end
    end
end

-- Set page
function DOCUI.Installer:SetPage(pageNum)
    if pageNum < 1 or pageNum > maxPage then return end

    ResetPage()
    currentPage = pageNum

    installerFrame.Next:Show()
    installerFrame.Next:Enable()
    installerFrame.Prev:Show()
    installerFrame.Prev:Enable()

    -- Disable prev on first page
    if currentPage == 1 then
        installerFrame.Prev:Disable()
    end

    -- Change Next to Finish on last page
    if currentPage == maxPage then
        installerFrame.Next:SetText("Finish")
    else
        installerFrame.Next:SetText("Next")
    end

    UpdateProgressBar()

    -- Execute page function
    if installerFrame.Pages and installerFrame.Pages[currentPage] then
        installerFrame.Pages[currentPage]()
    end

    LayoutOptionButtons()
    UpdateStepList()
end

-- Navigation
function DOCUI.Installer:NextPage()
    if currentPage < maxPage then
        self:SetPage(currentPage + 1)
    else
        -- Last page - close installer
        self:Hide()
    end
end

function DOCUI.Installer:PreviousPage()
    if currentPage > 1 then
        self:SetPage(currentPage - 1)
    end
end

-- Step button click handler
local function StepButton_OnClick(self)
    local pageNum = self:GetID()
    if pageNum and pageNum <= maxPage then
        DOCUI.Installer:SetPage(pageNum)
    end
end

-- Create main frame
local function CreateMainFrame()
    local frame = CreateFrame("Frame", "DOCUI_InstallerFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:Hide()

    ApplyBackdrop(frame)

    -- Title
    frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    frame.Title:SetPoint("TOP", 0, -15)
    frame.Title:SetText("DOC UI Installer")
    frame.Title:SetTextColor(DOC_BLUE[1], DOC_BLUE[2], DOC_BLUE[3])

    -- SubTitle
    frame.SubTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.SubTitle:SetPoint("TOP", 0, -50)
    frame.SubTitle:SetTextColor(1, 1, 1)

    -- Description lines
    frame.Desc1 = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.Desc1:SetPoint("TOPLEFT", 30, -95)
    frame.Desc1:SetWidth(FRAME_WIDTH - 60)
    frame.Desc1:SetJustifyH("CENTER")
    frame.Desc1:SetSpacing(3)

    frame.Desc2 = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.Desc2:SetPoint("TOP", frame.Desc1, "BOTTOM", 0, -20)
    frame.Desc2:SetWidth(FRAME_WIDTH - 60)
    frame.Desc2:SetJustifyH("CENTER")
    frame.Desc2:SetSpacing(3)

    frame.Desc3 = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.Desc3:SetPoint("TOP", frame.Desc2, "BOTTOM", 0, -20)
    frame.Desc3:SetWidth(FRAME_WIDTH - 60)
    frame.Desc3:SetJustifyH("CENTER")
    frame.Desc3:SetSpacing(3)

    -- Option buttons (1-8)
    for i = 1, 8 do
        local button = CreateFrame("Button", "DOCUI_InstallerOption"..i, frame)
        button:SetSize(160, 32)
        button:Hide()
        StyleButton(button)
        frame["Option"..i] = button
    end

    -- Previous button
    frame.Prev = CreateFrame("Button", "DOCUI_InstallerPrev", frame)
    frame.Prev:SetSize(100, 28)
    frame.Prev:SetPoint("BOTTOMLEFT", 8, 8)
    frame.Prev:Disable()
    frame.Prev:SetScript("OnClick", function() DOCUI.Installer:PreviousPage() end)
    StyleButton(frame.Prev)
    frame.Prev:SetText("Previous")

    -- Next button
    frame.Next = CreateFrame("Button", "DOCUI_InstallerNext", frame)
    frame.Next:SetSize(100, 28)
    frame.Next:SetPoint("BOTTOMRIGHT", -8, 8)
    frame.Next:Disable()
    frame.Next:SetScript("OnClick", function() DOCUI.Installer:NextPage() end)
    StyleButton(frame.Next)
    frame.Next:SetText("Next")

    -- Progress bar
    frame.StatusBar = CreateFrame("StatusBar", "DOCUI_InstallerStatusBar", frame)
    frame.StatusBar:SetPoint("TOPLEFT", frame.Prev, "TOPRIGHT", 8, 0)
    frame.StatusBar:SetPoint("BOTTOMRIGHT", frame.Next, "BOTTOMLEFT", -8, 0)
    frame.StatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    frame.StatusBar:SetMinMaxValues(0, 1)
    frame.StatusBar:SetValue(0)
    frame.StatusBar:SetStatusBarColor(DOC_BLUE[1], DOC_BLUE[2], DOC_BLUE[3])

    frame.StatusBar.bg = frame.StatusBar:CreateTexture(nil, "BACKGROUND")
    frame.StatusBar.bg:SetAllPoints()
    frame.StatusBar.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)

    frame.StatusBar.text = frame.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.StatusBar.text:SetPoint("CENTER")
    frame.StatusBar.text:SetText("0 / 0")

    return frame
end

-- Create step sidebar
local function CreateStepFrame(parent)
    local frame = CreateFrame("Frame", "DOCUI_InstallerStepFrame", UIParent, "BackdropTemplate")
    frame:SetSize(STEP_FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2, 0)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()

    ApplyBackdrop(frame)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetPoint("TOP", 0, -15)
    frame.title:SetText("Steps")
    frame.title:SetTextColor(DOC_BLUE[1], DOC_BLUE[2], DOC_BLUE[3])

    frame.buttons = {}

    return frame
end

-- Show installer
function DOCUI.Installer:Show(data)
    if not installerFrame then
        self:Initialize()
    end

    if not data or not data.Pages or #data.Pages == 0 then return end

    -- Reset state
    currentPage = 0
    maxPage = #data.Pages

    installerFrame.Pages = data.Pages
    installerFrame.StepTitles = data.StepTitles

    installerFrame.StatusBar:SetMinMaxValues(0, maxPage)
    installerFrame.StatusBar:SetValue(0)

    -- Create step buttons
    if data.StepTitles and #data.StepTitles == maxPage then
        if not installerFrame.stepFrame then
            installerFrame.stepFrame = CreateStepFrame(installerFrame)
        end

        local stepFrame = installerFrame.stepFrame
        local buttons = stepFrame.buttons

        -- Create buttons if needed
        if #buttons == 0 then
            for i = 1, maxPage do
                local button = CreateFrame("Button", nil, stepFrame)
                button:SetSize(STEP_FRAME_WIDTH - 20, 28)
                button:SetID(i)
                button:SetScript("OnClick", StepButton_OnClick)

                if i == 1 then
                    button:SetPoint("TOP", stepFrame.title, "BOTTOM", 0, -15)
                else
                    button:SetPoint("TOP", buttons[i - 1], "BOTTOM", 0, -3)
                end

                button.bg = button:CreateTexture(nil, "BACKGROUND")
                button.bg:SetAllPoints()
                button.bg:SetColorTexture(0.2, 0.2, 0.2, 0.4)

                button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
                button.highlight:SetAllPoints()
                button.highlight:SetColorTexture(1, 1, 1, 0.15)
                button:SetHighlightTexture(button.highlight)

                button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                button.text:SetPoint("CENTER")
                button.text:SetJustifyH("CENTER")
                button.text:SetText("")

                buttons[i] = button
            end
        end

        installerFrame:ClearAllPoints()
        installerFrame:SetPoint("CENTER", UIParent, "CENTER", -(STEP_FRAME_WIDTH / 2) - 5, 0)
        installerFrame.stepFrame:Show()
    else
        if installerFrame.stepFrame then
            installerFrame.stepFrame:Hide()
        end
        installerFrame:ClearAllPoints()
        installerFrame:SetPoint("CENTER")
    end

    installerFrame:Show()
    self:SetPage(1)
end

function DOCUI.Installer:Hide()
    if installerFrame then
        installerFrame:Hide()
        if installerFrame.stepFrame then
            installerFrame.stepFrame:Hide()
        end
    end
end

function DOCUI.Installer:Initialize()
    if installerFrame then return end
    installerFrame = CreateMainFrame()
end

-- Build installer pages
local function BuildInstallerData()
    local pages = {}
    local stepTitles = {}
    local pageIndex = 1

    -- Page 1: Welcome
    pages[pageIndex] = function()
        local f = installerFrame
        f.SubTitle:SetText("Welcome")
        f.Desc1:SetText("Welcome to  DOC UI. This wizard will guide you through installing the required layouts and profiles for my UI.")
        f.Desc2:SetText("|cff"..string.format("%02x%02x%02x", DOC_BLUE[1]*255, DOC_BLUE[2]*255, DOC_BLUE[3]*255).."Optimized for 1440p displays|r.")
        f.Desc3:SetText("Click 'Next' to begin or 'Skip' to close this installer.")

        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            DOCUIDB.hasRunBefore = true
            DOCUI.Installer:Hide()
        end)
        f.Option1:SetText("Skip Installation")
    end
    stepTitles[pageIndex] = "Welcome"
    pageIndex = pageIndex + 1

    -- Page 2: Layout Import
    pages[pageIndex] = function()
        local f = installerFrame
        f.SubTitle:SetText("Blizzard Edit Mode Layout")
        f.Desc1:SetText("DOC UI uses Blizzard's built-in Edit Mode.")
        f.Desc2:SetText("We'll attempt to import the layout automatically.")
        f.Desc3:SetText("Click 'Import Layout' to install automatically, or 'Manual Import' if you prefer.")

        -- Automatic import button
        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            if DOCUI.Profiles and DOCUI.Profiles.BlizzardEditMode then
                f.Option1:Disable()
                f.Option1:SetText("Importing...")

                -- Try automatic import
                local success, message = DOCUI.Profiles.BlizzardEditMode:Import()

                f.Option1:Enable()
                f.Option1:SetText("Import Layout")

                if success then
                    -- Success - record and move to next page
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Blizzard Edit Mode"] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S"),
                        method = "automatic"
                    }
                    f.Desc3:SetText("|cff00ff00" .. message .. "|r")
                    C_Timer.After(1, function()
                        DOCUI.Installer:NextPage()
                    end)
                else
                    -- Failed - show error and offer manual import
                    f.Desc3:SetText("|cffffaa00" .. message .. " Use Manual Import instead.|r")
                end
            end
        end)
        f.Option1:SetText("Import Layout")

        -- Manual import option
        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            -- Prepare for manual import (show string on next page)
            DOCUI.EditModeString = DOCUI.Profiles.BlizzardEditMode.layoutData
            DOCUI.EditModeManualImport = true
            DOCUI.Installer:NextPage()
        end)
        f.Option2:SetText("Manual Import")
    end
    stepTitles[pageIndex] = "Layout Selection"
    pageIndex = pageIndex + 1

    -- Page 3: Layout String (only shown if manual import was chosen)
    pages[pageIndex] = function()
        local f = installerFrame

        -- If automatic import succeeded, skip this page
        if not DOCUI.EditModeManualImport and not DOCUI.EditModeString then
            DOCUI.Installer:NextPage()
            return
        end

        -- If we have no string to show (user went backward without choosing manual), go back
        if not DOCUI.EditModeString then
            DOCUI.Installer:PreviousPage()
            return
        end

        f.SubTitle:SetText("Import Layout String")
        f.Desc1:SetText("The layout string is ready! Follow these steps:")
        f.Desc2:SetText("1. Click in the box below\n2. Press Ctrl+A to select all\n3. Press Ctrl+C to copy\n4. Open Edit Mode (ESC -> Edit Mode)\n5. Click 'Import Layout' and paste (Ctrl+V)")

        -- Create edit box if it doesn't exist
        if not f.LayoutEditBox then
            local editBoxFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
            editBoxFrame:SetSize(500, 120)
            editBoxFrame:SetPoint("CENTER", f, "CENTER", 0, -30)
            ApplyBackdrop(editBoxFrame)

            local scrollFrame = CreateFrame("ScrollFrame", nil, editBoxFrame, "UIPanelScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", 8, -8)
            scrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)

            local editBox = CreateFrame("EditBox", nil, scrollFrame)
            editBox:SetMultiLine(true)
            editBox:SetFontObject(ChatFontNormal)
            editBox:SetWidth(460)
            editBox:SetAutoFocus(false)
            editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            scrollFrame:SetScrollChild(editBox)

            f.LayoutEditBox = editBox
            f.LayoutEditBoxFrame = editBoxFrame
        end

        f.LayoutEditBoxFrame:Show()

        if DOCUI.EditModeString then
            f.LayoutEditBox:SetText(DOCUI.EditModeString)
            f.LayoutEditBox:HighlightText()
        end

        -- Record manual import
        DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
        DOCUIDB.installedProfiles["Blizzard Edit Mode"] = {
            installed = true,
            date = date("%Y-%m-%d %H:%M:%S"),
            method = "manual"
        }

        -- Reset flag for next run
        DOCUI.EditModeManualImport = false
    end
    stepTitles[pageIndex] = "Import Blizzard Layout"
    pageIndex = pageIndex + 1

    -- Page 4: Unhalted UnitFrames
    pages[pageIndex] = function()
        local f = installerFrame

        -- Hide edit box if showing
        if f.LayoutEditBoxFrame then
            f.LayoutEditBoxFrame:Hide()
        end

        f.SubTitle:SetText("Unhalted UnitFrames")
        f.Desc1:SetText("DOC UI includes a complete UnitFrames profile for Unhalted UnitFrames.")
        f.Desc2:SetText("This will import the 'DOC UI' profile into your UUF addon.")
        f.Desc3:SetText("Click 'Import Profile' to install, or 'Skip' to continue without UUF.")

        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            if DOCUI.Profiles.UnhaltedUnitFrames then
                -- Disable button while importing
                f.Option1:Disable()
                f.Option1:SetText("Importing...")

                -- Import is synchronous, so we only use the return values (no callback)
                local success, message = DOCUI.Profiles.UnhaltedUnitFrames:Import()

                -- Re-enable button
                f.Option1:Enable()
                f.Option1:SetText("Import Profile")

                if success then
                    -- Success - record and move to next page
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Unhalted UnitFrames"] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S")
                    }
                    DOCUI.Installer:NextPage()
                else
                    -- Show error
                    f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
                end
            end
        end)
        f.Option1:SetText("Import Profile")

        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            DOCUI.Installer:NextPage()
        end)
        f.Option2:SetText("Skip UUF")
    end
    stepTitles[pageIndex] = "Unhalted Uniframes"
    pageIndex = pageIndex + 1

    -- Page 5: Better Cooldown Manager
    pages[pageIndex] = function()
        local f = installerFrame

        f.SubTitle:SetText("Better Cooldown Manager")
        f.Desc1:SetText("DOC UI includes a complete profile for Better Cooldown Manager.")
        f.Desc2:SetText("This will import the 'DOC UI' profile into your Better Cooldown Manager addon.")
        f.Desc3:SetText("Click 'Import Profile' to install, or 'Skip' to continue without BCDM.")

        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            if DOCUI.Profiles.BetterCooldownManager then
                -- Disable button while importing
                f.Option1:Disable()
                f.Option1:SetText("Importing...")

                -- Import is synchronous, so we only use the return values
                local success, message = DOCUI.Profiles.BetterCooldownManager:Import()

                -- Re-enable button
                f.Option1:Enable()
                f.Option1:SetText("Import Profile")

                if success then
                    -- Success - record and move to next page
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Better Cooldown Manager"] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S")
                    }
                    DOCUI.Installer:NextPage()
                else
                    -- Show error
                    f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
                end
            end
        end)
        f.Option1:SetText("Import Profile")

        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            DOCUI.Installer:NextPage()
        end)
        f.Option2:SetText("Skip BCDM")
    end
    stepTitles[pageIndex] = "Better Cooldown Manager"
    pageIndex = pageIndex + 1

    -- Page 6: Platynator
    pages[pageIndex] = function()
        local f = installerFrame

        f.SubTitle:SetText("Platynator (Plater Nameplates)")
        f.Desc1:SetText("DOC UI includes Jundies' Platynator profile for nameplate styling.")
        f.Desc2:SetText("This will import the 'Jundies' profile into your Platynator addon.")
        f.Desc3:SetText("Click 'Import Profile' to install, or 'Skip' to continue without Platynator.")

        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            if DOCUI.Profiles.Platynator then
                -- Disable button while importing
                f.Option1:Disable()
                f.Option1:SetText("Importing...")

                -- Import is synchronous, so we only use the return values
                local success, message = DOCUI.Profiles.Platynator:Import()

                -- Re-enable button
                f.Option1:Enable()
                f.Option1:SetText("Import Profile")

                if success then
                    -- Success - record and move to next page
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Platynator"] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S")
                    }
                    DOCUI.Installer:NextPage()
                else
                    -- Show error
                    f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
                end
            end
        end)
        f.Option1:SetText("Import Profile")

        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            DOCUI.Installer:NextPage()
        end)
        f.Option2:SetText("Skip Platynator")
    end
    stepTitles[pageIndex] = "Platynator"
    pageIndex = pageIndex + 1

    -- Page 7: Raid Frame Settings
    pages[pageIndex] = function()
        local f = installerFrame

        f.SubTitle:SetText("Raid Frame Settings")
        f.Desc1:SetText("DOC UI includes a complete profile for Raid Frame Settings.")
        f.Desc2:SetText("This will import the 'DOC UI' profile into your Raid Frame Settings addon.")
        f.Desc3:SetText("Click 'Import Profile' to install, or 'Skip' to continue without RFS.")

        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            if DOCUI.Profiles.RaidFrameSettings then
                f.Option1:Disable()
                f.Option1:SetText("Importing...")

                local success, message = DOCUI.Profiles.RaidFrameSettings:Import()

                f.Option1:Enable()
                f.Option1:SetText("Import Profile")

                if success then
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Raid Frame Settings"] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S")
                    }
                    DOCUI.Installer:NextPage()
                else
                    f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
                end
            end
        end)
        f.Option1:SetText("Import Profile")

        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            DOCUI.Installer:NextPage()
        end)
        f.Option2:SetText("Skip RFS")
    end
    stepTitles[pageIndex] = "Raid Frame Settings"
    pageIndex = pageIndex + 1

    -- Page 8: Details
    pages[pageIndex] = function()
        local f = installerFrame

        f.SubTitle:SetText("Details! Damage Meter")
        f.Desc1:SetText("DOC UI includes a profile for Details! Damage Meter.")
        f.Desc2:SetText("This will import the 'DOCUI' profile into your Details addon.")
        f.Desc3:SetText("Click 'Import Profile' to install, 'Manual Import' to copy the string, or 'Skip'.")

        -- Auto import button
        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            if DOCUI.Profiles.Details then
                f.Option1:Disable()
                f.Option1:SetText("Importing...")

                local success, message = DOCUI.Profiles.Details:Import()

                f.Option1:Enable()
                f.Option1:SetText("Import Profile")

                if success then
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Details"] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S")
                    }
                    DOCUI.Installer:NextPage()
                elseif message == "MANUAL" then
                    -- No API available - fall through to manual
                    DOCUI.DetailsManualImport = true
                    DOCUI.DetailsString = DOCUI.Profiles.Details.importString
                    DOCUI.Installer:NextPage()
                else
                    f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
                end
            end
        end)
        f.Option1:SetText("Import Profile")

        -- Manual import button
        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            DOCUI.DetailsManualImport = true
            DOCUI.DetailsString = DOCUI.Profiles.Details.importString
            DOCUI.Installer:NextPage()
        end)
        f.Option2:SetText("Manual Import")

        -- Skip button
        f.Option3:Show()
        f.Option3:SetScript("OnClick", function()
            DOCUI.DetailsManualImport = false
            DOCUI.DetailsString = nil
            DOCUI.Installer:NextPage()
        end)
        f.Option3:SetText("Skip Details")
    end
    stepTitles[pageIndex] = "Details"
    pageIndex = pageIndex + 1

    -- Page 9: Details Manual Import String
    pages[pageIndex] = function()
        local f = installerFrame

        -- Skip this page if manual import was not requested
        if not DOCUI.DetailsManualImport or not DOCUI.DetailsString then
            DOCUI.Installer:NextPage()
            return
        end

        f.SubTitle:SetText("Import Details Profile String")
        f.Desc1:SetText("The Details profile string is ready! Follow these steps:")
        f.Desc2:SetText("1. Click in the box below and press Ctrl+A, then Ctrl+C to copy\n2. Open Details settings\n3. Find Profiles → Import and paste (Ctrl+V)")

        if not f.LayoutEditBox then
            local editBoxFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
            editBoxFrame:SetSize(500, 120)
            editBoxFrame:SetPoint("CENTER", f, "CENTER", 0, -30)
            ApplyBackdrop(editBoxFrame)

            local scrollFrame = CreateFrame("ScrollFrame", nil, editBoxFrame, "UIPanelScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", 8, -8)
            scrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)

            local editBox = CreateFrame("EditBox", nil, scrollFrame)
            editBox:SetMultiLine(true)
            editBox:SetFontObject(ChatFontNormal)
            editBox:SetWidth(460)
            editBox:SetAutoFocus(false)
            editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            scrollFrame:SetScrollChild(editBox)

            f.LayoutEditBox = editBox
            f.LayoutEditBoxFrame = editBoxFrame
        end

        f.LayoutEditBoxFrame:Show()
        f.LayoutEditBox:SetText(DOCUI.DetailsString)
        f.LayoutEditBox:HighlightText()

        DOCUI.DetailsManualImport = false

        DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
        DOCUIDB.installedProfiles["Details"] = {
            installed = true,
            date = date("%Y-%m-%d %H:%M:%S"),
            method = "manual"
        }
    end
    stepTitles[pageIndex] = "Import Details"
    pageIndex = pageIndex + 1

    -- Page 10: Cooldown Manager Layouts
    pages[pageIndex] = function()
        local f = installerFrame

        -- Hide edit box if showing
        if f.LayoutEditBoxFrame then
            f.LayoutEditBoxFrame:Hide()
        end

        f.SubTitle:SetText("Cooldown Manager Layouts")
        f.Desc1:SetText("DOC UI includes pre-configured layouts for Blizzard's Cooldown Manager.")
        f.Desc2:SetText("These strings setup spells and abilities layouts. Select your spec below.")
        f.Desc3:SetText("You'll need to manually import the string in Blizzard Cooldown Manager.")

        if DOCUI.Profiles.CooldownManager and DOCUI.Profiles.CooldownManager.layouts then
            local layouts = DOCUI.Profiles.CooldownManager.layouts
            local numLayouts = #layouts

            -- Show buttons for each layout
            for i = 1, math.min(numLayouts, 8) do
                local layout = layouts[i]
                local button = f["Option"..i]

                button:Show()
                button:SetText(layout.displayName)

                -- Set class color
                local r, g, b = DOCUI.Profiles.CooldownManager:GetClassColor(layout.class)
                if button.bg then
                    button.bg:SetColorTexture(r * 0.3, g * 0.3, b * 0.3, 0.9)
                end
                if button.text then
                    button.text:SetTextColor(r, g, b)
                end

                button:SetScript("OnClick", function()
                    -- Store the selected layout string
                    DOCUI.CooldownString = layout.importString
                    DOCUI.SelectedCooldownLayout = layout.displayName

                    -- Record it as prepared
                    DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                    DOCUIDB.installedProfiles["Cooldown Manager - " .. layout.displayName] = {
                        installed = true,
                        date = date("%Y-%m-%d %H:%M:%S")
                    }

                    DOCUI.Installer:NextPage()
                end)
            end
        end
    end
    stepTitles[pageIndex] = "Cooldown Manager Layouts"
    pageIndex = pageIndex + 1

    -- Page 9: Cooldown Manager Import String
    pages[pageIndex] = function()
        local f = installerFrame
        f.SubTitle:SetText("Import Cooldown Layout")
        f.Desc1:SetText("The layout string for " .. (DOCUI.SelectedCooldownLayout or "your spec") .. " is ready!")
        f.Desc2:SetText("1. Click in the box below and press Ctrl+A, then Ctrl+C to copy\n2. Open Blizzard Cooldown Manager settings\n3. Find the Import section and paste (Ctrl+V)")

        -- Reuse the edit box
        if not f.LayoutEditBox then
            local editBoxFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
            editBoxFrame:SetSize(500, 120)
            editBoxFrame:SetPoint("CENTER", f, "CENTER", 0, -30)
            ApplyBackdrop(editBoxFrame)

            local scrollFrame = CreateFrame("ScrollFrame", nil, editBoxFrame, "UIPanelScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", 8, -8)
            scrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)

            local editBox = CreateFrame("EditBox", nil, scrollFrame)
            editBox:SetMultiLine(true)
            editBox:SetFontObject(ChatFontNormal)
            editBox:SetWidth(460)
            editBox:SetAutoFocus(false)
            editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            scrollFrame:SetScrollChild(editBox)

            f.LayoutEditBox = editBox
            f.LayoutEditBoxFrame = editBoxFrame
        end

        f.LayoutEditBoxFrame:Show()

        if DOCUI.CooldownString then
            f.LayoutEditBox:SetText(DOCUI.CooldownString)
            f.LayoutEditBox:HighlightText()
        end
    end
    stepTitles[pageIndex] = "Import Cooldown"
    pageIndex = pageIndex + 1

    -- Page 12: Complete
    pages[pageIndex] = function()
        local f = installerFrame

        -- Hide edit box if showing
        if f.LayoutEditBoxFrame then
            f.LayoutEditBoxFrame:Hide()
        end

        f.SubTitle:SetText("Installation Complete!")
        f.Desc1:SetText("DOC UI has been installed successfully!")
        f.Desc2:SetText("To activate all changes, you need to reload your UI.")
        f.Desc3:SetText("You can reopen this installer anytime with |cff00ff00/docui|r")

        -- Create credits frame if it doesn't exist
        if not f.CreditsFrame then
            f.CreditsFrame = CreateFrame("Frame", nil, f)
            f.CreditsFrame:SetSize(540, 100)
            f.CreditsFrame:SetPoint("CENTER", 0, -60)

            local creditsTitle = f.CreditsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            creditsTitle:SetPoint("TOP", 0, 0)
            creditsTitle:SetText("|cff" .. string.format("%02x%02x%02x", DOC_BLUE[1]*255, DOC_BLUE[2]*255, DOC_BLUE[3]*255) .. "Credits|r")
            f.CreditsFrame.title = creditsTitle

            local creditsText = f.CreditsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            creditsText:SetPoint("TOP", creditsTitle, "BOTTOM", 0, -8)
            creditsText:SetWidth(520)
            creditsText:SetJustifyH("CENTER")
            creditsText:SetSpacing(2)
            creditsText:SetText(
                "|cffaaaaaa" ..
                "Unhalted - Creator of Unhalted Unit Frames and Better Cooldown Manager\n" ..
                "Plusmouse - Creator and author of Platynator\n" ..
                "Jundies - His profile we are using for Platynator\n" ..
                "Luckyone - UI wizard and inspiration for having a go at my own installer" ..
                "|r"
            )
            f.CreditsFrame.text = creditsText
        end

        f.CreditsFrame:Show()

        -- Reload UI button (primary action)
        f.Option1:Show()
        f.Option1:SetScript("OnClick", function()
            ReloadUI()
        end)
        f.Option1:SetText("Reload UI Now")

        -- Close button (secondary action)
        f.Option2:Show()
        f.Option2:SetScript("OnClick", function()
            DOCUI.Installer:Hide()
        end)
        f.Option2:SetText("Close")

        -- Mark as complete
        DOCUIDB.hasRunBefore = true
        DOCUIDB.installDate = date("%Y-%m-%d %H:%M:%S")
    end
    stepTitles[pageIndex] = "Complete"

    return {
        Pages = pages,
        StepTitles = stepTitles
    }
end

-- Initialize and show
function DOCUI:OpenInstaller()
    local data = BuildInstallerData()
    DOCUI.Installer:Show(data)
end
