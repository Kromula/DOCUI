# Profile Import Implementation Guide

**Purpose:** Reference guide for implementing profile imports for other addons

**Working Example:** Unhalted UnitFrames (UUF) - Successfully implemented 2026-01-17

---

## ✅ Working Method: Global Interface Pattern

### Overview
Most modern addons expose a **global interface** (not their internal namespace) for import/export functionality. This is the pattern to follow for all profile imports.

### Implementation Pattern

#### 1. Research the Target Addon

**Find the global interface:**
```lua
-- Check addon directory for files like:
- Core/Globals.lua
- Core/Config/Share.lua
- Core/Export.lua
- Core/Import.lua
```

**Look for global table initialization:**
```lua
-- Good: Global (no 'local')
AddonG = AddonG or {}

-- Bad: Local (not accessible)
local _, Addon = ...
```

#### 2. Find the Import Function

**Example from UUF (`Core/Config/Share.lua`):**
```lua
function UUFG:ImportUUF(importString, profileKey)
    local DecodedInfo = Compress:DecodeForPrint(importString:sub(6))
    local DecompressedInfo = Compress:DecompressDeflate(DecodedInfo)
    local success, profileData = Serialize:Deserialize(DecompressedInfo)

    if not success or type(profileData) ~= "table" then
        print("Invalid Import String.")
        return
    end

    if type(profileData.profile) == "table" then
        UUF.db.profiles[profileKey] = profileData.profile
        UUF.db:SetProfile(profileKey)
    end
end
```

**Key points:**
- Function signature: `GlobalInterface:ImportFunction(importString, profileName)`
- Takes encoded import string
- Handles decoding/decompression internally
- Sets profile as active automatically

#### 3. Implementation Template

```lua
-- DOC UI - [AddonName] Profile

DOCUI = DOCUI or {}
DOCUI.Profiles = DOCUI.Profiles or {}
DOCUI.Profiles.[AddonName] = {}

-- Profile Name
DOCUI.Profiles.[AddonName].profileName = "DOC UI"

-- Import String (from addon's export function)
DOCUI.Profiles.[AddonName].importString = [[!ADDON_encoded_string_here...]]

-- Import function (synchronous - no callback needed)
function DOCUI.Profiles.[AddonName]:Import()
    -- Step 1: Check if addon is loaded
    if not C_AddOns.IsAddOnLoaded("[AddonName]") then
        return false, "[AddonName] is not installed or enabled."
    end

    -- Step 2: Check if global interface exists
    if not _G.[AddonGlobal] or not _G.[AddonGlobal].[ImportFunction] then
        return false, "[AddonName] interface not found. Try /reload first."
    end

    -- Step 3: Import using addon's API
    local success, err = pcall(function()
        _G.[AddonGlobal]:[ImportFunction](self.importString, self.profileName)
    end)

    if not success then
        return false, "Failed to import: " .. tostring(err)
    end

    -- Step 4: Success
    return true, "[AddonName] profile 'DOC UI' imported successfully!"
end
```

---

## 📋 Checklist for New Profile Imports

### Research Phase
- [ ] Install addon and test export functionality
- [ ] Export a test profile to get import string format
- [ ] Locate addon source files (GitHub/CurseForge)
- [ ] Find global interface table (search for `= {} ` without `local`)
- [ ] Identify import function signature
- [ ] Note any special requirements (dependencies, file format, etc.)

### Implementation Phase
- [ ] Create `Profiles\[AddonName].lua`
- [ ] Embed profile name and import string
- [ ] Implement `Import()` function using template above
- [ ] Add profile to TOC file load order
- [ ] Add installer page for the addon

### Testing Phase
- [ ] Test global availability: `/run print(_G.[AddonGlobal] ~= nil)`
- [ ] Test function exists: `/run print(type(_G.[AddonGlobal].[ImportFunction]))`
- [ ] Test import via installer
- [ ] Verify profile appears in addon settings
- [ ] Visual verification of imported settings

