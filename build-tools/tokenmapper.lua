-- collapse.lua
--
-- © 2008 David Given.
-- This file is licensed under the MIT open source license.
--
-- tokenmapper is a simple tool that will analyse a C file and determine how
-- to transform it to make it smaller, by search-and-replacing tokens.
--
-- To use:
--
--   lua tokenmapper.lua -- <infile.c> <safetokens>
--
-- The mapfile will be written to stdout. (See ccruncher.lua.) <safetokens>
-- is a plain text file containing, one per line, a list of tokens that are
-- safe to rename without changing the program semantics. See
-- tokenfetcher.lua.
--
-- David Given dg@cowlark.com
--
-- $Id$

local string_gsub = string.gsub
local string_gfind = string.gfind
local string_len = string.len
local string_sub = string.sub
local math_floor = math.floor
local table_insert = table.insert

local datafile = io.open(arg[1]):read("*a")

local validtokens = {}
do
	for i in io.open(arg[2]):lines() do
		validtokens[i] = true
	end
end

local reserved = {
	j0 = true,
	j1 = true,
	y0 = true,
	y1 = true,
	j0f = true,
	j1f = true,
	y0f = true,
	y1f = true,
	j0l = true,
	j1l = true,
	y0l = true,
	y1l = true
}

local tokens = {}
do
	local s = "\n"..datafile
	s = string_gsub(s, "\n#include[^\n]*", "")
	s = string_gsub(s, "\n#line[^\n]*", "")
	s = string_gsub(s, "\n#[a-zA-Z]*", "\n")
	s = string_gsub(s, "\\\\", "")
	s = string_gsub(s, '\\"', "")
	s = string_gsub(s, "\\'", "")
	s = string_gsub(s, "'[^']'", " ")
	s = string_gsub(s, '"[^"]-"', ' ')
	
	for t in string_gfind(s, "([A-Za-z_][A-Za-z0-9_]*)") do
		if validtokens[t] then
			local n = tokens[t] or 0
			tokens[t] = n + 1
		end
	end
end

local map = {}
do
	local i = 1
	
	for k, v in pairs(tokens) do
		map[i] = k
		tokens[k] = {
			score = v * string_len(k),
			frequency = v,
			length = string_len(k)
		}
		i = i + 1
	end
end

table.sort(map, function(e1, e2)
	return tokens[e1].score > tokens[e2].score
end)

local tokennumber = 0
local t1 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local lt1 = string_len(t1)
local t2 = "_0123456789"
local lt2 = string_len(t2)
local t3 = t1 .. t2
local lt3 = string_len(t3)

local function charof(s, n)
	return string_sub(s, n+1, n+1)
end

local function gettoken()
	local s = {}
	local n = tokennumber
	table_insert(s, charof(t1, n % lt1))
	if (n >= lt1) then
		n = math_floor(n / lt1) - 1
		table_insert(s, charof(t2, n % lt2))
		if (n >= lt2) then
			n = math_floor(n / lt2) - 1
			table_insert(s, charof(t3, n % lt3))
			while (n >= lt3) do
				n = math_floor(n / lt3) - 1
				table_insert(s, charof(t3, n % lt3))
			end
		end
	end
	tokennumber = tokennumber + 1
	
	return table.concat(s)
end

local currenttoken = gettoken()
local function nexttoken()
	while true do
		currenttoken = gettoken()
		if not reserved[currenttoken] and not tokens[currenttoken] then
			break
		end
	end
end

local NONSYM = "([^%w_])"

for _, v in ipairs(map) do
	local l1 = string_len(v)
	local l2 = string_len(currenttoken)
	if l2 < l1 then
		print(v)
		print(currenttoken)
		nexttoken()
	end
end
