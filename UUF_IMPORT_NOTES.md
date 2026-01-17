# Unhalted UnitFrames Import - Work in Progress

## Goal
Programmatically import a UUF profile into the Unhalted UnitFrames addon using the installer, similar to how LuckyoneUI imports profiles for Plater, Details, etc.

## Current Status
❌ **Not Working** - Getting initialization errors even though UUF addon is loaded and enabled.

## What We Tried

### Approach 1: Direct API Call
**File:** `Profiles\UnhaltedUnitFrames.lua`

```lua
-- Using UUF's official import API from Core/Config/Share.lua
_G.UUF:ImportSavedVariables(importString, profileName)
```

**Problem:** `_G.UUF` global is not available when installer runs, even though addon is loaded.

### Approach 2: Retry Mechanism
Added 10 retry attempts (0.5 seconds each) to wait for UUF to initialize:

```lua
if not _G.UUF or not _G.UUF.ImportSavedVariables then
    retryCount = retryCount + 1
    if retryCount < 10 then
        C_Timer.After(0.5, function()
            self:Import(callback)
        end)
        return nil, "Waiting for UUF to initialize..."
    end
end
```

**Problem:** Still fails after all 10 retries. UUF global never becomes available.

## Technical Details

### UUF Import String Format
- Starts with `!UUF_`
- Compressed/encoded profile data using LibDeflate and AceSerializer
- Example: `!UUF_T316YTjsw4NiNI7in)ZkX2JRkw2RbVz3DQHnGm2IAuakuR4XPMkVyZ)2NSTVWLgO...`

### UUF Import API (from Share.lua)
```lua
function UUF:ImportSavedVariables(EncodedInfo, profileName)
    local DecodedInfo = Compress:DecodeForPrint(EncodedInfo:sub(6))
    local DecompressedInfo = Compress:DecompressDeflate(DecodedInfo)
    local success, data = Serialize:Deserialize(DecompressedInfo)

    if profileName then
        UUF.db:SetProfile(profileName)
        wipe(UUF.db.profile)
        for key, value in pairs(data.profile) do
            UUF.db.profile[key] = value
        end
        UUFG.RefreshProfiles()
        UIParent:SetScale(UUF.db.profile.General.UIScale or 1)
    end
end
```

## What We Learned

1. **UUF Uses LibStub Libraries:**
   - `AceSerializer-3.0` for data serialization
   - `LibDeflate` for compression
   - Both are embedded in UUF's `Libraries\` folder

2. **UUF Has Two Import Methods:**
   - `UUF:ImportSavedVariables(string, name)` - Main import function
   - `UUFG:ImportUUF(string, key)` - Alternative method in GUI

3. **Addon Load Order:**
   - UUF addon loads via `C_AddOns.IsAddOnLoaded("UnhaltedUnitFrames")` ✅
   - But `_G.UUF` namespace not available immediately ❌
   - Possible load order issue or namespace initialization timing

## Files Modified

```
DOCUI_Installer/
├── Profiles/
│   └── UnhaltedUnitFrames.lua     # Profile data + import function
├── Installer.lua                   # Page 4: UUF import page with retry logic
└── DOCUI_Installer.toc            # Added UUF profile to load order
```

## Next Steps to Try

### Option 1: Check Addon Dependencies
Add UUF as an addon dependency in TOC file:
```toc
## Dependencies: UnhaltedUnitFrames
```
This ensures UUF fully loads before our installer.

### Option 2: PLAYER_LOGIN Event
Wait for `PLAYER_LOGIN` event instead of just addon loaded:
```lua
-- In Init.lua, add PLAYER_LOGIN check
eventFrame:RegisterEvent("PLAYER_LOGIN")

if event == "PLAYER_LOGIN" then
    -- UUF should be fully initialized by now
end
```

