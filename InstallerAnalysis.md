# LuckyoneUI Addon Installer - Architecture Analysis

*Analysis Date: 2026-01-17*
*Source: D:\World of Warcraft\_ptr_\Interface\AddOns\LuckyoneUI*

---

## Executive Summary

LuckyoneUI is a production-grade WoW addon installer that demonstrates professional patterns for multi-addon profile distribution. It uses the Ace3 framework, dynamic wizard generation, and conditional feature loading based on game version and installed addons.

**Key Statistics:**
- **Total Size:** ~1.2 MB
- **Profile Data:** 349 KB across 9 addon profiles
- **Libraries:** 561 KB (full Ace3 suite)
- **Code Files:** 106 KB core logic
- **Languages:** 10 localizations supported
- **Installer Pages:** 14 dynamic steps

---

## 1. File Structure & Organization

### Directory Layout
```
LuckyoneUI/
├── Core/                           (106 KB)
│   ├── Init.lua                    - Addon initialization & namespace
│   ├── Core.lua                    - Main logic, events, version checks
│   ├── Installer.lua               - UI wizard framework (788 lines)
│   ├── Defaults.lua                - SavedVariables defaults
│   ├── Config.lua                  - Config panels integration
│   ├── Tags.lua                    - ElvUI custom text tags
│   ├── Themes.lua                  - Color theme manager
│   └── Core.xml                    - File loader
│
├── Profiles/                       (349 KB)
│   ├── ElvUI.lua                   - ElvUI profile (129 KB, 2667 lines)
│   ├── Details.lua                 - Damage meter profiles
│   ├── Plater.lua                  - Nameplate configurations
│   ├── OmniCD.lua                  - Party cooldown settings
│   ├── WindTools.lua               - ElvUI plugin config
│   ├── ShadowLight.lua             - Theme plugin settings
│   ├── BigWigs.lua                 - Boss warning profiles
│   ├── DBM.lua                     - Deadly Boss Mods profiles
│   └── Profiles.xml                - Profile loader
│
├── Modules/                        (85 KB)
│   ├── Auras/                      - Buff/debuff filters
│   ├── Blizzard/                   - CVars, privacy, easy delete
│   ├── Chat/                       - Chat configuration
│   └── Skins/                      - Addon skins
│
├── Libs/                           (561 KB)
│   ├── LibStub/
│   ├── AceAddon-3.0/
│   ├── AceDB-3.0/
│   ├── AceEvent-3.0/
│   ├── AceGUI-3.0/
│   ├── AceConfig-3.0/
│   ├── AceConsole-3.0/
│   ├── LibSharedMedia-3.0/
│   └── LibDBIcon-1.0/
│
├── Locales/                        (79 KB)
│   └── [10 language files]
│
├── Media/
│   ├── Fonts/
│   ├── Textures/
│   └── Sounds/
│
└── LuckyoneUI_Mainline.toc         - Addon manifest
```

---

## 2. TOC File Architecture

**File:** `LuckyoneUI_Mainline.toc`

```toc
## Title: |cff4beb2cLuckyoneUI|r
## Notes: Luckyone's user interface and Addon profiles
## OptionalDeps: ElvUI
## SavedVariables: LuckyoneDB

## DefaultState: enabled
## Author: Luckyone
## Version: 3.32

## Interface: 120000, 110207
## X-Required-ElvUI: 14.06

## X-Curse-Project-ID: 363472
## X-Wago-ID: Rn6VLGdB

## AddonCompartmentFunc: LuckyoneUI_OnAddonCompartmentClick
## IconTexture: Interface\AddOns\LuckyoneUI\Media\Textures\Compartment.png

Libs\Libs.xml
Locales\Locales.xml
Init.lua
Core\Core.xml
Media\Media.lua
Modules\Modules.xml
Profiles\Profiles.xml
```

