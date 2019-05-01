---
layout: exercise
topic: Shell
title: Files and Directories
language: Shell
---

### Exercises Week 1

1. 
	In the example below, what does `cp` do when given several filenames and a directory name?

	~~~
	$ mkdir backup
	$ cp amino-acids.txt animals.txt backup/
	~~~

	In the example below, what does `cp` do when given three or more file names?

	~~~
	$ ls -F
	amino-acids.txt  animals.txt  backup/  elements/  morse.txt  pdb/  planets.txt  salmon.txt  sunspot.txt
	$ cp amino-acids.txt animals.txt morse.txt 
	~~~


2.  Suppose that you created a plain-text file in your current directory to contain a list of the
	statistical tests you will need to do to analyze your data, and named it: `statstics.txt`

	After creating and saving this file you realize you misspelled the filename! You want to
	correct the mistake, which of the following commands could you use to do so?

~~~
	a. `cp statstics.txt statistics.txt`
	b. `mv statstics.txt statistics.txt`
	c. `mv statstics.txt .`
	d. `cp statstics.txt .`
~~~
