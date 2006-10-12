-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

default = cprogram {
	-- foreach applies a rule to all of its inputs. The following is
	-- equivalent to:
	--
	-- group {
	--     cfile "%DIR%/test.c",
	--     cfile "%DIR%/test1.c",
	--     cfile "%DIR%/test2.c",
	--     cfile "%DIR%/test3.c",
	--     cfile "%DIR%/test4.c",
	-- }
	
	foreach {
		rule = cfile,
		
		file "%DIR%/test.c",
		file "%DIR%/test1.c",
		file "%DIR%/test2.c",
		file "%DIR%/test3.c",
		file "%DIR%/test4.c"
	},
	
	install = pm.install("%DIR%/source/foreach")
}