**Key Elements:**
- **SavedVariables: LuckyoneDB** - Single global variable
- **OptionalDeps: ElvUI** - Gracefully works without ElvUI
- **Multiple Interface versions** - Supports Midnight (120000) and TWW (110207)
- **AddonCompartmentFunc** - Modern WoW addon compartment integration
- **Custom metadata fields** - CurseForge/Wago integration

---

## 3. Profile Data Storage Strategy

### Storage Method
**Lua code with embedded binary-encoded strings** for external addons.

### Profile File Example - BigWigs.lua

```lua
function Private:Setup_BigWigs(layout)
    -- Profile names
    local name_main = 'Luckyone Main'
    local name_healing = 'Luckyone Healing'

    -- Embedded encoded profile string
    local profile_main = 'BW1:TD1sVTrYryozSYUbl2SIswATnKbCcWgSbW7Iy59rGaYdnsKwsREqqsTY2xcB...'

    -- Register via addon API
    if _G.BigWigsAPI then
        BigWigsAPI.RegisterProfile('LuckyoneUI', profile_main, name_main, function()
            -- Callback: hide minimap icon
            if _G.BigWigsIconDB then
                _G.BigWigsIconDB.hide = true
            end
        end)
    end
end
```

### ElvUI Profile Storage - ElvUI.lua

**Direct Lua table embedding** (not encoded):

```lua
function Private:Setup_ElvUI(layout)
    local E = Private.ElvUI[1]
    local profile = E.db

    -- Direct table assignment
    profile.actionbar = {
        bar1 = { enabled = true, buttons = 12, ... },
        bar2 = { enabled = true, buttons = 12, ... },
        -- ... thousands of configuration keys
    }

    profile.unitframe = {
        units = {
            player = { width = 270, height = 60, ... },
            target = { width = 270, height = 60, ... },
            -- ... complete unit frame layouts
        }
    }
end
```

### Profile Types Offered
1. **Main** - DPS & Tank layouts
2. **Healing** - Healer-specific configurations
3. **Support** - Augmentation specialization (Retail only)

### Data Size Comparison
- **ElvUI:** 129 KB (plain Lua tables)
- **Details:** 96 KB (encoded strings)
- **Plater:** 47 KB (encoded strings)
- **OmniCD:** 19 KB (plain Lua tables)

---

## 4. UI Wizard Framework

**File:** `Core/Installer.lua` (788 lines)

### Frame Structure
```
LuckyoneInstaller (550×400 px)
├── Logo & Title
│   └── "LuckyoneUI Installation"
├── SubTitle (dynamic per page)
├── Description Blocks (4 text areas)
│   ├── Desc1
│   ├── Desc2
│   ├── Desc3
│   └── Desc4
├── Option Buttons (up to 4 per page)
│   ├── Option1
│   ├── Option2
│   ├── Option3
│   └── Option4
├── Step List Sidebar (220px wide)
│   └── [Clickable step titles]
└── Navigation Controls
    ├── Previous Button
    ├── Progress Bar (step/total)
    └── Next Button
```

### Visual Design Tokens
```lua
Background = {0.05, 0.05, 0.05, 0.9}  -- Dark gray, 90% opacity
Border = {0, 0, 0, 1}                  -- Black, 100% opacity
Button = {0.2, 0.2, 0.2, 0.8}          -- Gray button background
ButtonHighlight = {1, 1, 1, 0.15}      -- White 15% highlight
AccentColor = {0.294, 0.921, 0.173}    -- #4beb2c (LuckyoneUI green)
CurrentStep = {0, 0.702, 1}            -- Cyan for active step
Font = "Expressway" with OUTLINE
```

### Key API Functions

```lua
-- Display installer with page data
Installer:Show(data)

-- Navigate to specific page number
Installer:SetPage(pageNum)

-- Progress navigation
Installer:NextPage()
Installer:PreviousPage()

-- Completion trigger
Installer:OnFinish()
```