### Option 3: Direct SavedVariables Manipulation
Instead of using UUF's API, directly write to `UnhaltedUnitFramesDB`:
```lua
-- Decode the import string ourselves
local Serialize = LibStub("AceSerializer-3.0")
local Compress = LibStub("LibDeflate")

local DecodedInfo = Compress:DecodeForPrint(importString:sub(6))
local DecompressedInfo = Compress:DecompressDeflate(DecodedInfo)
local success, data = Serialize:Deserialize(DecompressedInfo)

-- Write directly to SavedVariables
UnhaltedUnitFramesDB = UnhaltedUnitFramesDB or {}
UnhaltedUnitFramesDB.profiles = UnhaltedUnitFramesDB.profiles or {}
UnhaltedUnitFramesDB.profiles["DOC UI"] = data.profile
UnhaltedUnitFramesDB.profileKeys = UnhaltedUnitFramesDB.profileKeys or {}
UnhaltedUnitFramesDB.profileKeys[playerKey] = "DOC UI"
```

### Option 4: Manual Copy-Paste (Fallback)
Create an EditBox similar to the Blizzard Edit Mode page:
- Show the `!UUF_` import string in a copyable text box
- User copies it (Ctrl+A, Ctrl+C)
- User opens UUF settings → Import → Pastes string
- Less automated but guaranteed to work

### Option 5: Study LuckyoneUI's Approach
Check if LuckyoneUI has any special handling for UUF imports that we're missing.

## How LuckyoneUI Does It

LuckyoneUI successfully imports profiles using this pattern:

```lua
-- From LuckyoneUI/Profiles/Plater.lua
function Private:Setup_Plater(installer)
    if not Private.IsAddOnLoaded('Plater') then
        return
    end

    -- Import using addon's built-in function
    local data = _G.Plater.DecompressData(profileString, 'print')
    PlaterDB.profiles[name] = data
    PlaterDB.profileKeys[playerRealm] = name
end
```

Key difference: They check addon load with a custom wrapper function and directly manipulate SavedVariables.

## Current Installer Flow

1. **Page 1:** Welcome
2. **Page 2:** Blizzard Edit Mode - Prepare layout string
3. **Page 3:** Import String - Copyable EditBox (working ✅)
4. **Page 4:** UUF Import - Programmatic import (broken ❌)
5. **Page 5:** Complete

## Workaround in Place

