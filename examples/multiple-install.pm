-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

local prog = cprogram {
	CDEFINES = {PARENT, "BAR"},
	cfile "%DIR%/test.c",
	install = pm.install("%DIR%R"},
	cfile (d.."test.c"),
	install = pm.install("test-source/%DESTINATION%")
}

default = group {
	group {
		DESTINATIONFOO"},
		DESTINATION = "multiple-install-2",
		prog,
	}
}
