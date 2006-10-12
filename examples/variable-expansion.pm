-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

default = cprogram {
	cfile "%DIR%/test.c",
	cfile "%DIR%/test1.c",
	cfile "%DIR%/test2.c",
	cfile "%DIR%/test3.c" (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
	cfile {
		-- Demonstrates the use of %{...}% to execute arbitrary chunks of Lua
		-- code in a variable expansion.
		
		CE"%DIR%/test4.c"
	},
	
	install = pm.install("%DIR%)}%",
		d.."test4.c"
	