<?xml version='1.0'?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>

  <head>

    <title>Frequently Asked Questions</title>

  </head>

  <body>

    <h1>General</h1>

    <h2>I don&apos;t want my users to have to install Prime Mover to be 
    able to build my application.</h2>

    <p>You don&apos;t have to.</p>

    <p>Prime Mover is designed to be simply dropped into your source 
    code package. It is distributed as a self-bootstrapping shell 
    script that&apos;s about 80kB long --- roughly on a par with a 
    medium complexity configure script. Your users don&apos;t have to 
    install anything; they simply run the script.</p>

    <h2>But Prime Mover&apos;s written in Lua. My users will have to 
    install a Lua interpreter to run Prime Mover.</h2>

    <p>Nope!</p>

    <p>When the Prime Mover shell script is first run, it unpacks a 
    copy of the Lua source code into a temporary file and compiles it. 
    The resulting executable is cached and used to run Prime Mover 
    itself.</p>

    <h2>But isn&apos;t this very inefficient?</h2>

    <p>Certainly, but the Lua source code is so small (about 50kB, 
    compressed) that the convenience factor far outweighs the cost. 
    Because each application that <i>uses</i> Prime Mover comes 
    <i>with</i> Prime Mover, we don&apos;t have to worry about 
    installion, version mismatches, application-specific patches, etc. 
    It really is a case of just run it and go.</p>

    <h2>What platforms does Prime Mover run?</h2>

    <p><i>Theoretically</i>, Prime Mover should run on any reasonably 
    Unix-like Posix system with <tt>gcc</tt> or a C compiler called 
    <tt>cc</tt>. <i>In practice</i>, it has been successfully tested 
    on:</p>

    <ul>

      <li>Linux</li>

      <li>NetBSD, OpenBSD, FreeBSD</li>

      <li>Solaris</li>

      <li>OS X</li>

      <li>BeOS</li>

    </ul>

    <p>It is known <i>not</i> run on:</p>

    <ul>

      <li>Minix, because Minix has no VM and requires applications to 
      be told up front how much memory they&apos;re ever going to use, 
      and Prime Mover&apos;s bootstrap process doesn&apos;t know 
      this;</li>

      <li>Microsoft Windows out of the box, because it requires the 
      Bourne shell, the standard Unix fileutils, etc. (However, if you 
      install <a href="http://www.cygwin.com/">Cygwin</a>, Prime Mover 
      should work.)</li>

    </ul>

    <p>If anyone has any reports of working-ness or non-working-ness, 
    please let me know.</p>

    <h1>Using pmfiles</h1>

    <h2>When I invoke my pmfile, I get this really wierd error 
    message!</h2>

    <p>Because all pmfiles are valid Lua programs, if you get something 
    wrong that confuses the Lua compiler, you&apos;ll get a Lua error 
    message. It&apos;s a stack trace. The bit you want is usually at 
    the top.</p>

    <p>Making the error messages friendlier is on my to-do list. If 
    you&apos;re really stuck, ask on the <a href="mailinglist.html">
    mailing list</a>.</p>

    <h2>When I invoke my pmfile, it hangs!</h2>

    <p>You&apos;ve got a recursive loop.</p>

    <p>pm dependency graphs may be cyclic; it&apos;s possible for A to 
    depend on B which depends on A. This may be useful if the two As 
    are built with different options that causes the second A not to 
    depend on B.</p>

    <p>If you get this wrong, pm will just keep happily recursing into 
    the cycle until it runs out of memory, without being able to tell 
    whether you&apos;re doing it on purpose or not.</p>

    <p>(I&apos;m still deciding with recursive dependency graphs are a 
    good idea or not.)</p>

    <h2>When I invoke my pmfile, it only builds some of a rule&apos;s 
    children!</h2>

    <p>You&apos;ve probably got a typo.</p>

    <p>This is a side effect of Prime Mover being written in Lua, 
    I&apos;m afraid. Prime Mover rules are expressed as Lua arrays; Lua 
    defines an array as a list of items terminated in a <tt>nil</tt>. 
    Unfortunately, unrecognised global symbols evaluate to <tt>nil</tt> 
    too. So this:</p>

    <pre>default = group {
    program1,
    program2,
    proogram3,
    program4
}</pre>
    <p>...will assume that <tt>program2</tt> is the last item in the 
    rule, because <tt>proogram3</tt> (which is misspelt) evaluated to 
    <tt>nil</tt>.</p>

    <p>I have a potential workaround for this, that should allow pm to 
    warn you in most cases; it&apos;s still on my to-do list.</p>

    <h1>The intermediate cache</h1>

    <h2>pm claims to have built something, but I don&apos;t see any .o 
    files!</h2>

    <p>When pm builds things, it puts all intermediate files into a 
    private cache directory. The contents of this directory are not 
    really intended for public consumption, and so you have to 
    explicitly tell pm to export files from it. This is done with the 
    <tt>install</tt> property, which may be added to any rule. See the 
    main documentation for a full discussion.</p>

    <p>The intermediate cache is, by default, in <tt>./.pm-cache</tt>. 
    It may be deleted at any time with no ill-effects (apart from 
    making the next build take longer).</p>

    <h2>What&apos;s the equivalent of <tt>make clean</tt>?</h2>

    <p>Firstly, if your dependency graph is correct, you should never 
    need to do this --- pm should, automatically, always rebuild all 
    files that need rebuilding whenever you change something. If you 
    can prove that it doesn&apos;t, and that you are sure you gave it 
    all the necessary information in the pmfile, then that&apos;s a 
    bug; please let me know so I can fix it.</p>

    <p>But to answer your question, if you invoke pm with the 
    <tt>--purge</tt> (or <tt>-p</tt>) option, it&apos;ll delete the 
    intermediate cache and rebuild everything from scratch.</p>

    <h2>My cache directory is 47GB and I&apos;ve just had to buy 
    another hard disk! What&apos;s going on?</h2>

    <p>pm always keeps all intermediate files, even if you no longer 
    need them. For example, if you do a build with debugging on, and 
    then do a build with optimisation on, you&apos;ll get two complete 
    sets of object files. This isn&apos;t a bug, it&apos;s a 
    feature.</p>

    <p>You may want to do a <tt>-p</tt> from time to time to keep the 
    size of the intermediate cache under control.</p>

  </body>

</html>

