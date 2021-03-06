---
layout: page
element: notes
title: Nelles Last Bash
language: Shell
---
### Nelle moves fast to move on

We've studied **loops** which are key to productivity improvements through 
automation as they allow us to execute commands repeatedly. 
Similar to wildcards and tab completion, using loops also reduces the
amount of typing (and typing mistakes).

Nelle needs to finish her project, and she has 1518 protein abundance files
(not counting the files with "Z" in the name) to process through `goostats`, 
and several hundred genome data 
files (`.dat` files) for mapping the proteins.

To simulate Nelle's project, first make sure you are in the 
`creatures` directory which only has two example genome data files.

```
cd ~
cd Desktop/nelle/data-shell/creatures
ls *.dat
basilisk.dat   unicorn.dat
```
Remember to use "tab-completion" and also that we are using 
two of Nelle's files but the principles can be applied to ***many*** 
more files.

#### Backup your data
Nelle needs to modify her files, but also save a version of the original files by 
naming copies of the originals to
`original-basilisk.dat` and `original-unicorn.dat`.
At first she tried:

~~~
$ cp *.dat original-*.dat
~~~
but that gave her an error:
~~~
cp: target `original-*.dat' is not a directory
~~~
because if you ***expand*** that command, it's is the same as typing:
~~~
$ cp basilisk.dat unicorn.dat original-*.dat
~~~
(copy all files ending in .dat to the **directory** named "original-*.dat")

When `cp` receives more than two inputs it
expects the last input to be a directory where it can copy all the files it was passed.
Instead, Nelle needs to use a **loop**. 
Here's the loop she needs:

~~~
$ for filename in *.dat
> do
>     cp $filename original-$filename
> done
~~~
This loop runs the `cp` command once for each filename.
The first time, when `$filename` expands to `basilisk.dat`,
the shell executes:

~~~
cp basilisk.dat original-basilisk.dat
~~~

The second time, the command is:

~~~
cp unicorn.dat original-unicorn.dat
~~~

> **Indentation of code within a `for` loop**
> Note that it is common practice to indent the line(s) of code within a `for` loop.
> You do not need to indent the inner loop, but it will make the code easier to read. 
> If you want to indent your loop in Gitbash, use four to eight spaces (**not** <kbd>Tab</kbd>)

When using variables it is also
possible to put the names into curly braces to clearly delimit the variable
name: `$filename` is equivalent to `${filename}`. 
We have called the variable in this loop `filename`
in order to make its purpose clearer to human readers.
The shell itself doesn't care what the variable is called;
BUT, programs are only useful if people can understand them,
so meaningless variable names (like `x`) or misleading names (like `temperature`)
increase the odds that the program won't do what its readers think it does.

### Variables in Loops

Nelle plans ahead, and knows she wants a position after she graduates that 
targets alkane metabolites produced by gelatinous marine organisms. 
Nelle has started saving special descriptions of alkanes in her `data-shell/molecules` 
directory. So before she starts working on the current critical data files
she decides to practice using variables in `for` loops on these files. 
This gives us a good opportunity to practice working with loops
in the shell. First we need to change to the correct directory:

```
cd ../molecules
```

`ls` gives the following output:
~~~
cubane.pdb  ethane.pdb  methane.pdb  octane.pdb  pentane.pdb  propane.pdb
~~~
#### Practice exercise

What is the output of the following code?
~~~
$ for datafile in *.pdb
> do
>    ls *.pdb
> done
~~~

Now, what is the output of the following code?

~~~
$ for datafile in *.pdb
> do
>	ls $datafile
> done
~~~

These two loops give different outputs because
the first code block gives **the same output on each iteration** through
the loop. Let's think about this for a minute.
Bash expands the wildcard `*.pdb` within the loop body to match **all** files ending in `.pdb`
and then lists them all using `ls`. The changing variable value `$datafile` isn't used.
The expanded loop would look like this:
```
$ for datafile in cubane.pdb  ethane.pdb  methane.pdb  octane.pdb  pentane.pdb  propane.pdb
> do
>	ls cubane.pdb  ethane.pdb  methane.pdb  octane.pdb  pentane.pdb  propane.pdb
> done
```
The second code block **lists a *different* file on each loop iteration.**
The value of the `datafile` variable is evaluated using `$datafile`,
and then listed using `ls`.

```
cubane.pdb
ethane.pdb
methane.pdb
octane.pdb
pentane.pdb
propane.pdb
```

Now change back to Nelle's `creatures` directory:
```
cd ../creatures
ls
basilisk.dat
unicorn.dat
```

Now let's run a slightly more complicated loop:

~~~
$ for filename in *.dat
> do
>     echo $filename
>     head -n 100 $filename | tail -n 20
> done
~~~

The shell starts creating a variable `filename` and expanding `*.dat` 
to create the list of files it will process.
The **loop body** then executes two commands for each of those files.
The first command; `echo`, prints to standard output (the terminal).
Since the shell expands `$filename` to be the name of a file,
`echo $filename` just displays the name of the file.

Note: We ***can't*** write this as:

~~~
$ for filename in *.dat
> do
>     $filename
>     head -n 100 $filename | tail -n 20
> done
~~~

because when `$filename` is expanded to `basilisk.dat`, the shell would try 
to run `basilisk.dat` as a program!

The second command uses the `head` and `tail` combination to select lines 81-100
from whatever file is being processed, and prints to the standard output.
> #### Spaces in Names
> It is best to **avoid using spaces** (or other special characters) in filenames.
> But there is a *workaround* if one of the list elements
> contains a space character: The workaround is to surround the full 
> filename with quotes (don't use wildcards), **and also** surround our loop variable with quotes.
> For example if the `creatures` directory had the following files:
>
> ~~~
> red dragon.dat
> purple unicorn.dat
> ~~~
> 
> To loop over these files, we would need to add double quotes in the loop:
> 
> ~~~
> $ for filename in "red dragon.dat" "purple unicorn.dat"
> > do
> >     head -n 100 "$filename" | tail -n 20
> > done
> ~~~

### Nelle's Pipeline: Processing Files

Nelle is now ready to process her current critical data files using 
`goostats` --- a shell script written by her supervisor.
This script calculates some statistics from a protein sample file, 
and it is **important** that we know it takes two arguments:

1. an input file (containing the raw data)
2. an output file (to store the calculated statistics)

Since she's still learning how to use the shell,
Nelle decides to build up the required commands in stages.
Her first step is to make sure that she can select the right input files --- remember,
these files are ones whose names end in 'A' or 'B', rather than 'Z'. 
Also remember that we are using 17 files in our simulation, but Nelle has 1518
files to process! Starting from her `creatures` directory, Nelle 
makes sure she can get the correct filenames by typing:

~~~
cd ../north-pacific-gyre/2012-07-03
for datafile in NENE*[AB].txt
> do
>     echo $datafile
> done

NENE01729A.txt
NENE01729B.txt
NENE01736A.txt
...
NENE02043A.txt
NENE02043B.txt
~~~

Her next step is *to decide what to call the files* that the 
`goostats` analysis program will create (the output filenames).
Prefixing each input file's name with "stats" seems simple,
and appropriate, so she modifies her loop to do that:

~~~
$ for datafile in NENE*[AB].txt
> do
>     echo $datafile stats-$datafile
> done

NENE01729A.txt stats-NENE01729A.txt
NENE01729B.txt stats-NENE01729B.txt
NENE01736A.txt stats-NENE01736A.txt
...
NENE02043A.txt stats-NENE02043A.txt
NENE02043B.txt stats-NENE02043B.txt
~~~

Even though Nelle hasn't actually run `goostats`,
now she's sure she can select the right files 
and generate the right output filenames.

But typing in these loop commands over and over again is already 
becoming tedious, and Nelle is worried about making mistakes,
so instead of re-entering her loop, she presses the **up arrow**.
In response, the shell redisplays the whole loop on **one line**
using semi-colons to separate the loop parts (except for 
`do` which never takes a semi-colon):

~~~
$ for datafile in NENE*[AB].txt; do echo $datafile stats-$datafile; done
~~~
Using the **left arrow** key, Nelle moves back on the command-line, 
and uses the **backspace** key to delete the command `echo` and 
then replaces it by typing in `bash goostats`:

~~~
$ for datafile in NENE*[AB].txt; do bash goostats $datafile stats-$datafile; done
~~~
> Using the command phrase `bash goostats` does two things. It tells the shell
> that it wants to run a program using the `bash` shell. Then the phrase 
> tells the bash shell the name of the program it wants to run (`goostats`). This
> is very similar to wanting to run any program. If the program was written in 
> Python for example, the command would have been `python goostats`.
  
When she presses **<kbd>Enter</kbd>**,
the shell runs the modified command.
However, nothing appears to happen --- there is no output!
After a moment, Nelle realizes that since her script doesn't print 
anything to the screen any longer, she has no idea whether it is 
running on one or all of the 1518 files, much less how quickly.
She kills the running command by typing **`Ctrl-C`**,
uses the **up-arrow** to repeat the command,
and edits it to read:

~~~
$ for datafile in NENE*[AB].txt; do echo $datafile; bash goostats $datafile stats-$datafile; done
~~~
When she runs her program now,
it produces one line of output every five seconds or so:

~~~
NENE01729A.txt
NENE01729B.txt
NENE01736A.txt
...
~~~

1518 times 5 seconds, divided by 60,
tells her that her script will take about two hours to run.
As a final check, she opens a NEW terminal window,
goes into `north-pacific-gyre/2012-07-03`,
and uses `cat stats-NENE01729B.txt`
to examine one of the completed output files.
It looks good,
so she decides to get some coffee and catch up on her reading.

![script-running]({{ site.baseurl }}/fig/reading-book.png)
