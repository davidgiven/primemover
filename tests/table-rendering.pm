-- Does a very basic test of the rule engine.
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

default = simple {
	outputs = {"%U%"},
	command = {
		"echo %testdata1% >> %out%",
		"echo %testdata2% >> %out%",
		"echo %testdata3% >> %out%",
		"echo %testdata4% >> %out%",
	},
	install = pm.install("RESULT"),
	testdata1 = {"foo", "bar", "baz"},
	testdata2 = {"foo'bar\"baz"},
	testdata3 = "foobarbaz",
	testdata4 = EMPTY,
	
	test1,
}
