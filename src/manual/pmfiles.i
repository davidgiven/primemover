<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="content-type" />
  <title>The core pmfile language</title>
</head>

<body>
<h1>Introduction</h1>

<p>This document describes, concisely but with luck clearly, the core
language used to write <code>pmfiles</code>. It does not describe how to use
pm or how to deploy it.</p>

<blockquote class="lua">
  <p>Prime Mover is written in Lua; in fact, pmfiles are Lua scripts. It is,
  however, not necessary to know how to write programs in Lua to use pm.</p>

  <p>Nevertheless, sometimes it's useful to embed Lua statements in your
  pmfiles so that you can do advanced things, such as automatically picking
  appropriate source files based on the architecture that's being used.</p>

  <p>Blocks of text in these boxes contain useful details that may be useful
  to people who already know Lua. If you don't, or don't care, then please
  ignore them.</p>
</blockquote>

<h1>Syntax</h1>

<p>pmfiles are composed of a series of statements. Statements may be:</p>
<ul>
  <li>Comments</li>
  <li>Directives</li>
  <li>Assignments</li>
</ul>

<p>Statements do not have termination characters, and may be split over
multiple lines; pm will determine whether statements extend across multiple
lines by whether they make syntactic sense or not.</p>

<p>Blank lines are ignored, of course.</p>

<h2>Comments</h2>

<p>Comments in pm start at a double hyphen (<code>--</code>) and extend to
the end of the line.</p>
<pre>-- This is a comment.</pre>

<p>You may also do block comments, which extend over multiple lines, and
start with a <code>--[[</code> and end with a <code>--]]</code>.</p>
<pre>--[[ This is a
block comment. --]]</pre>

<h2>Directives</h2>

<p>Directives cause pm to do something immediately. There is currently only
one supported directive:</p>

<h3><code>include</code></h3>

<p>Causes pm to read in another named pmfile. <code>include</code> takes a
single argument, which must be a <code>"</code> or <code>'</code> quoted
string.</p>
<pre>include "anotherfile.pm"
include 'lib/c.pm'</pre>

<blockquote class="warning">
  <p>The argument must be a constant string. String expansion is not
  performed.</p>
</blockquote>

<blockquote class="lua">
  <p>The file is read in and executed with the same global environment as the
  caller. This means that included files share globals, but as they are a
  separate chunk, they will have their own local variables.</p>
</blockquote>

<h2>Assignments</h2>

<p>Assignments assign a value to a <b>global property</b>. The bulk of your
pmfile will consist of assignments.</p>

<p>The syntax is simple:</p>
<pre>name = value</pre>

<p>You may assign any value to any name (that does not conflict with a
reserved word).</p>

<blockquote class="lua">
  <p>Global properties are Lua global variables; entries in the global
  environment.</p>
</blockquote>

<h2>Names</h2>

<p>Names are used across Prime Mover to refer to properties. They may contain
any combination of letters, numbers and underscores, but may not start with a
number. They are case sensitive. The following names are reserved and may not
be used:</p>
<pre>and       break     do        else      elseif
end       false     for       function  if
in        local     nil       not       or
repeat    return    then      true      until
while     io        string    table     os
posix     pm        EMPTY     PARENT    REDIRECT</pre>

<p>In addition, all names beginning with a double underscore are reserved for
internal use by Prime Mover and should not be used.</p>

<h2>Values</h2>

<p>Values in pm can be of these three types:</p>
<ul>
  <li>Strings</li>
  <li>Lists</li>
  <li>Booleans</li>
  <li>Rule instantiations</li>
</ul>

<p>Numbers are also supported, but they are equivalent to strings and are
only used in rare circumstances.</p>

<h3>Strings</h3>

<p>Strings are expressed as traditional sequences delimited with double or
single quotation marks. The escape character is <code>\</code>, with
<code>\n</code> and <code>\t</code> having the usual meaning.</p>
<pre>"a string"
'a string'
"mustn't"
'mustn\'t"
"multiple\nlines"</pre>

