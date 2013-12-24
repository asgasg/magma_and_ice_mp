local paxelnodeformspec = 
	"size[8,9]"..
	"label[3,0;Paxel Workshop]"..
	"list[current_name;paxeltype;1,2;1,1;]"..
	"label[0,2;Material:]"..
	"list[current_name;pickaxe;3,1;1,1;]"..
	"label[2,1;Pickaxe:]"..
	"list[current_name;axe;3,2;1,1;]"..
	"label[2,2;     Axe:]"..
	"list[current_name;shovel;3,3;1,1;]"..
	"label[2,3; Shovel:]"..
	"list[current_name;paxel;6,2;1,1;]"..
	"label[5,2;  Paxel:]"..
	"list[current_player;main;0,5;8,4;]"..
	"button[5,3;3,1;create;Create Paxel]"
local paxels = {
	{"icetools:ice_crystal_refined", "icetools:pick_ice", "icetools:axe_ice", "icetools:shovel_ice", "icetools:paxel_ice"},
	{"magmatools:magma_crystal_refined", "magmatools:pick_magma", "magmatools:axe_magma", "magmatools:shovel_magma", "magmatools:paxel_magma"}
}	


minetest.register_node("paxels:workshop", {
	description = "Paxel Workshop",
	tiles = {"paxels_workshop_top.png", "paxels_workshop_bottom.png", "paxels_workshop_side.png", "paxels_workshop_side.png", "paxels_workshop_side.png", "paxels_workshop_front.png"},
	paramtype2 = "facedir",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",paxelnodeformspec)
		meta:set_string("infotext", "Paxel Workshop")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		inv:set_size("pickaxe", 1*1)
		inv:set_size("axe", 1*1)
		inv:set_size("shovel", 1*1)
		inv:set_size("paxel", 1*1)
		inv:set_size("paxeltype", 1*1)		
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "pickaxe" or listname == "axe" or listname == "shovel" or listname == "paxeltype" then
			return stack:get_count()
		else
			return 0
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "paxel" then
			return 0
		else
			return 1
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("pickaxe") then
			return false
		elseif not inv:is_empty("axe") then
			return false
		elseif not inv:is_empty("paxeltype") then
			return false
		elseif not inv:is_empty("shovel") then
			return false
		elseif not inv:is_empty("paxel") then
			return false
		end
		return true
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		for _, row in ipairs(paxels) do
			local paxeltype = row[1]
			local pick = row[2]
			local axe = row[3]
			local shovel = row[4]
			local paxel = row[5]
			if fields.create then
			if	inv:get_stack('paxeltype', 1):get_name() == paxeltype and inv:get_stack("pickaxe", 1):get_name() == pick and inv:get_stack("axe", 1):get_name() == axe and inv:get_stack("shovel", 1):get_name() == shovel and inv:is_empty("paxel") then
					inv:add_item("paxel", paxel)
					inv:set_stack("pickaxe", 1, nil)
					inv:set_stack("axe", 1, nil)
					inv:set_stack("shovel", 1, nil)
					inv:remove_item("paxeltype", paxeltype)
				end
			end
		end
	end,
	groups = {choppy=3,oddly_breakable_by_hand=3},
})




minetest.register_craft({
	output = "paxels:workshop",
	recipe = {
		{"default:obsidian","default:obsidian_glass","default:obsidian"},
		{"default:mese","default:diamondblock","default:mese"},
		{"default:obsidian","default:steelblock","default:obsidian"},
	},	
})