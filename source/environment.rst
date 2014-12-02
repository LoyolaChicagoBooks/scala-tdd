Testing Environment and Simple Build Tool (SBT)
===============================================

.. note:: We should definitely cover the use of the command-line and
	  how to work within IntelliJ. I think we should not waste
	  time with Eclipse, but this can be discussed. 

.. note:: Here we can paint the context.

.. todo:: I think we should include a very brief paragraph to mention
	  the Scala Eclipse IDE and point out that it works with Juno
	  while Eclipse itself is up to Luna.

.. todo:: Consider evaluating and possibly discussing Typesafe
          Activator (sbt-based!).

.. todo:: explain sbt's test interface and that ScalaTest supports
	  this directly but the com.novocode interface is required for
	  running JUnit tests

.. todo:: explain in detail all different ways to run tests (or a
	  single test) with sbt, including test:console

In this chapter, we'll discuss your choices for setting up an
effective development and testing environment for Scala. The main
thing to keep in mind is that proper testing almost always involves
dependencies on external libraries. Even if you are comfortable
working with the Scala command-line tools and a text editor, you are
responsible for setting the dreaded classpath. This can quickly become
unwieldy even when only simple dependencies are involved, so this is
not something you would usually want to do manually.

Therefore, you will benefit greatly from upgrading to Scala's Simple
Build Tool (sbt), and the rest of this book relies heavily on
this. After switching to sbt, you can continue to use your favorite
text editor. And if you prefer to use an integrated development
environment (IDE), you are in luck as well: JetBrains IntelliJ IDEA
and Eclipse, both very popular IDEs for Scala, integrate well with
sbt.

Getting Started
---------------

The main prerequisite to Scala development is having a Java runtime,
version 1.6 or later, installed on your system. We recommend that you
install the `latest available Oracle Java 7 Development Kit
<http://www.oracle.com/technetwork/java/javase/downloads/>`_. While
you can work with OpenJDK and other VM implementations to run Scala,
we believe that that the best experience and performance comes from
the latest stable release of the Java 7 Platform.

Equally important is having an installation of sbt itself on your
system. The exact way of doing so depends on your platform. 

- On the Mac, the recommended way is to use Homebrew

  .. code-block:: bash

       $ brew install sbt

  or MacPorts:

  .. code-block:: bash

       $ sudo port install sbt

- On Windows and Linux, the recommended way is to use the installer
for your platform available in the `sbt setup instructions
<http://www.scala-sbt.org/0.13/tutorial/Setup.html>`_.
 

Brief History of Build Tools
----------------------------

.. TODO optional add links to tools

In general, build tools support the build process in several ways:

- structured representation of the project dependency graph
- management of the build lifecycle (compile, test, run)
- management of external dependencies

Some well-known build tools include:

Unix make, Apache ant 
  These earlier tools manage the build lifecycle but not external
  dependencies. 

Apache maven
  This tool introduced several innovative capabilities. It supports
  convention over configuration in terms of project layout in the file
  system and build lifecycle. In addition, it automatically manages
  external dependencies by downloading them from centralized
  repositories. It relies on XML-based configuration files.

.. code-block:: xml

   <dependency>
     <groupId>org.restlet</groupId>
     <artifactId>org.restlet.ext.spring</artifactId>
     <version>${restlet.version}</version>
   </dependency>

Apache ivy, Gradle, sbt, etc.
  These newer tools emphasize convention over configuration in support
  of agile development processes.  sbt is compatible with ivy and
  designed primarily for Scala development. For example, ivy uses a
  structured but lighter-weight format:

.. code-block:: xml

   <dependency org="junit" name="junit" rev="4.11"/>

sbt
---

In the simplest case, sbt does not require any configuration and will
use reasonable defaults. The project layout is the same as the one
Maven uses:

- Production code goes in ``src/main/scala``.
- Test code goes in ``src/test/scala``.

sbt supports two configuration styles, one based on a simple
Scala-based domain-specific language, and one based on the full Scala
language for configuring all aspects of a project.

build.sbt format
^^^^^^^^^^^^^^^^

