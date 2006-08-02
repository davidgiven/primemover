-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

local d = "test-source/"

default = cprogram {
	-- foreach applies a rule to all of its inputs. The following is
	-- equivalent to:
	--
	-- group {
	--     cfile (d.."test.c"),
	--     cfile (d.."test1.c"),
	--     cfile (d.."test2.c"),
	--     cfile (d.."test3.c"),
	--     cfile (d.."test4.c"),
	-- }
	
	foreach {
		rule = cfile,
		
		file (d.."test.c"),
		file (d.."test1.c"),
		file (d.."test2.c"),
		file (d.."test3.c"),
		file (d.."test4.c")
	},
	
	install = pm.install("test-source/foreach")
}
