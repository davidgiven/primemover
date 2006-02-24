-- collapse.lua
--
-- © 2006 David Given.
-- This file is licensed under the MIT open source license.
--
-- collapse is a very simple C preprocessor designed to combine multiple
-- C source files into a single one. Run it with the input C files as
-- arguments. It will emit to stdout (a) references to any <include> files;
-- (b) the contents of any "include" files; (c) the contents of the C
-- files, one after the other.
--
-- Needless to say, the C files must not step on each other's statics...
--
-- David Given dg@cowlark.com
--
-- $Id$

local sysheaders = {}
local luaheaders = {}
local body = {}

local stringfind = string.find
local tableinsert = table.insert

local function collapse(filename)
	local lineno = 1
	tableinsert(body, '#line 1 "'..filename..'"')
	for line in io.open(filename):lines() do
		local s, _, name = stringfind(line, '^#include "(.*)"$')
		if s then
			if not luaheaders[name] then
				luaheaders[name] = true
				collapse(name)
				tableinsert(body, '#line '..(lineno+1)..' "'..filename..'"')
			else
				tableinsert(body, "")
			end
		else
			s, _, name = stringfind(line, '^#include <(.*)>$')
			if s then
				tableinsert(body, "")
				sysheaders[name] = true
			else
				tableinsert(body, line)
			end
		end
		
		lineno = lineno + 1
	end
end

for _, l in ipairs(arg) do
	collapse(l)
end

for l, _ in pairs(sysheaders) do
	print("#include <"..l..">")
end
for _, l in ipairs(body) do
	print(l)
end
