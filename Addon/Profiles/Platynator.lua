-- DOC UI - Platynator Profile
-- Jundies' Platynator Profile

DOCUI = DOCUI or {}
DOCUI.Profiles = DOCUI.Profiles or {}
DOCUI.Profiles.Platynator = {}

-- Profile Name
DOCUI.Profiles.Platynator.profileName = "Jundies"

-- Platynator Import String
DOCUI.Profiles.Platynator.importString = [[{"stack_region_scale_y":1,"stack_region_scale_x":1,"click_region_scale":1,"version":1,"design_all":[],"click_region_scale_y":1,"cast_alpha":1,"closer_to_screen_edges":true,"cast_scale":1,"not_target_behaviour":"fade","closer_nameplates":false,"stacking_nameplates":true,"designs_assigned":{"friend":"_custom","enemySimplified":"_custom","enemy":"_custom"},"show_friendly_in_instances":true,"not_target_alpha":1,"target_scale":1,"show_friendly_in_instances_1":"always","stack_applies_to":{"normal":true,"minion":false,"minor":false},"addon":"Platynator","apply_cvars":true,"current_skin":"blizzard","show_nameplates_only_needed":false,"designs":{"_custom":{"highlights":[{"anchor":[],"height":1,"layer":0,"color":{"a":1,"b":1,"g":1,"r":1},"scale":0.96,"kind":"target","asset":"double-arrows","width":1},{"color":{"a":1,"r":0.6666666666666666,"g":0.6666666666666666,"b":0.6666666666666666},"height":1.544,"layer":0,"scale":1,"anchor":[],"kind":"mouseover","asset":"soft-glow","width":1.066},{"anchor":[],"height":1,"layer":2,"color":{"a":1,"b":1,"g":1,"r":1},"scale":1,"kind":"target","asset":"slight","width":1},{"anchor":[],"height":1.16,"layer":0,"color":{"a":1,"r":0,"g":1,"b":0.960784375667572},"scale":1,"kind":"focus","asset":"bold","width":1.02}],"specialBars":[{"filled":"normal/soft-full","layer":3,"scale":0.01,"kind":"power","anchor":[0,-7],"blank":"normal/soft-faded"}],"addon":"Platynator","auras":[{"direction":"LEFT","scale":0.8,"showCountdown":true,"sorting":{"reversed":false,"kind":"duration"},"height":0.8,"textScale":0.9,"anchor":["BOTTOMRIGHT",64,9],"kind":"debuffs","showPandemic":true,"filters":{"fromYou":true,"important":true}},{"direction":"LEFT","scale":1,"showCountdown":true,"sorting":{"reversed":false,"kind":"duration"},"height":1,"anchor":["LEFT",-88,0],"kind":"buffs","textScale":0.9,"filters":{"dispelable":true,"important":true}},{"direction":"RIGHT","scale":1,"showCountdown":true,"sorting":{"reversed":false,"kind":"duration"},"height":1,"anchor":["LEFT",68,0],"kind":"crowdControl","textScale":0.9,"filters":{"fromYou":false}}],"font":{"outline":true,"shadow":true,"asset":"Expressway"},"version":1,"bars":[{"relativeTo":0,"scale":1,"layer":1,"border":{"color":{"a":1,"r":0,"g":0,"b":0},"height":1,"asset":"thin","width":1},"autoColors":[{"combatOnly":false,"colors":{"offtank":{"a":1,"r":0.501960813999176,"g":0.501960813999176,"b":1},"transition":{"a":1,"r":1,"g":0.9137255549430847,"b":0.2274509966373444},"safe":{"a":1,"r":0.7450980544090271,"g":0.1882353127002716,"b":0.1137254983186722},"warning":{"a":1,"r":0.8666667342185974,"g":0.4352941513061523,"b":0}},"kind":"threat","useSafeColor":false,"instancesOnly":false},{"kind":"eliteType","colors":{"boss":{"a":1,"r":0.7450980544090271,"g":0.1882353127002716,"b":0.1137254983186722},"melee":{"a":1,"r":0.7450980544090271,"g":0.1882353127002716,"b":0.1137254983186722},"caster":{"a":1,"r":0,"g":0.7490196228027344,"b":1},"trivial":{"a":1,"r":0.7450980544090271,"g":0.1882353127002716,"b":0.1137254983186722},"miniboss":{"a":1,"r":0.5764706134796143,"g":0.4392157196998596,"b":0.8588235974311829}},"instancesOnly":false},{"colors":{"tapped":{"r":0.4313725490196079,"g":0.4313725490196079,"b":0.4313725490196079}},"kind":"tapped"},{"colors":{"neutral":{"a":1,"r":1,"g":0.4941176772117615,"b":0},"friendly":{"a":1,"r":1,"g":0.4941176772117615,"b":0},"hostile":{"a":1,"r":1,"g":0.4941176772117615,"b":0}},"kind":"quest"},{"colors":[],"kind":"classColors"},{"colors":{"neutral":{"b":0,"g":0.8588235974311829,"r":0.8980392813682556},"hostile":{"a":1,"r":0.7450980544090271,"g":0.1882353127002716,"b":0.1137254983186722},"friendly":{"b":0,"g":0.8901961445808411,"r":0},"unfriendly":{"r":1,"g":0.5058823529411764,"b":0}},"kind":"reaction"}],"marker":{"asset":"wide/glow"},"background":{"color":{"a":0.5,"b":1,"g":1,"r":1},"applyColor":true,"asset":"black"},"foreground":{"asset":"white"},"kind":"health","absorb":{"asset":"wide/blizzard-absorb","color":{"a":1,"b":1,"g":1,"r":1}},"anchor":[]},{"marker":{"asset":"none"},"layer":1,"border":{"color":{"a":1,"r":0,"g":0,"b":0},"height":0.51,"asset":"thin","width":1},"autoColors":[{"colors":{"ready":{"a":1,"r":1,"g":1,"b":0}},"kind":"interruptReady"},{"colors":{"cast":{"a":1,"r":1,"g":0.4941176772117615,"b":0.1372549086809158},"channel":{"a":1,"r":1,"g":0.4941176772117615,"b":0.13725490868091583}},"kind":"importantCast"},{"colors":{"uninterruptable":{"b":0.3019607961177826,"g":0.3019607961177826,"r":0.8000000715255737}},"kind":"uninterruptableCast"},{"colors":{"cast":{"a":1,"r":1,"g":0.4941176772117615,"b":0.1372549086809158},"interrupted":{"b":0.3019607961177826,"g":0.3019607961177826,"r":0.8000000715255737},"channel":{"a":1,"r":1,"g":0.4941176772117615,"b":0.1372549086809158}},"kind":"cast"}],"scale":1,"anchor":["TOP",0,-8],"kind":"cast","foreground":{"asset":"white"},"background":{"color":{"a":0.5,"b":1,"g":1,"r":1},"applyColor":true,"asset":"black"}}],"markers":[{"layer":3,"anchor":["LEFT",-103,0],"color":{"r":1,"g":1,"b":1},"kind":"quest","asset":"normal/quest-blizzard","scale":1},{"layer":3,"anchor":["BOTTOMRIGHT",10,-2],"color":{"r":1,"g":1,"b":1},"kind":"raid","asset":"normal/blizzard-raid","scale":1}],"texts":[{"widthLimit":52,"displayTypes":["absolute","percentage"],"scale":0.85,"layer":2,"align":"RIGHT","anchor":["RIGHT",61,0],"kind":"health","color":{"b":1,"g":1,"r":1},"truncate":true},{"showWhenWowDoes":false,"truncate":true,"scale":0.85,"layer":2,"autoColors":[],"align":"LEFT","anchor":["LEFT",-60,0],"kind":"creatureName","widthLimit":70,"color":{"b":1,"g":1,"r":1}},{"color":{"r":1,"g":1,"b":1},"layer":2,"widthLimit":61,"truncate":true,"anchor":["TOPLEFT",-62,-17],"kind":"castSpellName","align":"LEFT","scale":0.8},{"widthLimit":55,"truncate":true,"scale":0.8,"layer":2,"align":"LEFT","anchor":["TOPRIGHT",54,-17],"kind":"castTarget","color":{"r":1,"g":1,"b":1},"applyClassColors":true},{"scale":0.8,"anchor":["TOPRIGHT",64,-17],"widthLimit":0,"truncate":false,"align":"RIGHT","kind":"castTimeLeft","layer":2,"color":{"b":1,"g":1,"r":1}},{"widthLimit":55,"truncate":true,"align":"LEFT","layer":2,"color":{"b":1,"g":1,"r":1},"anchor":["TOPRIGHT",54,-17],"kind":"castInterrupter","scale":0.8,"applyClassColors":true}]}},"target_behaviour":"none","style":"_custom","click_region_scale_x":1,"global_scale":1.5,"kind":"profile","simplified_nameplates":{"minor":true,"minion":true,"instancesNormal":false},"show_nameplates":{"player":false,"npc":false,"enemy":true}}]]

