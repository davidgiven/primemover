-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "lib/c.pm"

DIR = "examples/source-- $State: Exp $

include "lib/c.pm"

local d = "test-source/"

dynamic_outputs = simple {
	outputs = {"%U%/first.c", "%U%/second.c", "%U%/third.c"},
	command = {
		"echo 'int foo() { return 1; }' > %out[1]%",
		"echo 'int foo() { return 2; }' > %out[2"%DIR%/test.c"
}

default = cprogram {
	cfile "%DIR%/test.c"le (d.."test.c")
}

default = cprogram {
	cfile (d.."test.c"),
	
	-- ith selects one input and discards the others. Because dynamic_outputs
	-- must generate three output files --- because of the way it works ---
	-- and we only want to build one, we use ith to select the second of its
	-- outputs while ignoring the others.
	
	cfile {
	%DIR%/ith")
}
