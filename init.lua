--Paint roller mod created by Krock
--License: WTFPL

paint_roller = {}
paint_roller.mod_path = minetest.get_modpath("paint_roller")
paint_roller.node_colors = {}
paint_roller.wear = 65535 / 300 --300 as maximal uses of every paint roller

function paint_roller.register_one(node_name, dye_group, pack_name)
	if not pack_name or pack_name == "" then
		print("[Paint roller] ERROR: Invalid pack name")
		return
	end
	if not paint_roller.node_colors[pack_name] then
		paint_roller.node_colors[pack_name] = {}
	end
	paint_roller.node_colors[pack_name][node_name] = dye_group
end

function paint_roller.register_table(data_table, pack_name)
	if not pack_name or pack_name == "" then
		print("[Paint roller] ERROR: Invalid pack name")
		return
	end
	if not paint_roller.node_colors[pack_name] then
		paint_roller.node_colors[pack_name] = {}
	end
	for _, v in ipairs(data_table) do
		if #v ~= 2 then
			print("[Paint roller] ERROR: Invalid register table: "..pack_name)
			return
		end
		if not v[1] or not v[2] then
			return
		end
		-- 1 = node name | 2 = color group
		paint_roller.node_colors[pack_name][v[1]] = v[2]
	end
	print("[Paint roller] Table added: "..pack_name)
end

minetest.register_tool("paint_roller:paint_roller", {
	description = "Paint roller",
	inventory_image = "paint_roller.png",
	on_use = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local idx = placer:get_wield_index() + 1
		if idx > 7 then	--copied from explorer tools moo-ha-ha
			return
		end
		if minetest.is_protected(pointed_thing.under, placer:get_player_name()) then
			minetest.record_protection_violation(pointed_thing.under, placer:get_player_name())
			return
		end
		local node_name = minetest.get_node(pointed_thing.under).name
		local pack_name = nil
		for p, n in pairs(paint_roller.node_colors) do
			if n[node_name] then
				pack_name = p
				break
			end
		end
		if not pack_name then
			return
		end
		local inv = placer:get_inventory()
		local stack = inv:get_stack("main", idx) --dye
		local stack_name = stack:get_name()
		if not minetest.registered_items[stack_name] then
			return
		end
		local groups = minetest.registered_items[stack_name].groups
		if groups.dye ~= 1 then
			return
		end
		local new_node = nil
		for n, c in pairs(paint_roller.node_colors[pack_name]) do
			if groups[c] == 1 then
				new_node = n
				break
			end
		end
		if not new_node then
			return
		end
		if new_node == node_name then
			return
		end
		minetest.set_node(pointed_thing.under, {name=new_node})
		stack:take_item(1)
		inv:set_stack("main", idx, stack)
		itemstack:add_wear(paint_roller.wear)
		return itemstack
	end
})

minetest.register_craft({
	output = "paint_roller:paint_roller",
	recipe = {
		{"wool:white",	"wool:white",	"default:steel_ingot"},
		{"",	"default:steel_ingot",	""},
		{"",	"default:steel_ingot",	""},
	}
})

dofile(paint_roller.mod_path.."/wool.lua")
dofile(paint_roller.mod_path.."/coloredwood.lua")