<h3>Lists</h3>

<p>Lists are comma-separated sequences of strings between <code>{}</code>
characters. Lists may be empty, and a trailing comma may be left on.</p>
<pre>{}
{"one", "two", "three"}
{"foo",}</pre>

<p>The special value <code>EMPTY</code> may be used to represent a particular
kind of empty list, used in string expansion.</p>

<p>The first entry of a list can also be one of the special terms
<code>PARENT</code> and <code>REDIRECT</code>. These have meaning when doing
property lookups.</p>

<blockquote class="lua">
  <p>Prime Mover lists are, obviously, Lua tables with only numeric items.</p>
</blockquote>

<h3>Booleans</h3>

<p>Booleans consists of the literal words <code>true</code> or
<code>false</code>.</p>
<pre>true
false</pre>

<p>They are normally used to switch on or off features via local
properties.</p>

<h3>Rule instantiation</h3>

<p>A rule instantiation consists of the name of an existing rule, plus a list
of modifiers between <code>{}</code> characters.</p>
<pre>rulename {
    foo = "1",
    bar = "2",
    "3",
    "4",
}</pre>

<p>Unnamed modifiers are numbered from 1 and specify <b>children</b>. Named
modifiers specify <b>local properties</b> if the name is in lower case and
<b>inherited properties</b> if the name is in upper case. The order of the
modifiers is irrelevant, and properties and children may be mixed, but
children are also numbered in order of appearance.</p>

<p>Rule names refer to global properties that are themselves rule
instantiations.</p>

<blockquote class="lua">
  <p>Rule instantiations are Lua functions that take a single parameter, a
  literal table containing modifiers to apply to the newly created rule.</p>
</blockquote>

<h1>Semantics</h1>

<h2>Overview</h2>

<p>When Prime Mover's rule engine runs, it looks at the rule that the user
specifies (which is <code>default</code> by default), and performs a depth
first traversal of all rules it references via its children. At each stage it
checks to see if the rule needs to do anything, and if so, it causes the rule
to perform its action.</p>

<p>Specifying the behaviour of each rule is done by subclassing an existing
rule and modifying its behaviour using the property system. Prime Mover
implements both a class-based property inheritance system and a call stack
based system. It is possible for a rule to override a property in such a way
that it applies to all rules that are called by that rule. This allows a rule
to, for example, build two copies of the same application with different
flags, by simply invoking the build rule twice with a property set
differently.</p>

<p>Most of Prime Mover's useful functionality exists in the default
library.</p>

<h2>The rule engine</h2>

<p>When pm wishes to build a rule, it applies the following algorithm to that
rule.</p>
<pre>build all children of the rule
are any of this rule's inputs newer than this rule?
  yes -&gt; execute this rule's command
does this rule have an install property?
  yes -&gt; execute this rule's installation instructions</pre>

<p>The timestamp of a rule is considered to be the newest of all the rule's
outputs. A missing output is considered to be infinitely old.</p>

<p>The result of this is a depth first traversal of the dependency tree. A
rule's dependents will be built before the rule is, and will always be built
in the order supplied when the rule was instantiated.</p>

<blockquote class="warning">
  <p>Because all children under a rule are visited every time the rule is
  visited, extremely large dependency trees may cause the same rule to be
  visited a very large number of times, which can be slow.</p>

  <p>As a result, it is possible to take advantage of the order of execution
  to prune the dependency tree. For example, consider the following:</p>
  <pre>slow_library = lib { ... }
program1 = cprogram { cfile "file1.c", slow_library }
program2 = cprogram { cfile "file2.c", slow_library }
program3 = cprogram { cfile "file3.c", slow_library }
default = group { program1, program2, program3 }</pre>

  <p>When <code>default</code> is built, <code>slow_library</code> will be
  visited three times. It will only actually be built once, and only if
  needed, but it will still cause pm to examine its source and object files
  three times. The above could be rewritten as follows:</p>
  <pre>slow_library = lib { ..., install = pm.install("libslow.a") }