-- Import function - Automatic import
function DOCUI.Profiles.Platynator:Import()
    -- Check if Platynator addon is loaded
    if not C_AddOns.IsAddOnLoaded("Platynator") then
        return false, "Platynator is not installed or enabled."
    end

    -- Check if C_EncodingUtil exists
    if not C_EncodingUtil or not C_EncodingUtil.DeserializeJSON then
        return false, "C_EncodingUtil not available. This requires a newer WoW version."
    end

    -- Check if saved variables exist
    if not _G.PLATYNATOR_CONFIG then
        return false, "PLATYNATOR_CONFIG not found. Try /reload first."
    end

    if not _G.PLATYNATOR_CURRENT_PROFILE then
        return false, "PLATYNATOR_CURRENT_PROFILE not found. Try /reload first."
    end

    -- Deserialize the JSON profile
    local success, profileData = pcall(C_EncodingUtil.DeserializeJSON, self.importString)

    if not success then
        return false, "Failed to deserialize profile data: " .. tostring(profileData)
    end

    -- Validate it's a Platynator profile
    if profileData.addon ~= "Platynator" or profileData.kind ~= "profile" then
        return false, "Invalid Platynator profile format."
    end

    -- Clean up metadata fields
    profileData.version = nil
    profileData.addon = nil
    profileData.kind = nil

    -- Create/overwrite profile
    if not _G.PLATYNATOR_CONFIG.Profiles then
        _G.PLATYNATOR_CONFIG.Profiles = {}
    end

    -- Write profile to saved variables
    _G.PLATYNATOR_CONFIG.Profiles[self.profileName] = profileData

    -- Switch to the new profile
    _G.PLATYNATOR_CURRENT_PROFILE = self.profileName

    return true, "Platynator profile '" .. self.profileName .. "' imported and activated! Reload UI to apply."
end