### Dynamic Page Population

Each page is a function that configures the frame:

```lua
installerFrame.SubTitle:SetText(title)
installerFrame.Desc1:SetText(description)
installerFrame.Option1:Show()
installerFrame.Option1:SetScript('OnClick', function()
    -- Execute setup function
    Private:Setup_Feature(option)
    -- Move to next page
    Installer:NextPage()
end)
```

### Step List Sidebar

- **Dynamically generated** from `StepTitles` table
- **Clickable** - Jump to any step
- **Color-coded:**
  - Current step: Cyan (#00b3ff)
  - Completed: White
  - Upcoming: Gray
- **Auto-scrolling** to keep current step visible

---

## 5. Installation Workflow

### First-Run Detection Flow

```
ADDON_LOADED event
    ↓
Init.lua: Create AceAddon("LuckyoneUI")
    ├── Initialize namespace (Private)
    ├── Load libraries (Ace3)
    └── Create slash commands (/lucky)
    ↓
Core.lua: OnInitialize()
    ├── Load SavedVariables → Private.Addon.db = AceDB:New('LuckyoneDB')
    ├── Register events (PLAYER_LOGIN, PLAYER_ENTERING_WORLD)
    └── Check ElvUI version compatibility
    ↓
PLAYER_LOGIN event
    ├── Check: Private.Addon.db.global.install_version == nil?
    │   └── TRUE: Show Installer (Private.Installer:OnLoad())
    └── FALSE: Skip installer, load normal features
```

### Installation Step Execution

**Page 2: Layout Scale**
```lua
Private:ApplyScale(native)
    SetCVar('useUiScale', 1)
    SetCVar('uiScale', native and 0.533 or 0.711)  -- 1440p vs 1080p
```

**Page 3: ElvUI Layouts**
```lua
Private:Setup_Layout(layout, installer)
    -- Create new profile
    E:SetupProfile(nil, 'Luckyone Main ' .. Private.Version)

    -- Configure ElvUI
    Setup_GlobalDB()      -- Global settings
    Setup_PrivateDB()     -- Private settings
    Setup_ElvUI(layout)   -- Profile-specific config

    -- Refresh UI
    E:UpdateAll(true)
```

**Page 4: ElvUI Filters**
```lua
Private:Setup_Filters(installer)
    -- Route to version-specific function
    if Private.isRetail then
        Setup_Filters_Retail()
    elseif Private.isMists then
        Setup_Filters_Mists()
    -- ... etc

    -- Populate filter IDs
    Add(E.global.unitframe.aurafilters['Buffs'], buffIDs, 'FRIENDLY PLAYER')
```

**Page 10: BigWigs**
```lua
Private:Setup_BigWigs(layout)
    if _G.BigWigsAPI then
        BigWigsAPI.RegisterProfile('LuckyoneUI', profileString, profileName, callback)
    end
```

**Page 14: Completion**
```lua
Private.Addon.db.global.install_version = Private.Version
C_UI.Reload()  -- Force UI reload
```

---

## 6. Library Dependencies

### Ace3 Framework Stack

**Core Libraries:**
- **AceAddon-3.0** - Addon creation and initialization
  - `AceAddon:NewAddon(name, ...)`
  - Module system, enable/disable lifecycle
- **AceEvent-3.0** - Event registration
  - `RegisterEvent(event, callback)`
  - `UnregisterEvent(event)`
- **AceTimer-3.0** - Delay and scheduling
  - `ScheduleTimer(func, delay)`
  - `CancelTimer(handle)`

**Database Management:**
- **AceDB-3.0** - SavedVariables with profiles
  - Per-character, per-realm, global data
  - Profile switching, copying, deletion
  - Default value fallbacks
- **AceDBOptions-3.0** - Profile UI generation
  - "New", "Copy", "Delete" profile dialogs

**UI & Configuration:**
- **AceGUI-3.0** - Widget library (50+ types)
  - Buttons, sliders, checkboxes, dropdowns
  - Containers, frames, tabs
- **AceConfig-3.0** - Options table to UI conversion
  - **AceConfigDialog** - Display options
  - **AceConfigRegistry** - Register options
  - **AceConfigCmd** - Chat command options

**User Interaction:**
- **AceConsole-3.0** - Slash command system
  - `RegisterChatCommand(cmd, func)`
  - Automatic help generation
- **AceLocale-3.0** - Multi-language support
  - Translation key lookup
  - Locale fallback to enUS

### External Libraries

**LibStub** - Library versioning system
```lua
local lib = LibStub:GetLibrary("LibraryName-1.0")
```

**LibDataBroker-1.1** - Data source standard
```lua
LDB:NewDataObject("LuckyoneUI", {
    type = "launcher",
    icon = iconPath,
    OnClick = function() ... end
})
```

**LibDBIcon-1.0** - Minimap icon display
```lua
LDBI:Register("LuckyoneUI", dataObject, savedVars.minimap)
```

**LibSharedMedia-3.0** - Asset registry
```lua
LSM:Register("font", "Expressway", fontPath)
LSM:Fetch("font", "Expressway")
```

### Optional Addon Dependencies

**Listed in OptionalDeps:**
- ElvUI (v14.06+)
- BigWigs or DBM
- Details! Damage Meter
- Plater Nameplates
- OmniCD
- WindTools (ElvUI plugin)
- Shadow & Light (ElvUI plugin)

**Detection Pattern:**
```lua
if _G.ElvUI then
    Private.ElvUI = _G.ElvUI
    -- Enable ElvUI features
end

if _G.BigWigsAPI then
    -- Enable BigWigs profile import
end
```

---

## 7. First-Run Detection System

### Detection Variable
```lua
Private.Addon.db.global.install_version
```

### Default State (Defaults.lua)
```lua
Private.Defaults = {
    global = {
        dev = false,
        install_version = nil,  -- NULL = first run
        scaled = false,
    },
    profile = {
        disabledFrames = { ... },
        minimap = { hide = false },
        qualityOfLife = { ... },
    }
}
```

### Initialization (Core.lua)
```lua
function Private.Addon:OnInitialize()
    -- Create database with defaults
    Private.Addon.db = Private.Libs.ADB:New('LuckyoneDB', Private.Defaults, true)

    -- Register events
    self:RegisterEvent('PLAYER_LOGIN')
end
```

### First-Run Check (Core.lua)
```lua
function Private.Addon:PLAYER_LOGIN()
    -- Initialize minimap icon
    Private.Libs.LDBI:Register(Name, LuckyoneLDB, Private.Addon.db.profile.minimap)

    -- Check compatibility
    Private:CheckElvUI()
    Private:CheckIncompatible()

    -- KEY CHECK: Show installer on first run
    if Private.Installer and (Private.Addon.db.global.install_version == nil) then
        Private.Installer:OnLoad()
    end
end
```

### Completion Marking (Installer.lua)
```lua
function Private.Installer:OnFinish()
    -- Mark installation complete
    Private.Addon.db.global.install_version = Private.Version

    -- Trigger reload
    C_UI.Reload()
end
```

### Version Migration Pattern
```lua
-- Migrate from old addon version
if E.global.L1UI and E.global.L1UI.install_version ~= nil then
    Private.Addon.db.global.install_version = tonumber(E.global.L1UI.install_version)
    E.global.L1UI.install_version = nil  -- Clean up
end
```

### Reinstall Capability
User can manually trigger via slash command:
```lua
SLASH_LUCKYONE1 = "/lucky"
SlashCmdList["LUCKYONE"] = function(msg)
    if msg == "install" then
        Private.Installer:OnLoad()  -- Show installer again
    end
end
```

---

## 8. SavedVariables Architecture

### File Location
```
WTF\Account\<ACCOUNT_NAME>\SavedVariables\LuckyoneDB.lua
```

### Structure - LuckyoneDB

```lua
LuckyoneDB = {
    -- Global settings (per account)
    global = {
        dev = false,                    -- Developer mode
        install_version = 3.32,         -- Installer completion marker
        scaled = false,                 -- UI scale selection (1440p vs 1080p)
        DebugDisabledAddOns = {},       -- Disabled addons in debug mode
    },

    -- Per-character settings
    profileKeys = {
        ['CharName - RealmName'] = 'Default',
    },

    -- Named profiles
    profiles = {
        ['Default'] = {
            disabledFrames = {
                AlertFrame = false,
                BossBanner = false,
                HousingDecorAlerts = false,
                ZoneTextFrame = false,
            },
            minimap = {
                hide = false,
            },
            qualityOfLife = {
                easyDelete = false,         -- Easy item deletion
                privacyOverlay = false,     -- Privacy overlay on screens
            },
            skins = {
                BugSack = false,
                Tabardy = false,
            },
        },
    },
}
```

### AceDB Profile System

**Initialization:**
```lua
Private.Addon.db = Private.Libs.ADB:New('LuckyoneDB', Private.Defaults, true)
```

**Access Patterns:**
```lua
-- Global data (account-wide)
Private.Addon.db.global.scaled

-- Profile data (character-specific via current profile)
Private.Addon.db.profile.minimap.hide

-- Profile management
Private.Addon.db:SetProfile('ProfileName')
Private.Addon.db:CopyProfile('SourceProfile')
Private.Addon.db:DeleteProfile('ProfileName')
```

### External Addon SavedVariables

**BigWigs Icon Storage:**
```lua
-- Auto-created by BigWigs, modified by LuckyoneUI
BigWigsIconDB = {
    hide = true,  -- Hidden via callback after profile import
}
```

**ElvUI Profile Storage:**
```lua
-- ElvUI stores profiles internally
ElvDB = {
    profiles = {
        ['Luckyone Main 3.32'] = {
            -- Thousands of configuration keys
        }
    }
}
```

---

## 9. Installer Page Structure

### InstallerData Table (Installer.lua lines 542-775)

```lua
Private.InstallerData = {
    Title = '|cff4beb2cLuckyoneUI|r Installation',

    Pages = {
        -- Dynamically built array of functions
    },

    StepTitles = {
        -- Populated during page creation
    },

    StepTitlesColor = {1, 1, 1},              -- White
    StepTitlesColorSelected = {0, 0.702, 1},  -- Cyan
}
```

### Page Creation Pattern

```lua
-- Page 1: Welcome
table.insert(Private.InstallerData.Pages, function()
    table.insert(Private.InstallerData.StepTitles, L["Welcome"])

    Private.StepTitleIndex = #Private.InstallerData.StepTitles

    installerFrame.SubTitle:SetText(L["Welcome to LuckyoneUI"])
    installerFrame.Desc1:SetText(L["This installer will guide you..."])
    installerFrame.Desc2:SetText(L["You can skip steps..."])

    installerFrame.Option1:Show()
    installerFrame.Option1:SetText(L["Continue"])
    installerFrame.Option1:SetScript('OnClick', function()
        Private.Installer:NextPage()
    end)
end)
```

### Conditional Page Inclusion

```lua
-- ElvUI-dependent pages
if Private.ElvUI then
    -- Add: ElvUI Layouts page
    -- Add: ElvUI Filters page

    if Private.isRetail then
        -- Add: ElvUI Plugins page (Retail only)
    end

    -- Add: Color Theme page
end

-- Always include
-- Add: Chat page
-- Add: Console Variables page
-- Add: NamePlates page

-- Addon-dependent pages
if _G.BigWigsAPI then
    -- Add: BigWigs page
end

if _G.Details then
    -- Add: Details page
end

if Private.isRetail and _G.OmniCD then
    -- Add: OmniCD page
end
```

### Page Types

1. **Information Pages** - Welcome, completion
   - Single "Continue" button
   - Descriptive text only

2. **Choice Pages** - Layout selection, scale selection
   - 2-4 option buttons
   - Each button triggers setup + navigation

3. **Optional Pages** - Addons not installed
   - "Skip" button
   - "Install Later" guidance text

---

## 10. Setup Function Pattern

### Standard Function Signature
```lua
function Private:Setup_<FeatureName>(option, installer)
    -- Parameter validation
    if not self:IsFeatureAvailable() then
        return
    end

    -- Core logic
    -- ... modify databases, call APIs ...

    -- Visual feedback (if called from installer)
    if installer then
        _G.LuckyoneInstallStepComplete:ShowMessage(L["Feature"] .. ' ' .. option)
    end

    -- Chat feedback
    self:Print(L["Feature configured successfully"])
end
```

### Example: Setup_Layout

```lua
function Private:Setup_Layout(layout, installer)
    if not Private.ElvUI then return end

    local E = Private.ElvUI[1]

    -- Create new profile
    E:SetupProfile(nil, 'Luckyone Main ' .. Private.Version)

    -- Configure ElvUI components
    Private:Setup_GlobalDB()
    Private:Setup_PrivateDB()
    Private:Setup_ElvUI(layout)

    -- Refresh UI
    E:UpdateAll(true)

    -- Feedback
    if installer then
        _G.LuckyoneInstallStepComplete:ShowMessage(L["Layout"] .. ': ' .. layout)
    end

    Private:Print(format(L["Layout %s applied"], layout))
end
```

### Example: Setup_BigWigs

```lua
function Private:Setup_BigWigs(layout)
    if not _G.BigWigsAPI then
        Private:Print(L["BigWigs not installed"])
        return
    end

    local profile_main = 'BW1:TD1sVTrYryozSYUbl...'  -- Encoded string
    local name_main = 'Luckyone Main'

    _G.BigWigsAPI.RegisterProfile('LuckyoneUI', profile_main, name_main, function()
        -- Callback: Hide minimap icon
        if _G.BigWigsIconDB then
            _G.BigWigsIconDB.hide = true
        end
    end)

    Private:Print(L["BigWigs profile imported"])
end
```

### Example: Setup_Chat

```lua
function Private:Setup_Chat(installer)
    -- Set CVars
    SetCVar('chatStyle', 'classic')
    SetCVar('chatMouseScroll', 1)

    -- Create chat windows
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G['ChatFrame'..i]

        if i == 1 then
            -- Configure General chat
            ChatFrame_RemoveAllMessageGroups(chatFrame)
            ChatFrame_AddMessageGroup(chatFrame, "SAY")
            ChatFrame_AddMessageGroup(chatFrame, "YELL")
            -- ... etc
        elseif i == 2 then
            -- Configure Combat Log
            -- ... etc
        end
    end

    if installer then
        _G.LuckyoneInstallStepComplete:ShowMessage(L["Chat configured"])
    end
end
```

---

## 11. Completion Feedback System

### Frame: LuckyoneInstallStepComplete

**File:** `Core/Installer.lua` lines 146-184

```lua
local frame = CreateFrame('Frame', 'LuckyoneInstallStepComplete', UIParent)
frame:SetSize(418, 72)
frame:SetPoint('TOP', 0, -190)
frame:SetFrameStrata('TOOLTIP')
frame:Hide()

-- Background
frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
frame.bg:SetAllPoints()
frame.bg:SetColorTexture(0, 0, 0, 0.8)

-- Icon (checkmark)
frame.icon = frame:CreateTexture(nil, 'ARTWORK')
frame.icon:SetSize(32, 32)
frame.icon:SetPoint('LEFT', 10, 0)
frame.icon:SetTexture([[Interface\RaidFrame\ReadyCheck-Ready]])

-- Text
frame.text = frame:CreateFontString(nil, 'OVERLAY')
frame.text:SetFont(Private.Font, 16, 'OUTLINE')
frame.text:SetPoint('LEFT', frame.icon, 'RIGHT', 10, 0)
frame.text:SetJustifyH('LEFT')
```

### ShowMessage Function

```lua
function frame:ShowMessage(msg)
    -- Play sound
    PlaySound(888)  -- SOUNDKIT.LEVELUP

    -- Set text
    self.text:SetText(format('%s: %s', Private.Name, msg))

    -- Show frame
    self:Show()

    -- Cancel existing timer
    if hideTimer then
        Private.Addon:CancelTimer(hideTimer)
    end

    -- Auto-hide after 3 seconds
    hideTimer = Private.Addon:ScheduleTimer(function()
        self:Hide()
    end, 3)
end
```

### Usage in Installer

```lua
installerFrame.Option1:SetScript('OnClick', function()
    -- Execute setup
    Private:Setup_Layout('Main', true)

    -- Auto-triggered from setup function:
    -- LuckyoneInstallStepComplete:ShowMessage(L["Layout"] .. ': Main')

    -- Navigate
    Private.Installer:NextPage()
end)
```

---

## 12. Version Management & Compatibility

### Version Detection

```lua
-- Addon version
Private.Version = tonumber(GetAddOnMetadata(Name, 'Version'))  -- 3.32

-- Required ElvUI version
Private.RequiredElvUI = tonumber(GetAddOnMetadata(Name, 'X-Required-ElvUI'))  -- 14.06

-- Interface version
Private.InterfaceVersion = select(4, GetBuildInfo())
```

### Game Flavor Detection

```lua
Private.isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
Private.isTBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
Private.isMists = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC
Private.isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Private.isMidnight = Private.InterfaceVersion >= 120000
```

### ElvUI Version Check

```lua
function Private:CheckElvUI()
    if not Private.ElvUI then
        StaticPopup_Show('LUCKYONE_NO_ELVUI')
        return
    end

    local ElvUIVersion = Private.ElvUI[1].version

    if ElvUIVersion < Private.RequiredElvUI then
        StaticPopup_Show('LUCKYONE_ELVUI_OUTDATED')
    end
end
```

### StaticPopup Definitions

```lua
StaticPopupDialogs['LUCKYONE_ELVUI_OUTDATED'] = {
    text = format(L["Your ElvUI version (%s) is outdated. LuckyoneUI requires version %s or newer."],
                  ElvUIVersion, Private.RequiredElvUI),
    button1 = OKAY,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
}
```

### Developer Mode Detection

```lua
function Private:HandleToons()
    local guid = UnitGUID('player')
    local serverID = string.sub(guid, 5, 8)
    local characterID = string.sub(guid, 9, 16)

    -- Check if player is Luckyone (author)
    if characterID == '00000001' then  -- Simplified example
        Private.itsLuckyone = true
        Private.Addon.db.global.dev = true
    end
end
```

---

## 13. Key Takeaways for DOCUI_Installer

### What to Adopt

1. **Ace3 Framework**
   - Professional addon foundation
   - Built-in profile management (AceDB)
   - Reduces custom code significantly

2. **Single SavedVariables Table**
   - `LuckyoneDB` pattern is clean
   - Use: `DOCUI_InstallerDB`

3. **Dynamic Page Generation**
   - Build pages as functions in array
   - Conditional inclusion based on detected addons
   - Allows easy addition of new profiles later

4. **Step List Sidebar**
   - Great UX for showing progress
   - Clickable navigation to any step
   - Visual feedback on completion

5. **Completion Feedback Frame**
   - Toast-style notifications
   - Sound effects for polish
   - Auto-hide timers

6. **Setup Function Pattern**
   - Standardized signatures
   - `if installer then` branching for feedback
   - Error handling with pcall()

7. **Version-Based First-Run**
   - `install_version = nil` detection
   - Clean and simple
   - Supports reinstall via command

### What to Simplify

1. **Reduce Profile Count**
   - LuckyoneUI: 9 addon profiles
   - DOCUI: 2 profiles (CooldownManager + UUF)
   - Much simpler implementation

2. **Skip Localization Initially**
   - LuckyoneUI: 10 languages (79 KB)
   - DOCUI: Start with enUS only
   - Add translations later if needed

3. **Minimal Module System**
   - LuckyoneUI: Separate Auras, Blizzard, Chat modules
   - DOCUI: Single ImportEngine.lua sufficient

4. **No Ace3 Framework Required**
   - LuckyoneUI needs it for ElvUI integration depth
   - DOCUI can use vanilla WoW API
   - Saves 561 KB of libraries

5. **Simpler Wizard UI**
   - 5 pages vs 14 pages
   - No sidebar needed (progress bar sufficient)
   - Fewer conditional branches

### Critical Patterns to Implement

1. **Profile String Handling**
   - Store as Lua strings in `Profiles/` directory
   - For UUF: Research exact format needed
   - For CooldownManager: Convert JSON to Lua table

2. **Addon Detection**
   - `C_AddOns.IsAddOnLoaded('AddonName')`
   - Check before import attempts
   - Graceful skip with warnings

3. **SavedVariables Manipulation**
   ```lua
   if not CooldownManagerDB then
       CooldownManagerDB = {profiles = {}}
   end
   CooldownManagerDB.profiles["DOC UI"] = profileData
   ```

4. **Profile Activation**
   ```lua
   local playerKey = UnitName("player") .. " - " .. GetRealmName()
   CooldownManagerDB.profileKeys[playerKey] = "DOC UI"
   ```

5. **Reload Trigger**
   ```lua
   C_UI.Reload()  -- Modern API (Retail)
   ReloadUI()     -- Classic API
   ```

---

## 14. Implementation Roadmap Comparison

### LuckyoneUI Complexity
- **14 installer pages**
- **9 addon integrations**
- **Multi-version support** (Classic, TBC, Mists, Retail)
- **Full Ace3 framework**
- **10 localizations**
- **Custom ElvUI modules**
- **1.2 MB total size**

### DOCUI_Installer Simplicity
- **5 installer pages**
- **2 addon integrations**
- **Single version** (Retail/Midnight only)
- **Vanilla WoW API**
- **English only**
- **No custom modules**
- **~100 KB estimated size**

### Shared Architecture
- ✅ Multi-page wizard UI
- ✅ First-run detection via SavedVariables
- ✅ Profile data embedded in Lua
- ✅ Addon detection with graceful fallback
- ✅ Progress feedback during import
- ✅ Completion screen with reload prompt
- ✅ Slash command to reopen

---

## Conclusion

LuckyoneUI represents a **production-grade, feature-complete addon installer** with extensive addon integrations and professional polish. For DOCUI_Installer, we can adopt the core architectural patterns while significantly simplifying the implementation due to our smaller scope (2 profiles vs 9, single version vs 4, no deep ElvUI integration).

**Key Success Factors:**
1. Clean separation of concerns (Core, Profiles, UI)
2. Embedded profile data as Lua code
3. Dynamic wizard with conditional pages
4. Graceful handling of missing addons
5. Simple first-run detection
6. Professional user feedback systems

**Recommended Approach for DOCUI:**
- Use the wizard UI pattern but simplified (5 pages, no sidebar)
- Adopt the SavedVariables structure (`DOCUI_InstallerDB`)
- Implement setup function pattern with feedback
- Skip Ace3 framework (vanilla API sufficient)
- Focus on polish: sounds, visual feedback, clear instructions
- Test thoroughly with both addons present and missing
