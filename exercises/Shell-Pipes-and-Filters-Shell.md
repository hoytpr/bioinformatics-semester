---
layout: exercise
topic: Shell
title: Pipes and Filters 
language: Shell
---


## Redirecting to the same file
 
  It's a very bad idea to try redirecting
  the output of a command that operates on a file
  to the same file. For example:
 
  ~~~
  $ sort -n lengths.txt > lengths.txt
  ~~~
  {: .language-bash}
 
  Doing something like this may give you
  incorrect results and/or delete
  the contents of `lengths.txt`.
{: .callout}

## What Does `>>` Mean?
  We have seen the use of `>`, but there is a similar operator `>>` which works slightly differently.
  By using the `echo` command to print strings, test the commands below to reveal the difference
  between the two operators:

 
  ~~~
  $ echo hello > testfile01.txt
  ~~~
  {: .language-bash}
 
  and:
 
  ~~~
  $ echo hello >> testfile02.txt
  ~~~
  {: .language-bash}
 
  Hint: Try executing each command twice in a row and then examining the output files.
  > ## Solution
  > In the first example with `>`, the string "hello" is written to `testfile01.txt`,
  > but the file gets overwritten each time we run the command.
  >
  > We see from the second example that the `>>` operator also writes "hello" to a file
  > (in this case`testfile02.txt`),
  > but appends the string to the file if it already exists (i.e. when we run it for the second time).
  {: .solution}
{: .challenge}


## Appending Data
 
  We have already met the `head` command, which prints lines from the start of a file.
  `tail` is similar, but prints lines from the end of a file instead.
 
  Consider the file `data-shell/data/animals.txt`.
  After these commands, select the answer that
  corresponds to the file `animalsUpd.txt`:
 
  ~~~
  $ head -n 3 animals.txt > animalsUpd.txt
  $ tail -n 2 animals.txt >> animalsUpd.txt
  ~~~
  {: .language-bash}
 
  1. The first three lines of `animals.txt`
  2. The last two lines of `animals.txt`
  3. The first three lines and the last two lines of `animals.txt`
  4. The second and third lines of `animals.txt`
 
  > ## Solution
  > Option 3 is correct. 
  > For option 1 to be correct we would only run the `head` command.
  > For option 2 to be correct we would only run the `tail` command.
  > For option 4 to be correct we would have to pipe the output of `head` into `tail -2` by doing `head -3 animals.txt | tail -2 > animalsUpd.txt`
  {: .solution}
{: .challenge}

## Piping Commands Together
 
  In our current directory, we want to find the 3 files which have the least number of
  lines. Which command listed below would work?
 
  1. `wc -l * > sort -n > head -n 3`
  2. `wc -l * | sort -n | head -n 1-3`
  3. `wc -l * | head -n 3 | sort -n`
  4. `wc -l * | sort -n | head -n 3`
 
  > ## Solution
  > Option 4 is the solution.
  > The pipe character `|` is used to feed the standard output from one process to
  > the standard input of another.
  > `>` is used to redirect standard output to a file.
  > Try it in the `data-shell/molecules` directory!
  {: .solution}
{: .challenge}

## Pipe Construction
 
  For the file `animals.txt` from the previous exercise, the command:
 
  ~~~
  $ cut -d , -f 2 animals.txt
  ~~~
  {: .language-bash}
  
  uses the `-d` flag to separate each line by comma, and the `-f` flag
  to print the second field in each line, to give the following output:
 
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
  {: .output}
 
  What other command(s) could be added to this in a pipeline to find
  out what animals the file contains (without any duplicates in their
  names)?
 
  > ## Solution
  > ```
  > $ cut -d , -f 2 animals.txt | sort | uniq
  > ```
  > {: .language-bash}
  {: .solution}
{: .challenge}

## Which Pipe?
 
  The file `animals.txt` contains 8 lines of data formatted as follows:
 
  ~~~
  2012-11-05,deer
  2012-11-05,rabbit
  2012-11-05,raccoon
  2012-11-06,rabbit
  ...
  ~~~
  {: .output}
 
  Assuming your current directory is `data-shell/data/`,
  what command would you use to produce a table that shows
  the total count of each type of animal in the file?
 
  1.  `grep {deer, rabbit, raccoon, deer, fox, bear} animals.txt | wc -l`
  2.  `sort animals.txt | uniq -c`
  3.  `sort -t, -k2,2 animals.txt | uniq -c`
  4.  `cut -d, -f 2 animals.txt | uniq -c`
  5.  `cut -d, -f 2 animals.txt | sort | uniq -c`
  6.  `cut -d, -f 2 animals.txt | sort | uniq -c | wc -l`
 
  > ## Solution
  > Option 5. is the correct answer.
  > If you have difficulty understanding why, try running the commands, or sub-sections of
  > the pipelines (make sure you are in the `data-shell/data` directory).
  {: .solution}
{: .challenge}

## Removing Unneeded Files
 
  Suppose you want to delete your processed data files, and only keep
  your raw files and processing script to save storage.
  The raw files end in `.dat` and the processed files end in `.txt`.
  Which of the following would remove all the processed data files,
  and *only* the processed data files?
 
  1. `rm ?.txt`
  2. `rm *.txt`
  3. `rm * .txt`
  4. `rm *.*`
 
 > ## Solution
 > 1. This would remove `.txt` files with one-character names
 > 2. This is correct answer
 > 3. The shell would expand `*` to match everything in the current directory,
 > so the command would try to remove all matched files and an additional
 > file called `.txt`
 > 4. The shell would expand `*.*` to match all files with any extension,
 > so this command would delete all files
 {: .solution}
{: .challenge}
