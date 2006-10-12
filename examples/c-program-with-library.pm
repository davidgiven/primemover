-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

lib = clibrary {
	cfile "%DIR%/test1.c",
	cfile "%DIR%/test2.c",
	cfile "%DIR%/test3.c",
	cfile "%DIR%/test4.c"
}

default = cprogram {
	cfile "%DIR%/test.c",
	lib,
	
	install = pm.install("%DIR%/c-program-with-library")
}
