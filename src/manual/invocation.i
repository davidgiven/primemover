<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
  <meta http-equiv="content-type"
  content="application/xhtml+xml; charset=UTF-8" />
  <title>Using Prime Mover</title>
</head>

<body>
<h1>Introduction</h1>

<p>This document describes how to use the Prime Mover command line tool to
invoke pmfiles, build things, and how to manage the intermediate cache.</p>

<p>It does not tell you how to write a pmfile; see <a
href="pmfiles.i">pmfiles.i</a> for that. It also does not tell you how to
install Prime Mover in a new package; see <a
href="installation.i">installation.i</a> for instructions on how to do
that.</p>

<h1>Running Prime Mover</h1>

<p>Prime Mover is deployed as a single, small shell script. On most systems,
run it by doing:</p>
<pre>./pm [options] [rules]</pre>

<p>The minimum possible command is simply:</p>
<pre>./pm</pre>

<p>This will load the default pmfile, which is called <code>pmfile</code>,
and attempt to build the rule called <code>default</code> from that
pmfile.</p>

<p>pm must be able to write to the current working directory.</p>

<h1>Options</h1>

<p>If pm is run with the <code>-h</code> or <code>--help</code> options, it
will produce the following summary:</p>
<pre>pm: Prime Mover version X.X © 2006 David Given
Syntax: pm [&lt;options...&gt;] [&lt;targets&gt;]
Options:
   -h    --help        Displays this message.
         --license     List Prime Mover's redistribution license.
   -cX   --cachedir X  Sets the object file cache to directory X.
   -p    --purge       Purges the cache before execution.
                       WARNING: will remove *everything* in the cache dir!
   -fX   --file X      Reads in the pmfile X. May be specified multiple times.
   -DX=Y --define X=Y  Defines variable X to value Y (or true if Y omitted)
   -n    --no-execute  Don't actually execute anything
   -v    --verbose     Be more verbose
   -q    --quiet       Be more quiet

If no pmfiles are explicitly specified, 'pmfile' is read.
If no targets are explicitly specified, 'default' is built.
Options and targets may be specified in any order.</pre>

<p>Option parameters are accepted in any of the formats <code>-lFNORD</code>,
<code>-l FNORD</code>, and <code>--long-option FNORD</code>. Options are read
in and processed in the order in which they are specified.</p>

<p>The options are described in more detail here.</p>
<dl>
  <dt><code>-h</code> or <code>--help</code></dt>
    <dd>Produces the above help summary.</dd>
  <dt><code>--license</code></dt>
    <dd>Emits Prime Mover's redistribution license to the terminal and exits
      immediately. Prime Mover may be distributed under the terms of the MIT
      public license, which is one of the 'classic' licenses approved by the
      Open Source Initiative; see <a
      href="http://www.opensource.org/licenses/index.php">the OSI's license
      page</a> for more information.</dd>
  <dt><code>-c </code><var>dir</var> or
  <code>--cachedir</code> <var>dir</var></dt>
    <dd>Changes the location of Prime Mover's intermediate cache to
      <var>dir</var>. This should point at the directory where Prime Mover
      should place all of its working files, including the results of all
      builds. It is not intended to be human readable, and defaults to
      <code>.pm-cache</code>; it will be automatically created if
    necessary.</dd>
  <dt><code>-p</code> or <code>--purge</code></dt>
    <dd>Causes the intermediate cache directory to be removed before
      proceeding; this will cause it to be automatically recreated. This will
      remove <i>all</i> files in the directory, including ones that Prime
      Mover does not know about.</dd>
  <dt><code>-f </code><var>filename</var> or
  <code>--file</code> <var>filename</var></dt>
    <dd>Reads in the pmfile <var>filename</var>. This option may be supplied
      several times; each pmfile will be read in in order.

      <blockquote class="lua">
        <p>Each pmfile will be executed immediately as a Lua script, but
        Prime Mover will only start the rule engine once all the pmfiles have
        been loaded. This means that any Lua extension code will be executed
        even if a subsequent error cause Prime Mover to fail its startup.</p>
      </blockquote>
    </dd>
  <dt><code>-D </code><var>name</var><code>=</code><var>value</var> or
  <code>--define </code><var>name</var>=<var>value</var></dt>
    <dd>Defines a global property <var>name</var>, with value
      <var>value</var>.
      <p><var>value</var> must be a valid constant; if a string, it must be
      quoted. (The quotation marks may need to be escaped to prevent the
      shell from touching them.) <var>value</var> may be omitted, in which
      case it defaults to <code>true</code>.</p>
    </dd>
  <dt><code>-n</code> or <code>--no-execute</code></dt>
    <dd>Cause Prime Mover to go through the motions of doing a build, but
      without actually doing anything. This can be occasionally useful for
      debugging.

      <blockquote class="lua">
        <p>Any Lua extension code will still be executed.</p>
      </blockquote>

      <blockquote class="warning">
        <p>The commands generated by <code>--no-execute</code> may differ
        slightly from those done by a normal build if there are any
        dynamically generated source files being used.</p>
      </blockquote>
    </dd>
  <dt><code>-v</code> or <code>--verbose</code></dt>
    <dd>Causes Prime Mover to produce quite a lot of debug tracing describing
      exactly what it is doing.</dd>
  <dt><code>-q</code> or <code>--quiet</code></dt>
    <dd>Causes Prime Mover to suppress some of its normal status messages,
      including the echoing of the command being executed.
      <p>(It is possible, but not very useful, to specify
      <code>--verbose</code> and <code>--quiet</code> together.)</p>
    </dd>