program1 = cprogram { cfile "file1.c", "libslow.a" }
program2 = cprogram { cfile "file2.c", "libslow.a" }
program3 = cprogram { cfile "file3.c", "libslow.a" }
default = group { slow_library, program1, program2, program3 }</pre>

  <p>When <code>default</code> is now built, <code>slow_library</code> will
  be visited once, and then the three uses of it will refer directly to its
  output. If one of <code>slow_library</code>'s source files is changed, then
  when <code>default</code> is invoked it will get rebuilt automatically,
  which will cause <code>libslow.a</code> to be refreshed, which will in turn
  trigger rebuilding of the three programs.</p>

  <p>However, if <code>program1</code> is invoked directly, it will not be
  built, because pm has not been explicitly told about the dependency.</p>

  <p>As a result, I strongly recommend avoiding this idiom unless you really
  need it.</p>
</blockquote>

<p>pm performs aggressive caching on timestamps; it will only look at the
actual file on disk the first time it needs to determine the file's
timestamp. It will then remember the result. If the file is used as an output
of a rule that has been built, then the file will be considered to be
up-to-date, regardless of the timestamp that the rule actually wrote to
disk.</p>

<h2>The intermediate cache</h2>

<p>pm stores all intermediate files in a hidden directory.</p>

<p>pm keeps track of the command used to generate each intermediate file, and
will only execute each command once. The same source file, built with two
different compiler command lines, will result in two different intermediate
files. This allows multiple versions of a program to be built side-by-side
without any object file collision.</p>

<p>The contents of the intermediate cache should be considered as internal to
pm. While the names of the files are human readable, this is merely to aid
debugging. No legitimate build process will ever need to directly refer to
files in the intermediate cache.</p>

<p>As a result of this, pm needs to be told which files are the result of a
build, so that it can copy them out of the intermediate cache and into the
user's desired location. This is done using the <code>install</code> property
on a node.</p>

<p>Each time a rule is visited, its <code>install</code> property is
consulted. If this exists, then the contents are executed.
<code>install</code> normally contains a list of commands to be executed; see
the documentation for <code>node</code> for more information on the exact
syntax.</p>

<p>For example:</p>
<pre>myprogram = cprogram {
  cfile "file.c",
  install = pm.install("a.out")
}</pre>

<p>When built, this rule will compile <code>file.c</code> as a C program and
then install the result to <code>a.out</code> in the current directory.</p>

<blockquote class="warning">
  <p><code>install</code> is executed <em>every time</em> the rule is
  visited. This means that if the rule is visited several times, then the
  file will be installed several times. As a result, care should be taken so
  that rules with <code>install</code> set are only visited once; following
  on from the above example, this can lead to confusion:</p>
  <pre>default = group {
  group { CFLAGS="-DFOO", myprogram },
  group { CFLAGS="-DBAR", myprogram }
}</pre>

  <p>This is going to build two versions of <code>myprogram</code>, one with
  <code>FOO</code> defined and one with <code>BAR</code> defined. Each one
  will be installed as <code>a.out</code>. It is not defined which one
  wins.</p>
</blockquote>

<h1>String expansion</h1>

<h2>Introduction</h2>

<p>Just before filenames or command lines are processed by Prime Mover, they
undergo string expansion. This causes marked sections of the strings to be
replaced with other values; this is equivalent to variable expansion in
<code>make</code>. String expansion always occurs in the context of the rule
currently being processed; the value of the expanded string will depend on
the rule's properties.</p>

<p>Each string expansion consists of the name of a property delimited with
<code>%</code> characters. The name may have an optional <i>selector</i>
clause, delimited with <code>[]</code> characters, and an optional
<i>modifier</i> clause, separated with a <code>:</code>:</p>
<pre>%NAME%
%NAME[selector]%
%NAME:modifier%
%NAME[selector]:modifier%</pre>

<p>For example, the following strings are candidates for string expansion:</p>
<pre>%OPTIMISATION%
%inputs[1]%
%FILENAME:basename%</pre>

