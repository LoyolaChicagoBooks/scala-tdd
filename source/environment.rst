Testing Environment and the Simple Build Tool (SBT)
===================================================

.. note:: We should definitely cover the use of the command-line and
	  how to work within IntelliJ. I think we should not waste
	  time with Eclipse, but this can be discussed. 

.. todo:: I think we should include a very brief paragraph to mention
	  the Scala Eclipse IDE and point out that it works with Juno
	  while Eclipse itself is up to Luna.

.. todo:: Consider evaluating and possibly discussing Typesafe
          Activator (sbt-based!).

.. note:: The main reference source for this chapter is
	  http://www.scala-sbt.org/0.13/docs/, especially
	  http://www.scala-sbt.org/0.13/docs/Testing.html 
	  
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


Brief History of Build Tools
----------------------------

.. TODO optional add links to tools

In general, build tools support the build process in several ways:

1. structured representation of the project dependency graph
2. management of the build lifecycle (compile, test, run)
3. management of external dependencies

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

We will focus on sbt in the remainder of this book, though the
concepts equally apply to similar build systems and IDEs.


Installing sbt
--------------

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
 

Configuring sbt
---------------

In the simplest cases, sbt does not require any configuration and will
use reasonable defaults. The project layout is the same as the one
Maven uses:

- Production code goes in ``src/main/scala``.
- Test code goes in ``src/test/scala``.

In practice, however, we will want to include some automated testing
in the build process, and this typically requires at least one build
dependency, as we will see shortly.
  
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

   libraryDependencies += "org.scalatest" %% "scalatest" % "2.2.2" % Test
 
or as a group

.. code-block:: scala

   libraryDependencies ++= Seq(
     "org.scalatest" %% "scalatest" % "2.2.2" % Test,
     "org.mod4j.org.apache.commons" % "logging" % "1.0.4"
   )

The dependency format follows the same structure as the Maven example
above:

- organization ID
- artifact ID
- version (of the artifact)
- configuration (within the sbt build lifecycle)
   
Furthermore, some dependencies are "cross-built" against different
versions of Scala. For example, the ScalaTest library comes in the
form of two artifacts, ``scalatest_2.10`` and ``scalatest_2.11``, for
use with the corresponding versions of Scala.

When we use "%%" between
organization ID and artifact ID, sbt automatically appends an
underscore and the Scala version to the artifact ID. For example, if
our Scala version is 2.10, then 

.. code-block:: scala

   "org.scalatest" %% "scalatest" % "2.2.2" % Test

is equivalent to

.. code-block:: scala

   "org.scalatest" % "scalatest_2.10" % "2.2.2" % Test

This allows us to rely on the default Scala version or indicate our
choice in a single place, e.g.:

.. code-block:: scala

   scalaVersion := "2.11.4"
   

Build.scala and multi-project formats
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Though you are generally encouraged to use the ``build.sbt`` format,
some complex projects may require build files that use the full Scala
syntax. The main build file should be named ``Build.scala``. It and
other Scala-based build files must be placed in the ``project``
subfolder of your project root. Further details are available in the
`.scala build definition
<http://www.scala-sbt.org/0.13/tutorial/Full-Def.html>`_ section of
the sbt reference manual.

The new `multi-project .sbt build definition
<http://www.scala-sbt.org/0.13/tutorial/Basic-Def.html>`_ format
combines the strengths of the other two flavors and is recommended for
complex projects instead of the `.scala` flavor.


Finding libraries to depend on
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default place where Maven and its descendents, including sbt, find
their dependencies is Maven's *Central Repository* at
http://search.maven.org. To use any dependencies not in the central
repo, you need to add custom resolvers (preferred) or perform a local
install (discouraged).

Concretely, sbt provides a common test interface that these main Scala
testing frameworks support directly:

- ScalaTest
- specs2
- ScalaCheck

What this means is that no additional support for the test interface
is needed, and you can simply add the desired testing framework(s) as
managed dependencies (``libraryDependencies``) in sbt.

If you want to use JUnit, however, you will also need to pull in this
separate adapter for JUnit to work with sbt's common interface.

.. code-block:: scala

   "com.novocode" % "junit-interface" % "0.10" % Test


Example: Trapezoidal Integration
--------------------------------

.. todo:: need another test class to illustrate testOnly

Before we discuss how to use sbt in more detail, let's introduce a
brief example. Our subject under test (SUT) is a Scala object that
defines three different integration methods

.. literalinclude:: ../examples/integration/src/main/scala/edu/luc/etl/sigcse13/scala/integration/Integration.scala
   :language: scala
   :linenos:
   :lines: 11,19,27

The first two take the boundaries of the integration interval and the
function to be integrated of type

.. literalinclude:: ../examples/integration/src/main/scala/edu/luc/etl/sigcse13/scala/integration/Integration.scala
   :language: scala
   :linenos:
   :lines: 7

The third one also takes a grain size that controls the granularity of
parallelism. 

The only additional test fixture in our example is a square function:

.. literalinclude:: ../examples/integration/src/main/scala/edu/luc/etl/sigcse13/scala/integration/Fixtures.scala
   :language: scala
   :linenos:

The following test case includes three methods, one for each
integration method. The arguments are the same in each case (except
for the additional grain size in the third test), and so is the
expected result.

.. literalinclude:: ../examples/integration/src/test/scala/edu/luc/etl/sigcse13/scala/integration/Tests.scala
   :language: scala
   :linenos:


Testing with sbt
----------------

In this section, we'll take a look at test organization and the key
sbt tasks (commands) for testing.

In ScalaTest, a *test* is an atomic unit of testing that is either
executed during a particular test run or it is not; a test is usually
a method or other program element that stands for a method. A *test
suite* is a collection of zero or more tests. (In JUnit, a *test
class* corresponding to a test suite in ScalaTest, and a test suite is
a collection of test classes.)

The sbt testing tasks correspond to this test organization
hierarchy. In general, to run one or more sbt tasks ``task1``,
``task2``, ... ``taskN``, we either specify them on the sbt command
line in the desired order separated by spaces

.. code-block:: bash

   $ sbt task1 task2 ... taskN

or we launch sbt's interactive mode and then enter the tasks one by
one

.. code-block:: bash

   $ sbt
   ...some output...
   > task1
   ...some more output...
   > task2
   ...etc...

   
- ``test``
  This task runs all tests in all available test suites.

  In our example, it would simply run the three tests

   .. code-block:: bash

      $ sbt test
      ...some output...
      [info] Passed: Total 3, Failed 0, Errors 0, Passed 3
      [success] Total time: 7 s, completed Dec 11, 2014 5:36:35 PM

with the most important information on the second-last line: the
three tests have passed.
   

- ``testOnly``


  
- testQuick
- test:console
- ``test:`` prefix

direct support for ScalaCheck, specs2, and ScalaTest
  
interface required for JUnit
  
other tips

- sbt history

parallel task execution including tests!



.. todo:: explain test:test versus test

      

Plugin Ecosystem
----------------

.. todo:: focus on plugins relevant to testing

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
- `sbt-coveralls <https://github.com/scoverage/sbt-coveralls>`_:
  uploads scala code coverage to https://coveralls.io and integrates
  with Travis CI
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

.. todo:: add screenshots and other details


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
