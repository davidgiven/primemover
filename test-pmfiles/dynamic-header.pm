-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $HeadURL: /cvsroot/tack/Ack/pmfile,v $
-- $LastChangedDate: Exp $

include "lib/c.pm"

local d = "test-source/"

make_dynamic_h = simple {
	command = {
		"echo '#define DYNAMIC 4' > %out%"
	},
	outputs = {"%U%/dynamic.h"},
}

default = cprogram {
	cfile (d.."test.c"),
	cfile {
		d.."includes-dynamic.c",
		dynamicheaders = make_dynamic_h,
	},
	
	install = pm.install(d.."dynamic-header")
}
