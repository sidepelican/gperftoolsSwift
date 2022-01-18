-- https://github.com/wg/wrk
-- wrk -c 1000 -d 30s -s access.lua --latency http://localhost:8080

local paths = {
  "/tarai",
  "/sha512",
}

math.randomseed(os.time())

randomPath = function()
  local path = math.random(1,table.getn(paths))
  return paths[path]
end

request = function()
  path = randomPath()
  return wrk.format(nil, path)
end
