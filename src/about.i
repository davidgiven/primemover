<?xml version='1.0'?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>

  <head>

    <title>About Prime Mover</title>

  </head>

  <body>

    <h1>Introduction</h1>

    <p>Prime Mover (<tt>pm</tt> for short) is a build tool, not unlike 
    <tt>make</tt>. It is designed to be small, portable, flexible, 
    powerful, and is very easy to deploy. It can be distributed along 
    with your application source code and does not require your end 
    user to have anything other than a basic C compiler in order to use 
    it.</p>

    <ul>

      <li>Automatic dependency checking for C-like files</li>

      <li>Explicit dependency graphs</li>

      <li>Arbitrarily complex rules (it&apos;s possible to clearly 
      represent far more complex dependency graphs in <tt>pm</tt> than 
      you can in make)</li>

      <li>Can handle multiple directories at the same time (no more 
      recursive makefiles!)</li>

      <li>Highly scalable (<tt>pm</tt> can deal with very large builds 
      as easily as very small ones)</li>

      <li>Easy cross-compilation (object files are stored in 
      <tt>pm</tt>&apos;s own object file cache, not in your build tree, 
      so you don&apos;t have to worry about distinguishing them)</li>

      <li>Build multiple versions of the same application (<tt>pm</tt> 
      remembers the compiler options used to build every file, and can 
      tell different versions of the same object file apart)</li>

      <li>Easy deployment (all of <tt>pm</tt>&apos;s core code consists 
      of exactly file, which can be run on nearly any platform --- no 
      installation or compilation needed!)</li>

      <li>Object oriented design (making it very easy to create your 
      own rules by specialising one of the existing ones)</li>

      <li>A true programming language (if you need it, all the power of 
      the Lua programming language is at your fingertips)</li>

    </ul>

    <p><tt>pm</tt> differs from <tt>make</tt> primarily in that all 
    dependencies in <tt>pm</tt> are explicit. <tt>make</tt> will 
    attempt to determine what needs to be done to build a file, based 
    on a set of rules that tell it how to transform file types. This 
    works well until you need to have <i>different</i> rules apply to 
    two files of the same type... which then causes <i>make</i> to 
    quickly become unmanageable.</p>

    <p><tt>pm</tt> avoids this by requiring all rules to be explicit. 
    Thanks to the power of syntactic sugar, it is much less work than 
    it sounds, never fear.</p>

    <p>The best explanation is an example, and so here is an example 
    pmfile that will build a simple C program:</p>

    <pre>-- load the C rules
include &quot;c.pm&quot;

-- default target builds a C program
default = cprogram {
    -- cfile transforms a C source file into an object file
    cfile &quot;main.c&quot;,
    cfile &quot;utils.c&quot;,
    cfile &quot;aux.c&quot;,

    -- once built, this makes the result available
    install = pm.install(&quot;myprogram&quot;)
}</pre>
    <p>If this is saved as &quot;pmfile&quot; in the current directory, 
    it can be invoked by simply doing:</p>

    <pre>./pm</pre>

    <p>...and it will run.</p>

    <p />

  </body>

</html>

