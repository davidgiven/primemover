<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
  <meta content="application/xhtml+xml; charset=UTF-8"
  http-equiv="content-type" />
  <title>Installing Prime Mover into a new project</title>
</head>

<body>
<h1>Introduction</h1>

<p>This document describes how to install Prime Mover into a new project.</p>

<p>This is intended to be used by application authors who wish to adopt Prime
Mover as their build tool. It does not tell you how to write a pmfile; see <a
href="pmfiles.i">pmfiles.i</a> for that. It also does not tell you how to use
Prime Mover itself; <a href="invocation.i">invocation.i</a> for instructions
on how to do that.</p>

<h1>Necessary files</h1>

<p>A project using Prime Mover must have at least two files, and probably a
few more. These consist of:</p>
<ul>
  <li>the Prime Mover executable itself;</li>
  <li>any optional plugins used by Prime Mover.</li>
  <li>the project's pmfile;</li>
</ul>

<p>The typical layout for a project using Prime Mover is to have the pm
executable in the project root directory, along with the default pmfile, and
to have the plugins in a subdirectory somewhere. For example:</p>
<pre>helloworld-0.1/README
helloworld-0.1/pm
helloworld-0.1/pmfile
helloworld-0.1/src/hello.c
helloworld-0.1/lib/c.pm</pre>

<p>This layout allows the application to be built by simply changing into the
project's directory and doing:</p>
<pre>./pm</pre>

<p>Practically every project is going to need <code>c.pm</code>; it contains
the additional rules necessary to allow Prime Mover to build C and C++ files.
See <a href="c.i">c.i</a> for detailed information.</p>

<h1>Installing the executable</h1>

<p>The Prime Mover distribution contains three different versions of the main
executable, which are in the <code>bin</code> directory in the Prime Mover
distribution. These are all functionally identical, but have been encoded
differently.</p>
<dl>
  <dt><code>pm_8bit</code></dt>
    <dd>This version is the smallest, and contains gzip compressed data. As a
      result, it is not 8-bit clean. Can not be updated via patch files.</dd>
  <dt><code>pm_uncompressed</code></dt>
    <dd>This version is the largest, and contains plain text. Can be updated
      via patch files.</dd>
  <dt><code>pm_7bit</code></dt>
    <dd>This is version is a compromise between the above two versions; it
      contains data that has been gzip compressed and then uuencoded. It is
      8-bit clean. Can be updated via patch files, but may produce extremely
      large patches.</dd>
</dl>

<p>Which version you use depends on your exact situation. In particular, if
your package is to be distributed as a <code>tar.gz</code> or
<code>tar.bz2</code> file, then using <code>pm_uncompressed</code> may
actually reduce the size of your distribution file; the extra overhead in
<code>pm_7bit</code> or <code>pm_8bit</code> causes it to compress less
well.</p>

<p>The exact figures:</p>

<table border="1">
  <tbody>
    <tr>
      <th>Version</th>
      <th>Uncompressed</th>
      <th>Compressed with gzip -9</th>
      <th>Compressed with bzip -9</th>
    </tr>
    <tr>
      <td><code>pm_uncompressed</code></td>
      <td>178kB</td>
      <td>63kB</td>
      <td>58kB</td>
    </tr>
    <tr>
      <td><code>pm_8bit</code></td>
      <td>63kB</td>
      <td>63kB</td>
      <td>64kB</td>
    </tr>
    <tr>
      <td><code>pm_7bit</code></td>
      <td>87kB</td>
      <td>66kB</td>
      <td>66kB</td>
    </tr>
  </tbody>
</table>

<p>To use a particular version, simply copy the file and rename it to pm.</p>
<pre>cp pm_uncompressed ~/projects/helloworld-0.1/pm</pre>

<h1>Installing the plugins</h1>

<p>Plugins are stored in the Prime Mover distribution's <code>lib</code>
directory; see the documentation index for a list of the supported plugins.
Most projects will want <code>c.pm</code>, as that will allow them to compile
C and C++ programs.</p>

<p>To use a plugin, simply copy it into your project somewhere. You may, if
you wish, put it in the root directory along with <code>pm</code> and your
<code>pmfile</code>, but this is not recommended as it can clutter things.</p>
<pre>cp lib/c.pm ~/projects/helloworld-0.1/lib/c.pm</pre>

<h1>Writing the pmfile</h1>

<p>The final stage is to write your application's pmfile. See <a
href="pmfiles.i">pmfiles.i</a> for a full description of this, but the key
points are:</p>
<ul>
  <li>Include your plugins, using the right filename, in the right order.</li>
  <li>Define a default rule.</li>
  <li>Remember that unless you explicitly tell Prime Mover to install things
    using the <code>install</code> property, you will not see the results of
    your build.</li>
</ul>

<p>For example:</p>
<pre>include "lib/c.pm"

default = cprogram {
  cfile "src/hello.c",

  install = pm.install("hello")
}</pre>

<p>This is a minimal but complete example that will build our helloworld
project.</p>

<h1>Tips</h1>

<p>Here is some random advice on writing pmfiles:</p>
<ul>
  <li>If you have a big application, try using <code>include</code> to split
    your pmfile up into little files spread throughout your application. This
    way the rules describing how to build each directory are in the directory
    itself.</li>
  <li>Paths are always relative to the current directory when pm was run.</li>
</ul>
</body>
</html>
