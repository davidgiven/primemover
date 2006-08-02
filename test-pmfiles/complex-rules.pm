-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

local d = "test-source/"

-- This example shows how to do some relatively complex things by subclassing
-- an existing rule. Here, we want to export all the intermediate objects made
-- when building an application; once with optimisation on, and once with it
-- turned off again.

OPTIMISATION = "1"
SRCDIR = d
DESTDIR = "test-objectfiles/"

exported_o = cfile {
	class = "cfile_with_public_o",
	CBUILDFLAGS = {PARENT, "-O%OPTIMISATION%"},
	file "%SRCDIR%%BASE%.c",
	install = pm.install("%DESTDIR%%BASE%-O%OPTIMISATION%.o")
}

program = cprogram {
	exported_o { BASE = "test" },
	exported_o { BASE = "test1" },
	exported_o { BASE = "test2" },
	exported_o { BASE = "test3" },
	exported_o { BASE = "test4" },
	install = pm.install("%DESTDIR%program-O%OPTIMISATION%")
}

default = group {
	program { OPTIMISATION = "3" },
	program { OPTIMISATION = "0" }
}
