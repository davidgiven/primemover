-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $Source: /cvsroot/tack/Ack/pmfile,v $
-- $State: Exp $

include "lib/c.pm"

local d = "test-source/"

lib = clibrary {
	cfile (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
	cfile (d.."test4.c")
}

default = cprogram {
	cfile (d.."test.c"),
	lib,
	
	install = pm.install("test-source/c-program-with-library")
}
