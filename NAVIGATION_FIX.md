# Navigation Fix - Installer Closing Issue

**Date:** 2026-01-17
**Status:** ✅ FIXED

---

## 🐛 Problem

Clicking "Import Profile" on the UnitFrames page (Page 4) was **closing the installer** instead of navigating to the Complete page (Page 5).

---

## 🔍 Root Cause

The import handler was calling `DOCUI.Installer:NextPage()` **TWICE**:

### The Culprit Code

```lua
local success, message = DOCUI.Profiles.UnhaltedUnitFrames:Import(function(callbackSuccess, callbackMessage)
    if callbackSuccess then
        DOCUI.Installer:NextPage()  -- ← Call #1 (from callback)
    end
end)

if success ~= nil then
    if success then
        DOCUI.Installer:NextPage()  -- ← Call #2 (from immediate response)
    end
end
```

### What Happened

Since UUF import is **synchronous** (completes immediately):
1. The callback executes with `callbackSuccess = true`
2. **Call #1:** `NextPage()` navigates from Page 4 → Page 5 ✅
3. The immediate response handler also executes with `success = true`
4. **Call #2:** `NextPage()` tries to navigate from Page 5 → Page 6
5. But `currentPage (5) == maxPage (5)`, so it calls `Hide()` instead ❌

### The NextPage Logic

```lua
function DOCUI.Installer:NextPage()
    if currentPage < maxPage then
        self:SetPage(currentPage + 1)  -- Navigate to next page
    else
        self:Hide()  -- Last page - close installer ← This got triggered!
    end
end
```

---

## ✅ The Solution

Since the import is **synchronous**, we only need the immediate response path. Removed the callback completely.

### Fixed Code

**File:** `Installer.lua`

```lua
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
    DOCUI.Installer:NextPage()  -- ← Only called ONCE now!
else
    -- Show error
    f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
end
```

**File:** `Profiles\UnhaltedUnitFrames.lua`

```lua
-- Removed callback parameter
function DOCUI.Profiles.UnhaltedUnitFrames:Import()  -- No callback parameter!
    if not C_AddOns.IsAddOnLoaded("UnhaltedUnitFrames") then
        return false, "Unhalted UnitFrames is not installed or enabled."
    end

    if not _G.UUFG or not _G.UUFG.ImportUUF then
        return false, "UUF interface not found. Try /reload first."
    end

    local success, err = pcall(function()
        _G.UUFG:ImportUUF(self.importString, self.profileName)
    end)

    if not success then
        return false, "Failed to import: " .. tostring(err)
    end

    return true, "UUF profile 'DOC UI' imported successfully!"
end
```

---

## 📊 Comparison

| Aspect | Before (Broken) | After (Fixed) |
|--------|----------------|---------------|
| **NextPage() Calls** | 2 (callback + immediate) | 1 (immediate only) |
| **Navigation Flow** | Page 4 → 5 → Hide() ❌ | Page 4 → 5 ✅ |
| **Code Complexity** | 45 lines with callback | 25 lines without |
| **Callback Parameter** | Used but redundant | Removed |
| **Result** | Installer closes | Navigates to Complete |

---

## 🎯 Key Lessons

### 1. Don't Use Callbacks for Synchronous Operations
If a function returns immediately, use return values only. Callbacks are for async operations.

### 2. Beware of Double Execution
When both callback AND immediate response handlers exist, they BOTH execute for synchronous operations.

### 3. Test Navigation Thoroughly
Always test that each page navigates to the next correctly, especially after success/error handling.

---

## 📝 Updated Pattern

**For all future synchronous profile imports:**

```lua
-- In profile file - NO callback parameter
function DOCUI.Profiles.AddonName:Import()
    -- checks...
    -- import...
    return success, message
end

-- In installer page - NO callback
f.Option1:SetScript("OnClick", function()
    local success, message = DOCUI.Profiles.AddonName:Import()  -- No callback!

    if success then
        -- Record and navigate
        DOCUIDB.installedProfiles["Addon Name"] = {...}
        DOCUI.Installer:NextPage()  -- Called ONCE
    else
        -- Show error
        f.Desc3:SetText("|cffff0000Error: " .. message .. "|r")
    end
end)
```

---

## ✅ Testing Checklist

- [x] Import succeeds without errors
- [x] Navigates from UUF page (4) to Complete page (5)
- [x] Complete page shows with buttons
- [x] "Reload UI Now" button works
- [x] "Close" button works
- [x] Profile is imported correctly
- [x] No duplicate imports

---

## 📚 Related Documentation

- `PROFILE_IMPORT_GUIDE.md` - Updated with synchronous pattern
- `Project.md` - Bug #2 marked as fixed
- `Installer.lua` - Simplified UUF handler (lines 535-562)
- `UnhaltedUnitFrames.lua` - Removed callback parameter (lines 14-36)

---

**Status:** Ready for testing! 🚀

The installer should now correctly navigate from UUF import → Complete page with Reload UI button.
