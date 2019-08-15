---
layout: page
element: notes
title: Shell Beyond Nelle
language: Shell
---

**Questions:**
- How can I save and re-use commands?

**Objectives:**
- Write a shell script that runs a command or series of commands for a fixed set of files.
- Run a shell script from the command line.
- Write a shell script that operates on a set of files defined by the user on the command line.
- Create pipelines that include shell scripts you, and others, have written.

### Nelle's Shell Works Well!

Nelle finished her analyses in plenty of time, and wrote het manuscript.
She continues to use her scripting skills, even after 
she has graduated and moved on to a new position. Her new colleagues 
are a group of scientists in Antarctica, who perform similar studies
with gelatinous marine life, and Nelle has improved her coding skills. 
Now she's ready to use the shell as a powerful programming environment.
We want to follow along with Nelle as she takes commands we repeat 
frequently, and saves them in **script** files which 
can re-run all those analyses by typing a single command.

For historical reasons, a bunch of commands saved in a file is 
usually called a **shell script**, but make no mistake:
these are actually small **programs**.

To catch up with Nelle, we will start by going back to Nelle's `molecules/` 
directory and use the command `nano middle.sh` to open a new file, `middle.sh` which 
will become our shell script:

~~~
$ cd molecules
$ nano middle.sh
~~~

Let's insert the following line:

~~~
head -n 15 octane.pdb | tail -n 5
~~~

This is a variation on the pipe we constructed earlier:
it selects lines 11-15 of the file `octane.pdb`.
Remember, we are *not* running it as a command just yet:
we are putting the commands in a file.

Then we save the file (`Ctrl-O` in `nano`),
and exit the text editor (`Ctrl-X` in `nano`).
Check that the directory `molecules` now contains a file called `middle.sh`.

Once we have saved the script file,
we can ask the shell to execute the commands it contains.
Our shell is called `bash`, so we run the following command:

~~~
$ bash middle.sh
ATOM      9  H           1      -4.502   0.681   0.785  1.00  0.00
ATOM     10  H           1      -5.254  -0.243  -0.537  1.00  0.00
ATOM     11  H           1      -4.357   1.252  -0.895  1.00  0.00
ATOM     12  H           1      -3.009  -0.741  -1.467  1.00  0.00
ATOM     13  H           1      -3.172  -1.337   0.206  1.00  0.00
~~~

Sure enough,
our script's output is exactly what we would get if we ran that pipeline directly.

**But** we want to select lines from any file in the directory, not just `octane.pdb`.
We could edit `middle.sh` each time to change the filename,
but that would probably take longer than just retyping the command.
Instead, let's edit `middle.sh` and make it more ***versatile***:

~~~
$ nano middle.sh
~~~

Now, within `nano`, replace the text `octane.pdb` with the **special variable** called `$1`:

~~~
head -n 15 "$1" | tail -n 5
~~~

Inside a shell script,
**`$1` means "the first filename (or value, or input) on the command line"**.
We can now run our script with any file in the directory. Here
is `octane.pdb` again:

~~~
$ bash middle.sh octane.pdb
ATOM      9  H           1      -4.502   0.681   0.785  1.00  0.00
ATOM     10  H           1      -5.254  -0.243  -0.537  1.00  0.00
ATOM     11  H           1      -4.357   1.252  -0.895  1.00  0.00
ATOM     12  H           1      -3.009  -0.741  -1.467  1.00  0.00
ATOM     13  H           1      -3.172  -1.337   0.206  1.00  0.00
~~~

and here's a different file:

~~~
$ bash middle.sh pentane.pdb
ATOM      9  H           1       1.324   0.350  -1.332  1.00  0.00
ATOM     10  H           1       1.271   1.378   0.122  1.00  0.00
ATOM     11  H           1      -0.074  -0.384   1.288  1.00  0.00
ATOM     12  H           1      -0.048  -1.362  -0.205  1.00  0.00
ATOM     13  H           1      -1.183   0.500  -1.412  1.00  0.00
~~~

