Testing Fundamentals
=========================

This chapter is focused on the essentials of testing. Because we know that most readers are likely to come to Scala from a Java (or similar) environment based on JUnit, which is one of the one of the *xUnit* variants See <http://en.wikipedia.org/wiki/XUnit>, we will begin this discussion with an example of how to use JUnit within Scala, since Java can be used and mixed into Scala programs. We'll then take a look at a couple of introductory (and integrated) Scala examples and how to write them using JUnit and ScalaTest.

Dependencies
----------------------

You need to install the Scala Build Tool [#SBT]_ - The details of this tool are covered in the :doc:`environment`. There is no need to install Scala separately, because what we'll be showing you is how SBT downloads the required version(s) of Scala automatically.

Git distributed version control system (DVCS). Git is available for all major platforms [#GIT]_. Git is one of the preeminent version control systems and is used by GitHub [#GitHub]_, one of the most popular--and we think, best--sites for hosting free and open source projects. We use it for almost all of our public-facing projects.

.. note::

   Many folks often think of Git (the tool) and GitHub (a social coding service built around Git) as being one in the same. You can use Git with or without a hosted service and might feel the need to do so, especially when your project isn't open source or you wish to keep it private. We take advantage of one such service in our own work, Bitbucket [#Bitbucket]_, which offers a number of features for corporate customers and academic software projects. For example, we write our papers in Markdown and LaTeX and often keep them private--at least until they are accepted for publication. Our book is also an example of where we use Git on two systems--one for the book chapters (our publisher wants to sell books) and several for the code examples.

To do the examples in this chapter, you must install both of these. Installation is not covered as it is platform-specific. However, we point you to web materials.

Cloning the Exemplar
----------------------

An important defining principle of our book is that the text and examples should remain relevant long after you have decided the book is no longer needed. We keep all of our examples under version control. There's nothing worse than having a book where there is a typo and having to waste time trying to convince the author to cough up the latest code (or fix it).

So without further ado, let's get the code for this chapter.

.. code-block:: shell

   $ git clone https://github.com/LoyolaChicagoCode/scala-tdd-fundamentals.git
   $ cd scala-tdd-fundamentals
   $ ls

At this point, it is worth noting that we do most of our work in a Unix style environment. You can also checkout our project using IntelliJ (covered int he next chapter) but we're mostly going to operate at the command line in this chapter. It really does help to illuminate the principles.

Let's Test without looking at code
-------------------------------------

As you now have the source code, let's make sure we can compile and run the tests using **sbt**.

The following *compiles* the code we just checked out via **git**. **sbt** generates a lot of output, mainly aimed at *helping* you when something goes wrong. Because dependencies are being pulled from the internet for the unit testing frameworks (JUnit and ScalaText) there is a chance you could see an error message but it is extremely unlikely. We're written the build file in such a way that it will evolve with Scala and its many moving parts.

.. literalinclude:: images/fundamentals/sbt-compile.txt

The most important line to observe in this output is the one beginning with ``[success]``. If for any reason you don't see this line when running it yourself, it is likely that something failed, more than likely a network connectivity problem (or some repository became unavailable, we hope, temporarily).

If you've indeed encountered success in building our code with **sbt**, the next step is to run the tests. This is achieved by running ``sbt test``.

.. literalinclude:: images/fundamentals/sbt-test.txt

Again there is a *lot* of output generated, and what you see may differ from what you see in this console output, owing to changes that occur between the time a book is published and other changes that we or the Scala developers may make.

You'll see a number of lines that begin with ``[info]``. This indicates that informative messages about tests are being written to the console. For our example, there are various tests being performed on our domain model (rational numbers). We have organized the tests according to the different methods in our implementation. Here, you can observe that we test everything from an internal helper method (the greatest common divisor), to initializer (construction) methods, and the each related groups of methods (for arithmetic, helpers, and equality/hashcode for use with other Scala classes).

While the aforementioned might sound a bit *vague*, it is deliberate on our part. There is a *mindset* to testing. When you do testing right, you should be able to check out someone's code, compile it, and run the tests.

Let's get started with looking at some code!

Assertions
-------------

A key notion of testing is the ability to make a logical assertion about something that generally must hold *true* if the test is to pass.

Assertions are not a standard language feature in Scala. Instead, there are a number of classes that provide functions for assertion handling. In the framework we are using to introduce unit testing (JUnit), a class named Assert supports assertion testing (class) methods.

In our tests, we make use of an assertion method, ``Assert.IsTrue()`` to determine whether an assertion is successful. If the variable or expression passed to this method is *false*, the assertion fails.

Here are some examples of assertions, JUnit style. Readers should consult [#junit]_ for details of all supported methods. Although these are Java, we will be using them in Scala (Scala can use any Java class, a salient feature of the language).

Let's take a look at how to test drive the API in the Scala sbt test:console. This is covered in the :doc:`environment` chapter.


Let's fire up the Scala test console:

.. code-block:: bash

   $ sbt test:console
   [info] Set current project to SimpleTesting (in build file:/Users/gkt/Dropbox/Work/LUC/scala-tdd-fundamentals/)
   [info] Starting scala interpreter...
   [info]
   Welcome to Scala version 2.11.4 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_25).
   Type in expressions to have them evaluated.
   Type :help for more information.

Now let's import JUnit and try out the assertion methods.

.. code-block:: bash

   scala> import org.junit.Assert._
   import org.junit.Assert._

   scala> org.junit.Assert.<tab>
   asInstanceOf        assertNotEquals   assertSame   isInstanceOf
   assertArrayEquals   assertNotNull     assertThat   toString
   assertEquals        assertNotSame     assertTrue
   assertFalse         assertNull        fail


Perhaps one of the most awesome things in Scala's console is that you can *discover* the available methods by using tab completion (a long-time favorite of Linux/Unix geeks like us).

Let's try an assertion that we know would be successful.

.. code-block:: bash

   scala> assertTrue(true)
   scala> assertFalse(false)

When an assertion is *successful*, you will see *no output*.

.. code-block:: bash

   scala> assertTrue(false)
   java.lang.AssertionError
   at org.junit.Assert.fail(Assert.java:86)
   at org.junit.Assert.assertTrue(Assert.java:41)
   at org.junit.Assert.assertTrue(Assert.java:52)
   ... 43 elided   

More to come.

dimensions of testing
-------------------------

- correctness
- performance: express runtime expectations as assertions
- level: unit, integration, system, acceptance
- visibility: white, gray, black box
- code coverage: measures (statement, branch, path, etc.), tools (->
  environment)

style: bdd versus tdd
---------------------

- http://blog.andolasoft.com/2014/06/rails-things-you-must-know-about-tdd-and-bdd.html
- http://stackoverflow.com/questions/15389490/bdd-in-scala-does-it-have-to-be-ugly
- http://blog.knoldus.com/2013/01/15/atdd-cucumber-and-scala/
- cucumber-jvm https://github.com/cucumber/cucumber-jvm, jbehave http://jbehave.org
- specs2: very powerful and expressive, covers broad range of styles, http://etorreborre.github.io/specs2

The role of automated testing in the development process (see Fowler)
  - testing
  - refactoring
  - CI/CD

examples
--------------

- rational numbers
- test-drive stack class
- integration example

A Basic Example: Rational Arithmetic
---------------------------------------------

We begin with a *guiding example* that has been conceived with the following objectives in mind:

- Easy to explain and (likely) familiar to most readers. It relies on mathematical ideas that are taught to us in childhood.
- Has sufficient complexity to make testing necessary.
- Plays to Scala's strengths as a language.
- Allows us to introduce all of the testing styles without getting bogged down by domain-specific details.

This example is also featured in Martin Odersky's seminal introduction to Scala, a.k.a. Scala by Example [#SBE]_. Harrington and Thiruvathukal also present a version with are more complete API and robust unit testing in their introductory CS1 course [#IntroCS]_.

While we're reasonably certain you already know what a rational number is, it is helpful to understand its requirements. Later, we shall see that these requirements can be expressed in the various testing styles--a form of documentation.

1. A rational number is expressed as a quotient of integers with a *numerator* and a *denominator*.

2. The *denominator* must not be zero.

3. The *numerator* and *denominator* are always kept in a reduced form. That is, if the *numerator* is 2 and the *denominator* is 4, you would expect the reduced form to be *numerator* = 1 and *denominator* = 2.

4. Rational numbers must be able to perform the usual rules of arithmetic, including binary operations such as +, -, *, and / (explained below) and various *convenience* operations such as negation and reciprocal.

5. Any two rational numbers that are the same number should compare equally and be treated as the same number anywhere they might be used. For example, if you used a Scala set to keep a set of rational numbers (e.g. 1/2, 2/3, 2/4) you would expect this set to contain 1/2 and 2/3. 2/4 wouldn't be expected to appear in the set.


Implementation
~~~~~~~~~~~~~~~~~

Central to making rational numbers work is a famous algorithm, attributable to Euclid, that computes the greatest common divisor. While one of the most important algorithms, it isn't provided as a standard Scala function. Even so, it makes for kind of an interesting testing example, because in the case of Rational numbers, it really needs to work for positive and negative values (and all possible combinations in the numerator and denominator). We'll come back to this point shortly. Suffice it to say, we want to make sure it works reliably and is well-tested.


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: begin-RationalMathUtility-gcd
   :end-before: end-RationalMathUtility-gcd

We won't rehash the details of how the ``gcd()`` actually does what it does. This is covered extensively in online resources.

The following is the complete implementation of the Rational class. We will explore this in a bit of detail to ensure the ensuing discussion of unit testing makes complete sense.

We'll present this in pieces. Here is a general outline of how the Rational class is organized:

class Rational(n: Int, d: Int) extends Ordered[Rational] {

.. code-block:: scala

   def gcd(x: Int, y: Int) = ...

   // initialization

   private val g = gcd(n, d)
   val numerator: Int = n / g
   val denominator: Int = d / g

   // arithmetic
   def +(that: Rational) = ...
   def -(that: Rational) = ...
   def *(that: Rational) = ...
   def /(that: Rational) = ...

   // important unary operations
   def reciprocal() = ...
   def negate() = ...

   // comparisons

   def compare(that: Rational) = ...

   // objects
   override def equals(o: Any) = ...
   override def hashCode = ...

   // companion object

   object Rational ...


We think the Rational class is a great example that plays to Scala's strengths, especially when it comes to clarity, conciseness, and correctness. Let's take a look at the implementation of this class in detail.

For readers new to Scala, you can start by thinking of Scala as "Java done more concisely". The class definition basically gives us all we need to construct instances. A Rational number has a numerator and a denominator, *n* and *d*, respectively.


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: RationalClass.Initialization
   :end-before: RationalClass

Initializing *members* is a matter of creating Scala ``val`` definitions. Our Rational implementation is intended to be *side-effect free*. We initialize the *numerator* and *denominator* by dividing out the greatest-common divisor. This has the effect of reducing the fraction 

We'll then dive into the arithmetic methods:

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: RationalClass.Arithmetic
   :end-before: RationalClass

And become even more excited about comparison operations!

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: RationalClass.Comparisons
   :end-before: RationalClass

Followed by the complete ecstasy attained by addressing object equality, needed for the be-matchers.

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: RationalClass.Object
   :end-before: RationalClass

Can it get more exciting? Time will tell.


Testing JUnit Style
---------------------------------------------

Testing GCD code

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalJUnitTests.scala
   :language: scala
   :start-after: RationalJUnitTests.gcd
   :end-before: RationalJUnitTests

Testing whether rational numbers get initialized properly and are kept in reduced form.

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalJUnitTests.scala
   :language: scala
   :start-after: RationalJUnitTests.Initialization
   :end-before: RationalJUnitTests

Testing whether rational number arithmetic works as expected.

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalJUnitTests.scala
   :language: scala
   :start-after: RationalJUnitTests.Arithmetic
   :end-before: RationalJUnitTests

Testing whether the comparisons involving rational numbers work as expected.

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalJUnitTests.scala
   :language: scala
   :start-after: RationalJUnitTests.Comparisons
   :end-before: RationalJUnitTest

Testing ScalaTest using FlatSpec Style
------------------------------------------

The following is an example of one of the ScalaTest styles, known as FlatSpec. FlatSpec is an example of *behavior-driven development* You write FlatSpec tests with the idea of *describing* an expected behavior. As software engineers, behavior-driven development allows us to ensure that the stated requirements match the expected behavior. As we consider each of the of the following groups of tests, we'll go back to what we *said* a rational number should *do*.

One thing we *said* that rational numbers should *do* is to maintain their representation in a reduced form. When combined with other rational numbers (via arithmetic), we also expect this behavior to be observed.

So let's start with looking at how this style applies to the greatest-common divisor itself.


What do we expect of the greatest common divisor algorithm? Well, our friend Euclid had something to say about this. 

- When 0 is involved, e.g. :math:`gcd(x, 0)` or :math:`gcd(0, y)`, we expect :math:`x` or :math:`y` to be the result.
- When some multiple of a reduced fraction's numerator and denominator are given, we expect that multiple to be the result. A good example is :math:`\frac{1}{3} \cdot \frac{3}{3}`. We'd expect the greatest common divisor to be this multiple.

In a technical sense, this might be more of a pure testing style than behavior driven. However, the way we have expressed this is in terms of how we expect GCD to behave.

As this is the first example of a FlatSpec style test, let's introduce a few things. To create a FlatSpec style test that uses the features we'll be showing in the remaining discussion, you need to put your tests in a Scala class:

.. code-block:: scala

   import org.scalatest._

   class RationalScalaTestFlatSpecMatchers extends FlatSpec with Matchers {
      // Tests go here
   }

You then write your tests (behavioral examples):

Each test is written as follows:

.. code-block:: scala

   "Example" should "do something" in {
      // details of what it should do
   }


or

.. code-block:: scala

   it sould "do something" in {
      // details of what it should do
   }

When you write something like "Example", the idea is to indicate that we are describing the behavior of a particular aspect under testing. When we use *it*, we are referring to the same aspect but breaking out a separate case. After seeing a few examples, it will become apparent how cool this is.

Back to the actual GCD, here it is:

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :start-after: RationalFlatSpec.GCD
   :end-before: RationalFlatSpec

As you can see, the code more or less follows the descriptions already given. We basically look at the different cases as written (GCD involving 0 and GCD not involving 0).

Behavior-driven development, as mentioned earlier, tends to eschew (but not prohibit) explicit assertions. So we see this:

.. code-block::scala

   gcd(0, 5) should be (5)

instead of:

.. code-block::scala

   assert(gcd(0, 5) == 5)

We think both have value, but it is clear that one has a more *literate* style than the other.

Let's take a look at how we use this to cover the rest of the requirements.


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :start-after: RationalFlatSpec.Initializing
   :end-before: RationalFlatSpec

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :start-after: RationalFlatSpec.Arithmetic
   :end-before: RationalFlatSpec

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :start-after: RationalFlatSpec.Comparisons
   :end-before: RationalFlatSpec

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :start-after: RationalFlatSpec.Collections
   :end-before: RationalFlatSpec

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :start-after: RationalFlatSpec.PatternMatching
   :end-before: RationalFlatSpec


Notes
-------

In production code, there are stable methods and classes. These classes have a high ratio of afferent coupling to efferent coupling. In some cases you may see 20:1 or 30:1.

Unit tests can drive this ratio up even higher. I've seen cases where tests contribute to a 500:1 ratio. What is worse is that only moderately stable classes or methods such as those with a ratio of 5:1 might move into an area of 40:1 if used in enough test fixtures.

This can lead to challenges in refactoring and to false-positive unit test failures. It is important in these cases to make use of a factory pattern or a facade pattern to isolate test from classes and methods that are not directly under tests. It can also assist readability to make these factories / facades follow a fluent development pattern to help improve readability in unit tests.

.. [#SBE] Martin Odersky, Scala by Example, http://www.scala-lang.org/docu/files/ScalaByExample.pdf.

.. [#IntroCS] Andrew N. Harrington and George K. Thiruvathukal, http://introcs.cs.luc.edu.

.. [#SBT] Scala Build Tool, http://www.scala-sbt.org/

.. [#Git] Git, http://git-scm.com

.. [#GitHub] GitHub, http://github.com

.. [#Bitbucket] http://bitbucket.org

.. [#junit] http://junit.org