# DOC UI

World of Warcraft UI setup with dedicated installer addon. Optimized for 1440p displays and Midnight (11.2.0+).

## 🎯 What's Included

### Installer Addon
**Location:** `/Addon/` - Complete WoW addon ready to install

A streamlined installer that imports all DOC UI profiles automatically:
- ✅ Auto-opens on first login
- ✅ 5-page guided wizard
- ✅ Blizzard Edit Mode layout import
- ✅ Unhalted UnitFrames profile import
- ✅ `/docui` command to reopen anytime

### Profile Data
Pre-configured profiles for supported addons:
- **Unhalted UnitFrames** - Complete frame layout (1440p optimized)
- **Better Cooldown Manager** - Organized cooldown tracking
- **Blizzard Edit Mode** - Native UI positioning
- **Jundies Platynator** - Plater nameplate profile

## 📦 Installation

### Method 1: Use the Installer (Recommended)
1. Download the addon: Copy `/Addon/` folder to `World of Warcraft\_retail_\Interface\AddOns\DOCUI\`
2. Launch WoW - Installer opens automatically
3. Follow the wizard to import profiles
4. Click "Reload UI Now" when complete

### Method 2: Manual Import
1. Install required addons (see below)
2. Use the profile data in repository root folders
3. Import manually through each addon's settings

## 🔧 Required Addons

- [Unhalted UnitFrames](https://www.curseforge.com/wow/addons/unhalted-unitframes)
- [Better Cooldown Manager](https://www.curseforge.com/wow/addons/better-cooldown-manager)
- Masque + Masque: Blizzard bars
- Masque: Renaitre (Faded variant)

## ✨ Features

### Layouts
- **DPS/Tank Layout** - Optimized for damage dealers and tanks
- **1440p Optimized** - Perfect scaling for 2560×1440 displays

### UI Elements
- Clean, minimalist design
- Organized cooldown tracking (Items, Buffs, Essential, Utility)
- Optimized unit frame positioning

## 📸 Screenshots

### DPS 1440p Layout
<img width="2559" height="1439" alt="DOC UI DPS Layout" src="https://github.com/user-attachments/assets/4a1f0464-1b24-41d1-845d-46dda3bc2a1f" />

## 📚 Documentation

Comprehensive guides for developers and contributors:

- **[Project.md](Project.md)** - Feature tracker, bugs, roadmap
- **[PROFILE_IMPORT_GUIDE.md](PROFILE_IMPORT_GUIDE.md)** - How to add new profile imports
- **[InstallerAnalysis.md](InstallerAnalysis.md)** - Deep dive into installer architecture
- **[UUF_TROUBLESHOOTING.md](UUF_TROUBLESHOOTING.md)** - Technical debugging reference

## 🛠️ Development

### Repository Structure
```
DOCUI/
├── Addon/                          # WoW Addon (install this)
│   ├── DOCUI.toc
│   ├── Core/
│   │   └── Init.lua
│   ├── Profiles/
│   │   ├── BlizzardEditMode.lua
│   │   └── UnhaltedUnitFrames.lua
│   └── Installer.lua
├── Profile Data/                   # Source profiles
│   ├── BetterCooldownManager Profile
│   ├── Unhalted Unitframe Profile
│   ├── Jundies Platynator Profile
│   └── Layouts/
└── Documentation/                  # Developer guides
    ├── PROFILE_IMPORT_GUIDE.md
    ├── InstallerAnalysis.md
    └── Project.md
```

### Adding New Profiles

See [PROFILE_IMPORT_GUIDE.md](PROFILE_IMPORT_GUIDE.md) for step-by-step instructions on adding profile imports for other addons.

## 🐛 Known Issues

See [Project.md](Project.md) for current bugs and feature roadmap.

## 📝 Version History

### v0.0.5 (Current - PTR Development)
- ✅ Working installer with 5-page wizard
- ✅ Blizzard Edit Mode profile
- ✅ Unhalted UnitFrames profile (using UUFG global)
- ✅ First-run detection
- ✅ Reload UI button on completion
- 🚧 In development for Midnight expansion

### Versioning Strategy
- **0.x.x** - Development versions (PTR testing)
- **1.0.0** - Official release for Midnight expansion launch

## 📄 License

See [LICENSE](LICENSE) for details.

## 🎮 Compatibility

- **Game Version:** Retail - Midnight (11.2.0+)
- **Tested On:** PTR (Public Test Realm)
- **Resolution:** Optimized for 1440p (works on other resolutions)
- **Language:** English (enUS)

---

**Maintained by:** DOC
**Repository:** https://github.com/Kromula/DOCUI
**Issues:** https://github.com/Kromula/DOCUI/issues
