<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
  <meta http-equiv="content-type"
  content="application/xhtml+xml; charset=UTF-8" />
  <title>The C and C++ plugin</title>
</head>

<body>
<h1>Introduction</h1>

<p>The <code>c.pm</code> plugin allows Prime Mover to build C and C++ files
into standard applications and simple static libraries. It supports automatic
dependency calculation on C-like files, and is reasonably configurable.</p>

<blockquote class="warning">
  <p>Shared libraries are, unfortunately, not supported. This is because the
  process for making shared libraries is extremely unportable; there are
  tools such as <a href="http://www.gnu.org/software/libtool/">GNU
  libtool</a> available, but they tend to be very large and complex. The
  libtool script is bigger than most Prime Mover executables.</p>

  <p>There is a strong possibility that at some point in the future Prime
  Mover will support libtool directly, or else have its own equivalent
  functionality, but for now, <code>c.pm</code> does not know how to make
  shared libraries.</p>
</blockquote>

<h1>Global settings</h1>

<p>By default, <code>c.pm</code> is set up to use the gcc tool chain. The
commands <code>gcc</code>, <code>g++</code>, <code>ar</code> and
<code>ranlib</code> are used. These can all be modified by changing the
appropriate properties.</p>

<h2>For building C</h2>
<dl>
  <dt><code>CC</code></dt>
    <dd><p>The command used to compile a single C source file into an object
      file. Defaults to:</p>
      <pre>%CCOMPILER% %CBUILDFLAGS% %CDYNINCLUDES:cincludes% %CINCLUDES:cincludes% %CDEFINES:cdefines% %CEXTRAFLAGS% -c -o %out% %in%</pre>
      <p>This may be overridden completely, or customised by modifying the
      variables that it refers to.</p>
    </dd>
  <dt><code>CPROGRAM</code></dt>
    <dd><p>The command used to compile object files into a runnable
      executable. Defaults to:</p>
      <pre>%CCOMPILER% %CBUILDFLAGS% %CLINKFLAGS% %CEXTRAFLAGS% -o %out% %in% %CLIBRARIES:clibraries%</pre>
    </dd>
  <dt><code>CCOMPILER</code></dt>
    <dd><p>The name of the C compiler executable. Defaults to:</p>
      <pre>gcc</pre>
    </dd>
</dl>

<h2>For building C++</h2>
<dl>
  <dt><code>CXX</code></dt>
    <dd>The command used to compile a single C++ source file into an object
      file. Defaults to:
      <pre>%CXXCOMPILER% %CBUILDFLAGS% %CDYNINCLUDES:cincludes% %CINCLUDES:cincludes% %CDEFINES:cdefines% %CEXTRAFLAGS% -c -o %out% %in%</pre>
      <p>This may be overridden completely, or customised by modifying the
      variables that it refers to.</p>
    </dd>
  <dt><code>CXXPROGRAM</code></dt>
    <dd>The command used to compile object files into a runnable executable.
      Defaults to:
      <pre>%CXXCOMPILER% %CBUILDFLAGS% %CLINKFLAGS% %CEXTRAFLAGS% -o %out% %in% %CLIBRARIES:clibraries%</pre>
    </dd>
  <dt><code>CXXCOMPILER</code></dt>
    <dd>The name of the C compiler executable. Defaults to:
      <pre>g++</pre>
    </dd>
</dl>

<h2>For both</h2>
<dl>
  <dt><code>CLIBRARY</code></dt>
    <dd><p>The command used to build C or C++ static libraries. Defaults
      to:</p>
      <pre>rm -f %out% &amp;&amp; ar cr %out% %in% &amp;&amp; ranlib %out%</pre>
    </dd>
  <dt><code>CBUILDFLAGS</code></dt>
    <dd><p>A list of strings containing flags that change the way the
      compiler behaves. This is typically used to change debugging and
      optimisation settings. Defaults to:</p>
      <pre>{"-g"}</pre>
      <p>(As this is a list, flags may be appended by using the
      <code>{PARENT, "..."}</code> syntax.)</p>
    </dd>
  <dt><code>CDYNINCLUDES</code></dt>
    <dd><p>This is replaced at run time with a list of paths determined by
      the dynamicheaders property of the
      <code>simple_with_clike_dependencies</code> rule. It is not overridable
      and has no default.</p>
    </dd>
  <dt><code>CINCLUDES</code></dt>
    <dd><p>A list of paths where the compiler should look for include files.
      Defaults to <code>EMPTY</code>.</p>
    </dd>
  <dt><code>CDEFINES</code></dt>
    <dd><p>A set of strings of the format <code>KEY</code> or
      <code>KEY=VALUE</code> that specify preprocessor constants that should
      be defined by the compiler. Defaults to <code>EMPTY</code>.</p>
    </dd>
  <dt><code>CEXTRAFLAGS</code></dt>
    <dd><p>A list of any additional flags that should be passed to the
      compiler. Defaults to <code>EMPTY</code>.</p>
    </dd>
</dl>

<h1>String modifiers</h1>

<p>A number of custom string modifiers are defined by the C plugin for
massaging lists. These may be overridden as necessary, but only on a global
basis.</p>

<h2><code>cincludes</code></h2>

