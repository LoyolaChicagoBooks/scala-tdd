Testing Fundamentals
=========================

Focus on principles

This chapter is focused on the essentials of testing. Because we know
that most readers are likely to come to Scala from a Java (or similar)
environment based on JUnit, which is one of the one of the *xUnit*
variants See <http://en.wikipedia.org/wiki/XUnit>, we will begin this
discussion with an example of how to use JUnit within Scala, since
Java can be used and mixed into Scala programs. We'll then take a look
at a couple of introductory (and integrated) Scala examples and how to
write them using JUnit and ScalaTest.

The organization and presentation is very much aimed at being hands
on.

Dependencies
----------------------

You need to install the Scala Build Tool - The details of this tool
are covered in the :doc:`environment`. There is no need to install
Scala separately, because what we'll be showing you is how SBT downloads the
required version(s) of Scala automatically.

Git distributed version control system (DVCS). Git is available for
all major platforms from <http://git-scm.com>. Git is one of the
preeminent version control systems and is used by GitHub at
<http://github.com>, one of the most popular sites for hosting free
and open source projects. We use it for almost all of our
public-facing projects.

To do the examples in this chapter, you must install both of
these. Installation is not covered as it is
platform-specific. However, we point you to web materials.

.. note::

   George will make sure to put the links here.


Cloning the Exemplar
----------------------




Assertions
-------------

A key notion of testing is the ability to make a logical assertion about something
that generally must hold *true* if the test is to pass.

Assertions are not a standard language feature in Scala. Instead, there are a number of
classes that provide functions for assertion handling. In the
framework we are using to introduce unit testing (JUnit), a class named Assert supports assertion testing.

In our tests, we make use of an assertion method, ``Assert.IsTrue()`` to determine
whether an assertion is successful. If the variable or expression passed to this
method is *false*, the assertion fails.

Here are some examples of assertions:

- ``Assert.IsTrue(true)``: The assertion is trivially successful, 
  because the boolean value ``true`` is true.
  
- ``Assert.IsTrue(false)``: The assertion is not successful, because the boolean value
  ``false`` is not true!
  
- ``Assert.IsFalse(false)``: This assertion is successful, because 
  ``false`` is, of course, false.
  
- ``Assert.IsTrue(5 > 0)``: Success

- ``Assert.IsTrue(0 > 5)``: Failure

There are many available assertion methods. In our tests, we use ``Assert.IsTrue()``,
which works for everything we want to test. Other assertion methods do their magic
rather similarly, because every assertion method ultimately must determine whether
what is being tested is true or false. 

.. index:: attribute [ ]
   single: [ ]; attribute
   

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

We begin with a *guiding example* that has been conceived with the following
objectives in mind:

- Easy to explain and (likely) familiar to most readers. It relies on
  mathematical ideas that are taught to us in childhood.
- Has sufficient complexity to make testing necessary.
- Plays to Scala's strengths as a language.
- Allows us to introduce all of the testing styles without getting
  bogged down by domain-specific details.

This example is also featured in Martin Odersky's seminal introduction
to Scala, a.k.a. Scala by Example [SBE]_. Harrington and Thiruvathukal
also present a version with are more complete API and robust unit testing in their introductory
CS1 course [IntroCS]_.

.. [SBE] Martin Odersky, Scala by Example, http://www.scala-lang.org/docu/files/ScalaByExample.pdf.

.. [IntroCS] Andrew N. Harrington and George K. Thiruvathukal, http://introcs.cs.luc.edu.

While we're reasonably certain you already know what a rational number
is, it is helpful to understand its requirements. Later, we shall see
that these requirements can be expressed in the various testing
styles--a form of documentation.

- A rational number is expressed as a quotient of integers with a *numerator* and a *denominator*.

- The *denominator* must not be zero.

- The *numerator* and *denominator* are always kept in a reduced form. That is, if the *numerator* is 2 and the *denominator* is 4, you would expect the reduced form to be *numerator* = 1 and *denominator* = 2.

- Rational numbers must be able to perform the usual rules of arithmetic, including binary operations such as +, -, *, and / (explained below) and various *convenience* operations such as negation and reciprocal.

- Any two rational numbers that are the same number should compare equally and be treated as the same number anywhere they might be used. For example, if you used a Scala set to keep a set of rational numbers (e.g. 1/2, 2/3, 2/4) you would expect this set to contain 1/2 and 2/3. 2/4 wouldn't be expected to appear in the set.

.. todo: Might be leaving something out, but this is a great start!

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: begin-Rational-gcd
   :end-before: end-Rational-gcd
   :linenos:


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/scala/Rational.scala
   :language: scala
   :start-after: begin-Rational
   :end-before: end-Rational
   :linenos:


Testing JUnit Style
---------------------------------------------
.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalJUnitTests.scala
   :language: scala
   :linenos:

Testing ScalaTest using FlatSpec Style
------------------------------------------

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/RationalScalaTestFlatSpecMatchers.scala
   :language: scala
   :linenos:

Notes
-------

In production code, there are stable methods and classes. These classes have a high ratio of afferent coupling to efferent coupling. In some cases you may see 20:1 or 30:1.

Unit tests can drive this ratio up even higher. I've seen cases where tests contribute to a 500:1 ratio. What is worse is that only moderately stable classes or methods such as those with a ratio of 5:1 might move into an area of 40:1 if used in enough test fixtures.

This can lead to challenges in refactoring and to false-positive unit test failures. It is important in these cases to make use of a factory pattern or a facade pattern to isolate test from classes and methods that are not directly under tests. It can also assist readability to make these factories / facades follow a fluent development pattern to help improve readability in unit tests.
