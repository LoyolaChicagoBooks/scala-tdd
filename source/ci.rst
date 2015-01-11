Continuous Integration
========================


.. |JetBrains| unicode:: JetBrains

.. |Team City| unicode:: Team City U+2122

.. |Jenkins| unicode:: Jenkins

.. note:: 
	All of this is copied from our notes on Trello.

	Good things to cover: - Testing with or without a database.
	- Scaling CI to 10s or 100s of developers
	- I/O tests vs scalability
	- Importance of having a componentized architecture and doing smaller builds / test runs
	- Automated GUI testing systems.

	Another area important to cover here is periodically failing unit tests. A test that throws up a false positive at a 0.5% rate will cause a lot of headaches when there are thousands of unit tests and hundreds of builds each day.

	CI systems that serve 20 or more developers tend to be distributed systems. The same problems that exist in distributed systems exist in CI systems, but some are unique. It would be a good idea to cover hardware / network considerations along with how I/O is managed.


In this chapter, we will discuss your choices for establishing an effective continuous integration system for your Scala Software. We will explore how to best configure a continuous integration server for two different continuous integration products. We will also explore best practices for writing unit tests to minimize false positives in your automated testing.


Continuous Integration Products
-------------------------------

The two products we will present in this chapter are |JetBrains| |Team City| and |Jenkins|. |Team City] is developed by the same company that develops IntelliJ IDEA and other products in the Java eco-system. |Jenkins| is an award winning product that has a long history with the Java community. Both are good options for implementing a continuous integration system.


Team City
---------


Jenkins
-------


Scaling Continuous Integration
------------------------------



Continuous Integration and Third Party Technologies
---------------------------------------------------


False Positives and Periodic Failure in Test Automation
-------------------------------------------------------




