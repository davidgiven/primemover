<?xml version='1.0'?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>

  <head>

    <title>About Prime Mover</title>

  </head>

  <body>

    <h1>Introduction</h1>

    <p>Prime Mover is a build tool.</p>

    <p>A build tool is a system for allowing you to compile large 
    applications efficiently. If you have an application made up of 
    thousands source files, then you don&apos;t want to have to compile 
    all those files every time you touch one thing in the source code. 
    You only want to rebuild the parts of the application that may be 
    affected by the change you made.</p>

    <p>Build tools let you do this.</p>

    <p>The classic build tool is the venerable 
    <a href="http://en.wikipedia.org/wiki/Make"><tt>make</tt></a>. 
    <tt>make</tt> has been invented and reinvented many times over its 
    incredibly long history --- the first version was written in 1977, 
    which makes it only two years younger than me --- and it does what 
    it does very well; unfortunately, times have changed since 1977, 
    and it&apos;s becoming more and more difficult to persuade 
    <tt>make</tt> to meet the needs of modern software development.</p>

    <p>Prime Mover was written because I had a large project to build 
    (the <a href="http://tack.sf.net">Amsterdam Compiler Kit</a>, which 
    as part of its build process generates over seven thousand object 
    files), and I simply couldn&apos;t make <tt>make</tt> do what I 
    wanted.</p>

    <h1>Dependencies</h1>

    <p>The key concept behind Prime Mover is that of 
    <i>dependencies</i>. A file A is considered to depend on a file B 
    if any changes to B will effect A. To put it another way: if B gets 
    modified, then A needs to be compiled as well. As an example of how 
    this works, consider the following simple application. It 
    contains:</p>

    <ul>

      <li>One executable</li>

      <li>...built from three object files</li>

      <li>...built from three C source files</li>

      <li>...which in turn refer to a single global header file.</li>

    </ul>

    <p><img src="dependencies.png"/></p>

    <p>Whenever any file gets modified, a build tool needs to follow 
    the arrows and recompile all files reached.</p>

    <p><tt>make</tt> expresses this dependency tree as follows:</p>

    <pre>a.out: one.o two.o three.o
one.o: one.c
two.o: two.c
three.o: three.c
one.c two.c three.c: globals.h</pre>
    <p><tt>pm</tt> expresses this dependency tree as follows:</p>

    <pre>default = cprogram {
    cfile &quot;one.c&quot;,
    cfile &quot;two.c&quot;,
    cfile &quot;three.c&quot;,
    install = pm.install(&quot;a.out&quot;)
}</pre>
    <p>You may notice a few major differences:</p>

    <p />

    <h1>Technology</h1>

    <p>Fundamentally, Prime Mover is a small program written in Lua, 
    wrapped inside some clever shell scripts so that you don&apos;t 
    need a Lua interpreter to allow you to run it. pmfiles themselves 
    are Lua scripts executed by pm. They </p>

  </body>

</html>

