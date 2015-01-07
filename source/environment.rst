Testing Environment and the Simple Build Tool (SBT)
===================================================

.. todo:: Consider evaluating and possibly discussing Typesafe
          Activator (sbt-based!).

.. note:: The main reference source for this chapter is
	  http://www.scala-sbt.org/0.13/docs/, especially
	  http://www.scala-sbt.org/0.13/docs/Testing.html 
	  
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

- Main application or library code goes in ``src/main/scala``.
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

In particular, the ``Test`` configuration indicates that this
dependency is required to compile and run the tests for this project
but to compile or run the main project code itself.
   
Furthermore, some dependencies are "cross-built" against different
versions of Scala. For example, the ScalaTest library comes in the
form of two artifacts, ``scalatest_2.10`` and ``scalatest_2.11``, for
use with the corresponding versions of Scala. When we use ``%%``
between organization ID and artifact ID, sbt automatically appends an
underscore and the Scala version to the artifact ID.

For example, if our Scala version is 2.10, then

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
their dependencies is Maven's *Central Repository*, which you can
search via http://search.maven.org. This search interface will allow
you to drill down into the desired artifact and ultimately show you
exactly what to add to the ``libraryDependencies`` in your build file.

For example, searching for ``scalatest`` results in a long list, of
which we show only the top.

.. image:: /images/environment/MavenSearchAll.png
   :alt: Maven Central Search Results for ``scalatest``
   :width: 100%
	   
Once we drill into the specific artifact ``scalatest_2.10``, we see
the available versions of this artifact. (The non-cross-built artifact
``scalatest`` without the added Scala version corresponds to much
older versions of this framework.)

.. image:: /images/environment/MavenSearchOne.png
   :alt: Maven Central Search Results for artifact ``scalatest_2.10``
   :width: 100%
	   
Now we can choose the desired version of this artifact. For learning
and production development, it is usually best to choose the latest
released version, in this case, ``2.2.2``. Once we select this
version, we can go to the "dependency information" section of the
page, select the "Scala SBT" tab, and will see the exact dependency
definition we can copy and paste into our build file.

.. image:: /images/environment/MavenArtifactDetails.png
   :alt: Maven Central Details for artifact ``scalatest_2.10`` version ``2.2.2``
   :width: 50%
   
To use any dependencies not in the central repo, you need to add
custom resolvers (preferred) or perform a local install (discouraged).

What Scala test framework are available for Scala?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Concretely, sbt provides a common test interface that these main Scala
testing frameworks support directly:

- ScalaTest
- specs2
- ScalaCheck

What this means is that no additional support for the test interface
is needed, and you can simply add the desired testing framework(s) as
managed dependencies (``libraryDependencies``) in sbt.

If you want to use JUnit or TestNG, however, you will also need to
pull in a separate adapter for either of these to work with sbt's
common interface. For JUnit, this is a simple additional dependency in
the build file:

.. code-block:: scala

   "com.novocode" % "junit-interface" % "0.10" % Test

For TestNG, there is an `sbt plugin
<https://github.com/sbt/sbt-testng-interface>`_ that requires a couple
of extra steps to add to your project.

In this book, we will start you out with plain JUnit because we assume
that most readers are familiar with it. Then we will focus on
ScalaTest, which also supports some techniques from ScalaCheck. In the
advanced chapter, we will also take advantage of specs2.


Example: Trapezoidal Integration
--------------------------------

Before we discuss how to use sbt in more detail, let's introduce a
brief example. Our subject under test (SUT) is a Scala object that
defines three different integration methods

.. literalinclude:: ../examples/integration/src/main/scala/edu/luc/etl/sigcse13/scala/integration/Integration.scala
   :language: scala
   :linenos:
   :lines: 11,19,27

.. todo:: Problem here with super-long lines of source code! Will have
	  to reformat source!

The first two take the boundaries of the integration interval and the
function to be integrated of type

.. literalinclude:: ../examples/integration/src/main/scala/edu/luc/etl/sigcse13/scala/integration/Integration.scala
   :language: scala
   :linenos:
   :lines: 7

