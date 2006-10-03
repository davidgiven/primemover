-- Does a very basic test of the rule engine.
--
-- © 2006 David Given.
-- Prime Mover is licensed under the MIT open source license. Search
-- for 'MIT' in this file to find the full license text.
--
-- $Id$

-- Create output files.
io.open("DATA1", "w"):write("one\n")
io.open("DATA2", "w"):write("two\n")
io.open("DATA3", "w"):write("three\n")
collectgarbage()
collectgarbage()

test1 = file "DATA1"
test2 = file "DATA2"
test3 = file "DATA3"

default = simple {
	outputs = {"%U%"},
	command = {
		"cat %in% > %out%"
	},
	install = pm.install("RESULT"),
	
	test1,
	test2,
	test3,
}
