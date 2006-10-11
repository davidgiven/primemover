-- Tests {PARENT, ...}
--
-- © 2006 David Given.
-- Prime Mover is licensed under the MIT open source license. Search
-- for 'MIT' in this file to find the full license text.
--
-- $Id$

-- Create output files.
io.open("DATA1", "w"):write("one\n")
collectgarbage()
collectgarbage()

test1 = file "DATA1"

VAR1 = {"one"}
VAR2 = {}
VAR3 = EMPTY

default = simple {
	outputs = {"%U%"},
	command = {
		"echo %VAR1% >> %out%",
		"echo %VAR2% >> %out%",
		"echo %VAR3% >> %out%",
	},
	install = pm.install("RESULT"),
	
	VAR1 = {PARENT, "two"},
	VAR2 = {PARENT, "three"},
	VAR3 = {PARENT, "four"},
	
	test1,
}