---

## 🎯 Example Implementations

### 1. Unhalted UnitFrames ✅ WORKING

**Global Interface:** `UUFG`
**Import Function:** `UUFG:ImportUUF(importString, profileKey)`
**Import String Format:** `!UUF_` prefix + base64 encoded data

**File:** `Profiles\UnhaltedUnitFrames.lua`
```lua
function DOCUI.Profiles.UnhaltedUnitFrames:Import(callback)
    if not C_AddOns.IsAddOnLoaded("UnhaltedUnitFrames") then
        return false, "Not installed"
    end

    if not _G.UUFG or not _G.UUFG.ImportUUF then
        return false, "Interface not found"
    end

    local success, err = pcall(function()
        _G.UUFG:ImportUUF(self.importString, self.profileName)
    end)

    return success, success and "Success!" or tostring(err)
end
```

**Success Rate:** 100% ✅

---

## 🔍 Common Addon Patterns

### Pattern 1: Global Interface (RECOMMENDED)
**Examples:** Plater, Details, OmniCD, WeakAuras
```lua
-- Addon exposes global table
PlaterGlobal = PlaterGlobal or {}
function PlaterGlobal:ImportProfile(string, name) ... end
```

**Pros:**
- ✅ Easy to access
- ✅ No dependencies needed
- ✅ Designed for external use
- ✅ Stable API

### Pattern 2: AceAddon Access
**Examples:** ElvUI, DBM (with LibStub)
```lua
-- Access via LibStub
local AceAddon = LibStub("AceAddon-3.0")
local Addon = AceAddon:GetAddon("AddonName")
Addon:ImportProfile(string, name)
```

**Pros:**
- ✅ Official addon instance
- ✅ Full API access

**Cons:**
- ❌ Requires LibStub dependency
- ❌ More complex

### Pattern 3: Direct SavedVariables (FALLBACK)
**When to use:** No import API exists
```lua
-- Decode manually and write to SavedVariables
local Serialize = LibStub:GetLibrary("AceSerializer-3.0")
local Compress = LibStub:GetLibrary("LibDeflate")

local decoded = Compress:DecodeForPrint(string)
local decompressed = Compress:DecompressDeflate(decoded)
local success, data = Serialize:Deserialize(decompressed)

AddonDB.profiles["DOC UI"] = data.profile
AddonDB.profileKeys[playerKey] = "DOC UI"
```

**Pros:**
- ✅ Works when no API exists

**Cons:**
- ❌ Requires LibStub + libraries
- ❌ May break on addon updates
- ❌ Requires `/reload` to see changes

---

## ⚠️ What NOT to Do

### ❌ Don't Use Local Namespaces
```lua
-- This will NEVER work:
if not _G.AddonInternalNamespace then
    -- Retry logic here - POINTLESS!
end
```

**Why it fails:** Local variables are never exposed to `_G`

### ❌ Don't Create Retry Mechanisms
```lua
-- Bad: Unnecessary complexity
for i = 1, 10 do
    C_Timer.After(i * 0.5, function()
        if _G.Addon then
            -- Import here
        end
    end)
end
```

**Why it's bad:**
- If global exists, it exists on addon load (no wait needed)
- If it doesn't exist, it never will (no amount of waiting helps)
- Adds 5+ seconds of delay for no reason

### ❌ Don't Assume API Names
```lua
-- Don't guess:
_G.Addon:Import()  -- Maybe it's ImportProfile()?
_G.Addon:SetProfile()  -- Maybe it's LoadProfile()?
```

**Always check the source code!**

---

## 📝 Adding to Installer

### 1. Create Profile File
```lua
-- Profiles\AddonName.lua
DOCUI.Profiles.AddonName = {
    profileName = "DOC UI",
    importString = [[...encoded data...]],
    Import = function(self, callback) ... end
}
```

