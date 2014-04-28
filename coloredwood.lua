local hues = {
	{"red",			"red"},
	{"orange",		"orange"},
	{"yellow",		"yellow"},
	{"lime",		"lime"},
	{"green",		"green"},
	{"aqua",		"aqua"},
	{"cyan",		"cyan"},
	{"skyblue",		"sky_blue"},
	{"blue",		"blue"},
	{"violet",		"violet"},
	{"magenta",		"magenta"},
	{"redviolet",	"red_violet"},
}

local wood_colors = {}
local fence_colors = {}

for _,h in pairs(hues) do
	table.insert(wood_colors,	{"coloredwood:wood_medium_"..h[1],		"excolor_"..h[2]})
	table.insert(fence_colors,	{"coloredwood:fence_medium_"..h[1],		"excolor_"..h[2]})
end

paint_roller.register_table(wood_colors, "VE Colored Wood")
paint_roller.register_table(fence_colors, "VE Colored Fences")

paint_roller.register_one("default:wood", "unicolor_dark_orange", "VE Colored Wood")
paint_roller.register_one("default:fence_wood", "unicolor_dark_orange", "VE Colored Fences")