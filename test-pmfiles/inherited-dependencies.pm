-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $HeadURL: /cvsroot/tack/Ack/pmfile,v $
-- $LastChangedDate: Exp $

include "lib/c.pm"

local d = "test-source/"

libcore = clibrary {
	class = "libcore",
	cfile (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
}

lib = libcore {
	outputs = {"%U%/1/2/3/4/lib.a"},
	cfile (d.."test4.c")
}

default = cprogram {
	cfile (d.."test.c"),
	lib,
	
	install = pm.install("test-source/c-program-with-library")
}
