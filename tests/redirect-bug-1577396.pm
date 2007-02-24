-- Checks for bug 1577396: REDIRECT not working properly.
--
-- © 2007 David Given.
-- Prime Mover is licensed under the MIT open source license. Search
-- for 'MIT' in this file to find the full license text.
--
-- $Id$

-- Create output files.
io.open("DATA1", "w"):write("one\n")
collectgarbage()
collectgarbage()

test1 = file "DATA1"


default = simple {
	outputs = {"%U%"},
	command = {
		"echo %TESTDATA1% >> %out%",
		"echo %TESTDATA2% >> %out%",
	},
	install = pm.install("RESULT"),
	TESTDATA1 = "fnord",
	TESTDATA2 = {REDIRECT, "TESTDATA1"},
	
	test1,
}
