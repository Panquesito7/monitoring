local metric = monitoring.counter("nodetimer_count", "number of nodetime calls")
local metric_time = monitoring.counter("nodetimer_time", "time usage in microseconds for nodetimer calls")

minetest.register_on_mods_loaded(function()
  for name, node in pairs(minetest.registered_nodes) do
    if node.on_timer then
      local old_action = node.on_timer
      minetest.override_item(name, {
	      	on_timer = function(pos, elapsed)
		        metric.inc()
		        local t0 = minetest.get_us_time()
	        	local result = old_action(pos, elapsed)
		        local t1 = minetest.get_us_time()
	
		        metric_time.inc(t1 - t0)
		        return result
		end
      	})
    end
  end
end)
