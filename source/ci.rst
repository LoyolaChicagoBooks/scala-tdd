Continuous Integration
========================

All of this is copied from our notes on Trello.

Good things to cover: - Testing with or without a database.
- Scaling CI to 10s or 100s of developers
- I/O tests vs scalability
- Importance of having a componentized architecture and doing smaller builds / test runs
- Automated GUI testing systems.

Another area important to cover here is periodically failing unit tests. A test that throws up a false positive at a 0.5% rate will cause a lot of headaches when there are thousands of unit tests and hundreds of builds each day.

CI systems that serve 20 or more developers tend to be distributed systems. The same problems that exist in distributed systems exist in CI systems, but some are unique. It would be a good idea to cover hardware / network considerations along with how I/O is managed.