<p>The algorithm used to perform string expansion is as follows.</p>
<pre>For each %...% clause:
 - fetch the value referred to by the name.
 - if the value is a list, apply the selector.
 - if a modifier is present, apply the modifier.
 - replace the %...% clause with the result.</pre>

<p>If the result is a list, and is not one of the special forms described
below, then the replacement text consists of all items in the list, quoted
and separated with whitespace. If the result is not a list, the replacement
text consists of that item, unquoted.</p>

<blockquote class="warning">
  <p>The distinction between single-item lists (which are quoted) and strings
  (which are not quoted) is important, and is used extensively to build
  command lines from multiple string expansions. For example, the C plugin
  uses the <code>CC</code> property to store the command line used to invoke
  the C compiler:</p>
  <pre>CC = "%COMPILER% %INCLUDES% -c -o %out[1]% %in[1]%"</pre>

  <p>When the C plugin expands <code>"%CC%"</code>, this will be replaced
  with the literal string above. If quoting were to happen, the end result
  would not be a valid command line.</p>

  <p>This is known to be inelegant.</p>
</blockquote>

<p>String expansion occurs recursively until there are no more
<code>%...%</code> clauses to be expanded. This <i>does</i> mean that if a
string expansion refers to itself, an infinite loop will result.</p>

<blockquote class="lua">
  <p>There is also a third string expansion form.</p>
  <pre>%{text}%</pre>

  <p>When a string expansion of this form is encountered, then
  <code>text</code> is executed as a chunk of Lua code, and the return value
  is used as the result. The code uses a read-only copy of the pmfile's
  global environment with <code>self</code> set to the current rule. Rule
  properties may be looked up by calling the <code>__index()</code> method on
  the rule. For example:</p>
  <pre>"the number is %{return 1 + 1}%"
"CFILE is set to %{return self:__index('CFILE')}%"</pre>

  <p>When a property is looked up in this way, it uses the same mechanisms as
  string expansion, but the value is not converted into a string and remains
  a table or raw value. (This means that <code>{PARENT, ...}</code> and
  <code>{REDIRECT, ...}</code> are honoured.)</p>
</blockquote>

<h2>Property lookup</h2>

<p>The first stage of string expansion is to look up the value of the
property being referred to. The way this happens depends on the name of the
property.</p>

<p>Property names in lower case refer to <b>local properties</b>. Property
names in upper case refer to <b>inherited properties</b>.</p>

<p>The algorithm used is as follows:</p>
<pre>does the named property exists on the current rule?
  yes -&gt; return it
  no -&gt; try again recursively on the rule's superclass
if still not found and the name refers to an inherited property
  does the named property exist on the current rule's caller?
    yes -&gt; return it
    no -&gt; try again recursively up the rule's call stack
  if still not found
    does the named property exist as a global property?
      yes -&gt; return it
      no -&gt; fail with an error message</pre>

<p>To summarise: all properties are first looked up via the rule's class
hierarchy; inherited properties are then looked up via the rule's call stack;
if all else fails, inherited properties take the value of the appropriately
named global property.</p>

<p>To rephrase:</p>
<ul>
  <li>All properties defined by a rule are visible to all rules that subclass
    the current rule.</li>
  <li>Inherited properties defined by a rule are visible to all rules called
    by the current rule.</li>
  <li>Global properties are always looked up last.</li>
  <li>If all else fails, pm halts with an error message.</li>
</ul>

<h2>Selectors</h2>

<p>Selectors are used to extract particular items from a list. It is not
legal to use a selector on a value that is not a list.</p>

<p>The syntax is:</p>
<pre>[from-to]
[index]</pre>

<p>For the first form:</p>

<p><var>from</var> and <var>to</var> are numeric constants identifying the
first and last item from the list. Entries are counted from 1. If values are
specified, they must be within the bounds of the list.</p>

<p><var>from</var> and <var>to</var> may also be omitted, in which case they
default to the start and end of the list, respectively.
<code>"%name[2-]%"</code> will look up <code>name</code> and return all but
the first item.</p>

