-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source"

make_dynamic_h = simple {
	command = {
		"echo '#define DYNAMIC 4' > %out%"
	},
	outputs = {"%U%/dynamic.h"},
}

default = cprogram {
	cfile "%DIR%/test.c",
	cfile {
		"%DIR%/includes-dynamic.c",
		dynamicheaders = make_dynamic_h,
	},
	
	install = pm.install("%DIR%/dynamic-header")
}
