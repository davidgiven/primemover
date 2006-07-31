-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $HeadURL: /cvsroot/tack/Ack/pmfile,v $
-- $LastChangedDate: Exp $

include "lib/c.pm"

local d = "test-source/"

default = cprogram {
	CDEFINES = {"-Dtest1=fnord"},
	
	cfile (d.."test.c"),
	cfile (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
	
	-- Compile these two files with a modified definition of CDEFINES ---
	-- they should get both test1 and test4 defined.
	
	cfile {
		CDEFINES = {PARENT, "-Dtest4=test4A"},
		d.."test4.c",
	},
	cfile {
		CDEFINES = {PARENT, "-Dtest4=test4B"},
		d.."test4.c",
	},
	
	install = pm.install("test-source/complex-c-program")
}
