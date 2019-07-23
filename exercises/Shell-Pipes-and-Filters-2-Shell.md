---
layout: exercise
topic: Shell
title: Pipes and Filters 
language: Shell
---
Uncomment below to work on exercise

<!--

#### Redirecting to the same file is risky
 
Make sure you have a file `lengths.txt` from the homework,
or you can re-create it using nano and the lines:

```
2
6
10
19
22
```
First, let's make a copy of `lengths.txt`:

`cp lengths.txt lengthsbkp.txt`

Then let's do something we normally would NOT do
and look at the results:

  ~~~
  $ sort -n lengths.txt > lengths.txt
  $ cat lengths.txt
    2
    6
    10
    19
    22
  ~~~
 
  This overwrites your working file `lengths.txt` forever 
  and without any warnings! In general NEVER redirect 
  a file to the same file.

#### What Does `>>` Mean?
  We have seen the use of `>`, but there is a similar operator `>>` which works slightly differently.
  By using the `echo` command to print strings, test the two commands below to reveal the difference   between the two operators:
 
  ~~~
  $ echo hello > testfile01.txt
  ~~~
 
  and:
 
  ~~~
  $ echo hello >> testfile02.txt
  ~~~

  *HINT: run each command more than once*

#### appending
Consider the file `data-shell/data/animals.txt`.
After these commands, select the answer that
corresponds to the file `animalsUpd.txt`:

~~~
$ head -n 3 animals.txt > animalsUpd.txt
$ tail -n 2 animals.txt >> animalsUpd.txt
~~~

1. The first three lines of `animals.txt`
2. The last two lines of `animals.txt`
3. The first three lines and the last two lines of `animals.txt`
4. The second and third lines of `animals.txt`

#### Solution
Option 3 is correct. 
For option 1 to be correct we would only run the `head` command.
For option 2 to be correct we would only run the `tail` command.
For option 4 to be correct we would have to pipe the output of `head` into `tail -2` by doing `head -3 animals.txt | tail -2 > animalsUpd.txt`
 
#### Piping Commands Together
 
  In our current directory (or any directory with several files), 
  we want to find the 3 files 
  which have the least number of
  lines. Which command listed below would work?
 
  1. `wc -l * > sort -n > head -n 3`
  2. `wc -l * | sort -n | head -n 1-3`
  3. `wc -l * | head -n 3 | sort -n`
  4. `wc -l * | sort -n | head -n 3`
 
#### Pipe Construction
 
  For the file `animals.txt` from the [previous exercise]({{ site.baseurl }}/data/animals.txt), enter the command:
 
  ~~~
  $ cut -d , -f 2 animals.txt
  ~~~
  
  `cut` uses the `-d` flag to separate each line by comma, and the `-f` flag
  to print the second field in each line. You should
  get the following output:
 
  ~~~
  deer
  rabbit
  raccoon
  rabbit
  deer
  fox
  rabbit
  bear
  ~~~
 
  What other command(s) could be added to the above `cut` command creating a
  pipeline to list all the animals the file contains without any duplicates 
  in their names?

#### Which Pipe?
 
  The file `animals.txt` contains 8 lines of data formatted as follows:
 
  ~~~
  2012-11-05,deer
  2012-11-05,rabbit
  2012-11-05,raccoon
  2012-11-06,rabbit
  ...
  ~~~
 
  Assuming your current directory is `data-shell/data/`,
  what command would you use to produce a table that shows
  the total count of each type of animal in the file?
 
  1.  `grep {deer, rabbit, raccoon, deer, fox, bear} animals.txt | wc -l`
  2.  `sort animals.txt | uniq -c`
  3.  `sort -t, -k2,2 animals.txt | uniq -c`
  4.  `cut -d, -f 2 animals.txt | uniq -c`
  5.  `cut -d, -f 2 animals.txt | sort | uniq -c`
  6.  `cut -d, -f 2 animals.txt | sort | uniq -c | wc -l`
 
#### Removing Unneeded Files
 
  Suppose you want to delete your processed data files, and only keep
  your raw files and processing script to save storage.
  The raw files end in `.dat` and the processed files end in `.txt`.
  Which of the following would remove all the processed data files,
  and *only* the processed data files?
 
  1. `rm ?.txt`
  2. `rm *.txt`
  3. `rm * .txt`
  4. `rm *.*`
  
  -->
 
Shell-Pipes-and-Filters-2-Shell.md