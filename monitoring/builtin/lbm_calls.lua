local metric = monitoring.counter("lbm_count", "number of lbm calls")
local metric_time = monitoring.counter("lbm_time", "time usage in microseconds for lbm calls")

local global_lbms_enabled = true

minetest.register_on_mods_loaded(function()
  for _, lbm in ipairs(minetest.registered_lbms) do
    local old_action = lbm.action
    lbm.action = function(pos, node)

      if not global_lbms_enabled then
        return
      end

      metric.inc()
      local t0 = minetest.get_us_time()
      old_action(pos, node)
      local t1 = minetest.get_us_time()
      metric_time.inc(t1 - t0)
    end
  end
end)

minetest.register_chatcommand("lbm_disable", {
	description = "disables all lbm's",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " disables all lbm's")
		global_lbms_enabled = false
	end
})

minetest.register_chatcommand("lbm_enable", {
	description = "enables all lbm's",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " enables all lbm's")
		global_lbms_enabled = true
	end
})
