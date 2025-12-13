--------------------------------------------------
-- PROXY LOADER (FINAL)
--------------------------------------------------

local WHITELIST_ENABLED = true
local SHOW_SUCCESS = true

local WHITELIST = {
    { userid = 2865782, growid = "MyZz" },
    { userid = 2578650, growid = "Dominic" }
}

-- SAFE GET IDENTITY (ANTI INFINITE LOOP)
local function getIdentity()
    local start = os.clock()
    while os.clock() - start < 10 do -- max 10 detik
        local me = GetLocal()
        if me and me.name then
            return me.userid, me.name
        end
        Sleep(200)
    end
    return nil, nil
end

-- CHECK WHITELIST
local function checkWhitelist()
    local uid, name = getIdentity()
    if not name then return false end

    local lname = name:lower()

    for _, v in pairs(WHITELIST) do
        if lname == v.growid:lower() or (uid and uid == v.userid) then
            return true, uid, name
        end
    end

    return false, uid, name
end

-- EXECUTE LOADER
if WHITELIST_ENABLED then
    local allowed, uid, name = checkWhitelist()

    if not allowed then
        SendVarlist({
            [0] = "OnConsoleMessage",
            [1] = "`4[BLOCKED] `wAccess denied",
            netid = -1
        })
        return
    end

    if SHOW_SUCCESS then
        SendVarlist({
            [0] = "OnConsoleMessage",
            [1] = "`2[AUTHORIZED] `w" .. name ..
                  " | UID: " .. tostring(uid or "N/A"),
            netid = -1
        })
    end
end

--------------------------------------------------
-- LOAD PAYLOAD (OBFUSCATED SCRIPT)
--------------------------------------------------

local payload = HttpGet(
    "https://raw.githubusercontent.com/VeLLL3/proxy-fy/main/payload.lua"
)

assert(loadstring(payload))()
