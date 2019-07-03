## Solution

A) The `read.csv()` function has the argument 'header' set to TRUE by default,
this means the function always assumes the first row is header information,
(i.e. column names)

B) The `read.csv()` function has the argument 'sep' set to ",". This means
the function assumes commas are used as delimiters, as you would expect.
Changing this parameter (e.g. `sep=";"`) would now interpret semicolons as
delimiters.

C) Although it is not listed in the `read.csv()` usage, `read.csv()` is
a "version" of the function `read.table()` and accepts all its arguments.
If you set `dec=","` you could change the decimal operator. We'd probably
assume the delimiter is some other character.

D) You can set `nrow` to a numeric value (e.g. `nrow=10000`) to choose how
many rows of a file you read in. This may be useful for very large files
where not all the data is needed to test some data cleaning steps you are
applying.

Hopefully, this exercise gets you thinking about using the provided help
documentation in R. There are many arguments that exist, but which we wont
have time to cover. Look here to get familiar with functions you use
frequently, you may be surprised at what you find they can do.
