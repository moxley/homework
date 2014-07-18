## Hireology Software Engineer Homework

### Instructions

There are two parts to the Software Engineer Homework set. Part 1 is written answer, and Part 2 is a set of programmable problems. Please fork this repo to your GitHub account, add your work to the forked repo, and send a pull request when your work is complete.

### Part 1 - Written Questions

1. How can Memcache improve a site’s performance?
  Include a description about how data is stored and
  retrieved in a multi-node configuration.

  *Memcached is a simple, fast key-value data store, good
  for storing temporary data, such as cache data. One
  caching use case would be to cache rendered view HTML
  so that it doesn't have to be calculated for every
  request. This can save CPU, memory and runtime
  of the web application server and the database
  server, which affects concurrency limits and
  transaction (request) frequency limits. Another use
  case is saving a user's session data instead of saving
  it to a database. This saves a trip to the database,
  which would normally take more time.*

  *A multi-node Memcached cluster works essentially as a
  distributed hash table. The keys and values of Memcached
  are the keys and values of the hash table. Each
  Memcached server instance holds a subset of the hash
  table, the size of which is proportional to the amount
  of memory allocated to the instance. As with hash tables
  in general, the keys are translated into a hashified
  representation which makes the keys normalized and easy
  to be used*

2. Please take a look at
  [this controller action](https://github.com/Hireology/homework/blob/master/some_controller.rb).
  Please tell us what you think of this code and how you
  would make it better.

  *I'll approach this from a high level, down to a low level.*

  1. *Pull all the query building and record sorting code out of the
      controller to a service class (`app/services/search_candidates.rb`).
      This will make the behavior easier to test, because controllers
      have a cumbersome interface compared to plain old Ruby classes.
      Besides, this action is way too big.*
  1. Break up the permission conditional into separate methods.
  1. Dry up the sorting logic.
  1. Use Rails 3/4 ActiveRecord syntax rather than Rails 2
    1. Use `#where` instead of `#all` to add conditionals to a query.
    2. Call `#order` instead of passing an `:order` hash element.
  1. Fix indentation
  1. Remove closing semi-colon
  1. Remove commented-out code
  1. Change the big sorting conditional to a `case` statement
  1. Sort last name in the query, not in memory
  1. Eliminate N+1 queries
  1. Move `is_deleted: false` conditional to the default scope.
  1. Share record sorting logic between the "has permission" and
     "hasn't permission" cases.
  1. Break out the "hasn't permission" case into multiple methods.
  1. ...And many, many more. See the commit history for more changes.

  All these changes should be accompanied by tests. The homework assignment
  didn't include tests. I started writing my own tests, but that involved
  starting a rails project around the code, adding models and their
  associations, and that didn't feel right, so I gave up on that.

### Part 2 - Programming Problems

1. Write a program using regular expressions to parse a file where each line is
  of the following format:

  `$4.99 TXT MESSAGING – 250 09/29 – 10/28 4.99`

  For each line in the input file, the program should output three pieces of information parsed from the line in the following JSON format (using the above example line):

  ```json
  {
    "feature" : "TXT MESSAGING – 250",
    "date_range" : "09/29 – 10/28",
    "price" : 4.99 // use the last dollar amount in the line
  }
  ```

  *See `parse_changes.rb`*

2. Please complete a set of classes for the problem described in
  [this blog post](http://www.adomokos.com/2012/10/the-organizations-users-roles-kata.html).
  Please do not create a database backend for this. Test doubles should work fine.
