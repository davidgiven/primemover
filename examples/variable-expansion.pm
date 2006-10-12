-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

default = cprogram {
	cfile "%DIR%/test.c",
	cfile "%DIR%/test1.c",
	cfile "%DIR%/test2.c",
	cfile "%DIR%/test3.c",
	cfile {
		-- Demonstrates the use of %{...}% to execute arbitrary chunks of Lua
		-- code in a variable expansion.
		
		CEXTRAFLAGS="%{return '-DNUMFILES='..table.getn(default)}%",
		"%DIR%/test4.c"
	},
	
	install = pm.install("%DIR%/simple-c-program")
}