Pretty sweet. But before we move on, there's an important cautionary 
note we need to make right away regarding the use of *spaces in filenames*:

> #### Use Double-Quotes Around Arguments 
>
> We aren't doing it now, but it's very common practice
> to use double-quotes all the time for arguments. 
> Earlier, we put the **loop variable** inside double-quotes,
> in case the filename happens to contain any spaces,
> For the SAME reason, we will often surround **special variables**
> like `$1` with double-quotes.

So this script is great if we always want lines 11 through 15 of each file, but 
if we want to change the lines that are output, we would still need to 
edit `middle.sh` each time.
Let's fix that by using **more** special variables like `$2` and `$3` for the
number of lines to be passed to `head` and `tail` respectively:

~~~
$ nano middle.sh
head -n "$2" "$1" | tail -n "$3"
~~~

We can now run:

~~~
$ bash middle.sh pentane.pdb 15 5
ATOM      9  H           1       1.324   0.350  -1.332  1.00  0.00
ATOM     10  H           1       1.271   1.378   0.122  1.00  0.00
ATOM     11  H           1      -0.074  -0.384   1.288  1.00  0.00
ATOM     12  H           1      -0.048  -1.362  -0.205  1.00  0.00
ATOM     13  H           1      -1.183   0.500  -1.412  1.00  0.00
~~~

By changing the arguments to our command we can change our script's
output:

~~~
$ bash middle.sh pentane.pdb 20 5
ATOM     14  H           1      -1.259   1.420   0.112  1.00  0.00
ATOM     15  H           1      -2.608  -0.407   1.130  1.00  0.00
ATOM     16  H           1      -2.540  -1.303  -0.404  1.00  0.00
ATOM     17  H           1      -3.393   0.254  -0.321  1.00  0.00
TER      18              1
~~~

Always remember that these special variables are numbered 
*based on where you place them in the argument list*. Which is why
they are sometimes called the argument's "positional parameters". 

Just a quick refresher, to make sure everyone understands:

![script-image]({{ site.baseurl }}/fig/script1.png)

This works,
but it may take the next person who reads `middle.sh` a moment to figure out what it does.
We can improve our script by adding some **comments** at the top:

~~~
$ nano middle.sh

# This selects lines from the middle of a file.
# To use: bash middle.sh filename end_line num_lines
head -n "$2" "$1" | tail -n "$3"
~~~

A comment starts with a `#` character and runs to the end of the line.
The computer ignores comments,
but they're invaluable for helping people (including your future self) understand and use scripts.
The only caveat is that each time you modify the script,
you should check that the comment is still accurate!
An explanation that sends the reader in the wrong direction is worse than none at all.

#### Script Magic

*What if we want to process many files in a single pipeline?*

Let's start by deciding we want to sort all our `.pdb` files by length. We would type:

~~~
$ wc -l *.pdb | sort -n
~~~

because `wc -l` lists the number of lines in the files
and `sort -n` sorts things numerically.
We could put this command in a script file,
but then it would only ever sort a list of `.pdb` files in the current directory.
If we want to be able to get a sorted list of ***other*** kinds of files,
we need a way to get all kinds of names into the script.

**BUT**, we can't use special variables like `$1`, `$2`, and so on
because we don't know how many files there are (and don't 
want to type in a special variable for each file anyway)!
Instead, we use a different special variable **`$@`**,
which means,

**"*All* the command-line arguments of the shell script."**

`"$@"` is equivalent to `"$1" "$2" ...`

We ALWAYS put `"$@"` inside double-quotes
to handle the case of arguments containing spaces.
Here's an example using a script we name "sorted.sh":

