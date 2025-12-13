-- loader.lua (REMOTE)

local WHITELIST = {
  2865782,
  2578650
}

local function allowed(uid)
  for _, v in pairs(WHITELIST) do
    if uid == v then return true end
  end
  return false
end

local me = GetLocal()
if not me or not allowed(math.floor(me.userid)) then
  SendVarlist({
    [0] = "OnConsoleMessage",
    [1] = "`4[BLOCKED] `wNot authorized",
    netid = -1
  })
  return
end

-- kalau lolos whitelist, load payload
local payload = io.popen(
  'powershell -Command "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/VeLLL3/gtfyfybre/refs/heads/main/proxy.lua/')"'
):read("*a")

local f = load(payload)
if f then f() end