</dl>

<h1>Using Prime Mover as a Lua interpreter</h1>

<p>It is possible to use the pm executable as a stand-alone Lua interpreter,
without invoking the rules engine. This can be particularly useful for
writing helper scripts for using during a build; having the full power of the
Lua language available can simplify matters considerably, as well as helping
avoid dependencies on third party tools.</p>

<p>To do this, invoke your Lua program as if it were a pmfile:</p>
<pre>./pm -f script.lua</pre>

<p>The script must explicitly terminate using <code>os.exit()</code>. If it
does not, then the rules engine will start, which can cause extremely odd
behaviour. For example:</p>
<pre>-- This is an example Lua script.
print "Enter your name:"
name = io.read()
for i = 1, string.len(name) do
  print(string.sub(name, 1, i))
end
os.exit(0)</pre>

<p>The arguments used to invoke pm are available in the <code>arg</code>
table; however, all the arguments are available there, even the ones
irrelevant to the script.</p>

<p>The version of Lua used is 5.0, patched to use integers only. A slightly
modified version of <a
href="http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/">Luiz Henrique de
Figueiredo's lposix library</a> is available in the <code>posix</code> table;
explicitly requiring it is not necessary.</p>

<h1>Troubleshooting</h1>

<h2>The bootstrap process</h2>

<blockquote class="warning">
  <p>You do not need to know anything from this section to use Prime Mover.
  This is provided for technical background and to assist if things go
  wrong.</p>
</blockquote>

<p>The <code>pm</code> executable is actually a shell script containing two
packed files. One of these files is the code that actually makes up Prime
Mover, which is written in Lua; the other file is C source code for a patched
version of the Lua interpreter.</p>

<p>In order to run Prime Mover, the Lua interpreter must be compiled. The
first time pm is run for a particular architecture, it will unpack the C file
and compile it using <code>gcc</code>, if available, or <code>cc</code> if
not. The executable is then cached in the file
<code>.pm-</code><var>architecture</var>, where <var>architecture</var>
identifies the machine architecture (so multiple architectures can use pm
from the same source directory). Subsequent invocations of pm will used this
cached version.</p>

<p>The architecture is determined by trying these three commands, in order,
until one of them succeeds:</p>
<pre>arch
machine
uname -m</pre>

<p>If none of these succeeds, the pm will emit a warning and continue, using
<code>unknown</code> as the architecture name.</p>

<p>To determine what compiler is available, pm will attempt to look up gcc on
the path. If it is available, then the Lua interpreter will be compiled with
the following interpreter:</p>
<pre>gcc -O -s $in.c -o $out</pre>

<p>If it is not available, this will be used instead:</p>
<pre>cc $in.c -o $out</pre>

<p>(<code>$in</code> is replaced with the name of the temporary file
containing the Lua interpreter source code, and <code>$out</code> is replaced
with the name of the cached executable.</p>

<p>If neither C compiler is available, or the available C compiler does not
use the standard syntax, then pm will fail in an obscure manner. This is a
known issue.</p>
</body>
</html>