~~~
$ nano sorted.sh
# Sort filenames by their length.
# Usage: bash sorted.sh one_or_more_filenames
wc -l "$@" | sort -n
~~~
Now we can not only sort by lines all the *.pdb files in the `molecules` directory, 
we can add more files to sort, for example, in the `creatures` directory. 
All we have to do is enter the correct path to the files we want to sort!
~~~
$ bash sorted.sh *.pdb ../creatures/*.dat
9 methane.pdb
12 ethane.pdb
15 propane.pdb
20 cubane.pdb
21 pentane.pdb
30 octane.pdb
163 ../creatures/basilisk.dat
163 ../creatures/unicorn.dat
~~~

> ### Using loops with special variables
>
> Remember when we were learning [how to use pipes]({{ site.baseurl }}/materials/shell04/#pipes) with the file animals.txt?
> Imagine if you had several hundred files, all formatted like this:
>
> ~~~
> 2013-11-05,deer,5
> 2013-11-05,rabbit,22
> 2013-11-05,raccoon,7
> 2013-11-06,rabbit,19
> 2013-11-06,deer,2
> 2013-11-06,fox,1
> 2013-11-07,rabbit,18
> 2013-11-07,bear,1
> ~~~
>
> An example of this type of file is given in `data-shell/data/animal-counts/animals.txt`.
> 
> Earlier we wrote a pipeline to extract and count the unique species in the file. 
> Now let's write a shell script called `species.sh` that takes ***any number*** of
> filenames as command-line arguments, and uses `cut`, `sort`, and
> `uniq` to print a list of the unique species appearing in each of
> those files separately.
>
> > ## Solution
> > In `nano` type:
> > ```
> > # Script to find unique species in csv files 
> > # where species is the second data field
> > # This script accepts any number of file names 
> > # as command line arguments
> >
> > # First it loops over all files
> > for file in $@ 
> > do
> > 	echo "Unique species in $file:"
> > 	# In the loop it extracts species names
> >		# just like we did before
> > 	cut -d , -f 2 $file | sort | uniq
> > done
> > ```

By now, you should be feeling proud of yourself!
(It probably took Nelle years to learn this stuff!)

#### Special Variables Table

Here's a [Table]({{ site.baseurl }}/assignments/special-variables-in-bash)
of Special Variables for reference purposes

#### All Special Variables need inputs!
**(When we make mistakes)**

What happens if a script is supposed to process a bunch of files, but we
don't give it any filenames? For example, what if we type:

~~~
$ bash sorted.sh
~~~

but don't say `*.dat` (or anything else)? In this case, `$@` expands to
nothing at all, so the pipeline inside the script is effectively:

~~~
$ wc -l | sort -n
~~~

Since it doesn't have any filenames, `wc` assumes it is supposed to
process standard input, so it just sits there and waits for us to give
it some data interactively. From the terminal however, all we see is it
sitting there: *The script doesn't appear to do anything*. 
If this happens, you probably need to use `Control-c` (or 
`Command-c` on a Mac) to exit 
the script and return to your prompt to start over.  

### Future Nelle's Pipeline: Creating a Script

We are almost caught up with Nelle's scripting skills at this point. 
When we find Nelle, we discover that **Nelle has moved on**, 
to a new position, still working with her gooey marine life. 
But Nelle never forgot how the supervisor insisted that 
**all** her analytics must be ***reproducible***. 

The easiest way to capture all the steps in her analyses is in a script. 
Nelle is much better at scripting now, 
and wants to rewrite some scripts for analyzing her new data
from Antarctica.

First we return to Nelle's data directory:
```
$ cd ../north-pacific-gyre/2012-07-03/
```
She checks her notes and sees her pipeline to run goostats was:
~~~
$ for datafile in NENE*[AB].txt; do echo $datafile; bash goostats $datafile stats-$datafile; done
~~~

She smiles as she realizes that her past self didn't make this loop into 
a script, with informational comments about how it was used. So Nelle runs 
the editor and writes the following:

~~~
# Calculate stats for data files.
for datafile in "$@"
do
    echo $datafile
    bash goostats $datafile stats-$datafile
done
~~~

She saves this in a file called `do-stats.sh`
so that she can now reproduce the first stage of her analysis by typing:

~~~
$ bash do-stats.sh NENE*[AB].txt
~~~

She can also do this:

~~~
$ bash do-stats.sh NENE*[AB].txt | wc -l
~~~

so that the output is just the **number** of files processed
rather than the names of the files that were processed.
Nelle then emails the script to her former supervisor, who is planning to 
write another manuscript on gelatinous marine life. 

One thing to note about Nelle's script is that
it lets the person running it decide what files to process.
What if she wrote the new script like this?

~~~
# Calculate stats for Site A and Site B data files.
for datafile in NENE*[AB].txt
do
    echo $datafile
    bash goostats $datafile stats-$datafile
done
~~~

This latter script is good because it always selects the right files
(For example, Nelle doesn't have to remember to exclude the 'Z' files).
The disadvantage is that it *always* selects *just* those 
files --- she can't run it on all files
or on the 'G' or 'H' files her former supervisor is creating. 
With the former script, by using `@$`, 
Nelle knows her future self will be able to handle the larger files 
her new colleagues in Antarctica are producing even though they 
use a different filename convention. Her script is flexible!

### The History of Nelle's Figure-3

One thing Nelle learned long ago was that her `history` could be
very useful for remembering and writing good scripts.
She remembers creating Figure-3, and then while trying to 
make it better, she forgot how she started formatting the data! 
To re-create the graph all she had to do was output her 
`history` to a file, then edit that file to create the graph again.
The other advantage of using `history` is she doesn't need to
type the commands in again(and potentially getting them wrong).
She does this:

~~~
$ history | tail -n 5 > redo-figure-3.sh
~~~

The file `redo-figure-3.sh` now contains:

~~~
297 bash goostats NENE01729B.txt stats-NENE01729B.txt
298 bash goodiff stats-NENE01729B.txt /data/validated/01729.txt > 01729-differences.txt
299 cut -d ',' -f 2-3 01729-differences.txt > 01729-time-series.txt
300 ygraph --format scatter --color bw --borders none 01729-time-series.txt figure-3.png
301 history | tail -n 5 > redo-figure-3.sh
~~~

After a moment's work in an editor to remove the serial numbers on the commands,
and to remove the final line where she called the `history` command,
she has a completely accurate record of how she created that figure.

There is a lot of code we haven't covered in 
Nelle's Figure-3, and we can ignore that for now. 
In practice, most people develop shell scripts by 
running commands at the shell prompt a few times
to make sure they're doing the right thing,
then saving them in a file for re-use.
This style of work allows people to recycle
what they discover about their data and their workflow with one call to `history`
and a bit of editing to clean up the output
and save it as a shell script.

> ### Class Exercise: Debugging Scripts
>
> Suppose you have saved the following script in a file called `do-errors.sh`
> in Nelle's `north-pacific-gyre/2012-07-03` directory:
>
> ~~~
> # Calculate stats for data files.
> for datafile in "$@"
> do
>     echo $datfile
>     bash goostats $datafile stats-$datafile
> done
> ~~~
>
> When you run it:
>
> ~~~
> $ bash do-errors.sh NENE*[AB].txt
> ~~~
>
> the output is blank.
> To figure out why, re-run the script using the `-x` option:
>
> ~~~
> bash -x do-errors.sh NENE*[AB].txt
> ~~~
>
> What is the output showing you?
> Which line is responsible for the error?
>
> > ### Solution
> > The `-x` flag causes `bash` to run in debug mode.
> > This prints out each command as it is run, which will help you to locate errors.
> > In this example, we can see that `echo` isn't printing anything. We have made a typo
> > in the loop variable name, and the variable `datfile` doesn't exist, hence returning
> > an empty string.

### Keypoints:

- Save commands in files (usually called shell scripts) for re-use.
- `bash filename` runs the commands saved in a file.
- `$@` refers to all of a shell script's command-line arguments.
- `$1`, `$2`, etc., refer to the first command-line argument, the second command-line argument, etc.
- Place variables in quotes if the values might have spaces in them.
- Scripts that let users decide what files to process are more flexible and more consistent with built-in Unix commands.
