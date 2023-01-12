---
layout: page
element: notes
title: Advanced Shell
language: Shell
---
### Review of Shell Accomplishments

- How can I search within files?
- How can I combine existing commands to do new things?
- Employ the `grep` command to search for information within files.
- Print the results of a command to a file.
- Construct command pipelines with two or more stages.

### Starting Genomics

In previous lessons, you learned how to use the bash shell to interact with your computer through a command line interface. In this lesson, you will be applying this new knowledge to a more genomics oriented shell, located on a remote supercomputer (or even a remote cloud service). We will spend most of our time learning about the basics of the shell by manipulating some experimental data. Some of the data we’re going to be working with is quite large, and we’re also going to be using several bioinformatics packages in later lessons to work with this data. To avoid having to spend time downloading the data and downloading and installing all of the software, we’re going to have the data available locally by [downloading it here]({{ site.baseurl }}/data/shell_data.zip). Also registered students can download it from [Canvas](https://canvas.okstate.edu/files/4300836/download?download_frd=1) then unzip it on our Desktop. NOTE, that if we are working with data on a remote server we may have the data preinstalled. 

### Searching files

We discussed in a previous episode how to search within a file using `less` and also
how to search within files without even opening them, using `grep`. Remember `grep` 
searches plain-text files for lines matching a specific set of 
characters (sometimes called a string) or a particular pattern 
(which can be specified using special wildcard-like characters called 
***regular expressions***). We're not going to work with 
regular expressions in this lesson, but are going to specify the strings 
we are searching for.


> #### Nucleotide abbreviations
> 
> The four nucleotides that appear in DNA are abbreviated `A`, `C`, `T` and `G`.
> When a sequencing instrument "sees" what it thinks is the addition of a 
> specific base, then it "calls" that base as an A, C, T, or G. When a base can not
> be called for any reason, unknown nucleotides are represented with the letter `N`. An `N` appearing
> in a sequencing file represents a position where the sequencing machine was not able to 
> confidently determine the nucleotide in that position. You can think of an `N` 
> as a `NULL` value within a DNA sequence. In other words, the base at that position could not be "called".  
> 
> Also, every single base that is called (including `N`) is given a **confidence score**.
> The computer algorithms that produce a "read" also provide confidence values for each read.
> We will see these confidence values (often called "Q" scores or Phred scores) 
> for every base in every read of the fastq files.  

#### Details on the FASTQ format

Although it looks complicated (and it is), we can understand the
[fastq](https://en.wikipedia.org/wiki/FASTQ_format) format with a little decoding. 
The first thing to know is that each sequence "read" in a fastq file is represented by FOUR lines.
Some rules about the format
include...

|Line|Description|
|----|-----------|
|1|Always begins with '@' and then information about the read (e.g. identifier)|
|2|**The actual DNA sequence**|
|3|Always begins with a `+`, otherwise blank, or has the same info as line 1|
|4|Has a string of characters which represent the **quality scores** and *must have same number of characters as line 2*|

Let's first make sure we are in the correct directory: `shell_data/untrimmed_fastq`. 
We have to remind ourselves 
that the directory we start in depends on the operating system. For Macs and PCs we should use:

~~~
$ cd ~/Desktop/shell_data/untrimmed_fastq
~~~
On an the Pete HPC we would start in our home directory on "scratch" without a Desktop directory 
~~~
$ cd /scratch/<username>/shell_data/untrimmed_fastq
~~~
Then we can start by searching for `N` strings inside of our fastq files.
Suppose we want to see how many reads in our file have really bad segments 
containing 10 consecutive unknown nucleotides ("N").

### Determining quality

Manually searching for strings of `N`s illustrates some principles of file 
searching. But it's only useful to do this type of searching to get an 
overall feel for the quality of your sequencing results. However, in your 
research you will most likely use a bioinformatics tool that has a built-in program for
filtering out low-quality reads. You'll learn how to use one such tool in 
[a later lesson]({{ site.baseurl }}/materials/genomics-assembly-files/).

Let's search for the string NNNNNNNNNN in the SRR098026 file.
~~~
$ grep NNNNNNNNNN SRR098026.fastq
~~~

This command returns a lot of output to the terminal. Every single line in the SRR098026 
file that contains at least 10 consecutive `N`s is printed to the terminal, regardless of how long or short the file is. 
We may be interested not only in the actual sequence which contains this string, but 
in the name (or identifier) of that sequence. We know 
that the identifier line immediately precedes the nucleotide sequence line for each read
in a FASTQ file. We may also want to inspect the quality scores associated with
each of these reads. To get all of this information, we need a command that will 
return the line immediately above (or ***b***efore each match) and the two lines immediately below (or **a**fter each match): a total of 4 lines.

We can use the `-B` argument for `grep` to return a specific number of lines **B**efore
each match. The `-A` argument returns a specific number of lines **A**fter each matching line. Here we want one line *before* and the two lines *after* each 
matching line, so we add `-B1 -A2` to our `grep` command.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq
~~~
The last four lines returned look like the correct output for our fastq format: 

~~~
@SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
+SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
~~~

However, these lines are preceeded by two dashes **`--`** which seems odd. It turns out that when you use the `-A` or `-B` flags, `grep` has a default setting to add a **group separator** between lines of output that are not contiguous. When we see `--` it means there are other lines in the file between the lines shown, that did not match our pattern. 

We bring this up now because it's important you know about this behavior and it is a great example of "wrangling" data. It also shows how it's important to read the `man` pages! This can be easily fixed if you know that it's happening.

To prevent extra separators from being introduced you can use 
`grep` and pipe the output to **another** grep. The second grep will select against the `--` pattern using the `-v` flag we learned about earlier.

```
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "\--"
```
Now we can see the output is exactly the same, but there are no `--` group separators. 
Also notice that the output is a perfectly formatted fastq file.
That means we can redirect the output creating a fastq file called
`bad_reads.fastq`

```
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "\--" > bad_reads.fastq
```

But you may be wondering why the `\` backslash means when we use 
`grep -v "\--"`. The easiest explanation is that it prevents an error! Try the command without the backslash.

```
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "--"
Usage: grep [OPTION]... PATTERN [FILE]...
Try 'grep --help' for more information.
```

The *error message* tells us that the proper usage of `grep` is the command, followed by an option (a "flag") and then a pattern before the filename. The shell cannot use a dash `-` as a pattern directly, because the dash symbolizes a flag or option is being passed to `grep`. To prevent the dash from beng used as a flag indicator, *we must put a **backslash** in front* which is known as an ***escape character***.

There are several special characters like the dash `-` that are reserved by the shell. We have used many of them already (e.g. $, >, #, {, *, ?). When used properly, they don't need "escaping", but when used for pattern matching, they always require some kind of escape character! Even the backslash `\` needs to be "escaped" if you are searching for it in a pattern (`\\` is used to search for `\`)! The [topic of pattern matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html) is pretty complicated but [we have a partial list]({{ site.baseurl }}/materials/Characters-to-escape) of [common characters]({{ site.baseurl }}/materials/character-chart) that may need to be "escaped" when used for pattern matching. For now all you need to remember is that in the Bash shell, the backslash character `\` is used in front of a special character like "dash" `-` or wildcard in a pattern search. 

> #### Preview, then redirect output
> 
> `grep` allowed us to identify sequences in our FASTQ files that match a particular pattern. 
> We used what is printed to the terminal then captured that output using "redirection" `>`.
> It's good practice to output to the terminal screen before creating or changing files to avoid problems. There are 
> other ways to check your data before using it for downstream analyses, and we 
> will discuss some later. 


> #### Exercise
>
> 1. Search for the sequence `GNATNACCACTTCC` in the `SRR098026.fastq` file. 
> Have your search return matching lines and the name (or identifier) for each sequence
> that contains a match.
> 
> 2. Search for the sequence `AAGTT` in **both** FASTQ files.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match. Remember to remove any group identifiers.
> 
> > #### Solution  
> > 1. `grep -B1 GNATNACCACTTCC SRR098026.fastq`  
> > 2. `grep -B1 AAGTT *.fastq | grep -v "\--"`
> >

### One last flag `-h`

The Exercise #2 above showed that when we send ***multiple*** files to the `grep` command, the output lines are prefaced with the file name. This is to help us find the actual lines later (think if you had 5000 files). If we want to stop this from happening (in order to have a perfectly formatted `fastq` file as the output), we can use the `-h` flag. 

```
grep -h -A1 -B1 AAGTT *.fastq | grep -v "\--"
```

Let's try out this command and copy all the records (including all four lines of each record) 
in our FASTQ files that contain 
`NNNNNNNNNN` to another file called `bad_reads.txt`.

~~~
$ grep -h -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "\--" > bad_reads.txt
~~~

> ### File extensions
> 
> You might be confused about why we're naming our output file with a `.txt` extension. After all,
> it will be holding FASTQ formatted data that we're extracting from our FASTQ files. Won't it 
> also be a FASTQ file? The answer is, **yes** - it will be a FASTQ file and it would make sense to 
> name it with a `.fastq` extension. However, using a `.fastq` extension will lead to problems
> when we move to using wildcards later in this episode. We'll point out where this becomes
> important. For now, it's good that you're thinking about file extensions! 

When you run the command above, the prompt should sit there a little bit, 
and then it should look like nothing
happened. But type `ls`. You should see a new file called `bad_reads.txt`. 

We can check the number of lines in our new file using a command called `wc`. 
Remember that `wc` stands for **word count**. This command counts the number of words, lines, and characters
in a file. 

~~~
$ wc bad_reads.txt
  536  1072 23214 bad_reads.txt
~~~

This will tell us the number of lines, words and characters in the file. If we
want only the number of lines, we can use the `-l` flag for `lines`.

~~~
$ wc -l bad_reads.txt
  536 bad_reads.txt
~~~

Because we asked `grep` for all four lines of each FASTQ record, we need to divide the output by
four to get the number of sequences that match our search pattern.

> ### Exercise
>
> How many sequences in `SRR098026.fastq` contain at least 3 consecutive Ns?
>
>> #### Solution
>>  
>>
>> ~~~
>> $ grep NNN SRR098026.fastq | grep -v "\--" > bad_reads.txt
>> $ wc -l bad_reads.txt
>> 249 bad_reads.txt
>> ~~~
>>

We might want to search multiple FASTQ files for sequences that match our search pattern.
However, we need to be careful, because each time we use the `>` command to redirect output
to a file, the new output will replace the output that was already present in the file. 
This is called "overwriting" and, just like you don't want to overwrite your video recording
of your kid's first birthday party, you also want to avoid overwriting your data files.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "\--" > bad_reads.txt
$ wc -l bad_reads.txt
  536 bad_reads.txt
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq | grep -v "\--" > bad_reads.txt
$ wc -l bad_reads.txt
  0 bad_reads.txt
~~~

Here, the output of our second  call to `wc` shows that we no longer have any lines in our `bad_reads.txt` file. This is 
because the second file we searched (`SRR097977.fastq`) does not contain any lines that match our
search sequence. So our file was overwritten and is now empty.

We can avoid overwriting our files by using the command `>>`. Remember that `>>` is known as the **"append redirect"** and will 
append new output to the end of a file, rather than overwriting it.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "\--" > bad_reads.txt
$ wc -l bad_reads.txt
  536 bad_reads.txt
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq | grep -v "\--" >> bad_reads.txt
$ wc -l bad_reads.txt
  536 bad_reads.txt
~~~

The output of our second call to `wc` shows that we have not overwritten our original data. 
In this way we can search all (think thousands of) our files for bad reads using a single line of code and a wildcard! 

~~~
$ grep -B1 -A2 NNNNNNNNNN *.fastq | grep -v "\--" > bad_reads.txt
$ wc -l bad_reads.txt
  536 bad_reads.txt
~~~

> ### File extensions - part 2
> 
> This is where we would have trouble if we were naming our output file with a `.fastq` extension. 
> If we already had a file called `bad_reads.fastq` (from our previous `grep` practice) 
> and then ran the command above using a `.fastq` extension instead of a `.txt` extension, `grep`
> would potentially use the output file as part of the input!. 
> 
> ~~~
> grep -B1 -A2 NNNNNNNNNN *.fastq | grep -v "\--" > bad_reads.fastq
> $ wc -l bad_reads.fastq
>  1072 bad_reads.fastq
> ~~~
> 
> Because `grep` used the output file `bad_reads.fastq` in your
> `grep` call (because it matches the `*.fastq` pattern) it counted the bad reads TWICE!
> Be careful with your file extensions as this as it can lead to
> some unintended results.
> 

Since we might have multiple different criteria we want to search for, 
creating a new output file each time has the potential to clutter up our workspace. We also
so far haven't been interested in the actual contents of those files, only in the number of 
reads that we've found. We created the files to store the reads and then counted the lines in 
the file to see how many reads matched our criteria. There's a way to do this, however, that
doesn't require us to create these intermediate files using the pipe command (`|`).

Remember that `|` takes the output that would otherwise be sent to the 
terminal and uses that output as input to another command. 
When our output is large, and we want to slow it down and
look at it, like we can with `less`, we can! We can redirect our output
from our `grep` call through the `less` command.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v "\--" | less
~~~

We can now see the output from our `grep` call within the `less` interface. We can use the up and down arrows 
to scroll through the output and use `q` to exit `less`.

Redirecting output can take some time to get used to but once you're 
comfortable with redirection, you'll be able to combine lots of commands to
manipulate your data! In fact the command line programs 
we've been learning are rarely impressive on their own, but when 
you start chaining them together, you can do some really powerful things very
efficiently. 

### Using `basename` in 'for' loops

Let's go back and review the `basename` command:

**Change to your older `data-shell` directory**

```
cd ../../data-shell/data/pdb
```
Recall that `basename` is a ***function*** (much like a program) in Unix that is helpful for replacing a uniform 
part of a name from a list of files. In this case, we will use `basename` 
to remove the `.pdb` extension from the files that we’ve been working with. 

~~~
$ basename aldrin.pdb .pdb
~~~

We see that this returns just the metabolite name, and no longer has the .pdb 
file extension on it.

~~~
aldrin
~~~

If we try the same thing but use `.pdf` as the file extension instead, nothing happens. This is because basename only works when it exactly matches a string in the file.

~~~
$ basename aldrin.pdb .pdf
aldrin.pdb
~~~

`basename` is really powerful when used in a `for` loop. It allows 
us to access file names from the end of a `$path` variable (a variable 
that includes a path), or even ONLY the file prefix, which you 
can use to name things. ***Let's try isolating a prefix for naming!***

Inside our `for` loop, we create a new variable `name`. We call 
the `basename` function inside the parenthesis, then submit a variable 
name `${filename}` which was defined in the `for` loop. Finally we indicate 
that `.pdb` should be removed from the file name. It’s important to note 
that **we’re not changing the actual files**, we’re creating a new variable 
called `name`. The line `> echo ${name}` will print to the terminal 
the variable name each time the `for` loop runs (and might help with troubleshooting too). Because we are iterating 
over 48 files, we expect to see 48 lines of output.

~~~
$ for filename in *.pdb
> do
> name=$(basename ${filename} .pdb)
> echo ${name}
> done

aldrin
ammonia
ascorbic-acid
benzaldehyde
camphene
cholesterol
cinnamaldehyde
etc...
~~~

> #### Review Exercise
>
> Print the file prefix of all of the `.txt` files in our current directory.
>
>> #### Solution
>>  
>>
>> ~~~
>> $ for filename in *.txt
>> > do
>> > name=$(basename ${filename} .txt)
>> > echo ${name}
>> > done
>> ~~~

One really useful way to use `basename` is to move files. Let's rename all of our `.txt` files using `mv` so that they have year timestamps on them, which will document when we created them. 

~~~
$ for filename in *.txt
> do
> name=$(basename ${filename} .txt)
> mv ${filename}  ${name}_2019.txt
~~~

Now you've learned a lot about some advanced shell commands for manipulating genomics data. But our "wrangling" isn't finished yet. 
Our [next lesson]({{site.baseurl }}/materials/genomics-data-and-writing-scripts) takes us into the exciting world of writing scripts to automate tasks!

### Keypoints:
- `grep` is a powerful search tool with many options for customization.
- `>`, `>>`, and `|` are different ways of redirecting output.
- `command > file` redirects a command's output to a file.
- `command >> file` redirects a command's output to a file without overwriting the existing contents of the file.
- `command_1 | command_2` redirects the output of the first command as input to the second command.
- `for` loops are used for iteration
- `basename` handles repetitive parts of names

