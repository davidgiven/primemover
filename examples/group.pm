-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "examples/simple-c-program.pm"
simple_c_program = default

include "examples/complex-c-program.pm"
complex_c_program = default

default = group {
	simple_c_program,
	complex_c_program
}
