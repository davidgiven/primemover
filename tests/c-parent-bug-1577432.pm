-- $Id$
-- $HeadURL$
-- $LastChangedDate$

include "../lib/c.pm"

-- Create output files
io.open("DATA.c", "w"):write([[
int main(int argc, char* argv[]) { return 0; }
]])
collectgarbage()
collectgarbage()

CINCLUDES = {"."}

default = cprogram {
	cfile {
		CINCLUDES = {PARENT, "."},
		"DATA.c",
	}
}