<p>The selector <code>[-]</code> (with both from and to omitted) will return
the entire list, and is equivalent to not having a selector at all.</p>

<p>For the second form:</p>

<p><var>index</var> is a numeric constant identifying the single index of the
item to extract from the list. It is equivalent to
<code>[</code><var>index</var><code>-</code><var>index</var><code>]</code>.
The selector will return a single-entry list containing the item, not the
item itself.</p>

<h2>Modifiers</h2>

<p>Modifiers are functions that can be applied to the result of the string
expansion before the replacement takes place. Each modifier is a name
referring to a function. They do not take arguments.</p>

<blockquote class="lua">
  <p>It is possible for a pmfile to add its own string modifiers, by defining
  functions in the <code>pm.stringmodifier</code> table. Each function takes
  two arguments; the current rule, and the value the modifier is to be
  applied on. For example:</p>
  <pre>function pm.stringmodifier.typeof(rule, argument)
    return type(argument)
end</pre>
  <pre>"The type is %NAME:typeof%"</pre>

  <p>It is strongly recommended that string modifiers work equivalently on
  raw strings and single-item lists.</p>
</blockquote>

<p>The following string modifiers are available:</p>

<h3><code>dirname</code></h3>

<p>Takes a string, or a list with one item. Assumes the argument contains a
pathname and returns the directory part of it only.</p>

<h2>Special forms</h2>

<p>The following property values are special.</p>

<h3><code>EMPTY</code></h3>

<p>This is a special form of the empty list. It differs from <code>{}</code>
in that, when expanded, <code>{}</code> produces <code>""</code> and
<code>EMPTY</code> produces nothing.</p>

<p>For example: a rule may invoke a C compiler as follows:</p>
<pre>"gcc -o %O% %I% %CFLAGS%"</pre>

<p><code>%O%</code> expands to the name of the output file, <code>%I%</code>
expands to the name of the input file, and <code>%CFLAGS%</code> expands to a
list of compiler options. If <code>I="in.c"</code>, <code>O="out.o"</code>
and <code>CFLAGS={"-g", "-Os"}</code>, then this would produce:</p>
<pre>gcc -o out.o in.c "-g" "-Os"</pre>

<p>However, if no flags were defined, and <code>CFLAGS</code> defaulted to
<code>{}</code>, then this would produce:</p>
<pre>gcc -o out.o in.c ""</pre>

<p>This is incorrect. The last argument would be treated by gcc as a blank
source filename, and an error would result. To prevent this, the default
calue of <code>CFLAGS</code> should be <code>EMPTY</code>. This would cause
the expanded string to be suppressed, resulting in the correct string:</p>
<pre>gcc -o out.o in.c</pre>

<h3><code>{PARENT,</code> <var>values...</var><code>}</code></h3>

<p>This form is used to append values to an existing list. It only works on
inherited properties.</p>

<p>When the call stack is being traversed while looking for an inherited
property, normally traversal stops at the first value found. However, if the
value is a list of the special form described here, then traversal continues,
and the values specified get appended to the older values.</p>

<p>For example:</p>
<pre>CFLAGS = EMPTY
default = rule1 {
  CFLAGS = {"-g"},
  rule2 {
    CFLAGS = {PARENT, "-Os"},
    string = "%CFLAGS",
    ...
  }
}</pre>

<p>When <var>string</var> is expanded in the instantiation of
<var>rule2</var>, the result will be <code>{"-g", "-Os"}</code>.</p>

<p><code>{PARENT, ...}</code> forms may be nested arbitrarily.</p>

<h3><code>{REDIRECT,</code> <var>name</var><code>}</code></h3>

<p>This form, when seen, causes another named property to be looked up
instead of the current one. For example:</p>
<pre>CFLAGS = {"-g", "-Os"}
CXXFLAGS = {REDIRECT, "CFLAGS"}</pre>

<p>Unlike string expansion, this allows <code>{PARENT, ...}</code> to append
items to the list. (String expansion forces the result into a string
form.)</p>

