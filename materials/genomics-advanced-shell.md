---
layout: page
element: notes
title: Advanced Shell
language: Shell
---
### Questions:
- How can I search within files?
- How can I combine existing commands to do new things?
### Objectives:
- Employ the `grep` command to search for information within files.
- Print the results of a command to a file.
- Construct command pipelines with two or more stages.

### Searching files

We discussed in a previous episode how to search within a file using `less` and also
how to search within files without even opening them, using `grep`. Remember `grep` 
searches plain-text files for lines matching a specific set of 
characters (sometimes called a string) or a particular pattern 
(which can be specified using something called regular expressions). We're not going to work with 
regular expressions in this lesson, but are going to specify the strings 
we are searching for.


> #### Nucleotide abbreviations
> 
> The four nucleotides that appear in DNA are abbreviated `A`, `C`, `T` and `G`. 
> Unknown nucleotides are represented with the letter `N`. An `N` appearing
> in a sequencing file represents a position where the sequencing machine was not able to 
> confidently determine the nucleotide in that position. You can think of an `N` as a `NULL` value
> within a DNA sequence. 
> 

We'll search for strings inside of our fastq files. Let's first make sure we are in the correct 
directory.

~~~
$ cd ~/shell_data/untrimmed_fastq
~~~

Suppose we want to see how many reads in our file have really bad segments containing 10 consecutive unknown nucleotides ("N").

### Determining quality

In this lesson, we're going to be manually searching for strings of `N`s within our sequence
results to illustrate some principles of file searching. It can be really useful to do this
type of searching to get a feel for the quality of your sequencing results, however, in your 
research you will most likely use a bioinformatics tool that has a built-in program for
filtering out low-quality reads. You'll learn how to use one such tool in 
[a later lesson]({{ site.baseurl }}/materials/genomics-assembly-files/).

Let's search for the string NNNNNNNNNN in the SRR098026 file.
~~~
$ grep NNNNNNNNNN SRR098026.fastq
~~~

This command returns a lot of output to the terminal. Every single line in the SRR098026 
file that contains at least 10 consecutive Ns is printed to the terminal, regardless of how long or short the file is. 
We may be interested not only in the actual sequence which contains this string, but 
in the name (or identifier) of that sequence. We discussed in a previous lesson 
that the identifier line immediately precedes the nucleotide sequence for each read
in a FASTQ file. We may also want to inspect the quality scores associated with
each of these reads. To get all of this information, we will return the line 
immediately before each match and the two lines immediately after each match.

We can use the `-B` argument for grep to return a specific number of lines before
each match. The `-A` argument returns a specific number of lines after each matching line. Here we want the line *before* and the two lines *after* each 
matching line, so we add `-B1 -A2` to our grep command.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq
~~~

One of the sets of lines returned by this command is: 

~~~
@SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
+SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
~~~

> #### Exercise
>
> 1. Search for the sequence `GNATNACCACTTCC` in the `SRR098026.fastq` file.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match.
> 
> 2. Search for the sequence `AAGTT` in both FASTQ files.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match.
> 
> > #### Solution  
> > 1. `grep -B1 GNATNACCACTTCC SRR098026.fastq`  
> > 2. `grep -B1 AAGTT *.fastq`
> >
> 

### Redirecting output

`grep` allowed us to identify sequences in our FASTQ files that match a particular pattern. 
All of these sequences were printed to our terminal screen, but in order to work with these 
sequences and perform other operations on them, we will need to capture that output in some
way. 

Remember that we can do this with something called "redirection". The idea is that
we are taking what would ordinarily be printed to the terminal screen and redirecting it to another location. 
In our case, we want to print this information to a file so that we can look at it later and 
use other commands to analyze this data.

The command for redirecting output to a file is `>`.

Let's try out this command and copy all the records (including all four lines of each record) 
in our FASTQ files that contain 
`NNNNNNNNNN` to another file called `bad_reads.txt`.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
~~~

> ### File extensions
> 
> You might be confused about why we're naming our output file with a `.txt` extension. After all,
> it will be holding FASTQ formatted data that we're extracting from our FASTQ files. Won't it 
> also be a FASTQ file? The answer is, yes - it will be a FASTQ file and it would make sense to 
> name it with a `.fastq` extension. However, using a `.fastq` extension will lead to problems
> when we move to using wildcards later in this episode. We'll point out where this becomes
> important. For now, it's good that you're thinking about file extensions! 
> 

