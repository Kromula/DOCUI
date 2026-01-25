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
    },
    {
        class = "SHAMAN",
        spec = "Elemental",
        displayName = "Elemental Shaman",
        importString = [[1|RdDZLkNRGAXgtmoergxdTSRH0kRCasr/R4tIRKsaQ4WICyVpEJUgiAdQ2sZMcOFWXHsFQ7LjgmfgRYx79YKb7+z8e5991llZ786NL5bZvZ6D9EMikAFIGNIDCUF6IVFIH2QIEoPEoYfQM8g4ZAyyBz2A7kMS0CtIFjICPYGeQo+g59AL6CUkB8n7Xe7uT8y+YfYdMgEZRnLRzsJB0moJvfpdnpYPLKzw6Bf5Jj+Yb+S225K+58pDikgxKSGlpIyU89wDeSRPnFWQSlJFqkkNqSV1pJ40EB/ZIJtki7wwZTNpI+2kg3SSLiR5uWEm44WM2uf2DHcCXN1xzJSGKQ1TGqY0jGUKbzLW8/JtU8b+rCf310ugUMl/Q06exdkSbYO2Rz2238pMRleXnKl0ai217gSdSGJwOv4L]]
    },
    {
        class = "PALADIN",
        spec = "Protection",
        displayName = "Protection Paladin",
        importString = [[1|LdC9SgNRFATgGOzUVpitdmNphHkFUcSosOtf74Ioiiiod2OMP3ETEk2h2FlpNvEZ0ljmNWxjb5PaM5jmO7cYOOdOY7KWzaaj9G0RfADrcBUMpr3cxNQF3BXYAm/BBO4aTMEGkhnQ3hXwBnSgZWqKz4l18BW8A+/BMvgMVjHsg23wCYMv8AWuimTesnsrYlWUxJrYQPlXMxSR2BRbYht8tHncE+/iQ3yKjshEFz+Bl8vj0PAKIjaCojgQHZGJrvg2CqGIekFq621Lvj6+eNj3W/rzfwXWxbiFZjraic7PLv0oPon3j079BX85XNot/QE=]]
    },
    {
        class = "PRIEST",
        spec = "Shadow",
        displayName = "Shadow Priest",
        importString = [[1|JdA/L0NRGAbw3qv+tSKxeSQn3gSJoTZFE41IhLb+tLS3VjfaBIObIGEgcZtSiZgMDAQRvbYOHRh8AB/C6ANYzLwPy++8Z3nOe55q+PihN+5XrrOQLkgUYveFrNsjcghpQ/8PYgVIGGLBjEE6YcZxAEgHBiIwkzATkG6sXeI+AWmHSWJ4FbF3lC5QntaYrTLcFz1rQzCjMAkdgyrvBTJL5kiKpEmGzJMFskiWSJbkyDJZIXnikCK5Iq/K3Y3yFCEB+VDqPYRP1hvkk7uAMD7QeHsqxOmEnJIaOSNv5Et5HlQa/EfTIlyyqUvayW3iKalvJRN9tHytza781yHnrOivA7hxSAjSAmlladqe9uYWfSe/4Za8fcntbJZ392REZrx1J/0L]]
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