<h1>The standard library</h1>

<p>The following rules are supplied as part of the Prime Mover core
functionality.</p>

<h2><code>node</code></h2>

<p>The ultimate superclass of all Prime Mover rules.</p>

<p>It is very unlikely that anyone will ever want to instantiate or subclass
<code>node</code>; it does not actually do anything useful. However, it
provides a number of services that subclasses will use.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><var>ensure_n_children</var></dt>
    <dd><p>A number. If set, then when this rule is instantiated, a check
      will be made that it has exactly this number of children.</p>
    </dd>
  <dt><var>ensure_at_least_one_child</var></dt>
    <dd><p>A number. If set, then when this rule is instantiated, a check
      will be made that it has at least one child.</p>
    </dd>
  <dt><var>construct_string_children_with</var></dt>
    <dd><p>A rule. If set, then any children that are bare strings and not
      rules will be replaced with instantiations of the rule, such that a
      child <code>"child"</code> will be replaced with <code>rule
      "child"</code>.</p>
      <p>Defaults to <code>file</code>.</p>
    </dd>
  <dt><var>all_children_are_objects</var></dt>
    <dd><p>A boolean. If set, then when this rule is instantiated, a check
      will be made that all children are rules and not bare strings. This
      check is done after <var>construct_string_children_with</var> is
      processed.</p>
      <p>Defaults to true. You will almost certainly never want to turn this
      off.</p>
    </dd>
  <dt><var>class</var></dt>
    <dd><p>A string. Contains the name of this class.</p>
      <p>This property has two purposes: firstly, it is used to produce
      meaningful error messages; and secondly, if this property is set when
      instantiating a rule, it signals Prime Mover that you are defining a
      new rule class and not producing a rule that is going to be used
      directly. This causes the checks described above (and others) to be
      bypassed.</p>
    </dd>
  <dt><var>install</var></dt>
    <dd><p>A string, or <code>pm.install()</code>, or a list of strings or
      <code>pm.install()</code>. Indicates special action to be taken after
      building this rule.</p>
      <p>Strings are treated as shell commands. String expansion is performed
      normally; <code>%out%</code> expands to a list of the current rule's
      outputs.</p>
      <p>The special value
      <code>pm.install(</code><var>src</var><code>,</code>
      <var>dest</var><code>)</code> may be used instead of a string. When
      executed, this causes pm to perform an optimised copy, and is the
      preferred way of doing an installation. <var>src</var> and
      <var>dest</var> are strings specifying the source and destination
      files; string expansion is performed normally. <var>src</var> may be
      omitted, in which case it defaults to <code>%out[1]%</code> (the first
      of the rule's output files).</p>
      <p>Strings and <code>pm.install</code> may be combined at will in a
      list.</p>

      <blockquote class="warning">
        <p>Any commands specified in <code>install</code> are executed every
        time the rule is visited by pm, even if nothing actually needs to be
        built. Don't use any commands that consume significant amounts of
        time to execute.</p>
      </blockquote>
    </dd>
</dl>

<h2><code>file</code></h2>

<p>Refers to a static file on the filesystem.</p>

<p>Does nothing when built. Is as old as the file is.</p>

<p>This rule is used in the leaves of the dependency tree to refer to source
files. It is illegal for a <code>file</code> to refer to a non-existant
file.</p>

<h4>Superclass</h4>

<p><code>node</code></p>

<h4>Inputs</h4>

<p>One or more constant strings, that are filenames relative to Prime Mover's
current directory.</p>

<h4>Outputs</h4>

<p>The files referred to.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><var>only_n_children_are_outputs</var></dt>
    <dd><p>A number. If set, then specifies the number of children to be used
      as outputs; any additional children will be ignored.</p>

      <blockquote class="warning">
        <p>Obsolete and will go away soon. Use <code>ith</code> instead.</p>
      </blockquote>
    </dd>
</dl>

<h2><code>group</code></h2>

<p>Groups together a number of children. Does nothing when built.</p>

<h4>Superclass</h4>

<p><code>node</code></p>

<h4>Inputs</h4>

<p>An arbitrary number of children.</p>

<h4>Outputs</h4>

<p>The same as its inputs.</p>

<h4>Example</h4>
<pre>rule1 = ...builds something...
rule2 = ...builds something else...

-- Building default causes both rule1 and rule2 to be built.
default = group {
    rule1,
    rule2
}</pre>

<p>This rule is also commonly used to allow properties to be overridden when
calling a child.</p>

<blockquote class="warning">
  <p><code>group</code> is equivalent to <code>ith</code> with no
  parameters.</p>
</blockquote>

<h2><code>ith</code></h2>

<p>Selects one or more of its children. Does nothing when built.</p>

<h4>Superclass</h4>

<p><code>node</code></p>

<h4>Inputs</h4>

<p>An arbitrary number of children.</p>

<h4>Outputs</h4>

<p>Some or all of its inputs.</p>

<h4>Recognised properties</h4>

<p><code>ith</code> responds to the following local properties:</p>
<dl>
  <dt><var>i</var></dt>
    <dd>a number describing the single child to select. May not be used in
      combination with <var>from</var> and <var>to</var>.</dd>
  <dt><var>from</var></dt>
    <dd>a number describing the first child of a range to select. May not be
      used in combination with <var>i</var>.</dd>
  <dt><var>to</var></dt>
    <dd>a number describing the last child of a range to select. May not be
      used in combination with <var>i</var>.</dd>
</dl>

<p><var>from</var> and <var>to</var> default to the first and last child
respectively. <code>ith</code> with no parameters is equivalent to group.</p>

<h4>Example</h4>
<pre>somerule = simple {
    -- This rule runs a script which outputs three files. However, we
    -- the first one is a text file that cannot be compiled.
}

default = cprogram {
    ith {
      -- Use of from causes the first child to be ignored; cprogram{}
      -- will only see the last two.
      from = 2,
      somerule
    }
}</pre>

<h2><code>foreach</code></h2>

<p>Applies a rule to all of its children.</p>

<p><code>foreach</code> instantiates all of its children with a particular
rule, and groups their outputs together like <code>group</code>.</p>

<p>It is useful if you have another rule that is returning an arbitrary
number of outputs, each of which needs to be built independently. For
example, a script may automatically generate several C files.</p>

<h4>Superclass</h4>

<p><code>node</code></p>

<h4>Inputs</h4>

<p>Zero or more rules.</p>

<h4>Outputs</h4>

<p>The accumulated outputs of the instantiated rule <code>r</code> after
applying r to all the inputs.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><var>rule</var></dt>
    <dd><p>The rule to apply to <code>foreach</code>'s children.
      Mandatory.</p>
    </dd>
</dl>

<h4>Example</h4>
<pre>myScript = simple {
    ...this script automatically generates some (maybe a lot) of C files.
}

default = cprogram {

    -- Run myScript, and build all of its results with cfile.
    foreach {
        rule = cfile,
        myScript
    }
}</pre>

<h2><code>simple</code></h2>

<p>Builds its children using a user-supplied shell command.</p>

<p>This rule, and subclasses of this rule, are where most of the work of a
pmfile will be executed. The rule <code>cfile</code>, which builds a C file
into an object file using gcc, is a subclass of <code>simple</code>.</p>

<p>To use simple, you must specify:</p>
<ul>
  <li>some inputs, which are supplied as children of the rule in the normal
    way;</li>
  <li>some outputs, supplied using the <code>outputs</code> property;</li>
  <li>and a command, which is supplied using the command property.</li>
</ul>

<p>If the command returns a error code, then any output files produced by the
rule will be automatically removed.</p>

<h4>Superclass</h4>

<p><code>node</code></p>

<h4>Inputs</h4>

<p>One or more rules.</p>

<h4>Outputs</h4>

<p>One or more rules.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><var>outputs</var></dt>
    <dd>A list of strings describing the output files this rule makes.
      <p>Each string describes the name of a file in the intermediate cache.
      String expansion is performed, but you may only use <code>%in%</code>,
      <code>%I%</code> and <code>%U%</code>. <code>%in%</code> expands to the
      list of input files; <code>%I%</code> expands to the leaf part of the
      first input file, without the extension; <code>%U%</code> expands to a
      unique identifier that represents the command being executed.
      <code>%O%</code> may not be used. Every template must start with
      <code>%U%</code>. Filenames may contain <code>/</code> characters ---
      directories are created automatically.</p>
      <p>The minimum legal output template is <code>{"%U%"}</code>. This
      defines one output with a machine-generated name. However, this is
      unfriendly when debugging, so it is usually recommended to use
      <code>{"%U%-%I%.x"}</code> where .x is replaced with the appropriate
      extension for the output file.</p>
    </dd>
  <dt><var>command</var></dt>
    <dd>A string, or a list of strings, containing the commands to be
      executed when building this rule.
      <p>Commands are executed via the standard shell (<code>/bin/sh</code>
      on most platforms). If multiple commands are provided, then they are
      glued together with <code>&amp;&amp;</code> before being executed.
      String expansion is performed; <code>%in%</code> expands to the list of
      input files, and <code>%out%</code> expands to the list of output files
      (as defined by the <var>outputs</var> property). <code>%I%</code> and
      <code>%U%</code> may not be used.</p>
    </dd>
</dl>

<h4>Example</h4>

<p>This example uses <code>tr</code> to convert files from upper case to
lower case.</p>
<pre>uppercasefnord = simple {
  outputs = {"%U%-%I%.txt"},
  command = "tr 'A-Za-z' &lt; %in[1]% &gt; %out[1]%"
  "fnord.txt"
}</pre>

<p>Here is the sample example using a rule subclass.</p>
<pre>uppercase = simple {
  class = "uppercase",
  outputs = {"%U%-%I%.txt"},
  command = "tr 'A-Za-z' &lt; %in[1]% &gt; %out[1]%"
}

uppercasefnord = uppercase "fnord.txt"</pre>

<p>This example provides a rule that uses head and tail to split a file into
three parts.</p>
<pre>topandtail = simple {
  class = "topandtail",
  outputs = {
    "%U%-%I%/top.txt",
    "%U%-%I%/middle.txt",
    "%U%-%I%/bottom.txt"
  },
  command = {
    "head -20 &lt; %in[1]% &gt; %out[1]%",
    "tail +20 &lt; %in[1]% | tail -20 &gt; %out[2]%",
    "tail -20 &lt; %in[1]% &gt; %out[3]%"
  }
}</pre>

<p>This command uses cc to compile a C source file into an object file.</p>
<pre>simple_cfile = simple {
  class = "simple_cfile",
  outputs = {"%U%-%I%.o"},
  command = "cc -c -o %out[1]% %in%"
}</pre>

<h2><code>deponly</code></h2>

<p>Builds its children, but does not return them.</p>

<p>This rule acts like <code>group</code>, but has no outputs. When built, it
will build its inputs, will also cause its caller to rebuild itself.</p>

<p>This is occasionally useful if you have a rule whose command is referring
to files outside of Prime Mover's control; for example, a C file will refer
to header files. You want the C file to be rebuilt if any of the headers
change, but you do not pass the header files directly into the C compiler.
deponly allows you to refer to the header files without actually using
them.</p>

<h4>Superclass</h4>

<p><code>node</code></p>

<h4>Inputs</h4>

<p>One or more rules.</p>

<h4>Outputs</h4>

<p>None.</p>

<h4>Example</h4>
<pre>example_cfile = simple {
    ...command to compile the first child as a source file...

    -- If input.c changes, the rule will rebuild.
    file "input.c",

    -- If header.h changes, the rule will also rebuild, even
    -- though header.h is not used by the rule.
    deponly {
        file "header.h"
    }
}</pre>

<p></p>
</body>
</html>
