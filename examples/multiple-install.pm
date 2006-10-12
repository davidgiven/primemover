-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $Source: /cvsroot/tack/Ack/pmfile,v $
-- $State: Exp $

include "lib/c.pm"

local d = "test-source/"

local prog = cprogram {
	CDEFINES = {PARENT, "-DBAR"},
	cfile (d.."test.c"),
	install = pm.install("test-source/%DESTINATION%")
}

default = group {
	group {
		DESTINATION = "multiple-install-1",
		prog,
	},
	group {
		CDEFINES = {"-DFOO"},
		DESTINATION = "multiple-install-2",
		prog,
	}
}
