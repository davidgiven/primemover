-- Does a very basic test of the rule engine.
--
-- © 2006 David Given.
-- Prime Mover is licensed under the MIT open source license. Search
-- for 'MIT' in this file to find the full license text.
--
-- $Id: basic.pm 53 2006-10-03 22:20:07Z dtrg $

-- Create output files.
io.open("DATA1", "w"):write("one\n")
io.open("DATA2", "w"):write("two\n")
io.open("DATA3", "w"):write("three\n")
collectgarbage()
collectgarbage()

test1 = file "DATA1"
test2 = file "DATA2"
test3 = file "DATA3"

function pm.stringmodifier.testmodifier(rule, arg)
	local t = {}
	for i, j in ipairs(arg) do
		t[i] = "FOO"..j.."BAR"
	end
	return t
end

default = simple {
	outputs = {"%U%"},
	command = {
		"echo %in[1]:dirname% > %out%",
		"echo %in:testmodifier% > %out%",
	},
	install = pm.install("RESULT"),
	
	test1,
	test2,
	test3,
}
