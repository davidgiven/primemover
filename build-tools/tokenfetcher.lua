-- collapse.lua
--
-- © 2008 David Given.
-- This file is licensed under the MIT open source license.
--
-- Extracts a list of tokens (and frequencies) from a C file.
--
-- To use:
--
--   lua tokenfetcher.lua -- <infile.c>
--
-- The result is written to stdout.
--
-- You can use the output of this file to generate a safetokens list for
-- tokenmapper.lua.
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

local tokens = {}
do
	local s = io.stdin:read("*a")
	s = "\n"..s
	s = string_gsub(s, "\n#include[^\n]*", "")
	s = string_gsub(s, "\n#line[^\n]*", "")
	s = string_gsub(s, "\n#[a-zA-Z]*", "\n")
	s = string_gsub(s, "0[xX][0-9a-fA-F]+", "")
	s = string_gsub(s, "\\\\", "")
	s = string_gsub(s, '\\"', "")
	s = string_gsub(s, "\\'", "")
	s = string_gsub(s, "'[^']'", "")
	s = string_gsub(s, '"[^"]-"', '')
	
	for t in string_gfind(s, "([A-Za-z_][A-Za-z0-9_]*)") do
		local n = tokens[t] or 0
		tokens[t] = n + 1
	end
end

for k, v in pairs(tokens) do
	print(k, v)
end
