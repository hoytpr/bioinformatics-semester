---
layout: page
element: notes
title: Shell grep and find
language: Shell
---

### Questions:
- How can I find files?
- How can I find things in files?

### Objectives:
- Use `grep` to select lines from text files that match simple patterns.
- Use `find` to find files whose names match simple patterns.
- Use the output of one command as the command-line argument(s) to another command.
- Emphasize the use of `help` and `man` to use commands

Explain what is meant by 'text' and 'binary' files, and why many common tools don't handle the latter well.

In the same way that many of us now use "Google" as a 
verb meaning "to find", Unix programmers often use the 
word "grep".
"grep" is a contraction of "global/regular expression/print",
a common sequence of operations in early Unix text editors.
It is also the name of a very useful command-line program.

`grep` finds and prints lines in files that match a pattern.
For our examples,
we will use a file that contains three haikus taken from a
1998 competition in *Salon* magazine. For this set of examples,
we're going to be working in the `data-shell/writing` subdirectory:

~~~
$ cd
$ cd Desktop/data-shell/writing
$ cat haiku.txt
~~~

~~~
The Tao that is seen
Is not the true Tao, until
You bring fresh toner.

With searching comes loss
and the presence of absence:
"My Thesis" not found.

Yesterday it worked
Today it is not working
Software is like that.
~~~


