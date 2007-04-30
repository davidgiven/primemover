-- $Id$
-- $HeadURL$
-- $LastChangedDate$

-- Warning --- this bug only manifests on subsequent runs, which the test
-- harness can't do. To test this bug: run this test once. Comment out the
-- 'create output files' section again. Touch DATA.in. Test again. Rebuild.

include "../lib/c.pm"

-- Create output files

io.open("DATA.in", "w"):write("#define VALUE \"fnord\"\n")
io.open("DATA.c", "w"):write([[
#include <stdio.h>
#include "DATA.h"
int main(int argc, const char* argv[])
{ printf(VALUE "\n"); }
]])

-- Ensure timestamps of input files are less than the files we're about
-- to create.
collectgarbage()
collectgarbage()
posix.sleep(1)

local makeheaders = simple {
	outputs = { "%U%/DATA.h" },
	command = "cp %in[1]% %out[1]%",
	file "DATA.in"
}

default = cprogram {
	cfile {
		"DATA.c",
		dynamicheaders = { makeheaders },
	}
}