### 2. Add to TOC
```toc
# Profile Data
Profiles\BlizzardEditMode.lua
Profiles\UnhaltedUnitFrames.lua
Profiles\AddonName.lua          ← Add here
```

### 3. Add Installer Page

**IMPORTANT:**
- Always call `DOCUI.Installer:NextPage()` on success to navigate to the next page
- **For synchronous imports:** Only use return values (no callback) to avoid calling NextPage() twice!

```lua
-- In Installer.lua, add new page:
pages[pageIndex] = function()
    local f = installerFrame

    f.SubTitle:SetText("[Addon Name]")
    f.Desc1:SetText("Profile description here...")
    f.Desc2:SetText("Click 'Import Profile' to install, or 'Skip' to continue.")

    -- Import button
    f.Option1:Show()
    f.Option1:SetScript("OnClick", function()
        if DOCUI.Profiles.AddonName then
            -- Disable button while importing
            f.Option1:Disable()
            f.Option1:SetText("Importing...")

            -- Import (synchronous - returns immediately)
            local success, message = DOCUI.Profiles.AddonName:Import()

            -- Re-enable button
            f.Option1:Enable()
            f.Option1:SetText("Import Profile")

            if success then
                -- Success - record and navigate
                DOCUIDB.installedProfiles = DOCUIDB.installedProfiles or {}
                DOCUIDB.installedProfiles["Addon Name"] = {
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

    -- Skip button
    f.Option2:Show()
    f.Option2:SetScript("OnClick", function()
        DOCUI.Installer:NextPage()
    end)
    f.Option2:SetText("Skip")
end
stepTitles[pageIndex] = "[Addon Name]"
pageIndex = pageIndex + 1
```

**Why no callback?**
- Most profile imports are **synchronous** (complete immediately)
- Using both callback AND return values causes `NextPage()` to be called twice
- First call: navigates to next page ✅
- Second call: tries to navigate again, hits maxPage limit, calls `Hide()` ❌

---

## 🎓 Summary

### The Winning Formula
1. ✅ Find the **global interface** (e.g., `UUFG`, `PlaterGlobal`)
2. ✅ Use the addon's **import function** (read the source!)
3. ✅ Keep it **simple** (no retries, no delays)
4. ✅ Handle **errors gracefully** with pcall
5. ✅ Support **callbacks** for async operations

### Remember
- **Global interfaces exist on addon load** - no waiting needed
- **Read the source code** - don't guess API names
- **Use pcall** - catch errors safely
- **Test in-game** - verify globals exist before release

---

**Reference Implementations:**
- ✅ Working: `Profiles\UnhaltedUnitFrames.lua`
- 📚 Full Analysis: `UUF_TROUBLESHOOTING.md`

---

## 🎨 Complete Page Pattern

The final page should always have buttons to finish the installation:

```lua
-- Page: Complete
pages[pageIndex] = function()
    local f = installerFrame

    f.SubTitle:SetText("Installation Complete!")
    f.Desc1:SetText("DOC UI has been installed successfully!")
    f.Desc2:SetText("To activate all changes, you need to reload your UI.")
    f.Desc3:SetText("You can reopen this installer anytime with /docui")

    -- Primary action: Reload UI
    f.Option1:Show()
    f.Option1:SetScript("OnClick", function()
        ReloadUI()
    end)
    f.Option1:SetText("Reload UI Now")

    -- Secondary action: Close
    f.Option2:Show()
    f.Option2:SetScript("OnClick", function()
        DOCUI.Installer:Hide()
    end)
    f.Option2:SetText("Close")

    -- Mark as complete
    DOCUIDB.hasRunBefore = true
    DOCUIDB.installDate = date("%Y-%m-%d %H:%M:%S")
end
```

**Why this matters:**
- ✅ Users know installation is complete
- ✅ Clear next action (reload)
- ✅ Option to reload later (close)
- ✅ Professional UX

---

**Last Updated:** 2026-01-17