> ## Forever, or Five Years
>
> We haven't linked to the original haikus because they don't appear to be on *Salon*'s site any longer.
> As [Jeff Rothenberg said](http://webcache.googleusercontent.com/search?q=cache:L8Qc7a8pP8YJ:www.clir.org/pubs/archives/ensuring.pdf+&cd=1&hl=en&ct=clnk&gl=us),
> "Digital information lasts forever --- or five years, whichever comes first."
> Luckily, popular content often [has backups](http://wiki.c2.com/?ComputerErrorHaiku).

Let's find lines in haiku.txt that contain the word "not":

~~~
$ grep not haiku.txt
Is not the true Tao, until
"My Thesis" not found
Today it is not working
~~~

Here, `not` is the pattern we're searching for. The `grep` command searches through the file, looking for matches to the pattern specified. To use it type `grep`, then the pattern we're searching for (`not`) and finally the name of the file (or files) we're searching in (`haiku.txt`).

The output is the three **lines** in the file that contain the letters `not`. NOTE that `grep` returns
lines of files!

By default, `grep` searches for a pattern in a *case-sensitive* way. In addition, the search pattern we have selected does not have to form a complete word, as we will see in the next example.

Let's search for the pattern: `The`.

~~~
$ grep The haiku.txt
The Tao that is seen
"My Thesis" not found.
~~~

This time, two lines that include the letters `The` are output,
one of which contained our search pattern within a larger word, `Thesis`.

To restrict matches to lines containing the word `The` on its own,
we can give `grep` with the `-w` flag.
This will limit matches to **word boundaries**. This does not necessarily 
mean single words (as we will see later), and it does not change the 
way `grep` returns lines of files. 

Later in this lesson, we will also see how we can change the search behavior of `grep` with respect to its case sensitivity.

~~~
$ grep -w The haiku.txt
The Tao that is seen
~~~

**Note** that a "word boundary" includes the start and end of a line, so not
just letters surrounded by spaces. 

Sometimes we don't
want to search for a single word, but a phrase. This is also easy to do with
`grep` by putting the phrase in quotes. `grep` will then treat the phrase in quotes as the 
PATTERN, and we can still use the `-w` flag to place word boundaries on the pattern.

~~~
$ grep -w "is not" haiku.txt
Today it is not working
~~~

We've now seen that you don't *have* to use quotes around single words,
but quotes are essential when searching for multiple words.
Quotes also help make it easier to distinguish between the search term or phrase
and the file being searched.
We will always use quotes in the remaining examples.

Another useful flag is `-n`, which **numbers** the lines that match the pattern.
NOTE that the line number is separated from the matching line by a "colon" character.

~~~
$ grep -n "it" haiku.txt
5:With searching comes loss
9:Yesterday it worked
10:Today it is not working
~~~

Here, we can see that lines 5, 9, and 10 contain the letters "it".

We can combine flags as we do with other Unix commands.
For example, let's find the line numbers and lines that contain the word "the". We can combine
the flag options `-w` and `-n` to match the pattern "the":

~~~
$ grep -n -w "the" haiku.txt
2:Is not the true Tao, until
6:and the presence of absence:
~~~

Here's a **new** flag, **`-i`** which grep can use to make our search case-**insensitive**:

~~~
$ grep -n -w -i "the" haiku.txt
1:The Tao that is seen
2:Is not the true Tao, until
6:and the presence of absence:
~~~

Here is another flag option that is very useful. We can use **`-v`** to **invert** 
our search, *i.e.*, we want to output 
the lines that do ***not*** match the word "the".

~~~
$ grep -n -w -v "the" haiku.txt
1:The Tao that is seen
3:You bring fresh toner.
4:
5:With searching comes loss
7:"My Thesis" not found.
8:
9:Yesterday it worked
10:Today it is not working
11:Software is like that.
~~~
***Wait!*** Why is line #1 is found in both searches? Because `grep -n -w -i "the" haiku.txt`
is case insensitive, while `grep -n -w -v "the" haiku.txt` is case sensitive! 
To output the exact opposite matches for `grep -n -w -i "the" haiku.txt`, we need
to use: `grep -n -w -v -i "the" haiku.txt`. Now you begin to see how precise
the `grep` command can be while searching for patterns! 

`grep` has lots of other options. To find out what they are, we can type:
`grep --help` on Windows, or `man grep` on a Mac:
~~~
Usage: grep [OPTION]... PATTERN [FILE]...
Search for PATTERN in each FILE or standard input.
PATTERN is, by default, a basic regular expression (BRE).
Example: grep -i 'hello world' menu.h main.c

Regexp selection and interpretation:
  -E, --extended-regexp     PATTERN is an extended regular expression (ERE)
  -F, --fixed-strings       PATTERN is a set of newline-separated fixed strings
  -G, --basic-regexp        PATTERN is a basic regular expression (BRE)
  -P, --perl-regexp         PATTERN is a Perl regular expression
  -e, --regexp=PATTERN      use PATTERN for matching
  -f, --file=FILE           obtain PATTERN from FILE
  -i, --ignore-case         ignore case distinctions
  -w, --word-regexp         force PATTERN to match only whole words
  -x, --line-regexp         force PATTERN to match only whole lines
  -z, --null-data           a data line ends in 0 byte, not newline

Miscellaneous:
...        ...        ...
~~~

### Using `grep` with Wildcards

`grep`'s real power doesn't come from its options, though; it comes from
the fact that ***patterns can include special wildcards***. (The technical name for
these is **regular expressions**, which
is what the "re" in "grep" stands for.) Regular expressions can be very complex
and if you want to do complex searches, please look at the lesson
on [the Software Carpentry website](http://v4.software-carpentry.org/regexp/index.html). 
For a small taste of what these special wildcards can do, let's
find all the ***lines*** in `haiku.txt` that have an 'o' in the second position like this:

~~~
$ grep -E '^.o' haiku.txt
You bring fresh toner.
Today it is not working
Software is like that.
~~~

We use the `-E` flag and put the pattern in quotes to prevent the *shell*
from trying to expand it. (If the pattern contained a `*`, for
example, the shell would try to expand it **before** running `grep`.) The
use of `-E` lets `grep` take control of the wildcard pattern matching,
changing to **regular expression wildcards** which are ***different 
than the wildcards in the shell***. For example, **`^`** in the pattern *anchors 
the match to the **start of the line***. Then the **`•`**
*matches any single character* (just like `?` in the shell), while the **`o`**
*matches the actual letter 'o'*. So we are asking `grep` to output all the lines 
that start with any one character followed by an "o" character. 

### Combining Shell Commands: Tracking a Species

Now we are going to create a **much** more complicated script. 
But don't worry because you have already covered all the commands 
you need for this script, and we will give you some hints. But 
it will take some thought and probably some (hint#1) testing! 
Feel free to talk with your neighbor about this problem for 5 minutes,
then we will solve this puzzle together. 

#### Nelle's undergraduate project
Nelle is careful to save all her data, and she has 
some old data from an undergraduate project with **several hundred** 
data files saved in the `data-shell\data\animal-counts` directory. 
Each file has dates, species, and the counts of each species seen, formatted like this:

~~~
2013-11-05,deer,5
2013-11-05,rabbit,22
2013-11-05,raccoon,7
2013-11-06,rabbit,19
2013-11-06,deer,2
~~~

Nelle wants to find the number of animals she counted, on any date. 
But she only wants data for one species at a time. Nelle knows she needs 
to write a powerful script, but the script needs to be flexible, 
because there are so many files, and she saw a lot of different animals!
She wants to tell the script which species to search for, and which directory to search.
Nelle decides to write a shell script that takes a ***species*** as the first command-line argument 
and a ***directory*** as the second argument. The script should return one file called `<species>.txt` 
containing a list of *dates* and the *number* of that species counted on each date.

To be clear, she wants to run a script like this:
```
bash count-species.sh <animalname> <directory>
```
AND, using the data file as shown above, the script will create a file named
for the species (*e.g.* when searching for "rabbit" it would produce `rabbit.txt`) that would contain:

~~~
2013-11-05,22
2013-11-06,19
~~~

Nelle figured this out in only a few minutes of going through her old 
notes on writing scripts. But we don't have time in class to review all our
old lectures, so to help us create the script, let's try putting these commands, 
special variables, and pipes in the correct order:

~~~
cut -d : -f 2  
>  
|  
grep -w $1 -r $2  
|  
$1.txt  
cut -d , -f 1,3  
~~~

**Hint#2:** use `man grep` (or `grep --help`) to look for how to `grep` text 
*recursively* in a directory and review `man cut` (or `cut --help`) to select more 
than one *field* in a line.
**Hint#3:** It might help to start by focusing on just one species.

For this lesson at least one example of this file type is provided as `data-shell/data/animal-counts/animals.txt`
and some of you might have another file called `more-animals.txt` in the same directory.

(try not to look at the answer!)

..

..

..

..

..



#### Solution

```
grep -w $1 -r $2 | cut -d : -f 2 | cut -d , -f 1,3  > $1.txt
```

For each animal, you would call the script above like this:

```
$ bash count-species.sh bear .
```

### `grep` and Little Women
*** A Couple more useful `grep` flags:
You and your friend, having just finished reading *Little Women* by
Louisa May Alcott, are in an argument.  Of the four sisters in the
book, Jo, Meg, Beth, and Amy, your friend thinks that Jo was the
most mentioned.  You, however, are certain it was Amy.  Luckily, you
have a file `LittleWomen.txt` containing the full text of the novel
(`data-shell/writing/data/LittleWomen.txt`).
Using a `for` loop, how would you tabulate the number of times each
of the four sisters is mentioned?

Hint: one solution might employ
the commands `grep` and `wc` and a `|`, while another might utilize
`grep` options only.
***There is often more than one way to solve a programming task***, so a
particular solution is usually chosen based on a combination of
yielding the correct result, elegance, readability, and speed. 
No one should expect that they will be able to determine
the "best" way to answer questions when first starting to
learn programming. 

..

..

..

..


#### Solution1
```
for sis in Jo Meg Beth Amy
do
	echo $sis:
grep -ow $sis LittleWomen.txt | wc -l
done
```
```
Jo:
1355
Meg:
683
Beth:
459
Amy:
645
```

#### Solution2
```
for sis in Jo Meg Beth Amy
do
	echo $sis:
grep -ocw $sis LittleWomen.txt
done
```
```
Jo:
1347
Meg:
683
Beth:
457
Amy:
643
```

The second solution is ***not quite as good!*** Let's break this down:

The `-o` flag changes `grep`'s default output from lines, to **o**nly 
showing the matching pattern within the line! In this example, 
`-o` **shows** "only the part of a line matching `$sis`". 
This means rather than lines, ALL of the instances of "Jo", "Meg", "Beth", or 
"Amy" are output (but this could include things like "John" or "Bethy"). 
The `-w` flag makes sure that only complete words are matched because of
**word boundaries**.  
This means only *exactly* "Jo", "Meg", "Beth", or "Amy" will be 
matched and output. If you output `grep -ow` to the *terminal*, 
each time a name is found, it ends up on a ***different terminal
line***. When you instead pipe those to `wc -l` you get a 
count of all exact matches to the sisters' names. 

With the second solution, `grep -c` forces `grep` back to reporting
the number of **lines** matched. So although `grep -o` will find all the instances 
of `$sis`, `grep -c` only **c**ounts and reports the number of 
***lines*** where they are found. The total number of matches 
reported *by lines*, will be always lower if there is *more than one 
match per line*.

If this is still confusing, try breaking down the loops into 
single commands, or try running these commands looking for 
only "Jo" and carefully study the difference in the outputs:

```
$ for sis in Jo; do echo $sis:; grep -o $sis LittleWomen.txt | wc -l; done
$ for sis in Jo; do echo $sis:; grep -ow $sis LittleWomen.txt | wc -l; done
$ for sis in Jo; do echo $sis:; grep -w $sis LittleWomen.txt | wc -l; done
$ for sis in Jo; do echo $sis:; grep -c $sis LittleWomen.txt; done
$ for sis in Jo; do echo $sis:; grep -cw $sis LittleWomen.txt; done
$ for sis in Jo; do echo $sis:; grep -oc $sis LittleWomen.txt; done
```

### Using `find`
While `grep` finds lines in files, the `find` command finds ***files*** themselves. 
The `find` command has too many options to cover in this lesson, 
so we will discuss a few options for `find` using the directory file 
structure shown below.

![File Tree for Find Example]({{ site.baseurl }}/fig/find-file-tree.png)

Nelle's `writing` directory contains one file called `haiku.txt` and three subdirectories:
`thesis` (which contains a sadly empty file, `empty-draft.md`);
`data` (which contains three files `LittleWomen.txt`, `one.txt` and `two.txt`);
and a `tools` directory that contains the programs `format` and `stats`,
and a subdirectory called `old`, with a file `oldtool`.

For our first command,
let's run `find .`.

~~~
$ find .
.
./data
./data/one.txt
./data/LittleWomen.txt
./data/two.txt
./tools
./tools/format
./tools/old
./tools/old/oldtool
./tools/stats
./haiku.txt
./thesis
./thesis/empty-draft.md
~~~

As always,
the `.` on its own means the current working directory,
which is where we want our search to start. After that, the objects 
`find` displays are not listed in any particular order.
`find`'s output includes the names of every file **and** directory
under the current working directory.
This seems useful but `find` has many other options
to filter the output and in this lesson we will discover some 
of them.

The first option in our list is
`-type d` that means "things that are directories".
Sure enough,
`find`'s output is the names of the five directories in our little tree
(including `.`):

~~~
$ find . -type d
./
./data
./thesis
./tools
./tools/old
~~~

If we change `-type d` to `-type f`,
we get a listing of all the files instead:

~~~
$ find . -type f
./haiku.txt
./tools/stats
./tools/old/oldtool
./tools/format
./thesis/empty-draft.md
./data/one.txt
./data/LittleWomen.txt
./data/two.txt
~~~

Now let's try matching by name:

~~~
$ find . -name *.txt
./haiku.txt
~~~

This is different! We might have expected it to find **all** the text files
in all the directories,
but `find` only displays `./haiku.txt`.
This is because, as we have said before, **the shell expands wildcard characters 
like `*` *before* commands run**. 
When the shell saw `*.txt` it ***immediately*** expanded it in the 
current directory to `haiku.txt` before doing anything else. So the command 
we actually ran was:

~~~
$ find . -name haiku.txt
~~~

`find` did what we asked! It found a `*.txt` file in the 
current working directory and it was finished! 

To get all the text files,
let's do what we did with `grep` and
put `*.txt` in quotes to *prevent the shell from expanding the `*` wildcard*.
This way, `find` is presented with the pattern `*.txt`!

~~~
$ find . -name '*.txt'
./data/one.txt
./data/LittleWomen.txt
./data/two.txt
./haiku.txt
~~~

### Listing vs. Finding

Understand that in these examples the `find` command works harder 
than commands we've seen in other lessons! 
Remember the command `find . -name *.txt` **stops** 
because it is **done**. To be clear, it's done because  
everything expands specifically as "find a `*.txt` file in the current working directory".
However, if no `.txt` file is present in the current working directory, **`find` will begin at 
the current working directory, and continue finding `.txt` files**! 
We won't worry about this process for
now, because we'll always use quotes around our arguments with wildcards. 
Just be aware that this behavior can happen. 

> `ls` and `find` can be made to do similar things given the right options,
> but under normal circumstances, `ls` lists everything it is told to list,
> while `find` ***searches*** for things with certain properties and shows them.

The command line's power lies in combining tools, and we've seen how to do that with pipes;
Now let's look at another way to **combine tools**.

We know that `find . -name '*.txt'` gives us a list of all 
text files in or below the current directory.
It's possible to combine that with `wc -l` to count the lines in all those files.

The simplest way to combine these tools is to put the `find` command inside **`$()`**:

~~~
$ wc -l $(find . -name '*.txt')
11 ./haiku.txt
300 ./data/two.txt
21022 ./data/LittleWomen.txt
70 ./data/one.txt
21403 total
~~~

This is kind of like Math again! When the shell executes this command,
the first thing it does is run whatever is inside the `$()`.
Then the `$()` expression is given to the command, and used to generate the command's output.
In this case, `find` outputs four filenames 

```
./data/one.txt
./data/LittleWomen.txt
./data/two.txt
./haiku.txt`
```

and the shell puts all these together into the command:

~~~
$ wc -l ./data/one.txt ./data/LittleWomen.txt ./data/two.txt ./haiku.txt
~~~

This is what we wanted! When you think about it, this expansion is 
exactly what the shell does when it expands wildcards like `*` and `?`,
but using `$()` lets us turn any command we want into our own "wildcard".

**NOTE: It's very common to use `find` and `grep` together**
because `find` can locate files that match a pattern,
and `grep` identifies lines inside those files that match another pattern.

To demonstrate how this works, let's find `.pdb` files that contain iron atoms
by looking for the string "FE" in all the `.pdb` files 
in Nelles `data-shell/data/pdb` directory (we don't even have to 
leave the `writing` directory to do this!):

```
$ grep "FE" $(find ../data/pdb/ -name '*.pdb')
../data/pdb/heme.pdb:ATOM     25 FE           1      -0.924   0.535  -0.518
```

### Matching and Subtracting

We learned the `-v` flag for `grep` inverts pattern matching, so that only lines
which do ***not*** match the pattern are printed. 
For example, we can use grep to look for lines in `haiku.txt` that do NOT
contain the word `is`:
```
$ grep -vw 'is' haiku.txt
Is not the true Tao, until
You bring fresh toner.

With searching comes loss
and the presence of absence:
"My Thesis" not found.

Yesterday it worked
```

Knowing this about `grep`, let's **first change into the `data-shell/data/pdb`** 
directory, then answer which of the following commands will find all files 
whose names end in `l.pdb` (*e.g.*, `nerol.pdb`), but do
*not* contain the word `meth`?
Once you have thought about your answer, you can test the commands below:

1.  `find . -name '*l.pdb' | grep -v meth`
2.  `find . -name *l.pdb | grep -v meth`
3.  `grep -v "temp" $(find . -name *l.pdb)`
4.  None of the above.

#### Solution
* The correct answer is 1. Putting the match expression in quotes prevents the shell
expanding it, so it gets passed to the `find` command.

* Option 2 is **incorrect** because the shell expands `*l.pdb` *first* instead of 
passing the wildcard expression to `find`. 

* Option 3 is incorrect because it searches the contents of the files for lines which
do not match "temp", rather than searching the file names.

> ### `find` Pipeline Reading Comprehension
>
> Provide a short explanatory comment for the following shell script:
>
> ~~~
> wc -l $(find . -name '*.dat') | sort -n
> ~~~
>
> #### Solution
> 1. Find all files with a `.dat` extension in the current directory
> 2. Count the number of lines in each of these files
> 3. Sort the output from step 2. numerically

> ### Advanced: Finding Files With Different Properties
> 
> The `find` command can be given several other criteria known as "tests"
> to locate files with specific attributes, such as creation time, size,
> permissions, or ownership.  Use `man find` to explore these, and then
> write a single command to find all files in or below the current directory
> that were modified by the user `nelle` in the last 24 hours.
>
> Hint 1: you will need to use three tests: `-type`, `-mtime`, and `-user`.
> 
> Hint 2: At the end of `help` you see that `find` is maintained at ["http://savannah.gnu.org/"](http://savannah.gnu.org), where
> you can get more help (do not email). Also, you can use a search engine or go 
> to [Indiana U.](https://kb.iu.edu/d/admm)  
> 
> Hint 3: The value for `-mtime` will need to be negative---why?
>
> > ## Solution
> > Assuming that Nelle’s home is our working directory we type:
> >
> > ~~~
> > $ find ./ -type f -mtime -1 -user nelle
> > ~~~
> > 

### Keypoints:
- `find` finds files with specific properties that match patterns.
- `grep` selects lines in files that match patterns.
- `--help` is a flag supported by many bash commands, and programs that can be run from within Bash, to display more information on how to use these commands or programs.
- `man command` displays the manual page for a given command.
- `$(command)` Can be used to generate a command's output for other commands.