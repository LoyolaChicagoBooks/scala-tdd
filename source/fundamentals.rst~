Testing Fundamentals
=========================

Focus on principles

dimensions of testing
-------------------------

- correctness
- performance: express runtime expectations as assertions
- level: unit, integration, functional
- code coverage: measures, tools (-> environment)

examples
--------------

- rational numbers
- test-drive stack class
- integration example

Testing and coupling
---------------------------


Notes
-------

In production code, there are stable methods and classes. These classes have a high ratio of afferent coupling to efferent coupling. In some cases you may see 20:1 or 30:1.

Unit tests can drive this ratio up even higher. I've seen cases where tests contribute to a 500:1 ratio. What is worse is that only moderately stable classes or methods such as those with a ratio of 5:1 might move into an area of 40:1 if used in enough test fixtures.

This can lead to challenges in refactoring and to false-positive unit test failures. It is important in these cases to make use of a factory pattern or a facade pattern to isolate test from classes and methods that are not directly under tests. It can also assist readability to make these factories / facades follow a fluent development pattern to help improve readability in unit tests.
