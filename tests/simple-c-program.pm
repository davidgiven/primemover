-- $Id: simple-c-program.pm 33 2006-08-02 22:42:37Z dtrg $
-- $HeadURL: https://svn.sourceforge.net/svnroot/primemover/pm/test-pmfiles/simple-c-program.pm $
-- $LastChangedDate: 2006-08-02 22:42:37Z $

include "../lib/c.pm"

-- Create output files
io.open("DATA.c", "w"):write([[
int main(int argc, char* argv[]) { return 0; }
]])

default = cprogram {
	cfile "DATA.c",
}
