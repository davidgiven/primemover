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

copy = simple {
	class = "copy",
	outputs = {"%U%"},
	command = {
		"cat %in% > %out%"
	}
}

default = group {
	copy { file "DATA1" },
	copy { file "DATA1" },
	install = pm.install("%out[1]%", "RESULT")
}