A minimal sbt ``build.sbt`` file looks like this. The empty lines are
required, and the file must be placed in the top-level root folder of
your project.

.. code-block:: scala

   name := "integration-scala"
    
   version := "0.2"

Additional dependencies can be specified either one at a time

.. code-block:: scala

   libraryDependencies += "com.novocode" % "junit-interface" % "0.10" % "test"
 
or as a group

.. code-block:: scala

   libraryDependencies ++= Seq(
     "org.scala-lang" % "scala-actors" % "2.10.1",
     "com.novocode" % "junit-interface" % "0.10" % "test"
   )

Build.scala format
^^^^^^^^^^^^^^^^^^

Some complex projects require build files that use the full Scala
syntax. The main build file should be named ``Build.scala``. It and
other Scala-based build files must be placed in the ``project``
subfolder of your project root.


Plugin Ecosystem
----------------

sbt includes a growing plugin ecosystem. `You can install them per
project or
globally. <http://www.scala-sbt.org/0.13.6/docs/Getting-Started/Using-Plugins.html>`_
Some useful examples include

- `sbteclipse <https://github.com/typesafehub/sbteclipse>`_
  automatically generates an Eclipse project configuration from an sbt
  one.

- `sbt-start-script <https://github.com/sbt/sbt-start-script>`_
  generates a start script for running a Scala application outside of
  sbt.

- `sbt-scoverage <https://github.com/scoverage/sbt-scoverage>`_:
  uses Scoverage to produce a test code coverage report
- `ls-sbt <https://github.com/softprops/ls>`_:  browse available
  libraries on GitHub using ls.implicit.ly
- `sbt-dependency-graph <https://github.com/jrudolph/sbt-dependency-graph>`_: creates a
  visual representation of library dependency tree
- `sbt-updates <https://github.com/rtimush/sbt-updates>`_: checks
  central repos for dependency updates
- `cpd4sbt <https://github.com/sbt/cpd4sbt>`_: copy/paste detection
  for Scala *(be sure to set* ``cpdSkipDuplicateFiles := true`` *in 
  Android projects to avoid a false positive for each source file)*
- `scalastyle <https://github.com/scalastyle/scalastyle-sbt-plugin>`_: static code checker for Scala
- `sbt-stats <https://github.com/orrsella/sbt-stats>`_: simple, extensible source code statistics/metrics
- `sbt-scalariform <https://github.com/sbt/sbt-scalariform>`_:
  automatic source code formatting using Scalariform

.. todo:: explain that IDEA directly works with sbt projects 

The IntelliJ IDEA Scala plugin also integrates directly with sbt. 


IDE Option: JetBrains IntelliJ IDEA
-----------------------------------

Many faculty teaching introductory CS courses prefer an Integrated
Development Environment (IDE). We recommend IntelliJ IDEA, which is
growing in popularity over Eclipse and preferred by many of us. You
can get the Community edition for free from the following URL and then
install the Scala plugin through the plugin manager.

- http://www.jetbrains.com/idea/download/  

When you install the Scala plugin through the plugin manager, you will
automatically get the version that matches that of IDEA. This plugin
has become quite mature and usable as of December 2014. In particular,
compilation (and execution of Scala worksheets) has become much
faster.

To work around false compilation errors in Scala worksheets, we also
recommend a standalone installation of sbt.


IDE Option: Eclipse Scala IDE
------------------------------

The official Scala IDE is provided as an Eclipse bundle that has Scala
already installed. It will work on all platforms with very minor
differences. The following link will take you there.

- http://scala-ide.org/download/sdk.html

This is based on the Eclipse Juno release, which is two full releases
behind the current Luna release.

Tips
----

- IntelliJ IDEA has a built-in native terminal for your OS. This allows you to use, say, hg or sbt conveniently without leaving IDEA.::

        View > Tool Windows > Terminal

- To practice Scala in a light-weight, exploratory way, you can use Scala worksheets in IntelliJ IDEA. These will give you an interactive, console-like environment, but your work is saved and can be put under version control.::

        File > New > Scala Worksheet

  *You can even make it test-driven by sprinkling assertions throughout your worksheet!*
