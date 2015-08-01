Basic Testing
=============

- almost like a meta-framework that supports a broad range of testing styles
- great way to get started with Scala as a team
- nonfunctional code, similar to writing build scripts in, say, Groovy (as in Gradlle)
- agile way to do Java!
- status of [ScalaTest shell](http://www.artima.com/weblogs/viewpost.jsp?thread=326389)?


A Basic Example: Rational Arithmetic
---------------------------------------------

In the previous chapter, we discussed a *guiding example* (Rational numbers) that was written in Scala and tested using JUnit (Java implementation of xUnit) and ScalaTest. This begs an interesting question:

Can we actually write a Java based version of the same class and test it using Scala?

Of course, the answer is an emphatic yes. By now, it should be apparent that Scala and Java can, in fact, be used together or apart. In our own work, we rely extensively on the ability to make use of existing Java frameworks/libraries, some of which may not be given the Scala touch for awhile.


JRational - the Java version of Rational
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We're mostly going to present this class *as is* with the following two assumptions:

- You're already familiar with Java and have working knowledge of it.
- You can easily go back to chapter one to understand the details.

We'll cover the key differences, which will probably make you love Scala more than Java after reading this chapter. We're going to present each of the fragments of code, which have been commented so you can see how the Scala and Java versions differ.

Let's start with the GCD implementation:


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/java/scalatddpackt/JRational.java
   :language: scala
   :dedent: 4
   :start-after: begin-JavaRationalMathUtility-gcd
   :end-before: end-JavaRationalMathUtility-gcd

Here we have a static class method as opposed to a standalone Scala def. The logic for computing the GCD is identical to the Scala version.

Initialization (construction) is similar to the Scala version. The only difference is that in Java all of the initialization code goes into a constructor method. In Scala, you initialize instances outside of any method. (There are no constructors.)

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/java/scalatddpackt/JRational.java
   :language: scala
   :dedent: 4
   :start-after: JavaRationalClass.Initialization
   :end-before: JavaRationalClass

Arithmetic is where we see a few differences, owing to Java's lack of support for operator overloading. So where you previously saw ``+``, ``-``, ``*``, and ``/``, here you see ``add()``, ``subtract()``, ``multiply()``, and ``divide()``. 

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/java/scalatddpackt/JRational.java
   :language: scala
   :dedent: 4
   :start-after: JavaRationalClass.Arithmetic
   :end-before: JavaRationalClass

The comparison logic is similar to the Scala version.

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/java/scalatddpackt/JRational.java
   :language: scala
   :dedent: 4
   :start-after: JavaRationalClass.Comparisons
   :end-before: JavaRationalClass

To make comparison work in Java, we immplement ``Comparable<JRational>`` and provide a definition that is virtually identical to the Scala version.

Lastly, and similar to our intentions in the Scala version, we provide methods for allowing JRational instances to work properly in object containers, e.g. Java Collections.


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/main/java/scalatddpackt/JRational.java
   :language: scala
   :dedent: 4
   :start-after: JavaRationalClass.Object
   :end-before: JavaRationalClass

Object equality, e.g. ``equals()``, basically requires us to use ``isinstanceof`` instead of a Scala pattern match expression. 

For computing ``hashCode()``, we simulate a Scala tuple by putting the numerator and denominator into an array and using the convenient utility ``Arrays.hashCode()`` to compute the hash value based on the content of the ``int[]`` array.

We wanted to be sure we believed it, so we fired up the ``sbt console`` to check ``hashCode()`` interactively.

.. code-block:: scala

   scala> import scalatddpackt.JRational
   import scalatddpackt.JRational

   scala> val r1 = new JRational(1, 2)
   r1: scalatddpackt.JRational = scalatddpackt.JRational@3e2

   scala> r1.hashCode
   res0: Int = 994

   scala> val r2 = new JRational(3, 6)
   r2: scalatddpackt.JRational = scalatddpackt.JRational@3e2

   scala> r2.hashCode
   res1: Int = 994

   scala> r1.equals(r2)
   res3: Boolean = true

Sure enough, it works as expected. :math:`\frac{1}{2}` and :math:`\frac{3}{6}` are indeed equal and have the same hash codes.

Scala + JUnit to Test Java Rational Class
---------------------------------------------

Here are the reworked versions to test our Java Rational (JRational) using JUnit and Scala!

Aside from a few differences, the tests look virtually identical to how we test the Scala Rational.


.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/JavaRationalJUnitTests.scala
   :language: scala
   :dedent: 2
   :start-after: JavaRationalJUnitTests.Initialization
   :end-before: JavaRationalJUnitTests

One key difference is related to Java style vs. Scala style. For our mathematical utiilty, ``gcd()``, which is a Java class (static) method, we cannot make a reference to the static member. Luckily, we can make use of these members by using a little Scala magic to import the method for use:

.. code-block:: scala

   import JRational.gcd

Once done, our JUnit code to test ``gcd()`` is identical to the Scala version.

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/JavaRationalJUnitTests.scala
   :language: scala
   :dedent: 2
   :start-after: JavaRationalJUnitTests.Initialization
   :end-before: JavaRationalJUnitTests

For testing initialization, our code is identical with the following notable difference: accessing private state in the Java class requires some magic. We introduce *getters* to access the numerator via ``getN()`` and denominator via ``getD()``.

When working with Java classes, only the *public* members can be accessed within Scala.

Arithmetic works largely as expected with the only notable difference being that the Java version doesn't support operators. So we need to turn infix expressions into the less-palatable form. 

That is, each occurrence of

.. code-block:: scala

   r1 + r2
   r1 - r2
   r1 * r2
   r1 / r2

becomes

.. code-block:: java

   r1.add(r2)
   r1.subtract(r2)
   r1.multiply(r2)
   r1.divide(r2)

The unary operators ``reciprocal()`` and ``negate()`` are the same in both of our implementations (that is, they don't define an operator).

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/JavaRationalJUnitTests.scala
   :language: scala
   :dedent: 2
   :start-after: JavaRationalJUnitTests.Arithmetic
   :end-before: JavaRationalJUnitTests

As for testing comparisons, our code simply needs to test what ``compareTo()`` does. Given that there's no operator overloading in Java, we don't need to test each of the operators and various combinations involving equality. 

.. literalinclude:: ../examples/scala-tdd-fundamentals/src/test/scala/JavaRationalJUnitTests.scala
   :language: scala
   :dedent: 2
   :start-after: JavaRationalJUnitTests.Comparisons
   :end-before: JavaRationalJUnitTest


Roadmap for the rest of this chapter

- A different example (so readers don't get bored)
- ScalaTest and JRational
- More ScalaTest (looking at other ScalaTest styles)
- ScalaTest console?