If UUF import fails, users can:
- Click "Skip UUF" button to proceed without it
- Manually import the profile through UUF's GUI later
- The profile string is: `!UUF_T316YTjsw4NiNI7in)ZkX2JRkw2RbVz3DQHnGm2IAuakuR4XPMkVyZ)2NSTVWLgO5QaDTNPscIg1NUp36Z3PBDWs0Y0Yimk4fVvUfU8gxF3i7vOlnD)tWMi31ORVoiY91OGn(pBzmZfaCJ(5xNTY7h)WocDh7f)rLTcSm(yWQGnr4o6rx7faVaF41Z1q)LO11kQsIsActeKK1NQpvY6LluvSMlznx4dtSMlx1taqpdUlipOuLDvDDXKTFui3IrHC9DHyl6IgMik57IMh2QB)mxFR7cO6XdbV5gH6iHKza5BI(EWpI4ozCyfQ2q9nfVtKUjATJ4g(GA83ssLsWd)SUAYdif)etX9RE2tmn(jK0sEcYJmPaj0eZiVCU2OAql)88dtKOMQIfAunTnmZ66aFqSjPp6JrE)4NF9FSX(5iBG9p)QjSfJL2ph8g6zUY32zL7Zwowg)7hcwBn)crlJ)f(kXeZsg8CbKYumjX056v2VAzC)tMF(25xHUPP9Rpf(SnW9wFO1(3HomiSvdZatd3qB4GjiYY4)93wgpDRXcBIZfQHd5EyAy8OT)R5AFgKwBa3)cPbmpW4w)4pH)ku04V(l0nEY3JWwcxz)owBIU3(vx7vGLZSX3NmT)YsxFt7WqYdCP)ILbrMbFmiyfK35)p9Cr6Ko0E(Up0EHh4DIAhLpV07NYsN9(hxzVEnQJV1)7UrRDr9usBPUaNLZZzSH0eb5jYt1eKuLMOknfzMOs8iWUf5QAbKZRD1MP6v6VrVsdxDIQbulaZZH)R5Yix34RTm(TqKj9c4eo63)TfBIcd)DIIKH3pqIqjlJpB)EWgazCz84T38RMOXHXS7nnV)U4pdvfVqgRlkLTmcdJkX0HZ1EFpBuulj)4vZnV6rmntUmvZxOLuZ8TGSPmCAUm8xSDCIA7CT0SST09E)D4K8AYdSdOgGyO(qK7ZEjbjyCPZ6GiN1fmOFATRbiYdA9ghLc6Mq)AE4VMXNV6AtMKlE1O8E4qeTTKXHMmebyo6u1A)1TKoASPqXeUCtKnEKmBZlVuCiDV)Q3nwg82de)CofKb5SFGccZ7Fitnlzwdx5htnJBIcEdS8tErUlOzCFjYoK6Mp9aAoUXhrJ6PwrRxHmJ386n1OjqjyqJd0NnMV5B4)L0bYkjCPpb)tIIsTkxDurn)GfVw1S3VDrGp(MoOh5tUo9v6GzYXchY1Ts2eRTDyjCKJfoY5eoiBD71G4fCP4p3zdwS8b7ixFWx8EgSeDVCd6uwIuEUv649cmZH8LNlPOuCnxilFEaahws0MqGhKYLNp9i8A6vYrodqtmA1pQj5i683i0D1Q52FRy4s1qYu2zkJS90d7C071LOyPvg7Ovq2xfMwf8O32qAQ2FRmnZ8YvqLeFOe87UyiiLvxzZilOxkNAvqRJ0QbAFJ9kvQOo2cLeJlZ3dXRXgB4jkiqMVWvQrHHhJTFnWZ)1wXdPD9rPpMSmRXJxzyE78BesCRiQrgnFZXguhbOCTdjrr)6PD)hV)UzxAwO3)SR9ZUrxUET3AGTpiDYvh9O9xvEobnTb5PXDbBw7g89YiuGYZvizkfkdiSuddW7qCsg384LF6w4uRrlwiykVNnTJE1fCND0FuIoDGzrg2sX(ZVok2RtIQNs7c)7cfj1pqw44cjD0L5DFdIX)xW4ZHwX(UnRaEHR8GZMy2sSAz6teRG6Wy1GDUnPmlBYU7LQIwyytA8TGa8sPyEzeiY2duGx(Fcc(gI3jx56rPAUxiMPcaJ)fZht7vNe1cfjIAHtW6IXaXbBp8kxaoy7dbW2)Mp0jy9uCBc3Id3(ydUDQ0ot9kX95XoqoSh(dqu2onkuoBYbcYgNdZ2A4D7ZHz3MGzQ2pRmnZmpirc2KcdGMKhNDOMuvfsanHVajT1y6T6t3)L5CavTrFC4aunBebu9sWInCev7xevJAy37xKtJoX6iCPHGKCithtqMQZd5Xvq5IXbLlMUQ)rlKPtyCSsXlS2tKsTylBbCGsNdaLC23aLCAK)CybuQImWqRFrT1yagOLKkQ80O1OSgzhMiretmSH(KE66)BSNV0DWK4SMdvACHkvZEpvZAoG6qkL4qhWktcCOsdV2fGV5t8nFAGzQaosQ41t78zFFBaF146NIh9X7FSF6q57BfFFR67kgNtWXkViaOLXbvTlAzAM5aahRNNOW6boXpuHZ5NPW(PAFqJRl3oGXb3DaaUBuraSFbXn6eRJi3gcsYrVTRrVvnuSM3YLtN9bJ9wUCacbRzHYzW(GnaH1EqfVjZKzixmIZ2Vfd1h(s59v4A8b2HVTchkHFwNFvq73xbEaO8aqhAQXdaDOOgGhakpa0gI1Hha6bOqbWdaTPaqZLay2IMlKQ8yUeZp5XJEYepAipmuEyOdj14HHouudWddDRdd90jIhXtNFpaN6ydqM2Lpbko8tGsM0O05oOnoepRobkohbNaL9ksPkD1pCiLAWwSACs8FoaTxFCNGtQVhBKy)5yvMxxf4qkE9WN)g8hEiU22dF(C3a7JcU44l2qjk67okv(EZQQt2mQk2ZSsQk2cFqvM6)WMgzf86lsy74XhDb1FakI8dqb1FaQg(7Jsz)a82iy7Rg(dWBJGeVy0kee)2cXEgPeZXnuOY4xDD4V5kIFZvv)6kz(1u97RTQ5xzP2V23CaeaJLQy9PNj)sheFkt18NjFu4nXUlqlWC1FgcDFS(n73j3jF9ZFylq)4jXUS83l2USf5uF2ICyS0KQIGIS4uDnD1PsWaWYwAQIwKRQfwbIPjORQOOiRRpvrrqtjlwqnjrnDzzDTPQt1Mknjlwq2Tuz2IQhAxRc7UUFwuKeAaYLKJEtYgXwstT4ug1BI1eScAAfNXOwtlTwqRItlYVHRq3SFixGCjIR1eV3CvW2K6i2b(xovrmWN0XuhnGzkQuAOAo1rj)2rQnTb96NjZEmJekSY(cJKMq6D2)CMkNPNoQg26HpEGZohsj5vHblKjsVMLnPPNCVjCK7UWbCANlPwHuTAVaYzUn3FzQPCQ2bzjjBhNYQDFs5i(zRVy37KjEuZj(hxbvRuU6DAqylZkyPjNTavXSzKVy33X8z0799Lu4vlL9lvHw5J)cfHKCFjlq59qwkEsSJsWfvkOgxH8(lbxd(B)GSaAl)Eqapw2U3(bm6(K3dciJL(9BvSM50PZpuraZcDFtPNFwZJ3JvgYEd9lR6nc4ufqCUkncyhdqTpqX7uCs0hjKTepmBlTtu8WDyJtoDqAXUA0xegCnE0gjyWZQijfL18HbM1i(3Hp3eADtOuo3eZkjuivC6yaWK0OFsxopAv4RvB2lN5PKdaEpcaEpdFRLv2cDOUbIii9tK0xJw)hbbKDbGhWr2nKi7ow2WmLPctNiOnzQ2eb9PYAume2TixvlGrFdZa7IAB)4XQ1fKMkQmrwyIIU4eHjzS6kArUQwyXQhs7gWaJoRXGOoE3wYorSdBOxfdaTDeJd)QZWVe7qGc7Yi97i8lXob)I9jz)WDxiplWepiv2E8KjF6(4yUgemxoCmxDeZvnwTGgpcW9gYLQyYgMPJLJhCNv8ZaaxnTvkonQVDyTvkzgpT7vFayNuo7hr0rYk6cktvG(fNcrnsPOurlYv1cy0bIoSOJ6WExfFXHnePINMYwSfovCwk7kcMEDoor4x(LfysS73Imah0uSNXoFG5tXzvtq98d(5EhYfRxXayzJktgiZddsZsMba4LCNMBLen6Dt0eVqspbEX31RDecm(UETRqGTDNzr(rwS72w7nCw98CcwpIOtQJkyffWENHgohVWnX3URXJy7oyu9bSy)igF7U682D1LZfZbm2RESZk7BSx8T7I92D1XqARtHf0JDv4iVGXZdYTnb5Eqf9jZSQixm(ZSDsiS009yNJu0tBN4i8WdhdIXdpKhEiJtd1rAKiIDpsKJOWdpFIzh(D51IHkjKCMVY9xs5D4jLVJiy6Bs5BlaMMv9pylJMNbOz45mE4fNyRWQEpF5W55JdpNdeBmighighi2zDm)hraXosrh3dHcOZr5o65P)O(9Q1zqGUh7jPEltBp5)T()`

## Testing Checklist

When trying again:
- [ ] Verify UUF addon is loaded: `/run print(C_AddOns.IsAddOnLoaded("UnhaltedUnitFrames"))`
- [ ] Check UUF global exists: `/run print(_G.UUF ~= nil)`
- [ ] Check import function exists: `/run print(_G.UUF.ImportSavedVariables ~= nil)`
- [ ] Try manual import through UUF GUI first (Settings → Import → Paste string)
- [ ] Compare timing: When does UUF initialize vs when installer opens?

## Questions to Answer

1. Why isn't `_G.UUF` available when other addons can access it?
2. Does load order matter? (Alphabetical: DOCUI_Installer loads before UnhaltedUnitFrames)
3. Can we access LibStub libraries that UUF uses?
4. Is there an event we should wait for instead?
5. How does the UUF GUI handle the import - can we call that directly?

---

**Last Updated:** 2026-01-16
**Status:** Needs more investigation into UUF initialization timing