<p>Used to convert a list of paths into a set of arguments suitable for
passing to the compiler. Defaults to prefixing <code>-I</code> to each
item.</p>

<h2><code>cdefines</code></h2>

<p>Used to convert a list of <code>KEY=VALUE</code> tuples into a set of
arguments suitable for passing to the compiler. Defaults to prefixing
<code>-D</code> to each item.</p>

<h2><code>clibraries</code></h2>

<p>Used to convert a list of library names into a set of arguments suitable
for passing to the compiler.</p>

<p>For each item, if the item ends in <code>.a</code>, it is left untouched;
otherwise <code>-l</code> is prefixed.</p>

<h1>Rules</h1>

<h2>For building C</h2>

<h3><code>cfile</code></h3>

<p>Compiles a C source file into an object file.</p>

<h4>Superclass</h4>

<p><code>simple_with_clike_dependencies</code></p>

<h4>Inputs</h4>

<p>Exactly one C source file.</p>

<h4>Outputs</h4>

<p>Exactly one object file.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><code>CC</code></dt>
    <dd>The command used to compile the source file.</dd>
</dl>

<h3><code>cprogram</code></h3>

<p>Compiles multiple C object files into a single executable program.</p>

<p>It is possible to mix object files built with <code>cfile</code> and
<code>cxxfile</code>, but this rule will assume that all the source files
were in C, and so will not include the C++ run time libraries.</p>

<h4>Superclass</h4>

<p><code>simple</code></p>

<h4>Inputs</h4>

<p>One or more object files.</p>

<h4>Outputs</h4>

<p>Exactly one executable.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><code>CPROGRAM</code></dt>
    <dd>The command used to link the application.</dd>
</dl>

<h2>For building C++</h2>

<h3><code>cxxfile</code></h3>

<p>Compiles a C++ source file into an object file.</p>

<h4>Superclass</h4>

<p><code>simple_with_clike_dependencies</code></p>

<h4>Inputs</h4>

<p>Exactly one C++ source file.</p>

<h4>Outputs</h4>

<p>Exactly one object file.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><code>CXX</code></dt>
    <dd>The command used to compile the source file.</dd>
</dl>

<h3><code>cxxprogram</code></h3>

<p>Compiles multiple C++ object files into a single executable program.</p>

<p>It is possible to mix object files built with <code>cfile</code> and
<code>cxxfile</code>.</p>

<h4>Superclass</h4>

<p><code>simple</code></p>

<h4>Inputs</h4>

<p>One or more object files.</p>

<h4>Outputs</h4>

<p>Exactly one executable.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><code>CXXPROGRAM</code></dt>
    <dd>The command used to link the application.</dd>
</dl>

<h2>General</h2>

<h3><code>clibrary</code></h3>

<p>Creates a static library from multiple object files.</p>

<p>This can be used with any combination of object files created with
<code>cfile</code> or <code>cxxfile</code>.</p>

<h4>Superclass</h4>

<p><code>simple</code></p>

<h4>Inputs</h4>

<p>One or more object files.</p>

<h4>Outputs</h4>

<p>Exactly one static library.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><code>CLIBRARY</code></dt>
    <dd>The command used to link the library.</dd>
</dl>

<h3><code>simple_with_clike_dependencies</code></h3>

<p>Performs like simple, but takes into account any included files used by
its argument. This rule is not intended to be used directly, and is more
appropriate for use as an abstract base class.</p>

<p>The dependency analysis is rather simple. The source files are studied
recursively for #include lines. References to missing include files are
ignored. If any of the included files is newer than the object file, then the
source file will be rebuilt; however, no attempt will be made to build the
included files themselves. (See <code>dynamicheaders</code> below.)</p>

<h4>Superclass</h4>

<p><code>simple</code></p>

<h4>Inputs</h4>

<p>Exactly one source file destined to be run through the C preprocessor.</p>

<h4>Outputs</h4>

<p>As for <code>simple</code>.</p>

<h4>Recognised properties</h4>
<dl>
  <dt><code>dynamicheaders</code></dt>
    <dd><p>This property should contain a list of rule instantiations, which
      are intended to be used for building any dynamic header files that the
      source file will need to refer to. This rules will be considered as
      part of the dependency calculations, and they will be rebuilt if
      necessary, but their result will be ignored by Prime Mover. (It is
      assumed that the source file is going to refer to the result using a
      mechanism that Prime Mover does not know about.)</p>
      <p>If this property is used, then the <code>CDYNINCLUDES</code>
      property will be automatically set up to contain a list of the
      directories containing the results of the rules in
      <code>dynamicheaders</code>. This allows the C preprocessor to find any
      generated files.</p>
      <p>The main use of this property is to tell pm how to build dynamically
      generated header files. For example:</p>
      <pre>include "lib/c.pm"

make_dynamic_h = simple {
  command = {
    "echo '#define DYNAMIC' &gt; %out%"
  },
  outputs = {"%U%/dynamic.h"},
}

default = cprogram {
  cfile "test.c",
  cfile {
    "includes-dynamic.c",
    dynamicheaders = make_dynamic_h,
  }
}</pre>
    </dd>
</dl>
</body>
</html>