The third one also takes a grain size that controls the granularity of
parallelism. 

In addition, we have a couple of test fixtures: an identity function
(corresponding to the :math:`y = x` diagonal line) and a square
function.

.. literalinclude:: ../examples/integration/src/main/scala/edu/luc/etl/sigcse13/scala/integration/Fixtures.scala
   :language: scala
   :start-after: begin-object-Fixtures
   :end-before: end-object-Fixtures
   :linenos:

The following test case includes three methods, one for each
integration method. The arguments are the same in each case (except
for the additional grain size in the third test), and so is the
expected result.

.. literalinclude:: ../examples/integration/src/test/scala/edu/luc/etl/sigcse13/scala/integration/TestId.scala
   :language: scala
   :linenos:

There is another, very similar, test case that uses the ``sqr``
fixture instead of the ``id`` one to test whether our integration
methods work as expected.
      

Testing with sbt
----------------

.. todo:: mention parallel task execution including tests!
      
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


The following are the most important sbt tasks for testing:
   
- ``test`` runs all tests in all available test suites.

  In our example, it would simply run the six tests (two times three)

  .. code-block:: bash

     $ sbt test
     ...some output...
     [info] Passed: Total 6, Failed 0, Errors 0, Passed 6
     [success] Total time: 1 s, completed Dec 14, 2014 8:04:54 PM

  with the most important information on the second-last line: all
  six tests have passed.
   

- ``testOnly``: During development, to save time, we may want to run
  only a subset of the available tests. The ``testOnly`` task allows
  us to specify zero or more test classes to run.

  For example, we can run only the test with the square function:

  .. code-block:: bash

     $ sbt 'testOnly edu.luc.etl.sigcse13.scala.integration.TestSqr'
     ...some output...
     [info] Passed: Total 3, Failed 0, Errors 0, Passed 3
     [success] Total time: 1 s, completed Dec 14, 2014 9:03:38 PM

  This task also supports wildcards, so

  .. code-block:: bash

     $ sbt 'testOnly *Sqr'

  will run only ``TestSqr``, while

  .. code-block:: bash

     $ sbt 'testOnly *Test*'

  will run both of them.
  
- ``testQuick`` is similar to ``testOnly`` in giving you the option to select
  the matching tests to run. In addition, it runs only those tests
  that meet at least one of the following conditions:

  - the test failed in the previous run
  - the test has not been run before
  - the tests has one or more transitive dependencies that have been recompiled
  
- ``test:console`` allows you to enter an interactive Scala REPL
  (read-eval-print loop) just like ``sbt console`` but with the test
  code and its library dependencies for the ``Test`` configuration
  (along with any transitive dependencies) on the class path.

  This is useful when you want to explore any code in
  ``src/test/scala`` or the library dependencies for the ``Test``
  configuration interactively.

- The ``test:`` prefix is optional for the other tasks we discussed
  above because their names are unambiguous. There are various other
  tasks, however, that also apply to the main sources. In those cases,
  the ``test:`` prefix will allow you to disambiguate.

  For example,

  .. code-block:: bash

     $ sbt test:compile

  will compile the test sources along with the main sources, while

  .. code-block:: bash

     $ sbt compile

  will compile only the main sources.

  Similarly, if you have a main program in your test sources, you can
  run it with

  .. code-block:: bash

     $ sbt test:run

  or

  .. code-block:: bash

     $ sbt test:runMain
  

Plugin Ecosystem
----------------

sbt includes a rich and growing plugin community-based
ecosystem. Plugins extend the capabilities of sbt, and you can install
them per project or globally. More details are available in the `sbt
reference
<http://www.scala-sbt.org/0.13.6/docs/Getting-Started/Using-Plugins.html>`_.

In addition to the `sbt-testng-interface
<https://github.com/sbt/sbt-testng-interface>`_ mentioned above, here
are some useful examples relevant to testing:

- `sbt-scoverage <https://github.com/scoverage/sbt-scoverage>`_:
  uses Scoverage to produce a test code coverage report
