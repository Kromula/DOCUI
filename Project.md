# DOC UI Installer - Project Tracker

**Project Type:** World of Warcraft Addon Installer
**Target Version:** Retail - Midnight (11.2.0+)
**Development Location:** `D:\World of Warcraft\_ptr_\Interface\AddOns\DOCUI\`
**Repository:** `E:\Claude Dev\DOCUI\` (source profiles)

---

## 📋 Project Overview

A streamlined WoW addon installer for distributing DOC UI profiles. Users run the installer once on first login, select which profiles to import, and the addon automatically configures supported addons with pre-built layouts and settings.

**Target Addons:**
1. **Blizzard Edit Mode** - Native UI layout system (11.0+)
2. **Unhalted UnitFrames (UUF)** - Custom unit frame addon

---

## ✅ Completed Features

### Core Infrastructure
- [x] TOC file configuration (Interface: 120000, 120001)
- [x] SavedVariables setup (`DOCUIDB`)
- [x] Core initialization system (`Core/Init.lua`)
- [x] First-run detection mechanism
- [x] Slash command registration (`/docui`)
- [x] Addon renamed from DOCUI_Installer to DOCUI

### Installer UI Framework
- [x] Main installer frame (600x450px)
- [x] Dark themed backdrop with DOC blue accents (#1e95e3)
- [x] Multi-page wizard system
- [x] Navigation controls (Previous/Next buttons)
- [x] Progress bar with step counter
- [x] Dynamic option button layout system
- [x] Page reset and cleanup functions

### Profile Data
- [x] Blizzard Edit Mode profile embedded (`Profiles/BlizzardEditMode.lua`)
- [x] UUF profile embedded (`Profiles/UnhaltedUnitFrames.lua`)
- [x] Import string generation for Edit Mode

### Installer Pages
- [x] **Page 1:** Welcome screen
- [x] **Page 2:** Blizzard Edit Mode preparation
- [x] **Page 3:** Edit Mode import string (copyable EditBox)
- [x] **Page 4:** UUF programmatic import (FIXED - uses UUFG global)
- [x] **Page 5:** Completion screen with Reload UI button

---

## 🚧 In Progress

### UUF Programmatic Import
**Status:** ✅ FIXED!
**Solution:** Use `_G.UUFG` instead of `_G.UUF`
**Files:**
- `UUF_TROUBLESHOOTING.md` - Complete root cause analysis
- `UUF_IMPORT_NOTES.md` - Investigation history (deprecated)

**What Was Wrong:**
- Used `_G.UUF` which is a local variable in UUF addon, never global
- Retry mechanism was pointless - `_G.UUF` would never exist

**The Fix:**
- Changed to `_G.UUFG:ImportUUF(importString, profileName)`
- `UUFG` IS global (`UUFG = UUFG or {}` in UUF's Globals.lua)
- No retry mechanism needed - works immediately
- 42 lines of code vs 54 lines (simpler and cleaner)

**Testing Needed:**
1. Verify `_G.UUFG` is available on addon load
2. Test import functionality in-game
3. Confirm profile appears in UUF settings
4. Verify unit frames use imported layout

---

## 🎯 Planned Features

### Phase 1: Core Functionality
- [x] Complete UUF programmatic import ✅ FIXED (uses UUFG global)
- [ ] Add addon detection page (Page 2)
  - Check for UUF installation
  - Show warnings if missing
  - Provide CurseForge/Wago links
- [ ] Add profile selection page (Page 3)
  - Checkboxes for Blizzard Edit Mode
  - Checkboxes for UUF
  - "Select All" / "Deselect All" buttons
- [ ] Enhance completion page (Page 5)
  - Import summary (X of Y profiles installed)
  - "Reload UI Now" button
  - "Close" button
  - Next steps guidance

### Phase 2: Polish & UX
- [ ] Step indicator sidebar (similar to LuckyoneUI)
  - Show all 5 steps
  - Highlight current step
  - Click to jump between steps
- [ ] Completion toast notifications
  - "Profile imported successfully" messages
  - Sound effects on success
  - Auto-hide after 3 seconds
- [ ] Error handling improvements
  - Graceful failure messages
  - Retry options for failed imports
  - Detailed error logging
- [ ] Visual polish
  - Animated transitions between pages
  - Loading spinners during imports
  - Better button hover states

### Phase 3: Additional Profiles
- [ ] Add Cooldown Manager profile support
  - Convert JSON to Lua table
  - Implement direct SavedVariables write
  - Add to profile selection page
- [ ] Add Plater nameplate profile (if available)
- [ ] Add WeakAuras import strings (if available)

### Phase 4: Advanced Features
- [ ] Version checking and updates
  - Detect if profiles have been updated
  - Offer to reimport updated profiles
  - Migration system for breaking changes
- [ ] Profile backup system
  - Backup existing profiles before overwriting
  - Restore previous profiles option
- [ ] Custom import strings
  - Allow users to paste their own strings
  - Validate format before import
- [ ] Profile previews
  - Screenshots of layouts
  - Feature descriptions
  - Resolution recommendations

---

## 🐛 Known Bugs

### Critical
1. **UUF Import Failure** ✅ FIXED
   - **Severity:** ~~High~~ Resolved
   - **Impact:** ~~Core feature not working~~ Now working
   - **Status:** Fixed (2026-01-17)
   - **File:** `UUF_TROUBLESHOOTING.md`
   - **Description:** Was using `_G.UUF` (local variable) instead of `_G.UUFG` (global). Fixed by changing to `UUFG:ImportUUF()` API.
   - **Root Cause:** UUF uses local namespace `local _, UUF = ...` which is never exposed globally. UUFG is the public interface.
   - **Code Changes:** `Profiles\UnhaltedUnitFrames.lua` - Removed retry mechanism, simplified to use UUFG

### Medium
2. **Installer Closing After UUF Import** ✅ FIXED
   - **Severity:** ~~High~~ Resolved
   - **Impact:** ~~Installer closed instead of showing Complete page~~ Now navigates correctly
   - **Status:** Fixed (2026-01-17)
   - **Description:** Import handler was calling NextPage() TWICE - once from callback, once from immediate response. Second call hit maxPage limit and called Hide().
   - **Root Cause:** UUF import is synchronous but was using both callback and immediate response handlers
   - **Code Changes:** `Installer.lua` - Removed callback, only use synchronous return values

3. **Complete Page Missing Buttons** ✅ FIXED
   - **Severity:** ~~Medium~~ Resolved
   - **Impact:** ~~No way to finish installation~~ Now has Reload/Close buttons
   - **Status:** Fixed (2026-01-17)
   - **Description:** Complete page had no buttons defined, making it unclear what to do next
   - **Code Changes:** `Installer.lua` - Added "Reload UI Now" and "Close" buttons to Complete page

4. **No SavedVariables Validation**
   - **Severity:** Medium
   - **Impact:** Could cause issues if SavedVariables are corrupted
   - **Description:** Installer doesn't validate `DOCUIDB` structure before use
   - **Risk:** First-run detection might fail if SavedVariables are malformed
   - **Fix:** Add validation in `Core/Init.lua`

5. **Missing Addon Detection**
   - **Severity:** Medium
   - **Impact:** Users might try to import profiles for addons they don't have
   - **Description:** No dedicated addon detection page before profile selection
   - **Status:** Planned for Phase 1
   - **Current State:** Assumes addons are installed

### Low
6. **No Import Logging**
   - **Severity:** Low
   - **Impact:** Difficult to debug failed imports
   - **Description:** No persistent log of import operations
   - **Suggestion:** Add `DOCUIDB.logs` table with timestamped entries

7. **Progress Bar Doesn't Update During Import**
   - **Severity:** Low
   - **Impact:** UX - users don't see visual feedback
   - **Description:** Progress bar is static, doesn't animate during operations
   - **Suggestion:** Add incremental updates during import steps

---

## 💡 Enhancement Ideas

### User Experience
- **Dark Mode Toggle:** Allow users to switch between dark/light themes
- **Compact Mode:** Smaller installer window option for lower resolutions
- **Tutorial Mode:** First-time tips explaining each step
- **Import History:** Show when profiles were last imported
- **Profile Switcher:** Quick-switch between imported profiles

### Technical Improvements
- **Ace3 Framework:** Consider adopting for professional foundation
  - Pros: AceDB (profile management), AceGUI (widgets), AceConfig (options)
  - Cons: 561 KB library size, learning curve
  - Decision: Current vanilla API approach working well, skip for now
- **Localization Support:** Multi-language installer (deDE, frFR, esES, etc.)
- **Modular Architecture:** Break `Installer.lua` into separate page files
- **Unit Tests:** Automated testing for import functions
- **CI/CD Pipeline:** GitHub Actions for automated releases

### Distribution
- **CurseForge Release:** Package and upload to CurseForge
- **Wago.io Release:** Alternative distribution platform
- **GitHub Releases:** Direct download from repository
- **Update Checker:** In-game notification when new version available
- **Changelog Display:** Show what's new in each version

---

## 📦 File Structure

```
DOCUI/
├── DOCUI.toc                         # Addon manifest
├── Core/
│   └── Init.lua                      # Initialization & first-run detection
├── Profiles/
│   ├── BlizzardEditMode.lua          # Native UI layout profile
│   └── UnhaltedUnitFrames.lua        # UUF profile + import logic
├── Installer.lua                     # Main wizard UI (396 lines)
└── UUF_IMPORT_NOTES.md              # Investigation notes (work in progress)
```

**Total Size:** ~35 KB (excluding notes)

---

## 🔬 Technical Decisions

### Why Vanilla API Instead of Ace3?
- **Simplicity:** Only 2 profiles vs LuckyoneUI's 9
- **Size:** Avoid 561 KB library overhead
- **Learning Curve:** Vanilla API is simpler for small scope
- **Maintainability:** Less dependencies = easier to maintain

### Why "DOCUI" Instead of "DOCUI_Installer"?
- **Cleaner:** Shorter, more memorable addon name
- **Branding:** Matches the "DOC UI" brand
- **SavedVariables:** `DOCUIDB` is cleaner than `DOCUI_InstallerDB`
- **User-Facing:** Appears as "DOC UI" in addon list

### Why Manual Edit Mode Import?
- **Blizzard Limitation:** No programmatic API for Edit Mode imports in 11.2
- **User Control:** Users can see exactly what they're importing
- **Reliability:** Copy-paste method guaranteed to work
- **Future-Proof:** If Blizzard adds API, we can switch

### Profile Data Format
- **Edit Mode:** Layout string (encoded by Blizzard)
- **UUF:** Import string with `!UUF_` prefix (LibDeflate + AceSerializer)
- **Storage:** Embedded as Lua strings in profile files
- **No External Files:** Everything in addon directory

---

## 🧪 Testing Checklist

### Before Each Release
- [ ] Fresh install test (delete SavedVariables)
- [ ] First-run detection works
- [ ] Installer auto-opens on first login
- [ ] `/docui` command reopens installer
- [ ] All pages navigate correctly
- [ ] Blizzard Edit Mode import string copies correctly
- [ ] UUF import works (or skip button functions)
- [ ] Completion page shows correct status
- [ ] `/reload` doesn't break installer state
- [ ] Profiles visible in respective addons after import

### Addon Presence Tests
- [ ] Test with UUF installed and enabled
- [ ] Test with UUF disabled
- [ ] Test with UUF not installed
- [ ] Test with both profiles working
- [ ] Test with one profile failing

### Edge Cases
- [ ] Multiple characters on same account
- [ ] Cross-realm characters
- [ ] Reinstalling profiles (overwrite existing)
- [ ] Corrupted SavedVariables
- [ ] Very first login (no WTF folder yet)

---

## 📚 Documentation Needs

### User Documentation
- [ ] README.md for repository
  - Installation instructions
  - Usage guide
  - FAQ section
  - Troubleshooting guide
- [ ] In-game help system
  - `/docui help` command
  - Tooltips on UI elements
  - What each profile does
- [ ] Video tutorial
  - Installation walkthrough
  - Import demonstration
  - Profile showcase

### Developer Documentation
- [ ] Code comments in all files
- [ ] Architecture overview
- [ ] How to add new profiles
- [ ] How to debug import issues
- [ ] Contributing guidelines

---

## 📊 Metrics to Track

### Success Metrics
- Number of successful imports
- Number of failed imports
- Most popular profile
- Time to complete installation
- Number of reinstalls

### Error Metrics
- UUF import failure rate
- SavedVariables corruption rate
- Addon detection failures
- User-reported bugs

### Usage Metrics
- `/docui` command usage
- Average pages viewed
- Skip button usage
- Completion rate

---

## 🔗 Resources

### Reference Addons
- **LuckyoneUI:** `D:\World of Warcraft\_ptr_\Interface\AddOns\LuckyoneUI`
  - Comprehensive analysis: `E:\Claude Dev\DOCUI\InstallerAnalysis.md`
- **ElvUI:** Industry standard for UI replacements
- **WeakAuras Companion:** Example of import string handling

### Documentation
- **WoW API:** https://warcraft.wiki.gg/wiki/World_of_Warcraft_API
- **Ace3 Docs:** https://www.wowace.com/projects/ace3
- **LibStub:** https://www.wowace.com/projects/libstub
- **UUF Import Logic:** `UnhaltedUnitFrames\Core\Config\Share.lua`

### Tools
- **BugSack:** In-game Lua error viewer
- **BugGrabber:** Error capture addon
- **Bugsack:** Development debugging
- **VS Code:** With WoW API autocomplete extensions

---

## 🎯 Current Sprint Goals

### Sprint 1: Core Functionality (Current)
**Goal:** Get basic installer working with at least one profile
**Duration:** In progress
**Priority:** Fix UUF import or implement fallback

**Tasks:**
1. Resolve UUF import issue (see UUF_IMPORT_NOTES.md)
2. Add addon detection page
3. Complete profile selection page
4. Polish completion page
5. Test end-to-end flow

### Sprint 2: Polish & UX
**Goal:** Professional user experience
**Duration:** TBD
**Priority:** Visual polish and error handling

**Tasks:**
1. Add step indicator sidebar
2. Implement completion toasts
3. Add sound effects
4. Improve error messages
5. Add retry mechanisms

### Sprint 3: Distribution
**Goal:** Public release on CurseForge/Wago
**Duration:** TBD
**Priority:** Package and release

**Tasks:**
1. Write user documentation
2. Create screenshots/video
3. Package for distribution
4. Upload to CurseForge
5. Upload to Wago.io

---

## 🔄 Version History

### v1.0.0 (In Development)
- Initial installer framework
- Blizzard Edit Mode profile support
- UUF profile embedded (import not working)
- 5-page wizard UI
- First-run detection

### v0.1.0 (Initial Prototype)
- Basic file structure
- TOC file configuration
- Core initialization

---

## 📝 Notes

### Design Philosophy
- **Simplicity First:** Don't over-engineer for 2 profiles
- **User Control:** Show users what's happening, don't hide complexity
- **Graceful Degradation:** If something fails, let user continue
- **Future-Friendly:** Design for easy addition of new profiles later

### Lessons Learned
1. **Addon Load Order Matters:** Alphabetical loading can cause initialization issues
2. **Global Namespace Timing:** Not all addon globals are available immediately after load
3. **SavedVariables Are Tricky:** Need validation and error handling
4. **Import String Formats Vary:** Each addon has its own encoding method
5. **Manual Import Is Reliable:** Sometimes simple copy-paste beats complex automation

### Questions to Research
1. Can we access LibStub libraries that UUF embeds?
2. Is there a `UUF_INITIALIZED` event we can listen for?
3. How does LuckyoneUI time its imports - do they have the same issue?
4. Can we hook into UUF's GUI import function instead of API?
5. Would direct SavedVariables manipulation be more reliable?

---

**Last Updated:** 2026-01-17
**Status:** Active Development
**Next Review:** After Sprint 1 completion
