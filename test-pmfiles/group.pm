-- $Id: shell 15 2006-07-25 09:21:06Z dtrg $
-- $Source: /cvsroot/tack/Ack/pmfile,v $
-- $State: Exp $

include "test-pmfiles/simple-c-program.pm"
simple_c_program = default

include "test-pmfiles/complex-c-program.pm"
complex_c_program = default

default = group {
	simple_c_program,
	complex_c_program
}
