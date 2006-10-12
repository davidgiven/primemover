-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

default = cprogram {
	CDEFINES = {"test1=fnord"},
	
	cfile "%DIR%/test.c",
	cfile "%DIR%/test1.c",
	cfile "%DIR%/test2.c",
	cfile "%DIR%/test3.c" (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
	
	-- Compile these two files with a modified definition of CDEFINES ---
	-- they should get bottest4=test4A"},
		"%DIR%/test4.c",
	},
	cfile {
		CDEFINES = {PARENT, "test4=test4B"},
		"%DIR%/test4.c",
	},
	
	install = pm.install("examples/source/complex-c-program")
}
