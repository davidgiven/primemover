-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

local d = "test-source/"

default = cprogram {
	cfile (d.."test.c"),
	cfile (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
	cfile (d.."test4.c"),
	
	install = pm.install("test-source/simple-c-program")
}