The prompt should sit there a little bit, and then it should look like nothing
happened. But type `ls`. You should see a new file called `bad_reads.txt`. 

We can check the number of lines in our new file using a command called `wc`. 
Remember that `wc` stands for **word count**. This command counts the number of words, lines, and characters
in a file. 

~~~
$ wc bad_reads.txt
  537  1073 23217 bad_reads.txt
~~~

This will tell us the number of lines, words and characters in the file. If we
want only the number of lines, we can use the `-l` flag for `lines`.

~~~
$ wc -l bad_reads.txt
  537 bad_reads.txt
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
>> $ grep NNN SRR098026.fastq > bad_reads.txt
>> $ wc -l bad_reads.txt
>> 249
>> ~~~
>>

We might want to search multiple FASTQ files for sequences that match our search pattern.
However, we need to be careful, because each time we use the `>` command to redirect output
to a file, the new output will replace the output that was already present in the file. 
This is called "overwriting" and, just like you don't want to overwrite your video recording
of your kid's first birthday party, you also want to avoid overwriting your data files.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
$ wc -l bad_reads.txt
  537 bad_reads.txt
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq > bad_reads.txt
$ wc -l bad_reads.txt
  0 bad_reads.txt
~~~

Here, the output of our second  call to `wc` shows that we no longer have any lines in our `bad_reads.txt` file. This is 
because the second file we searched (`SRR097977.fastq`) does not contain any lines that match our
search sequence. So our file was overwritten and is now empty.

We can avoid overwriting our files by using the command `>>`. Remember that `>>` is known as the **"append redirect"** and will 
append new output to the end of a file, rather than overwriting it.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
$ wc -l bad_reads.txt
  537 bad_reads.txt
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt
$ wc -l bad_reads.txt
  537 bad_reads.txt
~~~

The output of our second call to `wc` shows that we have not overwritten our original data. 

We can also do this with a single line of code by using a wildcard. 

~~~
$ grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.txt
$ wc -l bad_reads.txt
  537 bad_reads.txt
~~~

> ### File extensions - part 2
> 
> This is where we would have trouble if we were naming our output file with a `.fastq` extension. 
> If we already had a file called `bad_reads.fastq` (from our previous `grep` practice) 
> and then ran the command above using a `.fastq` extension instead of a `.txt` extension, `grep`
> would give us a warning. 
> 
> ~~~
> grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.fastq
> grep: input file ‘bad_reads.fastq’ is also the output
> ~~~
> 
> `grep` is letting you know that the output file `bad_reads.fastq` is also included in your
> `grep` call because it matches the `*.fastq` pattern. Be careful with this as it can lead to
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
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | less
~~~

We can now see the output from our `grep` call within the `less` interface. We can use the up and down arrows 
to scroll through the output and use `q` to exit `less`.

Redirecting output is often not intuitive, and can take some time to get used to. Once you're 
comfortable with redirection, however, you'll be able to combine any number of commands to
do all sorts of exciting things with your data!

None of the command line programs we've been learning
do anything all that impressive on their own, but when you start chaining
them together, you can do some really powerful things very
efficiently. 

### Using `basename` in 'for' loops
`basename` is a function in Unix that is helpful for replacing a uniform 
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
us to access ONLY the file prefix, which you can use to name things. 
Let's try this.

Inside our `for` loop, we create a new variable name. We call 
the `basename` function inside the parenthesis, then submit our variable 
name from the `for` loop, in this example `${filename}`, and finally indicate 
that `.pdb` should be removed from the file name. It’s important to note 
that **we’re not changing the actual files**, we’re creating a new variable 
called `name`. The line `> echo ${name}` will print to the terminal 
the variable name each time the for loop runs. Because we are iterating 
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

> #### Exercise
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
>> 
>>

One really useful way to use `basename` is to move files. Let's rename all of our .txt files using `mv` so that they have the years on them, which will document when we created them. 

~~~
$ for filename in *.txt
> do
> name=$(basename ${filename} .txt)
> mv ${filename}  ${name}_2019.txt
~~~


### Keypoints:
- `grep` is a powerful search tool with many options for customization.
- `>`, `>>`, and `|` are different ways of redirecting output.
- `command > file` redirects a command's output to a file.
- `command >> file` redirects a command's output to a file without overwriting the existing contents of the file.
- `command_1 | command_2` redirects the output of the first command as input to the second command.
- `for` loops are used for iteration
- `basename` handles repetitive parts of names

