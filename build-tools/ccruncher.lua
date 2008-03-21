-- ccruncher.lua
--
-- © 2008 David Given.
-- This file is licensed under the MIT open source license.
--
-- Extracts whitespace and renames tokens in a C file.
-- 
-- To use:
-- 
--   lua ccruncher.lua -- <infile.c> <tokenmap>
--
-- The result is writen to stdout. <tokenmap> is a mapfile describing which
-- tokens should be renamed; plain text, each pair of lines containing from
-- and to. tokenmapper.lua generates one of these.
--
-- David Given dg@cowlark.com
--
-- $Id$

local string_len = string.len
local string_find = string.find
local string_sub = string.sub
local coroutine_yield = coroutine.yield
local table_concat = table.concat

local fp
local swaptable = {}

local nl = false
local ws = false
local id = false
local breaks = true

local function emit_nl()
	nl = true
end

local function emit_ws()
	ws = true
end

local function breaks_on()
	breaks = true
end

local function breaks_off()
	breaks = false
end

local function emit(s)
	local thisid = string_find(s, "^[%w_]")
	
	if (thisid and id) or ws or nl then
		if nl or breaks then
			coroutine_yield("\n")
		else
			coroutine_yield(" ")
		end
		ws = false
		nl = false
	end	
	
	local ss = swaptable[s]
	if ss then
		s = ss
	end
	coroutine_yield(s)

	id = string_find(s, "[%w_]$")	
end

local function process_string(s, pos, sep)
	local ss, se, sc1, sc2
	local rn = 2
	local r = {sep}
	
	pos = pos + 1
	while true do
		ss, se, sc1, sc2 = string_find(s, "^([^\\"..sep.."]*)(.)", pos)
		if not ss then
			error("unterminated string or character constant in "..s)
		end
		pos = se + 1
		
		r[rn] = sc1
		rn = rn + 1
		
		if (sc2 == sep) then
			r[rn] = sep
			break
		end
		
		if (sc2 == "\\") then
			r[rn] = string_sub(s, se, se+1)
			rn = rn + 1
			pos = se + 2
		end
	end
	
	emit(table_concat(r))
	return pos
end

local function process_token(s, pos)
	local ss, se, sc1, sc2
	local len = string_len(s)

	ss = string_find(s,
		'^%s*$', pos)
	if ss then
		return len+1
	end
	
	ss, se = string_find(s,
		'^(%s+)', pos)
	if ss then
		return se+1
	end
	
	ss, se = string_find(s,
		'^/%*.*%*/%s*', pos)
	if ss then
		return se+1
	end

	ss, se = string_find(s,
		'^/%*', pos)
	if ss then
		while true do
			s = fp:read("*l")
			ss, se = string_find(s,
				'%*/')
			if ss then
				return se+1, s
			end
		end
	end

	ss, se, sc1 = string_find(s,
		'^(["\'])', pos)
	if ss then
		return process_string(s, pos, sc1) 
	end

	ss, se, sc1 = string_find(s,
		'^([%u%l_][%w_]*)', pos)
	if ss then
		emit(sc1)
		return se+1
	end
	
	ss, se, sc1 = string_find(s,
		'^(0[xX][%x]+)', pos)
	if ss then
		emit(sc1)
		return se+1
	end
	
	ss, se, sc1 = string_find(s,
		'^(%d+[lLuU]*)', pos)
	if ss then
		emit(sc1)
		return se+1
	end
	
	ss, se, sc1 = string_find(s,
		'^(%d*%.%d+[eE][-+]?%d+)', pos)
	if ss then
		emit(sc1)
		return se+1
	end
	
	ss, se, sc1 = string_find(s,
		'^(%d*%.%d+)', pos)
	if ss then
		emit(sc1)
		return se+1
	end
	
	ss, se, sc1 = string_find(s,
		'^([-()*,;.=<>/?:{}~+&|![%]%%^])', pos)
	if ss then
		emit(sc1)
		return se+1
	end
	
	error("unrecognised token at "..string.sub(s, pos))
end

local function process_normal_line(s)
	local pos = 1
	
	local token
	while (pos <= string_len(s)) do
		local news
		pos, news = process_token(s, pos)
		s = news or s
	end
end

local function process_preprocessor_directive(s)
	local ss, se, sc1, sc2, sc3
	local len = string_len(s)
	
	-- Collapse continuations.
	
	while true do
		ss = string_find(s, "\\$")
		if not ss then
			break
		end
		
		s = string_sub(s, 1, ss-1) .. fp:read("*l")
	end

	-- Eat #line statements.
		
	ss, se = string_find(s,
		'^%s*#line.*$', pos)
	if ss then
		return
	end

	ss, se, sc1 = string_find(s,
		'^%s*#%s*include%s+([<"].*[>"])%s*$', pos)
	if ss then
		emit_nl()
		emit("#include")
		emit(sc1)
		emit_nl()
		return
	end

	-- #define foo bar...
	
	ss, se, sc1, sc2 = string_find(s,
		'^%s*#%s*define%s+([%w_]+)%s+(.*)$', pos)
	if ss then
		emit_nl()
		emit("#define")
		process_normal_line(sc1)
		emit_ws()
		process_normal_line(sc2)
		emit_nl()
		return
	end

	-- #define foo(baz) bar...
	
	ss, se, sc1, sc2, sc3 = string_find(s,
		'^%s*#%s*define%s+([%w_]+)(%b())%s+(.*)$', pos)
	if ss then
		emit_nl()
		emit("#define")
		process_normal_line(sc1)
		process_normal_line(sc2)
		emit_ws()
		process_normal_line(sc3)
		emit_nl()
		return
	end

	ss, se, sc1, sc2 = string_find(s,
		'^%s*#%s*([%u%l]+)%s*(.*)$', pos)
	if not ss then
		error("malformed preprocessor directive in "..s)
	end

	emit_nl()
	emit("#"..sc1)
	process_normal_line(sc2)
	emit_nl()
end

local function gettoken()
	while true do
		local s = fp:read("*l")
		if not s then
			break
		end
		
		if string_find(s, "^%s*#") then
			breaks_off()
			process_preprocessor_directive(s)
			breaks_on()
		else
			process_normal_line(s)
		end
		
	end

	fp:close()
end

-- main program --

fp = io.open(arg[2])
while true do
	local k = fp:read("*l")
	local v = fp:read("*l")
	if not k or not v then 
		break
	end
	swaptable[k] = v
end

fp = io.open(arg[1])
local tt = coroutine.wrap(gettoken)

while true do
	local t = tt()
	if not t then
		break
	end
	io.stdout:write(t)
end
io.stdout:write("\n")
