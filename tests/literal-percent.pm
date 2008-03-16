-- Tests that %% sequences work correctly.
--
-- © 2006 David Given.
-- Prime Mover is licensed under the MIT open source license. Search
-- for 'MIT' in this file to find the full license text.
--
-- $Id$

-- Create output files.
io.open("DATA1", "w")

test1 = file "DATA1"

default = simple {
	outputs = {"%U%"},
	command = {
		"echo %% > %out%"
	},
	install = pm.install("RESULT"),
	
	test1,
}
