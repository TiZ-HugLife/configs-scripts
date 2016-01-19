require 'cairo'

local function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

local function check_ql()
	local test = io.open(os.getenv("HOME").."/.quodlibet/current", "r")
	if test == nil then
		return false
	else
		test:close()
		local test = io.open("/tmp/.current.song", "r")
		if test == nil then
			return false
		else
			test:close()
			return true
		end
	end
end

function conky_draw(bg_colour, bg_alpha, rad_tl, rad_tr, rad_br, rad_bl, v, ql)
	if conky_window == nil then return end
	if ql and not check_ql() then return end
	if v == nil then v = 0 end
	local w = conky_window.width
	local h = conky_window.height
	if h <= 24 then return end
	
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	local cr = cairo_create(cs)
	
	cairo_move_to(cr,rad_tl,0)
	cairo_line_to(cr,w-rad_tr,0)
	cairo_curve_to(cr,w,0,w,0,w,rad_tr)
	cairo_line_to(cr,w,h+v-rad_br)
	cairo_curve_to(cr,w,h+v,w,h+v,w-rad_br,h+v)
	cairo_line_to(cr,rad_bl,h+v)
	cairo_curve_to(cr,0,h+v,0,h+v,0,h+v-rad_bl)
	cairo_line_to(cr,0,rad_tl)
	cairo_curve_to(cr,0,0,0,0,rad_tl,0)
	cairo_close_path(cr)

	cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
	cairo_fill(cr)

	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end

function conky_draw_cover(bg_colour, bg_alpha, top, bottom, x, y, middle)
	if conky_window == nil then return end
	if not check_ql() then return end
	if top == nil then top = 0 end
	if bottom == nil then bottom = 0 end
	if x == nil then x = 0 end
	if y == nil then y = 0 end
	local w = conky_window.width
	local h = conky_window.height
	
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	local cr = cairo_create(cs)
	
	if middle then w = w / 2 end
	
	cairo_move_to(cr,2,top)
	cairo_line_to(cr,w,top)
	cairo_line_to(cr,w,h-bottom)
	cairo_line_to(cr,2,h-bottom)
	cairo_line_to(cr,2,top)
	cairo_close_path(cr)

	cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
	cairo_fill(cr)
	
	local image = cairo_image_surface_create_from_png("/tmp/conkycover.png")
	if image then
		cairo_set_source_surface(cr, image, x, y)
		cairo_paint(cr)
	end

	cairo_surface_destroy(cs)
	cairo_surface_destroy(image)
	cairo_destroy(cr)
end
