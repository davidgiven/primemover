-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

local prog = cprogram {
	CDEFINES = {PARENT, "BAR"},
	cfile "%DIR%/test.c",
	install = pm.install("%DIR%/%DESTINATION%")
}

default = group {
	group {
		DESTINATION = "multiple-install-1",
		prog,
	},
	group {
		CDEFINES = {"FOO"},
		DESTINATION = "multiple-install-2",
		prog,
	}
}
