-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $HeadURL: /cvsroot/tack/Ack/pmfile,v $
-- $LastChangedDate: Exp $

include "lib/c.pm"

local d = "test-source/"

default = cprogram {
	cfile (d.."test.c"),
	cfile (d.."test1.c"),
	cfile (d.."test2.c"),
	cfile (d.."test3.c"),
	cfile {
		-- Demonstrates the use of %{...}% to execute arbitrary chunks of Lua
		-- code in a variable expansion.
		
		CEXTRAFLAGS="%{return '-DNUMFILES='..table.getn(default)}%",
		d.."test4.c"
	},
	
	install = pm.install("test-source/simple-c-program")
}
