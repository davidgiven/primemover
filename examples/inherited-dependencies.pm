-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

libcore = clibrary {
	class = "libcore",
	cfile "%DIR%/test1.c",
	cfile "%DIR%/test2.c",
	cfile "%DIR%/test3.c",
}

lib = libcore {
	outputs = {"%U%/1/2/3/4/lib.a"},
	cfile "%DIR%/test4.c"
}

default = cprogram {
	cfile "%DIR%/test.c",
	lib,
	
	install = pm.install("%DIR%ile (d.."test.c"),
	lib,
	
	