- `sbt-dependency-graph <https://github.com/jrudolph/sbt-dependency-graph>`_: creates a
  visual representation of library dependency tree
- `ls-sbt <https://github.com/softprops/ls>`_:  browse available 
  libraries on GitHub using ls.implicit.ly 
- `sbt-updates <https://github.com/rtimush/sbt-updates>`_: checks
  central repos for dependency updates


IDE Option: JetBrains IntelliJ IDEA
-----------------------------------

Many developers and students prefer an Integrated Development
Environment (IDE) because of code completion and easier code
comprehension for complex projects.

Our preferred IDE is IntelliJ IDEA, which has had a lot of traction in
the open-source and agile development communities for a long time. You
can get the current version of IntelliJ IDEA Community edition for
free from the following URL and then install the Scala plugin through
the plugin manager.

- http://www.jetbrains.com/idea/download

When you install the Scala plugin through the plugin manager, you will
automatically get the version that matches that of IDEA. This plugin
has become quite mature and usable as of December 2014. In particular,
compilation (and execution of Scala worksheets) has become much
faster.

The IntelliJ IDEA Scala plugin also integrates directly with sbt:
Instead of *importing* an sbt-based project, you simply *open*
it. When you make any changes to the sbt build file(s), IDEA reloads
your project and updates the classpath and other IDEA-specific
settings accordingly.

.. image:: /images/environment/IntelliJProjectDependencies.png
   :alt: IntelliJ IDEA Scala project view with sbt dependencies expanded
   :width: 50%

Testing in IntelliJ IDEA
^^^^^^^^^^^^^^^^^^^^^^^^
	   
IntelliJ IDEA gives you several options for running tests:

- To run all available tests, you can pop up the context menu (Windows
  and Linux: right-click, Mac: Control-click) for the project root
  node or ``src/test/scala`` and select "Run All Tests".

- To run an individual test class, pop up the context menu for that
  test and run it.

- To run two or more specific tests, you can select them, pop up the
  context menu, and then run them.

.. image:: /images/environment/IntelliJProjectView.png 
   :alt: IntelliJ IDEA Scala project view with test classes expanded 
   :width: 50%

After you run the tests and they all passed, you will usually see a
condensed view with the passed tests hidden.

.. image:: /images/environment/IntelliJTestsCondensed.png 
   :alt: IntelliJ IDEA Scala test view with passed tests hidden 
   :width: 100%
	   
This is because the leftmost button, "hide passed", is enabled by
default. You can turn this option off and drill into the tests.

.. image:: /images/environment/IntelliJTestsExpanded.png  
   :alt: IntelliJ IDEA Scala test view with passed tests expanded  
   :width: 100%
	   
 Also, failed tests automatically show up in expanded fashion.

.. image:: /images/environment/IntelliJTestsFailed.png
   :alt: IntelliJ IDEA Scala test view with failed/erroneous tests
   :width: 100%

On these images, we recognize the three possible outcomes of a test
from the fundamentals chapter [REF]:

- pass: green circle with the word "OK"
- fail: orange circle with an exclamation mark 
- error: red circle with an exclamation mark 
	   

Tips
^^^^

- IntelliJ IDEA has a built-in native terminal for your OS. This
  allows you to use, say, hg or sbt conveniently without leaving
  IDEA. ::

        View > Tool Windows > Terminal

- To practice Scala in a light-weight, exploratory way, you can use
  Scala worksheets in IntelliJ IDEA. These will give you an
  interactive, console-like environment, but your work is saved and
  can be put under version control. ::

        File > New > Scala Worksheet

  *You can even make your worksheets test-driven by sprinkling assertions throughout them.*
	   

IDE Option: Eclipse Scala IDE
------------------------------

The official Scala IDE is provided as an Eclipse bundle that has Scala
already installed. It will work on all platforms with very minor
differences and provides similar functionality to IntelliJ IDEA. The
following link will take you there.

- http://scala-ide.org/download/sdk.html

This is based on the Eclipse Juno release, which is two full releases
behind the current Luna release.
