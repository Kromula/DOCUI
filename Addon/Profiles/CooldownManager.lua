-- DOC UI - Blizzard Cooldown Manager Profiles
-- This file contains pre-configured spells and abilities layouts for various specs

DOCUI.Profiles = DOCUI.Profiles or {}
DOCUI.Profiles.CooldownManager = {}

-- Cooldown layouts organized by spec
DOCUI.Profiles.CooldownManager.layouts = {
    {
        class = "MAGE",
        spec = "Arcane",
        displayName = "Arcane Mage",
        importString = [[1|Fc49L0NxGIbxkia+gDxx/Q09X6AGVHN6pEGtSGciqaNpYpAw1uuRBqkv0HRjNmkTwcBksJzOFtqkwdpNLZ5n+d33eNWSp9cTxeisEcAnDKn/cpWCP+jiasQ7yBKSQ2aRGaRAJ4HMI3P0LpE8skBvk/oQCZAM4hO/I9NIls6qS4yEA1yI29b7kVS2Ytyrrv9oPCm5caOpBCklP6acPxsvyt290qoaB8ahcWQcGyfGrdJOG1PGurGhPHwZ38aP8tZncu9mNNIw78KSrTRjpdar+X5UXF4reGlvcT8s7Za9lVKl/A8=]]
    },
    {
        class = "DRUID",
        spec = "Balance",
        displayName = "Balance Druid",
        importString = [[1|HdC/L0NRFAdw57IYdCPfI0glmJR/AMN7FlJdRMNY7/UlkmppvN2jW+PHYBBb06nRVZpY28WvxOxHUmGwIn7E5H4tn9xz7zkn95xS13YFhWjneBFpnPR3yEqMVCzLv7hFHVV9bcCDjywClU4V4AlvKvsqB3hXMSpbOj+jsqdSU2mqtLRxpG6AUCWBJFIqrpoeNTE1S2zeR3rJABkkQ2SUjJFxkiATlvUpMs1wkozwdx/kh3ySL/KtzqE6Z+p2q1tG017lTi3355Z22fJQY32L7dIkTwpkg2yy4sJy1+bpmtyQK3LJFE6w+kxeGBYtj3N8rVeHo//BzC5SCJGMl+zKfATwogUnk8vkvWx8thiu+X8=]]
    }
}

-- Helper function to get class color
function DOCUI.Profiles.CooldownManager:GetClassColor(className)
    local classColor = RAID_CLASS_COLORS[className]
    if classColor then
        return classColor.r, classColor.g, classColor.b
    end
    return 1, 1, 1  -- Default to white if class not found
end
